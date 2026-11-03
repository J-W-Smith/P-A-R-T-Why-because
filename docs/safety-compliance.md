# Product safety, RF and commercialization gates

- No frequency is medically 'safe' in an absolute sense. We will use compliant low-power radio modules, their approved antenna configurations, and study EMC/coexistence.
- For the US, assess FCC Part 15 / 15.212 conditions and labeling for the **final assembled device**, not just the module. Start: https://docs.fcc.gov/public/attachments/DA-08-314A1.pdf
- Thermal-output attachments are **not part of V1**. Separate review needed for unintended activation, hot-surface contact, battery faults, thermal runaway, shorted drivers, software hangs, and safe mounting/removal.
- Explicit independent safety mechanisms must not depend solely on firmware or RF.
- Assess appropriate battery transportation, replacement, and child-access protections; perform product hazard and liability review, and determine venue/fire code restrictions.
- Keep product marked prototype and do not sell until design verification and regulatory evaluation.
