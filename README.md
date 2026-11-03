# P-A-R-T-Why-because 🎈

Open-source research and engineering notebook for a short-range, individually addressed **wireless event-effects platform**.

**Stage:** concept, patent landscape research, and software-only simulation. **Not** a certified or production-ready balloon-popping device. No energized heater-driving circuitry or firmware is provided; thermal-effect attachments need separate engineering, safeguards, and review.

## Project targets
- 60 ft (~18 m) line-of-sight operating goal, requiring real testing
- ESP32-C3 with ESP-NOW at 2.4 GHz as a **candidate**, not a claim of interference-free operation
- Individually addressed nodes, groups, status, and authenticated commands
- Safe default-off/disarmed behavior; physical arming, independent fault protection and thermal-safety review prior to actuation
- KiCad PCB, FreeCAD enclosure, ESP-IDF firmware, Python simulation
- Repeatable prototypes, actual PCBA quotes, and US-market regulatory evaluation

## Read first
- [Commercial competitor landscape](docs/market-landscape.md)
- [Patent landscape and FTO checklist](docs/patent-landscape.md)
- [System architecture and learning plan](docs/architecture.md)
- [Manufacturing and price model](docs/manufacturing.md)
- [Compliance and testing](docs/safety-compliance.md)

Patent landscape is **not** a legal clearance opinion; ability to patent something is different from freedom to manufacture and sell it. Public disclosure can affect patent rights; consult patent counsel before publishing potentially novel inventions.

## Milestones
1. Build software-only message simulator and replay/expiry tests.
2. Build LED-only ESP32-C3 receiver prototype and measure packet reliability at 10/30/60 ft.
3. Produce first KiCad receiver PCB and open-source enclosure without thermal output.
4. Obtain competitive assembled PCB quotations.
5. Review patent claims with counsel, plus thermal/electrical, EMC, battery and product safety requirements before any sale.

## License
Licensing policy is **under review** while the commercial/IP strategy is determined. Contributions and design assets should not be assumed patent-licensed; obtain permission before using any third-party proprietary design.
