import Foundation
import IOBluetooth
import CoreAudio

class Monitor: NSObject {

    var btNotification: IOBluetoothUserNotification?
    var waitingForAudioChange = false

    let targetDevice = "Bose QC45"
    let switchAudioSource = "/opt/homebrew/bin/SwitchAudioSource"

    func start() {


        print("Bluetooth monitor started")

        btNotification = IOBluetoothDevice.register(
            forConnectNotifications: self,
            selector: #selector(deviceConnected(_:device:))
        )

        registerCoreAudioListener()

        RunLoop.current.run()
    }

    @objc func deviceConnected(_ notification: IOBluetoothUserNotification,
                               device: IOBluetoothDevice) {

        guard let name = device.name else { return }

        if name == targetDevice {

            print("Target headphones connected")

            // Wait for CoreAudio to finish device changes
            waitingForAudioChange = true
        }
    }

    func registerCoreAudioListener() {

        var addr = AudioObjectPropertyAddress(
            mSelector: kAudioHardwarePropertyDevices,
            mScope: kAudioObjectPropertyScopeGlobal,
            mElement: kAudioObjectPropertyElementMain
        )

        AudioObjectAddPropertyListenerBlock(
            AudioObjectID(kAudioObjectSystemObject),
            &addr,
            DispatchQueue.global()
        ) { _, _ in

            if self.waitingForAudioChange {

                self.waitingForAudioChange = false
                self.setInputDevice()
            }
        }
    }

    func setInputDevice() {

        print("Setting microphone to MacBook Pro Microphone")

        let task = Process()
        task.executableURL = URL(fileURLWithPath: switchAudioSource)

        task.arguments = [
            "-t", "input",
            "-s", "MacBook Pro Microphone"
        ]

        try? task.run()
    }
}

let monitor = Monitor()
monitor.start()
