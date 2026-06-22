#!/bin/bash
set -e

APP_DIR="frontend"
OUTPUT_DIR="build_artifacts"
BASE_URL="https://raha-c9e7.onrender.com"

cd "$(dirname "$0")/$APP_DIR"

flutter clean
flutter pub get
flutter build apk --release --dart-define=BASE_URL="$BASE_URL"

APK_PATH="build/app/outputs/flutter-apk/app-release.apk"
VERSION=$(grep '^version: ' pubspec.yaml | sed 's/version: //' | cut -d'+' -f1)

mkdir -p "../$OUTPUT_DIR"
cp "$APK_PATH" "../$OUTPUT_DIR/raha-v$VERSION.apk"

echo "Release APK created at: $OUTPUT_DIR/raha-v$VERSION.apk"
