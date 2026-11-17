#!/bin/sh
set -eu
# Flutter's plugin symlink points to the version resolved in pubspec.lock.
source_library="$PROJECT_DIR/Flutter/ephemeral/.symlinks/plugins/tflite_flutter/macos/libtensorflowlite_c-mac.dylib"
target_dir="$TARGET_BUILD_DIR/$CONTENTS_FOLDER_PATH/Resources"
mkdir -p "$target_dir"
cp "$source_library" "$target_dir/libtensorflowlite_c-mac.dylib"
/usr/bin/codesign --force --sign "${EXPANDED_CODE_SIGN_IDENTITY:--}" "$target_dir/libtensorflowlite_c-mac.dylib"
