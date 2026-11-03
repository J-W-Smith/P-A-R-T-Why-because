# Authentication and connected accounts — P-A-R-T Studio

**Decision (2026-11-02):** Local-first and account-optional. No app-specific passwords. Use **OpenID Connect (OIDC)** for user authentication, on top of OAuth 2.0 Authorization Code + PKCE (S256). Do not confuse authentication with Bluetooth pairing: cloud account sessions NEVER directly authorize thermal or other physical effect commands.

## Suggested stack
- **Flutter**: Android, iOS, Windows/macOS, with Linux validated separately.
- **Supabase Auth** as initial managed open-source-based identity backend, with option to self-host; evaluate deployment/maintenance burden before self-hosting. Social identity providers at launch: Google, Apple, Microsoft; additional OIDC providers later. Email magic link possible, but no local password database.
- OAuth login must launch the **system browser**, not embedded webview. External redirect/deep link handling and sign-in flow are platform specific; validate every target OS. Use App Links / Universal Links where practical or secure loopback native callbacks on desktop. Enforce verified state, nonce when applicable, redirect URI matching and PKCE S256.
- Session tokens handled by supported SDK with secure device storage (Keychain, Android Keystore, Windows credential protection, macOS Keychain). Never commit secrets/client credentials; native apps are public clients and must not embed a client secret.
- Only request minimal profile scopes (openid, email, profile). Do not request cloud-drive/email access until user explicitly enables such a feature.

## Offline-first design
- Room layouts, node labels, cue patterns, rehearsal simulations and local BLE gateway should work **fully offline and without signing in**.
- 'Continue as guest' is the primary first-run path; allow account later to sync shows, collaborate and restore configurations across devices.
- Sessions may persist securely and refresh when connectivity returns; do not require cloud connectivity during show.
- Account-based entitlement or sharing must be validated server-side; never use cloud login to circumvent independent physical safety interlocks.
- Allow export/import, account deletion and data portability. Explicitly distinguish local-only and synced data; conflict handling requires event logs and user resolution.

## Application UX
Welcome screen: 'Continue without account', 'Continue with Google', 'Continue with Apple', 'Continue with Microsoft'. Clearly mark sync as optional.
Profile: linked identities, local/synced workspaces, device sessions, sign out, delete account, revoke provider connections, export data.
Team collaboration (later): organization with owner/admin/operator/viewer roles, invitations, show sharing, audit log. Actions affecting physical outputs must also require local device authorization.

## Apple App Store
Apple guideline 4.8 requires an equivalent privacy-preserving login option for most apps using third-party social login, subject to exceptions. Plan to offer Sign in with Apple. Native iOS integration may differ from web flow.

## Planned implementation
1. Add AuthRepository interface with GuestAuthRepository (fully offline and testable).
2. Add SupabaseAuthRepository implementing OIDC sessions behind interface, with secure tokens and platform-specific redirect config.
3. Build provider login UI and account link/unlink tests.
4. Enable optional sync with row-level security (RLS) and strict per-user/per-organization ownership controls.
5. Run security review, mobile deep-link takeover/redirect attacks, token lifetime/revocation tests, privacy/legal review before production.

## Primary references
- https://www.rfc-editor.org/rfc/rfc8252.html
- https://www.rfc-editor.org/rfc/rfc9700.html
- https://www.rfc-editor.org/rfc/rfc10017.html
- https://supabase.com/docs/guides/auth/social-sign-in
- https://supabase.com/docs/guides/self-hosting
- https://developer.apple.com/app-store/review/guidelines/

**Important:** OAuth means we don't handle third-party passwords; it does NOT mean zero security responsibilities. We still protect session tokens and account data.
