import Cocoa
import Foundation

class FocusWindow {
  static func focusWindow(_ windowNum: String) -> Bool {
    if !isTrusted() {
      print("Missing Accessibility Permissions", to: .standardError)
      exit(1)
    }

    if let windowNumber = Int(windowNum) {
      let options = CGWindowListOption(arrayLiteral: CGWindowListOption.optionOnScreenOnly)
      let windowList = (CGWindowListCopyWindowInfo(options, kCGNullWindowID) as! NSArray).map { $0 as! NSDictionary }

      if let cgWindow = windowList.first(where: { $0.value(forKey: "kCGWindowNumber") as! Int == windowNumber }) {
        let ownerPid = cgWindow.value(forKey: "kCGWindowOwnerPID") as! Int

        let index = windowList.filter {
          $0.value(forKey: "kCGWindowOwnerPID") as! Int == ownerPid
        }.firstIndex(where: {
          $0.value(forKey: "kCGWindowNumber") as! Int == windowNumber
        })

        if let axWindows = attribute(AXUIElementCreateApplication(pid_t(ownerPid)), kAXWindowsAttribute, [AXUIElement].self) {
          if axWindows.count > index! {
            let axWindow = axWindows[index!]
            if let app = NSRunningApplication(processIdentifier: pid_t(ownerPid)) {
                app.activate(options: [.activateIgnoringOtherApps])
                AXUIElementPerformAction(axWindow, kAXRaiseAction as CFString)
                return true
            }
          }
        }
      } else {
          print("Window not found", to: .standardError)
          exit(1)
      }
    } else {
      print("Window number is not a number", to: .standardError)
      exit(1)
    }

    return false
  }

  static func isTrusted(_ shouldAsk: Bool = false) -> Bool {
    return AXIsProcessTrustedWithOptions(["AXTrustedCheckOptionPrompt": shouldAsk] as CFDictionary)
  }

  private static func attribute<T>(_ element: AXUIElement, _ key: String, _ type: T.Type) -> T? {
    var value: AnyObject?
    let result = AXUIElementCopyAttributeValue(element, key as CFString, &value)
    if result == .success, let typedValue = value as? T {
        return typedValue
    }
    return nil
  }

  private static func value<T>(_ element: AXUIElement, _ key: String, _ target: T, _ type: AXValueType) -> T? {
      if let a = attribute(element, key, AXValue.self) {
          var value = target
          AXValueGetValue(a, type, &value)
          return value
      }
      return nil
  }
}