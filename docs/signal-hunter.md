# Signal Hunter — proximity-assisted device finding

## User experience
Select a receiver by its immutable hardware ID / friendly name, tap **Find**, walk through the venue with a Ghostbusters-like animated scanner. Increasingly frequent clicks, green animated meter, haptics, and accessible on-screen status indicate *relative received signal strength*, not measured physical distance. Allow quiet mode and visual-only alternative.

Near the likely target: **Identify** sends a strictly non-heating command to flash the receiver LED and/or beep; operator checks printed ID then marks placement verified. Optional phone TTS announces the name, but that alone does **not** prove node identity.

## Architecture considerations
- V1 approach: each node intermittently advertises a rotating authenticated BLE identifier to phones, while gateway normally handles ESP-NOW control. Must test BLE + Wi-Fi coexistence and battery impact on ESP32-C3. Do **not** infer physical proximity from hub-measured RSSI: that measures hub-to-node link, not phone-to-node range.
- Alternative: special portable scanner or hub moves with technician to measure ESP-NOW packets. ESP-IDF >=v5.1 callback exposes RSSI through `esp_now_recv_info_t.rx_ctrl.rssi`: https://github.com/espressif/esp-faq/blob/master/docs/en/application-solution/esp-now.rst
- Smooth noisy RSSI via rolling median/low-pass, hysteresis and relative calibration. Never display fabricated meter/feet values as a measurement. Keep clear 'approximate signal strength' language, avoid false-positive 'found' state.
- Investigate Bluetooth Channel Sounding or UWB only if more accurate ranging is needed; both need compatible radio hardware, and increase BOM and certification complexity. Bluetooth SIG notes RSSI-based distances are particularly unreliable beyond a couple of meters: https://www.bluetooth.com/bluetooth-le-primer/
- Be mindful that phone OS background scan/throttling and BLE/Wi-Fi contention differ by handset. Performance testing on Android and iOS required.

## Animation
- Themes: 'Ecto-Scan' paranormal detector, simple radar, accessible monochrome view.
- Audio: rising click rate/volume with explicit mute, optional haptics and reduced-motion setting.
- Status: SEARCHING / FAINT / WARMER / STRONG / VERIFY LABEL. No automatic physical effect arming.
- Walking instructions are visual and spoken, not claiming direction vectors from a single antenna.

## Test plan
- Compare BLE RSSI at 0.5,1,2,5,10,18 m with crowd movement, body occlusion, props and metal; report false-positive rates.
- Confirm scan can distinguish 32 neighboring nodes without confusing friendly names/IDs.
- Validate coexistent ESP-NOW traffic, phone BLE scan reliability, battery impact, accessibility and hearing-sensitive mode.
- Test/identify commands must be electrically isolated from any future thermal-effect interface; no hot outputs in prototype.

## Patent review note
Animated 'warmer/colder' signal-finding is established prior art in RF asset-tracking applications; do not claim it is novel. Search specific implementations and claims before making patentability assertions.
