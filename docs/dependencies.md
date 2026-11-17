# Dependencies and reproducible toolchain

Verified on 2026-11-17: Flutter **3.50.0** stable (`ab2912035e`), Dart **3.14.0**, Xcode **27.2**, CocoaPods **1.16.2**. The shared Flutter SDK was not modified. The isolated SDK was copied to `/private/tmp/teachable-flutter-sdk`.

Direct packages: material_ui **1.11.1**, tflite_flutter **0.12.1**, image **4.13.1**, image_picker **1.2.4**; flutter_lints **6.0.0**. Flutter, flutter_test and integration_test come from the pinned SDK.

`flutter pub outdated` reports every direct/development dependency current. Three newer catalog releases cannot resolve: cross_file **0.3.5+5** (upstream image_picker/file_selector constraints exclude **0.4.0**), material_color_utilities **0.13.0** and test_api **0.7.14** (SDK pins exclude **0.13.1** and **0.7.15**). There are no dependency overrides. Commit and enforce pubspec.lock.

The macOS tflite_flutter plugin still requires CocoaPods, with a warning about future Swift Package Manager enforcement. Its package includes a universal x86_64/arm64 native library. `tool/embed_tflite_macos.sh` copies that resolved package library into Resources and signs it during the Xcode embed phase; no separate unversioned runtime download is required. Preserve its Apache-2.0 license notices.

Android scaffolding uses Gradle **9.5.0**, AGP **9.3.1**, Kotlin **2.4.20**, JVM target **17**, minimum API **26**. Android/iOS configurations are maintained but were not physically tested. No SDK licenses were accepted. macOS deployment target is **12.0**, iOS template target **15.0**. No web implementation is advertised: tflite_flutter provides a native runtime only.

## Resolved package inventory

- `archive`: 4.7.1
- `async`: 2.13.1
- `boolean_selector`: 2.1.2
- `characters`: 1.4.1
- `clock`: 1.1.3
- `collection`: 1.19.1
- `cross_file`: 0.3.5+5
- `cupertino_ui`: 1.1.7
- `fake_async`: 1.3.3
- `ffi`: 2.2.0
- `file`: 7.0.1
- `file_selector_linux`: 0.9.4+1
- `file_selector_macos`: 0.9.5+2
- `file_selector_platform_interface`: 2.7.0
- `file_selector_windows`: 0.9.3+6
- `flutter`: 0.0.0
- `flutter_driver`: 0.0.0
- `flutter_lints`: 6.0.0
- `flutter_localizations`: 0.0.0
- `flutter_plugin_android_lifecycle`: 2.0.35
- `flutter_test`: 0.0.0
- `flutter_web_plugins`: 0.0.0
- `fuchsia_remote_debug_protocol`: 0.0.0
- `http`: 1.6.0
- `http_parser`: 4.1.2
- `image`: 4.13.1
- `image_picker`: 1.2.4
- `image_picker_android`: 0.8.13+25
- `image_picker_for_web`: 3.1.1
- `image_picker_ios`: 0.8.13+15
- `image_picker_linux`: 0.2.2
- `image_picker_macos`: 0.2.2+1
- `image_picker_platform_interface`: 2.11.2
- `image_picker_windows`: 0.2.2
- `integration_test`: 0.0.0
- `intl`: 0.20.3
- `leak_tracker`: 11.0.2
- `leak_tracker_flutter_testing`: 3.0.10
- `leak_tracker_testing`: 3.0.2
- `lints`: 6.1.0
- `listen`: 1.0.1
- `matcher`: 0.12.20
- `material_color_utilities`: 0.13.0
- `material_ui`: 1.11.1
- `meta`: 1.19.0
- `mime`: 2.1.0
- `path`: 1.9.1
- `platform`: 3.2.0
- `plugin_platform_interface`: 2.1.8
- `posix`: 6.5.4
- `process`: 5.0.6
- `quiver`: 3.2.2
- `sky_engine`: 0.0.0
- `source_span`: 1.10.2
- `stack_trace`: 1.12.2
- `stream_channel`: 2.1.4
- `string_scanner`: 1.4.1
- `sync_http`: 0.3.1
- `term_glyph`: 1.2.2
- `test_api`: 0.7.14
- `tflite_flutter`: 0.12.1
- `typed_data`: 1.4.0
- `vector_math`: 2.4.4
- `vm_service`: 15.4.0
- `web`: 1.1.2
- `webdriver`: 3.2.0
