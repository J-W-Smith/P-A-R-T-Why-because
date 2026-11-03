# Manufacturing and cost methodology

The manufacturer's job is to fabricate a **printed circuit board** and optionally assemble purchased components including an off-the-shelf ESP32 module; this project is not fabricating custom silicon.

## Candidate services
- JLCPCB https://jlcpcb.com/
- PCBWay https://www.pcbway.com/
- Consider a US-based small-batch assembler for alternative quote and traceability.

## Planning-only cost assumptions
Receiver electronics/enclosure/battery provisional unit cost (not a bid; excludes effect attachment, controller, compliance, tax/tariffs, development and failures):
- 5 units: $15–64 each
- 25 units: $12–45 each
- 100 units: $8.60–30.50 each
- 500 units: $7–24 each

Request quotes at 5/25/100/500 including PCB fab, SMT placement, feeder/setup, parts sourcing, 3D-print/injection enclosure, cell/pack, inspection/testing, packaging, freight, tariffs and scrap. Quote **total landed cost**, not just PCB fab teaser rate.

## Quote readiness
Do not request a binding per-unit quote until Gerbers, centroid, BOM with alternates, assembly drawings, firmware flashing method, inspection/test plan, power budget and intended enclosure are fixed.

## Commercial economics
Build separate models for engineering NRE, regulatory/EMC certification, insurance, returns, merchant fees, warranty, patent review, customer support and storage. A listed competitor kit price does not imply receiver-only sale price or profit.
