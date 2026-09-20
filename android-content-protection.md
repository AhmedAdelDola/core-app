# Android content protection contract

This feature protects tenant-hosted video, audio, and PDF files. YouTube and live sessions remain outside device attestation. Existing `/api/mobile/v1` clients continue to work in `off` and `monitor`; hosted-content delivery returns HTTP 426 with `MOBILE_APP_UPDATE_REQUIRED` after the tenant enables `enforce`.

## Server configuration

Configure these global secrets once on the backend:

- `PLAY_INTEGRITY_CLOUD_PROJECT_NUMBER`
- `PLAY_INTEGRITY_SERVICE_ACCOUNT_JSON_BASE64`
- `ANDROID_KEY_ATTESTATION_ROOT_CERTIFICATES_BASE64`: base64 of a PEM bundle containing the trusted Google Android Key Attestation roots.

Each tenant configures `android_package_name`, all allowed app-signing SHA-256 fingerprints, and `content_protection_mode`. `enforce` additionally requires `student_web_app_enabled=false`.

Each tenant has its own Android application and Google Play listing. The app uses a unique package name and sends its fixed tenant domain in `X-Tenant-Domain` on every API request. Every Play Console app must link to the shared `A Plus Play Integrity Runtime` Cloud project, while package names and public app-signing SHA-256 fingerprints remain tenant-specific in the dashboard. Never upload an app signing private key, keystore, or Google service-account JSON to tenant settings.

## Android enrollment

1. Call `GET /api/mobile/v2/security/config` with the student Sanctum token.
2. Call `POST /api/mobile/v2/device-attestations/challenge`.
3. Base64-decode `payload_to_sign`. Generate an ECDSA P-256 signing key in Android Keystore with that byte array passed to `KeyGenParameterSpec.setAttestationChallenge`. Prefer StrongBox and fall back to TEE, never software.
4. Request a Standard Play Integrity token using `play_integrity_request_hash` as `requestHash`.
5. Sign the decoded payload bytes using `SHA256withECDSA` and send the DER signature as base64 to `POST /api/mobile/v2/device-attestations/complete` with the leaf-first certificate chain, Play Integrity token, model, and app version.

The server extracts the public key from the leaf certificate. A client-supplied standalone public key is never accepted.

## Content access

Request `POST /api/mobile/v2/content/challenges`:

```json
{"device_id":"uuid","session_id":123,"content_kind":"session_media"}
```

The response includes `play_integrity_refresh_due` and `play_integrity_token_required`. When refresh is due, request a Standard Play Integrity token using the challenge's `play_integrity_request_hash` and include it in the matching access request. A valid challenge is not consumed when an enforced refresh is missing, so the client may obtain the token and retry the same challenge before it expires.

`content_kind` is `session_media` or `session_pdf`. Sign the decoded `payload_to_sign` with the enrolled key, then call:

```json
{
  "challenge_id":"uuid",
  "device_id":"uuid",
  "signature":"base64-der-ecdsa-signature",
  "play_integrity_token":"include when play_integrity_refresh_due is true"
}
```

Media returns a device-bound playback token and `player_url`. The player URL contains no R2 source URL and resolves it through `resolve_endpoint`. PDF access returns a short-lived URL and fails closed when storage cannot issue one.

## Stable mobile error codes

- `DEVICE_ATTESTATION_REQUIRED`
- `DEVICE_NOT_TRUSTED`
- `SIGNATURE_INVALID`
- `CHALLENGE_EXPIRED`
- `CHALLENGE_REPLAYED`
- `DEVICE_REVOKED`
- `APP_INTEGRITY_FAILED`
- `MOBILE_APP_UPDATE_REQUIRED`

Google is checked at enrollment and every 24 hours. A previously trusted device may continue for up to seven days only when Google is temporarily unavailable. A new device never receives this grace period.
