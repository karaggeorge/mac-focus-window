import Cocoa
import SwiftCLI

final class FocusCommand: Command {
    let name = "focus"

    let windowNumber = Param.Required<Int>()

    func execute() throws {
      FocusWindow.focusWindow(windowNumber: windowNumber.value)
    }
}

final class CheckPermissionsCommand: Command {
    let name = "check"

    func execute() throws {
      print(FocusWindow.isTrusted())
    }
}

final class AskPermissionsCommand: Command {
    let name = "ask"

    func execute() throws {
      print(FocusWindow.isTrusted(shouldAsk: true))
    }
}

final class PermissionsGroup: CommandGroup {
  let name = "permissions"
  let shortDescription = "Check or ask for Accessibility permissions"
  let children: [Routable] = [CheckPermissionsCommand(), AskPermissionsCommand()]
}


let selectWindow = CLI(name: "focus-window")
selectWindow.commands = [FocusCommand(), PermissionsGroup()]
_ = selectWindow.go()
