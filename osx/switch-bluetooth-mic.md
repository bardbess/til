# Switch OSX Mic

Swift Script to switch the mic back to the OSX mic after bluetooth headphones connect.

The latest version of OSX headphone output is distorted when the input is set to the headphone device. Setting the input to the osx mic fixes the output for me.

## Create the Script

> bluetooth_audio_fix.swift

```
import Foundation
import IOBluetooth

class BluetoothMonitor: NSObject {

    var connectNotification: IOBluetoothUserNotification?

    let targetDeviceName = "Apple Air"
    let switchAudioSource = "/opt/homebrew/bin/SwitchAudioSource"

    func start() {

        print("Bluetooth monitor running")

        connectNotification = IOBluetoothDevice.register(
            forConnectNotifications: self,
            selector: #selector(deviceConnected(_:device:))
        )

        RunLoop.current.run()
    }

    @objc func deviceConnected(_ notification: IOBluetoothUserNotification,
                               device: IOBluetoothDevice) {

        guard let name = device.name else { return }

        print("Connected device: \(name)")

        if name == targetDeviceName {

            print("Apple Air detected — resetting input mic")

            let task = Process()
            task.executableURL = URL(fileURLWithPath: switchAudioSource)

            task.arguments = [
                "-t", "input",
                "-s", "MacBook Pro Microphone"
            ]

            do {
                try task.run()
            } catch {
                print("Failed to run SwitchAudioSource")
            }
        }
    }
}

let monitor = BluetoothMonitor()
monitor.start()
```

Compile it

> swiftc bluetooth_audio_fix.swift -o bluetooth_audio_fix -framework IOBluetooth

Test it

> ./bluetooth_audio_fix

Optimize the build for maximum performance by Force embeding the minimal runtime pieces:

> swiftc bluetooth_audio_fix.swift \ -O \ -static-stdlib \ -framework IOBluetooth \ -framework CoreAudio \ -o bluetooth_audio_fix

## Create the Launch Agent

> ~/Library/LaunchAgents/com.bluetooth.monitor.plist

```
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN"
"http://www.apple.com/DTDs PropertyList-1.0.dtd">
<plist version="1.0">
<dict>

    <key>Label</key>
    <string>com.bluetooth.monitor</string>

    <key>ProgramArguments</key>
    <array>
        <string>/Users/yourname/bluetooth_listener</string>
    </array>

    <key>RunAtLoad</key>
    <true/>

    <key>KeepAlive</key>
    <true/>

    <key>StandardOutPath</key>
    <string>/tmp/bluetooth_monitor.log</string>

    <key>StandardErrorPath</key>
    <string>/tmp/bluetooth_monitor.log</string>

</dict>
</plist>
```

Load it

> launchctl load ~/Library/LaunchAgents/com.bluetooth.monitor.plist

View logs

> tail -f /tmp/bluetooth_monitor.log

##
