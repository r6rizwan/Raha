# Changelog

All notable changes to Raha should be documented in this file.

## v1.1.2

- Fixed Food screen thumbnails for Google Places-backed restaurants by routing list images through the backend photo proxy
- Fixed delayed duplicate booking validation messages by moving missing date/time feedback inline inside the booking sheet
- Fixed service booking times showing incorrectly in Profile by normalizing booking timestamps between device local time and stored UTC time

## v1.1.1

- Added a manual `Check for Updates` action in Profile and switched update detection to the installed app version instead of a hardcoded value
- Localized AI recommendation requests and CTA labels for Arabic, with better mixed Arabic-English card rendering on Home
- Localized Home service category labels in Arabic mode
- Reworked language selection in Profile into a dedicated two-option English/Arabic selector
- Fixed RTL and mixed-language layout issues across localized screens
- Locked the app to portrait mode and aligned iOS orientation support with the Flutter app restriction
- Fixed iOS Firebase setup by adding `GoogleService-Info.plist` to the Xcode project resources
- Restored the iOS status bar visibility and removed landscape orientations from the iOS app configuration
- Fixed iOS project setup issues affecting app startup on simulator and device

## v1.1.0

- Added Arabic translation and Right-to-Left (RTL) support across the main app flows and shared UI
- Implemented persisted language preference selection using SharedPreferences
- Integrated Arabic-aware backend Gemini recommendation prompts
- Added Arabic localized fallback recommendation cards for AI failures
- Updated default production API endpoint to point directly to live Render server
- Cleaned up redundant configurations and dead env code

## v1.0.2

- Fixed Google Places photo proxy responses so food detail images load as real image bytes instead of invalid JSON payloads
- Improved user-facing error messages across login, onboarding, bookings, and network failures
- Added automatic text capitalization for user-friendly text inputs
- Added password show/hide toggle on the login and sign-up password field
- Expanded the home screen with richer live sections, utility modules, and stronger visual hierarchy

## v1.0.1

- Fixed onboarding continue flow getting stuck on loading after profile save
- Replaced hardcoded home recommendation cards with live backend-driven recommendations
- Added backend Google Places photo proxy so mobile clients no longer receive raw Places API photo URLs with server credentials
- Improved authenticated profile loading and routing behavior to avoid false onboarding redirects on transient backend failures
- Cleaned temporary client and backend debug logging from auth and onboarding flows
- Enabled Android back callback support and bumped app version to `1.0.1`

## v1.0.0

- Initial Android MVP release with local `build_apk.sh` packaging
- GitHub Actions backend keep-warm workflow for Render deployments
- Firebase Auth onboarding and profile setup
- Food discovery with Google Places-backed live import flow
- Home services listing, booking, and booking history
- AI recommendation cards powered by Gemini
- Offline read fallback for core user flows
