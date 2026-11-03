# Device identify and rehearsal mode

## Core UX
Every placed node has unique immutable hardware ID plus user-friendly display label (e.g. Balloon 07 — Stage Left).

From the layout, the operator can select a device and press **Identify / Test**:
- Flash a dedicated low-power indicator LED on the selected physical receiver.
- Emit a short piezo beacon on receiver if hardware size/energy permits.
- Announce the assigned label through the phone or hub ("Balloon seven, stage left"). Phone/hub audio is preferred to speech hardware on each node.
- Combined sound and flash; configurable audible levels and silent venue policy.

## Rehearsal
- Dry-run selected device, named group or whole cue timeline.
- Simulated 'pop' sound via phone/hub, sound volume control, captions and per-cue spoken labels.
- User-configurable test response settings; accessible visual cues for noisy or hearing-sensitive environments.
- Record command receipt/acknowledgment, connection failures and timing deviation. An emitted phone sound doesn't demonstrate the remote node received a command.
- Allow operator to verify and mark each node's physical placement after audible/visual identification.

## Mandatory safety separation
TEST MODE must have an independent hardware-level mechanism that prevents heating-output activation. Avoid claims that a software-only flag provides physical isolation.
Provide visible 'TEST / DISARMED' status, and do not permit unattended physical thermal-effect timers. Verification should be performed with non-heating outputs.
No heater-driving code, electrical specifications, or activation instructions included in this phase.

## Acceptance criteria
- Selected label and physical device ID never silently diverge.
- No test command can energize a thermal attachment, including after reset, packet loss, malicious/replayed packet, or power fault.
- Voice announcements accurately reflect assigned room positions; on-screen and audio cues can be disabled separately.
- Dry-run timing/reporting distinguishes predicted cues, transmitted commands, receiver acknowledgments, and perceived acoustic playback.
