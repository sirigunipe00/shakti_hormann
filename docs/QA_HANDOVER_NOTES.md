# QA Handover Notes — Shakti Hormann Flutter

| Field | Value |
|---|---|
| **Handover date** | 2026-11-05 |
| **Build for QA** | `2.0.0+1` release APK (UAT backend) |
| **Verdict** | **READY FOR QA WITH KNOWN ISSUES** |
| **Production** | **NOT READY** |

Companion docs:

- `docs/PRE_QA_READINESS_REPORT.md`
- `docs/FEATURE_TEST_CHECKLIST.md`
- `docs/BUG_REPORT.md`
- `docs/qa_evidence/`

---

## 1. Features ready for QA (exploratory / scripted on UAT)

These areas are stable enough to start testing. Expect cosmetic and Medium issues.

| Area | Notes |
|---|---|
| Login / session restore | Works against UAT; watch post-login navigation regressions |
| Home grid + role tiles | Large surface; verify per role |
| Bottom navigation | Home / Dashboard / Profile |
| Profile display | Name, email, company, version; photo edit removed |
| Dashboard shell | Empty and populated plant data both need coverage |
| Logistic Request **list** | Draft rows loaded in smoke |
| Packaging Home info stickers | Manual check of “i” dialogs |
| Hardware MES **string helpers** | Covered by unit tests only — still need device OCR QA |

---

## 2. Features requiring fixes before confident sign-off

Treat as **known broken / high risk** — file verification bugs against `BUG_REPORT.md` IDs rather than rediscovering blindly.

| Area | Why |
|---|---|
| Zone Transfer | Not on Home (BUG-013); shared create stack with Storage (BUG-014) |
| Proof of Delivery geo flow | Form may pop on permission Allow (BUG-009) |
| Logistic Request actions | Empty submit / wrong success check (BUG-010, BUG-011); UI overlap (BUG-016) |
| Frame / Shutter Save–Submit | Method mapping inverted (BUG-012) |
| Duplicate Save taps | Many modules (BUG-008) |
| Success-after-failure dialogs | Stale `isSuccess` (BUG-007) |
| Auth 401 / RBAC / secrets | Security High/Critical (BUG-001–BUG-005) |

---

## 3. Known limitations

1. **Backend is UAT for debug and release** — `Urls.live()` is unused. Do not distribute this APK as a “production” build.
2. **Portrait only** — landscape not supported (`bootstrap.dart`).
3. **Client RBAC is UI-only** — Home tiles hide modules; routes are not hardened.
4. **WIMM** depends on stored password → desk session WebView; sensitive by design today.
5. **Emulator camera / OCR** is unreliable — prefer physical devices for scan packs.
6. **Automated tests are thin** — one failing boilerplate widget test; no E2E suite.
7. **Eager list prefetch** after login may load many doctypes at once (slow networks).
8. Route path typos are intentional in code (`logisticrRequest`, etc.) — deep links must match exactly.

---

## 4. Test environment requirements

| Item | Requirement |
|---|---|
| Backend | `https://shaktihormannuat.easycloud.co.in` |
| App | Debug or release APK from this repo (`2.0.0+1`) |
| Devices | ≥1 Android physical device for camera/scan; phones 360–430 dp; optional tablet |
| Network | Stable HTTPS; ability to simulate offline for negative tests |
| Permissions | Camera, location (POD), notifications (OneSignal), storage/photos as prompted |
| Tools | Logcat for debug builds (expect verbose API logs today) |
| Data | Dedicated UAT sandbox documents; **no production writes** |

**Build artifact (local):**  
`build/app/outputs/flutter-apk/app-release.apk`

---

## 5. Test accounts and roles required

Provide QA with **UAT accounts only**. **Never store real passwords in this repository or in tickets.**

Suggested role matrix (create/reset in UAT admin):

| Account alias | Purpose | Role flags to exercise |
|---|---|---|
| `qa.gate` | Gate Entry / Exit / Gate Mgmt | `showGateEntry`, `showGateExit`, `showgateManagement` |
| `qa.logistics` | LR / Transport / Vehicle / Loading / POD | corresponding show* flags |
| `qa.packing` | Pallet / Shutter / Frame / Hardware / Vision / Installation / Storage | packing flags |
| `qa.supervisor` | Packing Supervisor-SH | forces packaging tiles |
| `qa.dashboard` | Operations dashboard | `showDashboards = 1` |
| `qa.restricted` | Negative RBAC | minimal flags — confirm tiles hidden (routes still risk) |
| `qa.wimm` | Where Is My Material | any packing flag that reveals WIMM tile |

Coordinate password delivery via your secure channel (1Password / vault), not Slack/email plaintext if possible.

---

## 6. Special testing instructions

1. **Mutating tests (Save/Submit/Approve)**  
   - Use only disposable UAT documents.  
   - Prefer create → draft → cancel/amend patterns agreed with functional owners.  
   - Record document names (`LR-SHM-…`, etc.) in the test log.

2. **Scan / OCR**  
   - Use printed MES / packing stickers from `docs` owners or Home “i” samples.  
   - Validate SO mismatch and duplicate box handling.

3. **Regression watchlist**  
   - After login, confirm Home appears (not stuck on Login).  
   - Confirm Profile has **no** photo edit snackbar.  
   - On Logistic detail, scroll to bottom — note bottom-nav overlap.

4. **Security smoke (non-invasive)**  
   - Confirm debug logcat still prints Authorization (known BUG-003) — do not paste tokens into tickets.  
   - Do not attempt penetration beyond agreed scope.

5. **Do not** mark a module Passed because the list opened. Require validation + save path for formal pass.

6. **iOS** was not audited in this pass — schedule separately if iOS is in scope.

---

## 7. Outstanding dependencies

| Dependency | Owner | Impact |
|---|---|---|
| UAT role accounts + passwords | Backend / IT | Blocks role matrix |
| Approved UAT test data set | Functional / MES | Blocks write-path QA |
| Decision: fix Critical security before or after functional QA cycle | Eng + Security | Risk acceptance |
| Physical devices + sticker samples | QA ops | Blocks scan packs |
| Live URL cutover plan | Release manager | Prod blocker (BUG-006) |
| Zone Transfer product decision (show on Home?) | Product | BUG-013 |
| Clarified Save vs Submit API contract for Frame/Shutter | Backend + App | BUG-012 |

---

## 8. Suggested QA entry criteria (minimum)

- [ ] UAT reachable from QA devices  
- [ ] At least two role accounts available  
- [ ] QA has `BUG_REPORT.md` and checklist  
- [ ] Agreement that Critical security bugs are tracked for pre-prod  
- [ ] Sandbox documents identified for create/submit tests  

## Suggested exit criteria (formal QA complete)

- [ ] Checklist modules executed with Pass/Fail (no silent NT)  
- [ ] No open Critical defects  
- [ ] No open High defects on primary logistics + packing happy paths  
- [ ] Release build points to intended environment  
- [ ] Default `flutter test` green  
- [ ] Security findings BUG-001–BUG-005 accepted or fixed  

---

## 9. Communication

- Report new bugs with module, build number, UAT doc id, steps, severity.  
- Cross-check duplicates against BUG-001…BUG-037 before filing.  
- **No application code was changed during this audit.** Fix work waits for explicit approval.

---

## 10. One-line summary for stakeholders

**UAT QA can start with eyes open; production release must wait on security Criticals, High functional defects, and a real live environment cutover.**
