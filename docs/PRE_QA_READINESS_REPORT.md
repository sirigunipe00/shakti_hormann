# HÖRMANN Flutter App — Pre-QA Readiness Report

| Field | Value |
|---|---|
| **Application** | Shakti Hormann Mobile (`shakti_hormann`) |
| **Version** | 2.0.0+1 |
| **Audit date** | 2026-11-05 |
| **Auditor role** | Senior Flutter QA / Release readiness |
| **Environment under test** | UAT (`https://shaktihormannuat.easycloud.co.in`) — wired for both debug and release |
| **Device smoke** | Android Emulator `Medium_Phone_API_37.0` (≈1080×2400) |
| **Code changes during audit** | **None** (read-only) |
| **Verdict** | **READY FOR QA WITH KNOWN ISSUES** |

---

## Executive summary

The application **builds**, **launches**, **authenticates against UAT**, and surfaces a large logistics + packaging feature set behind role-based home tiles. Release APK build succeeded (`app-release.apk`, ~152 MB).

It is **not** “clean” for QA. Formal testing can proceed on **UAT only** if the QA team works from the attached bug list and understands that:

1. Most **Save / Submit / Approve / Delete** paths were **not** executed end-to-end in this audit (no unauthorized mutation of business records).
2. Several **High** functional defects are already confirmed by code review and should be expected during testing.
3. Multiple **Critical / High** security findings exist; they do not block UAT exploratory QA but **must** be resolved before any production / live release.
4. Automated tests are **not** a reliable gate (`widget_test.dart` fails; coverage is tiny).

**Production release readiness: NOT READY.**  
**UAT formal QA readiness: READY WITH KNOWN ISSUES.**

---

## Phase 1 — Application understanding

### Architecture

| Layer | Implementation |
|---|---|
| UI | Flutter Material, custom widgets |
| State | `flutter_bloc` / Cubits (Freezed states) |
| DI | `get_it` + `injectable` |
| Navigation | `go_router` + `StatefulShellRoute` (Home / Dashboard / Profile) |
| Networking | `http` client → `ApiClient` → `BaseApiRepository` (Frappe-style REST) |
| Persistence | FlutterSecureStorage (user JSON) + SharedPreferences (API key/secret) |
| Push | OneSignal |
| Crash | Firebase Crashlytics |
| Updates | Shorebird configured |

### Screens & modules identified

**Shell / account**

| Screen | Route / entry |
|---|---|
| Splash / Welcome / Login | `/login` + local `Navigator.push` login |
| Home | `/home` |
| Dashboard (Operations) | `/dashboard` (role-gated) |
| Profile | `/account` |
| Notifications | `/home/notifications` |

**Logistics**

| Feature | List | Create/Edit |
|---|---|---|
| Gate Entry | `/home/gateentry` | `newGateEntry` |
| Gate Exit | `/home/gateexit` | `newGateExit` |
| Logistic Request | `/home/logisticrRequest` | `newLogisticRequest` |
| Transport Confirmation | `/home/transportConfirmation` | `newTarnsportCnfrm` |
| Vehicle Reporting Entry | `/home/vehiclereporting` | `newvehiclereporting` |
| Dispatch Loading | `/home/loadingConfirmation` | `newLoadingConfirmation` |
| Proof of Delivery | `/home/proofOfDelivery` | `newproofOfDelivery` |
| Gate Management | `/home/gatemanagement` | `newGateManagement` |

**Scanning & packaging**

| Feature | List | Create/Edit |
|---|---|---|
| Pallet Creation | `/home/palletCreation` | `newPallerCreation` |
| Shutter Packaging | `/home/shutterPackaging` | `newshutterPackaging` |
| Frame Packaging | `/home/framePackaging` | `newframePackaging` |
| Storage Allocation | `/home/storageallocation` | `newStorageAllocation` |
| Zone Transfer | `/home/zonetransfer` | `newZoneTransfer` (**no Home tile**) |
| Installation Packaging | `/home/installation` | `newinstallation` |
| Accessories Packaging (Vision Panel) | `/home/visionPanel` | `newvisionPanel` |
| Hardware Packaging | `/home/hardwarepackaging` | `newHardwarePackaging` |
| Where Is My Material? | `/home/whereIsMyMaterial` (WebView) | — |

**Totals**

| Metric | Count |
|---|---|
| Feature modules (business) | 18 (+ auth, home, dashboard, profile, notifications) |
| Distinct GoRouter screens (approx.) | 40+ route builders |
| Home tiles (role-filtered) | 16 visible tiles max (Zone Transfer excluded) |

### Roles & access

- Permissions come from `LoggedInUser.roleStatus` flags (e.g. `showGateEntry`, `showHardware`, `showDashboards`).
- Home tiles hide when permission ≠ 1.
- **Packing Supervisor-SH** forces scanning/packaging tiles visible.
- **Client does not enforce RBAC on routes** — only UI tile hiding. Direct `go` / deep path can open unauthorized screens if session is valid.
- Dashboard tab appears only when `showDashboards == 1`.

### Auth & storage (summary)

1. Login → Frappe `getUsers` → API key/secret + user.
2. User JSON (including password copy) → Secure Storage.
3. API key/secret **also** → SharedPreferences (plaintext).
4. Requests send `Authorization: token <key>:<secret>`.
5. Logout clears prefs + secure storage; does not clearly log out OneSignal.

---

## Phase 2 — Functional testing results

### Execution policy

- UAT read / list / navigation smoke allowed.
- **No** intentional create / update / delete / approve of live UAT business documents during this audit.
- Therefore Save/Submit/Approve for most modules = **NOT TESTED** (blocked by policy), not “Passed”.

### Device smoke (executed)

| ID | Case | Result | Evidence |
|---|---|---|---|
| S-01 | App launches on emulator | **Pass** | App focus `in.easycloud.shakti_hormann` |
| S-02 | Session restore / login reaches Home | **Pass** | `docs/qa_evidence/home_*.png` — user “Obaid” |
| S-03 | Home logistics + packaging tiles render | **Pass** | Screenshots |
| S-04 | Logistic Request list loads Draft data | **Pass** | `logistic_request_list.png` — LR-SHM-3221 / 3199 |
| S-05 | Logistic Request detail opens | **Pass with issues** | `logistic_request_detail.png` — SO “Loading…”, bottom nav overlap |
| S-06 | Profile opens; no photo-edit control | **Pass** | `profile.png` |
| S-07 | Dashboard opens; empty gate summary | **Pass with issues** | `dashboard_empty.png` — Entry share 50% with zero movements |
| S-08 | Bottom nav Home / Dashboard / Profile | **Pass** | Screenshots |
| S-09 | Zone Transfer from Home | **Fail (blocked UX)** | No home tile (code confirmed) |
| S-10 | Logout end-to-end | **Not tested** this session | — |
| S-11–S-40 | Save/Submit/Approve/Reject/Delete per module | **Not tested** | Policy: no UAT writes |

### Code-confirmed functional defects (selected)

See `BUG_REPORT.md`. Highlights:

- Logistic “Send for Approval” / success condition bugs.
- POD geo permission can pop the form route.
- Frame/Shutter Save vs Submit method naming inverted.
- Storage + Zone share create UI; Zone not on Home.
- Duplicate-submit races on many cubits.
- Stale `isSuccess` can show success after later failure.
- Empty-state copy typos (Gate Exit / Gate Management).

### Feature status roll-up

| Feature | Screen open | List load | Filters/search | Create validation | Save/Submit | Overall |
|---|---|---|---|---|---|---|
| Login / Auth | Pass | N/A | N/A | N/A | Pass (prior session + smoke) | **Pass w/ known nav risks** |
| Home | Pass | N/A | N/A | N/A | N/A | **Pass** |
| Dashboard | Pass | Empty OK | Plant tabs visible | N/A | N/A | **Pass w/ issues** |
| Profile | Pass | N/A | N/A | N/A | Logout NT | **Pass** |
| Gate Entry | NT device | NT | Code present | Code present | **NT** | **Not tested** |
| Gate Exit | NT | NT | Code present | Code present | **NT** | **Not tested** |
| Logistic Request | Pass | Pass | UI present | Code issues | **NT** | **Partial / issues** |
| Transport Confirmation | NT | NT | Code present | Code present | **NT** | **Not tested** |
| Vehicle Reporting | NT | NT | Code present | Code present | **NT** | **Not tested** |
| Dispatch Loading | NT | NT | Code present | Code present | **NT** | **Not tested** |
| Proof of Delivery | NT | NT | Code present | High geo bug | **NT** | **Failed (code) / NT device** |
| Gate Management | NT | NT | Code present | Code present | **NT** | **Not tested** |
| Pallet Creation | NT | NT | Code present | Code present | **NT** | **Not tested** |
| Shutter Packaging | NT | NT | Code present | Save/Submit naming | **NT** | **Failed (code) / NT device** |
| Frame Packaging | NT | NT | Code present | Save/Submit naming | **NT** | **Failed (code) / NT device** |
| Storage Allocation | NT | NT | Code present | Shared zone cubit | **NT** | **Risk / NT** |
| Zone Transfer | Blocked | NT | Exists | Shared NewEntry | **NT** | **Blocked** |
| Installation Packaging | NT | NT | Code present | Code present | **NT** | **Not tested** |
| Accessories Packaging | NT | NT | Code present | Code present | **NT** | **Not tested** |
| Hardware Packaging | NT | NT | Code present + unit tests | MES helpers unit-tested | **NT** | **Partial** |
| Where Is My Material? | NT | WebView | N/A | N/A | N/A | **Not tested** |
| Notifications | NT | NT | N/A | N/A | N/A | **Not tested** |
| Scanning / QR / OCR | NT device | — | — | Code paths exist | **NT** | **Not tested** |

**Pass percentage (executed cases only)**

| Bucket | Count |
|---|---|
| Executed smoke cases (S-01…S-09 + prior login fix verification) | 10 |
| Passed cleanly | 6 |
| Passed with issues | 2 |
| Failed / blocked | 2 |
| **Pass rate (clean)** | **60%** of executed |
| **Pass rate (incl. pass-with-issues)** | **80%** of executed |
| Features with Save/Submit fully validated | **0** |

Untested cases are **excluded** from pass percentage.

---

## Phase 3 — UI/UX observations

### Confirmed on device

1. Home card grid and Hormann branding are consistent.
2. Profile photo edit control removed (avatar display only).
3. Logistic list cards are readable for Draft rows.
4. **Bottom navigation overlaps form content** on Logistic Request detail — footer fields clipped (`logistic_request_detail.png`).
5. Dashboard empty state messaging exists; **Entry share 50%** with zero movements is misleading.
6. Info (“i”) icons on packaging cards are small touch targets (risk on dense layouts).
7. Nested feature screens still show bottom nav (except WIMM which uses parent navigator) — reduces usable form height.

### Cross-module inconsistency (code)

- Older logistics screens: weaker PopScope / dirty-back handling.
- Newer packing screens: PopScope + stronger Save gating.
- Empty-state copy quality varies; typos present.
- `Save` / `Submit` / `Approve` / `createDocument` semantics differ by module.

---

## Phase 4 — Responsive testing

| Width target | Result |
|---|---|
| ~360–430 class (emulator Medium Phone) | Smoke only — layouts usable on Home/Profile/Dashboard/Logistic list |
| 320 / 375 / 390 / tablet | **Not executed** (single AVD) |
| Landscape | App locks portrait in `bootstrap.dart` — N/A by design |

**Risk (code / observation):** long SAP codes, MES sticker values, and multi-item tables historically overflow; packing tables need focused QA on small devices. Bottom nav overlap is already visible on detail forms.

---

## Phase 5 — API & integration

| Check | Status |
|---|---|
| Base URL | UAT for debug **and** release (`bootstrap.dart`) |
| Auth header | `token key:secret` |
| Timeout | 45s on primary `ApiClient` calls |
| 401 handling | Throws invalid credentials — **does not force logout** |
| Debug logging | Logs URI, body, **headers (Authorization)**, response |
| Empty / error UI | Present on many lists via InfiniteList patterns |
| Success after failure | **Risk** — stale `isSuccess` + unguarded listeners |
| Duplicate submit | **Risk** — many cubits lack re-entry guard |
| `downloadFile` / Frappe session | Separate HttpClients; no timeout / no pinning |

Live create/update/delete API verification: **Not executed** (policy).

---

## Phase 6 — Security observations

| Severity | Topic |
|---|---|
| Critical | API key/secret in SharedPreferences |
| Critical | Password persisted with user session (needed for WIMM desk login) |
| Critical (debug) | Authorization + payloads logged |
| High | No route-level RBAC |
| High | 401 does not clear session |
| High | Release binary points at UAT (good for QA; wrong for live) |
| High | Cleartext traffic allowed; no cert pinning; debug accepts bad certs |
| Medium | OneSignal not clearly cleared on logout |

**Do not ship live/production until Critical/High storage & logging issues are addressed.**

---

## Phase 7 — Performance & stability

### Commands run

| Command | Result |
|---|---|
| `flutter analyze` | **42 issues** (0 errors; warnings + infos) — see `docs/qa_evidence/flutter_analyze.txt` |
| `flutter test` | **8 passed, 1 failed** (`test/widget_test.dart` counter boilerplate) |
| `flutter build apk --release` | **Success** — `build/app/outputs/flutter-apk/app-release.apk` |

### Observations

- On authentication, app eagerly `fetchInitial`s many module lists (heavy parallel UAT traffic) — confirmed historically in debug logs.
- Deprecated `SimpleBarcodeScannerPage` usages across modules (tech debt).
- `use_build_context_synchronously` infos in loading confirmation (crash risk if unmounted).
- Emulator QEMU segfaults observed earlier in the day — environment instability, not necessarily app bug.

---

## Phase 8 — Bug summary

| Severity | Count (this audit) |
|---|---|
| Critical | 3 |
| High | 12 |
| Medium | 14 |
| Low | 8 |
| **Total** | **37** |

Full detail: `docs/BUG_REPORT.md`.

---

## Phase 9 — QA readiness assessment

| # | Metric | Value |
|---|---|---|
| 1 | Screens identified | 40+ routed UIs |
| 2 | Features identified | 22 (incl. auth/home/dashboard/profile/notifications) |
| 3 | Features with any execution | 6 |
| 4 | Features passed (clean) | 3 (Home, Profile, Login smoke) |
| 5 | Features failed / blocked | 3+ (Zone discoverability; POD/Frame/Shutter code fails) |
| 6 | Features blocked for write testing | All mutating flows (policy) |
| 7 | Features not tested | Majority of modules |
| 8 | Bugs by severity | C3 / H12 / M14 / L8 |
| 9 | UI/UX | Bottom nav overlap; dashboard 50% share; inconsistent modules |
| 10 | Performance | Eager multi-fetch; analyze warnings only |
| 11 | Security | Critical storage/logging findings |
| 12 | API | UAT wired; write paths unproven in audit |
| 13 | Build | Release APK OK; unit smoke partially failing |
| 14 | Remaining blockers for *production* | Security Criticals, env switch to live, High functional bugs, failing default test |

---

## Phase 10 — Verdict

### **READY FOR QA WITH KNOWN ISSUES**

**Why this verdict**

- The app is installable, runnable on UAT, and navigable for exploratory / scripted QA.
- Enough surface area works (login, home, profile, dashboard shell, at least one list/detail) for QA to begin.
- Known defects are documented so QA is not blind.

**Why not “READY FOR QA” (clean)**

- Critical security defects and High functional bugs will consume QA cycles and risk false confidence.
- Save/Submit integrity is unverified in this audit.
- Default automated test fails.

**Why not “NOT READY FOR QA”**

- Blocking UAT QA entirely would delay discovery of module-specific issues that only humans with role accounts can find.
- Release APK builds; UAT connectivity works.

### Conditions for QA start

1. Test **only** against UAT.
2. Use role-specific test accounts (no production passwords in docs).
3. Treat `BUG_REPORT.md` as known defects (avoid re-reporting duplicates; verify fixes).
4. Prioritize write-path test cases next (with approved UAT data).
5. Do **not** promote this build to live/production.

---

## Related deliverables

- `docs/FEATURE_TEST_CHECKLIST.md`
- `docs/BUG_REPORT.md`
- `docs/QA_HANDOVER_NOTES.md`
- `docs/qa_evidence/` (screenshots + analyze/test/build logs)
