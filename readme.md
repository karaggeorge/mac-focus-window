# mac-focus-window

> Focus a window and bring it to the front on macOS

Requires Accessibility permissions

Requires macOS 10.12 or later. macOS 10.13 or earlier needs to download the [Swift runtime support libraries](https://download.developer.apple.com/Developer_Tools/Swift_5_Runtime_Support_for_Command_Line_Tools/Swift_5_Runtime_Support_for_Command_Line_Tools.dmg).

## Install

```
$ npm install mac-focus-window
```

## Usage

```js
const focusWindow = require('mac-focus-window');

if(focusWindow.isSupported && focusWindow.hasPermissions()) {
  focusWindow(12345);

  // true
} else {
  focusWindow.requestPermissions();
}
```

## API

### `focusWindow(windowNumber: number | string): Boolean`

Focus the given window and bring it to the front.

An error will be thrown if:
- Accessibility permissions are not enabled for the current app
- You provide `windowNumber` as a string, but it's not a number
- There is no window with the given number

Returns `true` if the window was focused successfully, and `false` otherwise.

#### `focusWindow.isSupported`

Will be `true` if the module is supported (based on macOS version).

#### `focusWindow.hasPermissions(): Boolean`

Check if the current app has accessibility permissions. This will not prompt the user with the system dialog.

Returns `true` if the app has permissions, and `false` otherwise.

#### `focusWindow.checkPermissions(): Boolean`

Same as `hasPermissions`, but it will present the user with the native permissions dialog.

**Notes:**
- The permissions dialog will only be shown if the app doesn't have permissions
- The user has to go into the System Preferences to give access, so if the app doesn't have permissions, this will return `false` immediately after presenting the dialog. You have to check again after the user has granted the permissions for this to be `true` (restart of the app not required)

## Related

- [mac-window-select](https://github.com/karaggeorge/mac-window-select) - Prompt the user to select a window on macOS, mimicking the native screenshot utility
- [mac-windows](https://github.com/karaggeorge/mac-windows) - Provide Information about Application Windows running

## License

MIT