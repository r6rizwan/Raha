# Raha Roadmap

This file tracks future product and engineering work for Raha.

## Vision

Raha should become the go-to mobile companion for expat professionals in the UAE by combining food discovery, trusted home services, and useful local guidance in one reliable app.

## Completed

- Firebase Auth with Google Sign-In and email/password
- Onboarding flow for nationality, city, neighbourhood, and interests
- Home recommendations powered by the backend Gemini AI
- Food discovery with Google Places-backed live import flow
- Home services listing, booking, and booking history
- Offline read fallback for core user flows
- App update checker backed by the backend `/health` endpoint
- **Arabic localization and full RTL layout support** ✓
- **Language preference persistence across app restarts** ✓
- **Arabic AI recommendations — Gemini prompts dynamically switch language** ✓
- Localized Arabic fallback recommendation cards ✓

## Now

- Improve the home experience with richer live modules and better personalization
- Strengthen food and services search, filtering, and discovery flows
- Refine onboarding so user preferences shape the app more clearly from day one
- Improve empty, loading, and error states across all major screens
- Tune recommendation quality and reduce fallback usage where possible

## Next

- Saved food spots and saved service providers
- Booking reschedule and cancellation improvements
- Push notifications for booking updates and reminders
- Better provider detail pages with service scope, pricing clarity, and trust signals
- More city-aware content for Dubai, Abu Dhabi, Riyadh, and Jeddah
- Expand cuisine discovery beyond current seeded and synced categories
- Add deeper search for restaurants, cuisines, and neighbourhoods

## Later

- In-app AI concierge chat for food, services, and local lifestyle help
- Additional language support beyond English and Arabic
- Ratings and reviews for providers and food spots
- Referral and loyalty programs
- Personalized weekly digest of recommendations and local tips
- Employer or community partnerships for expat onboarding bundles

## AI Roadmap

- ~~Arabic AI recommendations (Phase 2)~~ ✓ Done in v1.1.0
- Improve recommendation prompts using richer user profile context
- Add behavior-based personalization from bookings, searches, and views
- Explain recommendations in clearer end-user language
- Add recommendation diversity so food, services, and tips feel balanced
- Reduce Gemini dependency risk with better fallbacks and caching

## Data and Integrations

- Improve Google Places ingestion and refresh cadence
- Add provider onboarding and internal admin tooling
- Add maps, directions, and location-aware ranking
- Add payment integration for booking deposits or full checkout
- Add analytics, crash reporting, and usage dashboards

## Offline and Performance

- Expand offline caching beyond current read fallback
- Add sync-on-reconnect behavior for key user actions
- Improve image loading, caching, and scrolling performance
- Reduce cold-start sensitivity between mobile app and backend

## Security and Reliability

- Complete production certificate pinning strategy
- Add stronger monitoring, alerting, and incident visibility
- Harden auth and abuse protection flows
- Improve release validation for backend env vars and mobile config

## Release and Ops

- Automate signed APK release builds end-to-end
- Prepare Play Store release assets and production checklist
- Separate staging and production environments cleanly
- Formalize app versioning and update rollout policy

## Open Questions

- Should Raha remain UAE-first for the near term or expand regionally sooner?
- Should service bookings stay request-based or move toward live availability slots?
- Should AI recommendations remain lightweight cards or evolve into a full assistant flow?
