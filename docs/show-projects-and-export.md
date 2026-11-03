# Reusable show files, acts, scenes, cues, and reset semantics

## Goal
The same named production can run at different venues and on different days without re-authoring every cue. Offer a simplified event timeline or theatrical Act > Scene > Cue hierarchy, sharing one underlying project model.

## Project data
- `show_id`, `schema_version`, `name`, `description`, creator, modified timestamp, optional tags.
- Venue profiles (dimensions, stage position, layout and device positions, units).
- Logical roles/slots for receivers (`slot_id`, friendly name, physical placement, required capability, group); never export live pairing secrets, OAuth tokens, or unique private radio keys.
- Acts (optional), scenes (optional), named cues with durable IDs, order, relative timing, group assignment, and expected rehearsal responses.
- Audio/voice cues and optional user-supplied audio asset references, with licenses and missing-file detection.
- Safety and verification metadata stored separately from exported show templates; importing cannot mark physical devices as verified or armed.
- Version history, duplicate-as-template, copy/paste cues, and per-show change log.

## UI flows
### Simple events
Event -> timeline -> named cue presets (all, wave, chase, pairs, custom) -> Preview -> Operator GO.
Provide a prominent **Reset to Beginning** control, with explicit clarification that this resets the playhead and simulated completion markers, not physical outputs.

### Theatre
Show -> Act -> Scene -> Cue, using collapse/expand navigation, cue number, operator notes and optional QLab/OSC/MIDI integrations after review.
Controls: Next, Previous, Jump to Cue, Restart Scene, Restart Act, Reset to Beginning, Hold, Rehearsal Run.
Confirmation before destructive edits and live-mode stage resets; never replay earlier physical effects automatically on a timeline reset.

## Export format proposal
File extension: `.partshow` (custom ZIP container; MIME registration, schema and security validation TBD).
Contains:
- `manifest.json` with schema version, minimum supported app version and optional checksums.
- `show.json` logical venue layout and cue data.
- `assets/` optional user-supplied audio/thumbnail files, subject to max sizes/content checks.
No tokens, credentials, radio pairing keys, raw passwords, user identity provider claims, or hardware authorization state.

Provide additional human-readable JSON export for advanced users. Validate archive entry size/path to prevent zip slip/bomb attacks. Migrate old schemas explicitly and retain backups. Bundle import must show a preview and conflicts instead of immediately overwriting an existing production.

## Device mapping and reset
Import never assumes the receiver previously assigned to 'Balloon 07' is physically in place. Each new installation:
1. Locate/scan unique receiver IDs and map logical slots.
2. Perform visual/audible Identify with non-heating test.
3. Confirm positions and operator preflight. Prevent any import from copying physical verification or arm state.

'Reset to Beginning' ONLY returns cue playhead to first cue; it does not recharge batteries, replace balloons or silently re-arm any thermal attachments.
'Prepare New Performance' starts a new run with a fresh inspection/verification checklist; no unattended effect activation.

## Auth and sharing
Offline guest export/import works without a cloud account. Optional signed-in sync provides backups and cross-platform sharing. For collaboration use organization/workspace roles and revision conflict handling.
Sensitive logs (physical activations, operator identities) excluded from general shared templates by default.

## Proposed initial app milestone
Implement Flutter data classes, a file schema (version 1), JSON serialization tests, demo production, tree-based act/scene/cue editor, and simulator-only reset. Defer live output implementation until independently safety-reviewed.

## Important IP note
Existing theatre show-control systems use act/scene/cue concepts; this organizational model is not itself new or presumptively patentable.
