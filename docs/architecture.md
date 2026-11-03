# Initial architecture — RF learning

## Radio
- Candidate: ESP32-C3-MINI-1 (choose an appropriate module with current modular certification, verified approved antenna, power and placement constraints).
- ESP-NOW on 2.4 GHz for short command/status packets. 60 ft / 18 m is a measurement target, **not guaranteed**.
- Event control: controller -> individually identified nodes; status -> controller; explicitly modeled state and delivery acknowledgments.
- Design replay resistance, message authentication, key provisioning, rolling counters, sender allowlists, group addressing, duplicate rejection and timeout behavior.
- RF is never a sole safety interlock. EMI, packet loss, wrong group configuration, battery brownouts and unauthorized transmissions must not create activation.
- 2.4 GHz is shared spectrum. Do not claim medical-device immunity or zero interference. Measure coexistence with busy Wi-Fi/Bluetooth environments.

## V1 software milestones
- Python simulator only: PING, STATUS, DISARM accepted; invalid signatures, stale packets and repeats rejected.
- LED-only receivers: authenticated messages indicate state through LEDs, no heating output.
- Test at 10/30/60 feet with people, balloons, walls and metal structures; record packet success rate, latency, battery life and failure responses.
- Separate attachment/interface design requires independent thermal review and hardwired safety mechanisms; it is outside V1.

## PCB/CAD
- KiCad: 2-layer radio + power board after module documentation; observe antenna keep-outs and power layout guidance.
- FreeCAD: sealed insulating enclosure, secure attachment, battery isolation, strain relief and tamper-resistant arm/disarm interface.
- Before manufacturing: release versioned schematics, BOM, placement files, Gerbers, drill files, assembly drawings, test fixtures and design review notes.
