# TODO — Aegis IdP

## Turn on backup codes ("Try another way")

Keycloak already has the pages (select-authenticator, recovery code input) and the
Aegis theme styles them. They only show up once backup codes are switched on.

Admin console → `aegis` realm:

- [x] **Authentication → Required actions**: switch on **Recovery Authentication Codes**.
- [x] **Authentication → Flows**: duplicate **browser** as `aegis browser`.
- [x] In its two-step sub-flow (the one with **OTP Form**): **+ → Add step → Recovery Authentication Code Form**.
- [x] Set **OTP Form** and **Recovery Authentication Code Form** both to **Alternative**.
- [x] **Action → Bind flow → Browser flow**.
- [ ] Backend: add `CONFIGURE_RECOVERY_AUTHN_CODES` after `CONFIGURE_TOTP` in the setup email's required actions.
- [x] Test: add the action to your own user (**Users → you → Required user actions**), sign in, save the codes,
      then sign in again and use **Try another way → backup code**.
- [ ] Optional: build custom templates to match the canvas board "Keycloak · reset & alternative sign-in"
      (redraw it in the split layout first, approve, then code).

## Other loose ends

- [ ] **Authentication → Flows → reset credentials**: disable **Reset - Conditional OTP** so Forgot password
      doesn’t wipe the authenticator app.
- [ ] `keycloak-setup/.env`: `KC_SPI_EVENTS_LISTENER__EMAIL__EXCLUDE_EVENTS=UPDATE_PASSWORD,UPDATE_TOTP,REMOVE_TOTP`
      to stop duplicate security emails — confirm only one email arrives after a password change.
- [ ] Fill theme settings: `aegisSignupUrl`, `aegisAppUrl` (login) and `aegisSignInUrl`, `aegisCompanyAddress` (email).
- [ ] Email `logoUrl`: switch from the raw GitHub link to the deployed app’s `/email-logo.png`.
- [ ] Click through the restyled Keycloak pages (choose a new password, error, link expired) on the split layout.
- [ ] When CSS changes: bump `aegisAssetVersion` in `login/theme.properties`.
- [ ] Compose: keep iam-1/2/3 on the same image tag (consider one `IAM_TAG` variable in `.env`).
