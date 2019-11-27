import Cocoa
import SwiftCLI

class FocusCommand: Command {
    let name = "focus"

    let windowNumber = Parameter()

    func execute() throws {
      print(FocusWindow.focusWindow(windowNumber.value))
    }
}

class CheckPermissionsCommand: Command {
    let name = "check"

    func execute() throws {
      print(FocusWindow.isTrusted())
    }
}

class AskPermissionsCommand: Command {
    let name = "ask"

    func execute() throws {
      print(FocusWindow.isTrusted(true))
    }
}

class PermissionsGroup: CommandGroup {
  let name = "permissions"
  let shortDescription = "Check or ask for Accessibility permissions"
  let children: [Routable] = [CheckPermissionsCommand(), AskPermissionsCommand()]
}


let selectWindow = CLI(name: "focus-window")
selectWindow.commands = [FocusCommand(), PermissionsGroup()]
selectWindow.go()