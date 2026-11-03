# ESP32-C3 LED node (safe hardware bring-up)

This is a **serial-controlled LED identification demonstrator**, not a balloon popper. It does not implement Bluetooth, ESP-NOW, batteries, or any heater/actuation circuitry. It should be used on a supported ESP32-C3 board with an LED connected through an appropriate resistor to GPIO8; if your board has a different LED pin or active-low LED, edit the pin and polarity.

Requires [Espressif ESP-IDF](https://docs.espressif.com/projects/esp-idf/en/stable/esp32c3/get-started/index.html).

```bash
cd firmware/led-node
idf.py set-target esp32c3
idf.py build
idf.py -p /dev/ttyUSB0 flash monitor
```

Send a line ending in newline over the device UART:
- `STATUS` — log safe LED-only status
- `IDENTIFY` — blink LED three times
- `HELP` — list permitted commands

**Hardware warning:** GPIO8 is a strapping pin on some ESP32-C3 boards, and board LED mapping varies. Confirm board schematic and boot strapping before wiring. Never connect a resistive heating element or other load to this demo pin.

Next: implement separately authenticated BLE gateway and encrypted ESP-NOW receiver connection with replay-resistant commands; do not expose physical hot outputs in this milestone.
