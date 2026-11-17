# Modernization log — 2026-11-17

- Cloned the authorized repository, verified clean `master`, origin URL and origin/HEAD. Starting commit: `877c1f9`. No existing local edits.
- Read shared/local instructions and reduced principles. Used a separate APFS copy of Flutter 3.50.0; shared SDK and other projects were not modified. Checked disk availability.
- Inspected original helpers, model, labels and platform files. FlatBuffer inspection: float32 RGB input `[1,224,224,3]`, float32 softmax `[1,2]`, labels `0 Gato`, `1 Cachorro`; first graph operator PAD (no input normalization). Preserved model bytes.
- Replaced discontinued legacy tflite and percent_indicator. Resolved newest compatible dependencies without overrides; retained SDK and upstream pins explicitly.
- TDD: domain tests first failed because the new API did not exist (`/private/tmp/teachable-domain-red.log`), then 5 tests passed. Controller and widget tests likewise failed before replacement (`teachable-controller-red.log`, `teachable-widget-red.log`); 9 combined tests passed afterward.
- Added pure validation, EXIF orientation, center crop, RGB normalization `(channel/127.5)-1`, bounded decoding and validated softmax interpretation. This follows the Teachable Machine MobileNet convention; original training data/export metadata are unavailable, so accuracy is not asserted.
- Replaced static helper lifecycle with an injected controller. Tested cancellation, stale results after reset, load/inference/picker failures, retry and disposal. Each inference owns its native interpreter in an isolate, so native resources are never shared with a disposed UI.
- Built responsive Material UI with accessible controls, two-class explanation, local privacy, empty/loading/error/result states and recovery. Widget checks cover narrow and wide viewports.
- Updated platform scaffolding from the pinned SDK, preserved original Android/iOS application identifiers and existing icons. Added macOS read-only selected-file access and a build phase to embed/sign the package's native runtime.
- Checked installed crapper, dryer and mutator help: none supports Dart. No CRAP, duplication or mutation score is claimed.
- Generated a fresh AI conceptual cover, visibly labelled as illustration. Application screenshots are captured separately from the running app.
- Native smoke test first found a relative-file lookup error in the test harness; moved licensed photos into bundled assets. Re-run passed native model loading, real cat/dog predictions, malformed-image rejection and post-disposal rejection. No accuracy benchmark was claimed.
- Added bundled sample buttons and Android lost-picker-data recovery. Converted decoded channels to uint8 before normalization, including higher-bit-depth sources.
- macOS debug build passed. Release build passed (57.3 MB). Release app visually inspected via native UI: both samples inferred, a cat file opened through the system picker, picker cancellation retained the previous result, and reset restored the empty state. Captured actual empty/cat/dog screens in `docs/images/`.
- Static analysis passed with no issues; 9 unit/controller/widget tests passed. Validated domain outputs before any push.
- Updated repository About in English and confirmed five topics: dart, flutter, image-classification, machine-learning, teachable-machine.
