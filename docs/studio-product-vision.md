# P-A-R-T Studio — application-first event cue design

## Vision
The customer configures a space and visually assigns reusable, uniquely labeled effect nodes to positions. They design dry-run cue sequences, verify readiness, then deliberately operate a professionally safety-reviewed effects system. Intended users include balloon decorators, live events and theatre.

## Onboarding
1. Choose room shape and approximate dimensions; allow custom dimensions, stage position and optional obstacles.
2. Add physically labeled receiver nodes (QR/NFC/printed ID). Pair with proof of physical access and map ID to positions. Never rely on inferred BLE coordinates.
3. Preview effect timing using software-only simulations and LED mock nodes.
4. Assign to named scenes and groups; save and clone show templates.
5. Perform preflight checklist and operator confirmation before any physical effect. No unattended hot-surface execution.

## Cue editor
- Individual cues; groups; sequential wave, chase, pair, randomized order; delay and relative timing.
- Manual GO, HOLD, ABORT; cue versioning, repeatable templates, status and event log.
- Theatre integration investigation: OSC, MIDI Show Control / QLab interoperability, potentially DMX via an approved show-control gateway.
- Timer cues are schedules of **intent**, not unconditional future heater activations. If an effect requires thermal energy, a trained operator, independent hardware safety checks and on-site review are mandatory.
- Show offline in a local network with no cloud login requirement.

## Proposed communication
Phone (BLE) -> dedicated show gateway -> authenticated 2.4 GHz ESP-NOW -> individually addressed nodes.

Why gateway: phone BLE connections to many individual receivers are cumbersome; gateway manages groups, acknowledgments, link measurement and timing. The ESP32-C3 can run BLE/Wi-Fi coexistence, but it shares one RF front-end, making radio contention and latency testing essential. Reference https://docs.espressif.com/projects/esp-idf/en/v5.5/esp32c3/api-guides/coexist.html

An alternative pure BLE architecture and wired theatre gateway should be benchmarked. 60-foot range is an experimental goal, not guaranteed in crowded venues. RF channels are shared; there is no interference-free band and no absolute medical-device safety guarantee.

## Safety and fault behavior
All early prototypes are LED-only. Physical effect attachments must be designed and reviewed independently. Connection loss, expired commands, app backgrounding, low battery, wrong pairing, reset and radio interference must result in safe nonactivation. Do not allow unattended hot-effect timers. An emergency stop must have a hardware-independent path as appropriate to hazard assessment.

## Suggested milestones
A. Browser show editor and simulated receiver layer.
B. Android BLE discovery + authenticated gateway proof of concept, no actuators.
C. 8 LED nodes, then 32 nodes: 60 ft packet-loss, drift, delay and busy-venue tests.
D. KiCad PCB and priced BOM.
E. Theatre integration prototype using OSC or MIDI, validated independently.
F. Legal/FTO, safety, EMC and manufacturing review before physical effect use.

## Research
- https://qlab.app/docs/v4/control/midi-cues/
- https://docs.espressif.com/projects/esp-idf/en/v5.5/esp32c3/api-guides/coexist.html
