# Performer Proximity Cues — concept and safety requirements

## Feature
A designer assigns a virtual cue zone in the stage layout to a named performer/prop tag and a named scene/cue. A stage manager can explicitly enable monitoring for that scene; an identified tag entering the virtual zone raises a **READY / PROXIMITY MET** indication.

For non-hazardous outputs (LED/sound), zone crossing may trigger an automatic simulated/real benign response if configured. For **thermal balloon effects**, a performer entering a zone must NEVER by itself cause heat output. Require a separate deliberate operator GO after safe-condition verification, plus independent physical safety controls; no unattended physical effect timer or relay.

## User workflow
- Act > Scene > Cue; add spatial trigger to cue.
- Select performer/tag, attach to costume or prop, map to stage zone, set intended position tolerance.
- Show a real-time stage plot with tag age, confidence and drift; distinguish measured positions from simulated stage coordinates.
- Stage manager ENABLES proximity monitoring for one scene, then a zone crossing presents READY. GO/HOLD/ABORT and preflight remain independent.
- Entry dwell, exit hysteresis, minimum confidence, stale measurement rejection, re-entry lockout and one-shot cue behavior.
- Any loss of tracking, duplicate identity, wrong stage map, stale battery, unexpected person or radio fault -> NO AUTOMATIC HAZARDOUS OUTPUT.

## Technical validation
- ESP32-C3 RSSI is insufficient for accurate feet-level performer-to-prop positioning on a crowded stage.
- Consider UWB anchors/tags or Bluetooth 6 Channel Sounding-enabled radios for later Pro stage-location subsystem. Bluetooth Channel Sounding is not guaranteed by an ESP32-C3 module; may require a different chipset and integration.
- For lightweight applications, floor pressure mat/beam-break detectors may be more dependable for crossing a specified stage mark; separately assess interference, trip and obstruction hazards.
- Position accuracy, latency, multipath, reflective props, heavy costumes, low signal, tag battery and multiple performers must be measured at actual venues before any control integration.
- Time-stamped trigger events and audit trail (who enabled, who confirmed, proximity measurement confidence, outcome).

## Acceptance tests
- LED-only simulator includes actor moving across virtual stage, cue enable, READY, explicit rehearsal confirmation.
- Returning actor to same zone does not retrigger without deliberate cue reset.
- Changing the scene invalidates prior proximity readiness and requires renewed operator enable.
- Wrong tag or ambiguous measurements never count as qualified presence.
- Physical thermal-actuation interface not provided; design review first.

## Sources
Bluetooth SIG Channel Sounding: https://www.bluetooth.com/learn-about-bluetooth/feature-enhancements/channel-sounding/
2025 scientific evaluation (outliers/accuracy): https://doi.org/10.1109/ACCESS.2025.3623242
Actor's Equity theatrical effects safety reference: https://www.actorsequity.org/resources/Producers/safe-and-sanitary/pyrotechnics/
(Note: balloon heaters are not necessarily pyrotechnics; cite only as relevant live-effects practices, not categorical legal classification.)
