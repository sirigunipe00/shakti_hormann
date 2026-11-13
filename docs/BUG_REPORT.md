# Bug Report — Shakti Hormann Flutter (Pre-QA Audit)

| Field | Value |
|---|---|
| **Audit date** | 2026-11-05 |
| **App version** | 2.0.0+1 |
| **Environment** | UAT |
| **Code modified during audit** | No |

**Legend**

- **Confirmed (code):** Defect proven by source inspection.
- **Confirmed (device):** Observed on emulator during smoke.
- **Risk:** Strongly indicated; needs QA reproduction.
- **Potential:** Defense-in-depth / future exposure.

Severities: Critical / High / Medium / Low.

---

## Critical

### BUG-001 — API key and secret stored in plaintext SharedPreferences
| | |
|---|---|
| **Module** | Auth / Local storage |
| **Title** | API credentials duplicated into insecure SharedPreferences |
| **Description** | After login, `apiKey` and `apiSecret` are written with `storage.setString` (SharedPreferences) in addition to the secure user blob. On rooted devices or backup extract, tokens can be stolen. |
| **Steps** | 1. Login successfully. 2. Inspect SharedPreferences keys under `in.easycloud.m11_ind.apiKey` / `apiSecret`. |
| **Expected** | Secrets only in encrypted/secure storage. |
| **Actual** | Plain SharedPreferences values. |
| **Severity / Priority** | Critical / P0 |
| **Evidence** | `lib/features/auth/data/auth_repo_impl.dart` (~65–66) |
| **Status** | Confirmed (code) |
| **Recommended fix** | Store secrets only in FlutterSecureStorage; remove SharedPreferences copies; migrate existing installs. |

### BUG-002 — User password persisted with session
| | |
|---|---|
| **Module** | Auth / WIMM |
| **Title** | Plaintext password saved into LoggedInUser and secure JSON |
| **Description** | Login copies password into `LoggedInUser` via `copyWith(password: pswd)` and persists full JSON. Used later for Frappe desk cookie login (WIMM). Increases blast radius of storage compromise. |
| **Steps** | Login → inspect secure storage user JSON for password field. |
| **Expected** | Prefer short-lived desk token/cookie without long-term password retention, or encrypt with hardware-backed key and clear ASAP. |
| **Actual** | Password retained for session lifetime. |
| **Severity / Priority** | Critical / P0 |
| **Evidence** | `auth_repo_impl.dart` (~63–75); `frappe_session.dart` |
| **Status** | Confirmed (code) |
| **Recommended fix** | Redesign WIMM auth without storing password; if unavoidable, document residual risk and minimize lifetime. |

### BUG-003 — Debug logs include Authorization headers and request bodies
| | |
|---|---|
| **Module** | Networking |
| **Title** | ApiClient logs credentials and payloads in debug |
| **Description** | When `kDebugMode`, logger prints URI, body, **headers**, status, and response. Authorization token appears in logcat / Crashlytics-adjacent debugging. |
| **Steps** | Run debug build → perform authenticated API call → inspect logcat. |
| **Expected** | Redact Authorization and sensitive fields. |
| **Actual** | Full headers logged. |
| **Severity / Priority** | Critical (debug) / P0 |
| **Evidence** | `lib/core/network/api_client.dart` (~119–125); device logs historically show `authorization: token …` |
| **Status** | Confirmed (code + prior device logs) |
| **Recommended fix** | Never log Authorization; scrub passwords; gate verbose logs behind explicit diagnostic flag. |

---

## High

### BUG-004 — No client-side route RBAC
| | |
|---|---|
| **Module** | Navigation / Security |
| **Title** | Feature routes not guarded by RoleStatus |
| **Description** | Permissions only hide Home tiles. Authenticated users can `go` to feature paths they should not see. Server must enforce; client currently does not. |
| **Severity / Priority** | High / P1 |
| **Evidence** | `app_home_page.dart` tile gating; `route_config.dart` lacks per-route redirect |
| **Status** | Confirmed (code) |
| **Recommended fix** | GoRouter `redirect` checks auth + permission per route. |

### BUG-005 — HTTP 401 does not force logout
| | |
|---|---|
| **Module** | API / Auth |
| **Title** | Unauthorized responses leave local session intact |
| **Description** | 401 maps to `ServerException(invalidcredentials)` only — no storage clear / navigate to login. |
| **Severity / Priority** | High / P1 |
| **Evidence** | `api_client.dart` (~147–148) |
| **Status** | Confirmed (code) |

### BUG-006 — Release builds target UAT, not live
| | |
|---|---|
| **Module** | Bootstrap / Release |
| **Title** | Debug and release both register UAT base URL |
| **Description** | `Urls.live()` unused. Release APK talks to UAT. Acceptable for QA builds; **wrong** for production store builds. |
| **Severity / Priority** | High / P1 (prod blocker) |
| **Evidence** | `lib/bootstrap.dart` (~24–28) |
| **Status** | Confirmed (code) |

### BUG-007 — Stale success state can show success after failure
| | |
|---|---|
| **Module** | Multiple create forms |
| **Title** | Failure path may leave `isSuccess: true` |
| **Description** | Several cubits set `error` without clearing `isSuccess`. Listeners without `listenWhen` may show success dialogs after a later failure. |
| **Severity / Priority** | High / P1 |
| **Evidence** | Gate entry / logistic / POD / pallet cubit fold patterns; older `new_*` listeners |
| **Status** | Confirmed (code) / Risk for QA |

### BUG-008 — Duplicate create/submit race conditions
| | |
|---|---|
| **Module** | Gate Entry, Gate Exit, Logistic, Vehicle, POD, Loading, Gate Mgmt, Pallet, Hardware, Vision, … |
| **Title** | Cubit save/submit lacks re-entry guard |
| **Description** | Double-tap before `isLoading` emit can fire parallel API creates. |
| **Severity / Priority** | High / P1 |
| **Status** | Confirmed (code) |

### BUG-009 — Proof of Delivery geo “Allow” may pop the form
| | |
|---|---|
| **Module** | Proof of Delivery |
| **Title** | `context.pop()` after opening app settings can dismiss POD form |
| **Description** | On denied-forever path, after `Geolocator.openAppSettings()`, code calls `context.pop()` which may pop the page route, not only a dialog. |
| **Steps** | Open POD → deny location forever → tap Allow in dialog. |
| **Expected** | Only dialog closes; form remains. |
| **Actual** | Form may close (code path). |
| **Severity / Priority** | High / P1 |
| **Evidence** | `pod_form_widget.dart` (~160–166) |
| **Status** | Confirmed (code) |

### BUG-010 — Logistic Request “Send for Approval” no-op path
| | |
|---|---|
| **Module** | Logistic Request |
| **Title** | `onSubmit: () {}` when default TitleStatusAppBar submit shows |
| **Description** | Empty submit handler; action can appear with no effect for some statuses. |
| **Severity / Priority** | High / P1 |
| **Evidence** | `new_logistic_request.dart` (~367); `title_status_app_bar.dart` |
| **Status** | Confirmed (code) |

### BUG-011 — Logistic success condition compares document name to status string
| | |
|---|---|
| **Module** | Logistic Request |
| **Title** | Success UI checks `form.name == 'Pending From Transporter'` |
| **Description** | Document `name` (e.g. `LR-SHM-…`) is compared to a **status** string — success dialog logic likely wrong. |
| **Severity / Priority** | High / P1 |
| **Evidence** | `new_logistic_request.dart` (~385–386) |
| **Status** | Confirmed (code) |

### BUG-012 — Frame / Shutter Save vs Submit methods inverted
| | |
|---|---|
| **Module** | Frame Packaging / Shutter Packaging |
| **Title** | Save calls `createDocument()`, Submit confirm calls `save()` |
| **Description** | Naming/lifecycle mismatch confuses QA and may hit wrong API stage. |
| **Severity / Priority** | High / P1 |
| **Evidence** | `new_frame.dart` (~108, ~376); `new_shutter.dart` (~113, ~381) |
| **Status** | Confirmed (code) |

### BUG-013 — Zone Transfer not reachable from Home
| | |
|---|---|
| **Module** | Zone Transfer |
| **Title** | Routes exist but no Home dashboard tile |
| **Description** | QA cannot discover Zone Transfer without deep link / manual route. Storage and Zone share `NewEntry` + `CreateZoneCubit`. |
| **Severity / Priority** | High / P1 |
| **Evidence** | `app_home_page.dart` (no Zone item); `route_config.dart` |
| **Status** | Confirmed (code + Home screenshots) |

### BUG-014 — Storage Allocation uses Zone create cubit; CreateStorageCubit unused
| | |
|---|---|
| **Module** | Storage Allocation / Zone Transfer |
| **Title** | Create flow consolidation left dead storage cubit |
| **Description** | Risk of wrong doctype / validation / copy for Storage vs Zone. |
| **Severity / Priority** | High / P1 |
| **Evidence** | `route_config.dart` NewEntry + CreateZoneCubit |
| **Status** | Confirmed (code) |

### BUG-015 — Android cleartext + no certificate pinning
| | |
|---|---|
| **Module** | Platform security |
| **Title** | `usesCleartextTraffic=true`; no SSL pinning; debug accepts bad certs |
| **Severity / Priority** | High / P1 |
| **Evidence** | `AndroidManifest.xml`; `injector.dart` badCertificateCallback |
| **Status** | Confirmed (code) |

---

## Medium

### BUG-016 — Bottom navigation overlaps Logistic Request detail form
| | |
|---|---|
| **Module** | Logistic Request / Shell |
| **Title** | Form fields clipped under floating bottom nav |
| **Description** | On detail screen, content scrolls under bottom nav; “Delivery Order Details” / lower fields obscured. |
| **Severity / Priority** | Medium / P2 |
| **Evidence** | `docs/qa_evidence/logistic_request_detail.png` |
| **Status** | Confirmed (device) |

### BUG-017 — Dashboard “Entry share 50%” with zero movements
| | |
|---|---|
| **Module** | Dashboard |
| **Title** | Misleading percentage on empty dataset |
| **Severity / Priority** | Medium / P2 |
| **Evidence** | `docs/qa_evidence/dashboard_empty.png` |
| **Status** | Confirmed (device) |

### BUG-018 — UniqueKey on app-bar dropdowns resets selection
| | |
|---|---|
| **Module** | Gate Exit/Entry, Vehicle, POD, Logistic, Loading |
| **Title** | `UniqueKey()` forces widget recreate on rebuild |
| **Severity / Priority** | Medium / P2 |
| **Status** | Confirmed (code) |

### BUG-019 — Empty `onSubmit` / `onReject` stubs on many TitleStatusAppBars
| | |
|---|---|
| **Module** | Multiple |
| **Title** | Dead handlers when default buttons appear |
| **Severity / Priority** | Medium / P2 |
| **Status** | Confirmed (code) |

### BUG-020 — Loading Confirmation save button uses set-literal body
| | |
|---|---|
| **Module** | Dispatch Loading |
| **Title** | `onPressed: () => { cubit.save(), }` |
| **Severity / Priority** | Medium / P2 |
| **Evidence** | `new_loading_confirmation.dart` |
| **Status** | Confirmed (code) |

### BUG-021 — Transport create path calls `approve()` / submit API
| | |
|---|---|
| **Module** | Transport Confirmation |
| **Title** | Create button semantics are submit/approve, not draft save |
| **Severity / Priority** | Medium / P2 |
| **Status** | Confirmed (code) |

### BUG-022 — Gate Exit empty copy typo
| | |
|---|---|
| **Module** | Gate Exit |
| **Title** | “No GateExists Found.” |
| **Severity / Priority** | Medium / P3 |
| **Status** | Confirmed (code) |

### BUG-023 — Gate Management empty copy wrong module name
| | |
|---|---|
| **Module** | Gate Management |
| **Title** | “No GateEntries Found.” |
| **Severity / Priority** | Medium / P3 |
| **Status** | Confirmed (code) |

### BUG-024 — Filter Draft type inconsistency (string vs int)
| | |
|---|---|
| **Module** | Hardware / Frame / Shutter vs logistics |
| **Title** | Status filter payload shape differs by module |
| **Severity / Priority** | Medium / P2 |
| **Status** | Confirmed (code) |

### BUG-025 — Missing PopScope on logistics create screens
| | |
|---|---|
| **Module** | Gate / Logistic family |
| **Title** | Inconsistent dirty-back / list refresh vs packing modules |
| **Severity / Priority** | Medium / P2 |
| **Status** | Confirmed (code) |

### BUG-026 — Storage confirm dialog Save vs Submit wording mismatch
| | |
|---|---|
| **Module** | Storage Allocation |
| **Title** | Title “Confirm Save”, body “submit” |
| **Severity / Priority** | Medium / P3 |
| **Status** | Confirmed (code) |

### BUG-027 — Auth cold-start may skip home navigation
| | |
|---|---|
| **Module** | Auth |
| **Title** | Authenticated listener returns early on `/login` without local route |
| **Description** | Relies on splash to navigate; if splash fails, user can stick on login while authenticated. Prior GoRouterState.of crash was mitigated. |
| **Severity / Priority** | Medium / P2 |
| **Evidence** | `frapp_app.dart` |
| **Status** | Risk (code) |

### BUG-028 — Dashboard packing failure silently empties stats
| | |
|---|---|
| **Module** | Dashboard |
| **Severity / Priority** | Medium / P2 |
| **Status** | Confirmed (code) |

### BUG-029 — OneSignal not cleared on logout
| | |
|---|---|
| **Module** | Auth / Push |
| **Severity / Priority** | Medium / P2 |
| **Status** | Confirmed (code) |

---

## Low

### BUG-030 — Default `widget_test.dart` fails
| | |
|---|---|
| **Module** | CI / Tests |
| **Title** | Counter smoke test still present |
| **Actual** | `flutter test` → 8 passed, 1 failed |
| **Severity / Priority** | Low / P3 |
| **Evidence** | `docs/qa_evidence/flutter_test.txt` |
| **Status** | Confirmed (executed) |

### BUG-031 — Route path typos baked into URLs
| | |
|---|---|
| **Module** | Router |
| **Title** | `logisticrRequest`, `newTarnsportCnfrm`, `newPallerCreation`, `vehcileReporting` |
| **Severity / Priority** | Low / P3 |
| **Status** | Confirmed (code) |

### BUG-032 — Deprecated SimpleBarcodeScannerPage usages
| | |
|---|---|
| **Module** | Scanning |
| **Severity / Priority** | Low / P3 |
| **Evidence** | `flutter analyze` infos |
| **Status** | Confirmed (analyze) |

### BUG-033 — `use_build_context_synchronously` in Loading Confirmation
| | |
|---|---|
| **Module** | Dispatch Loading |
| **Severity / Priority** | Low–Medium / P2 |
| **Status** | Confirmed (analyze) |

### BUG-034 — Unused imports / locals / catch stacks (analyze warnings)
| | |
|---|---|
| **Module** | Multiple |
| **Severity / Priority** | Low / P3 |
| **Evidence** | 42 analyzer issues, 0 errors |
| **Status** | Confirmed (analyze) |

### BUG-035 — Info (“i”) icons are small touch targets
| | |
|---|---|
| **Module** | Home |
| **Severity / Priority** | Low / P3 |
| **Status** | Confirmed (device observation) |

### BUG-036 — AppRoute.initial `/` unused
| | |
|---|---|
| **Module** | Router |
| **Severity / Priority** | Low / P3 |
| **Status** | Confirmed (code) |

### BUG-037 — Legacy download hosts in base_api_repo
| | |
|---|---|
| **Module** | Downloads |
| **Title** | Non-Shakti hosts referenced in `downloadFile` |
| **Severity / Priority** | Low / P3 |
| **Status** | Confirmed (code) |

---

## Untested areas (not bugs — coverage gaps)

- Full Save/Submit/Approve/Reject matrices for all modules on UAT.
- Camera / QR / OCR physical device matrix.
- Multi-role permission matrix (each RoleStatus flag).
- Tablet / 320px / landscape (portrait locked).
- Offline / flaky network scenarios.
- Session timeout after idle.
- Push notification delivery.
- Shorebird update path.
- iOS build / TestFlight (Android-only in this audit).

---

## Suggested fix order before production

1. BUG-001, BUG-002, BUG-003 (secrets & logging)  
2. BUG-006 (env switch) + BUG-005 (401 logout) + BUG-004 (RBAC)  
3. BUG-007, BUG-008 (data integrity)  
4. BUG-009–BUG-014 (module High functionals)  
5. Medium UI/shell issues (BUG-016+)  
6. Replace failing boilerplate test (BUG-030)
