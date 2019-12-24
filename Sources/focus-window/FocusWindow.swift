import Cocoa

final class FocusWindow {
  static func focusWindow(windowNumber: Int) {
    if !isTrusted() {
      print("Missing Accessibility Permissions", to: .standardError)
      exit(1)
    }

    let windowList = CGWindowListCopyWindowInfo(.optionOnScreenOnly, kCGNullWindowID) as! [[String: Any]]

    guard
      let cgWindow = (windowList.first { $0[kCGWindowNumber as String] as! Int == windowNumber })
    else {
      print("Window not found", to: .standardError)
      exit(1)
    }

    let ownerPID = cgWindow[kCGWindowOwnerPID as String] as! Int

    let maybeIndex = windowList
      .filter { $0[kCGWindowOwnerPID as String] as! Int == ownerPID }
      .firstIndex { $0[kCGWindowNumber as String] as! Int == windowNumber }

    guard
      let axWindows = attribute(
        element: AXUIElementCreateApplication(pid_t(ownerPID)),
        key: kAXWindowsAttribute,
        type: [AXUIElement].self
      ),
      let index = maybeIndex,
      axWindows.count > index,
      let app = NSRunningApplication(processIdentifier: pid_t(ownerPID))
    else {
      print("Window not found", to: .standardError)
      exit(1)
    }

    let axWindow = axWindows[index]
    app.activate(options: [.activateIgnoringOtherApps])
    AXUIElementPerformAction(axWindow, kAXRaiseAction as CFString)
  }

  static func isTrusted(shouldAsk: Bool = false) -> Bool {
    AXIsProcessTrustedWithOptions(["AXTrustedCheckOptionPrompt": shouldAsk] as CFDictionary)
  }

  private static func attribute<T>(element: AXUIElement, key: String, type: T.Type) -> T? {
    var value: AnyObject?
    let result = AXUIElementCopyAttributeValue(element, key as CFString, &value)

    guard
      result == .success,
      let typedValue = value as? T
    else {
      return nil
    }

    return typedValue
  }

  private static func value<T>(
    element: AXUIElement,
    key: String,
    target: T,
    type: AXValueType
  ) -> T? {
      guard let attribute = self.attribute(element: element, key: key, type: AXValue.self) else {
        return nil
      }

      var value = target
      AXValueGetValue(attribute, type, &value)
      return value
  }
}
