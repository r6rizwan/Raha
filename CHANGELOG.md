# Changelog

All notable changes to Raha should be documented in this file.

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
