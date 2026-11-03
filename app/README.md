# P-A-R-T Studio (Flutter prototype)

**Implemented:** interactive numbered room layout, slot selection, simulated identify, Act/Scene/Cue display, simulated GO/next/reset, JSON clipboard export and paste import.

**Not implemented:** actual BLE scanning/connection, RF gateway, phone spoken audio, reliable disk persistence, cue editing forms, OAuth, physical effects, hardware arming. All device activity is **simulated**.

## Run
Install Flutter SDK and platform-specific build tools: https://docs.flutter.dev/install

```bash
cd app
flutter create --platforms=android,ios,windows,macos,linux .
flutter pub get
flutter test
flutter run
```

The generated platform directories are not committed in this repository yet. iOS builds require a Mac and Xcode; desktop BLE compatibility will be validated independently when gateway integration begins.

**Try it:** select a numbered balloon in Room and press Test identify; run cues in Rehearsal; reset the playhead; export JSON to clipboard, then import it again. These steps do not contact any hardware.

## Next work
1. Persistent local show storage, live edit forms, named cue templates and full archive export.
2. Explicit `GatewayTransport` abstraction with fake transport tests.
3. ESP32-C3 gateway BLE GATT link and encrypted ESP-NOW LED-only receivers.
4. Android/iOS/desktop BLE permission and connection tests.
5. Only after independent safety review: physical event-effect integration.
