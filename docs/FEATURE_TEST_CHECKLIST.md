# Feature Test Checklist — Shakti Hormann Flutter

| Field | Value |
|---|---|
| **Version** | 2.0.0+1 |
| **Environment** | UAT only |
| **Audit date** | 2026-11-05 |
| **Legend** | `P` Pass · `PW` Pass with issues · `F` Fail · `B` Blocked · `NT` Not tested · `N/A` |

**Important:** Cases marked `NT` must not be treated as passed. Execute them with approved UAT accounts before sign-off.

---

## 0. Build & environment gate

| ID | Case | Result | Notes |
|---|---|---|---|
| G-01 | `flutter analyze` completes | PW | 42 issues, 0 errors |
| G-02 | `flutter test` all green | F | `widget_test.dart` fails |
| G-03 | `flutter build apk --release` | P | `app-release.apk` ~152 MB |
| G-04 | App installs & launches on emulator | P | Medium Phone API 37 |
| G-05 | Points to UAT base URL | P | Intentional for QA; live unused |

---

## 1. Authentication & session

| ID | Case | Result | Notes |
|---|---|---|---|
| A-01 | Splash / welcome renders | NT | Session restored in smoke |
| A-02 | Login with valid UAT user | P | Prior + session smoke (“Obaid”) |
| A-03 | Login with invalid credentials shows error | NT | |
| A-04 | Empty email/password validation | NT | |
| A-05 | Post-login navigates to Home | P | Fixed GoRouterState crash earlier; monitor regressions |
| A-06 | Cold start with saved session → Home | P | Observed logged-in Home |
| A-07 | Logout clears session → login/welcome | NT | |
| A-08 | After logout, protected API fails / blocked | NT | |
| A-09 | 401 forces re-login | F | Code: no logout on 401 (BUG-005) |
| A-10 | Password not visible in logcat (debug) | F | BUG-003 |

---

## 2. Home & shell

| ID | Case | Result | Notes |
|---|---|---|---|
| H-01 | Home tiles render for role | P | Logistics + packaging visible |
| H-02 | Role-hidden tiles not shown | NT | Need restricted account |
| H-03 | Info (“i”) sticker dialogs open | NT | |
| H-04 | Notification bell opens list | NT | |
| H-05 | Bottom nav Home/Dashboard/Profile | P | |
| H-06 | Dashboard tab hidden when `showDashboards!=1` | NT | Visible for current user |
| H-07 | Zone Transfer reachable from Home | F | No tile (BUG-013) |

---

## 3. Dashboard

| ID | Case | Result | Notes |
|---|---|---|---|
| D-01 | Opens Operations dashboard | P | |
| D-02 | Empty state messaging | PW | Banner OK; Entry share 50% odd (BUG-017) |
| D-03 | Plant tabs All / Jaipur / Medchal | NT | Visible, not exercised deeply |
| D-04 | Refresh control | NT | |
| D-05 | Charts with real plant data | NT | Empty in smoke |

---

## 4. Profile

| ID | Case | Result | Notes |
|---|---|---|---|
| P-01 | Shows name, email, company, version | P | 2.0.0 (1) |
| P-02 | No profile photo update control | P | Removed |
| P-03 | Hormann logo not clipped | P | On Medium Phone |
| P-04 | Logout works | NT | |

---

## Module matrix (lists / forms / writes)

For each module, QA should execute the full row. Pre-audit status filled where known.

### 5. Gate Entry

| ID | Case | Result |
|---|---|---|
| GE-01 | List opens | NT |
| GE-02 | Search works | NT |
| GE-03 | Status filter works | NT |
| GE-04 | Empty / error / loading states | NT |
| GE-05 | New form opens | NT |
| GE-06 | Mandatory validation | NT |
| GE-07 | Dropdowns / PO selection | NT |
| GE-08 | Photo / barcode capture | NT |
| GE-09 | Save draft | NT |
| GE-10 | Submit / update | NT |
| GE-11 | Back with unsaved data | NT |
| GE-12 | Double-tap Save does not duplicate | NT (Risk BUG-008) |

### 6. Gate Exit

| ID | Case | Result |
|---|---|---|
| GX-01 | List opens | NT |
| GX-02 | Search / filter | NT |
| GX-03 | Empty copy readable | F | Code typo “GateExists” (BUG-022) |
| GX-04 | New / edit form | NT |
| GX-05 | IRN QR scan happy path | NT |
| GX-06 | Invalid QR handled | NT |
| GX-07 | Save / submit | NT |

### 7. Logistic Request

| ID | Case | Result |
|---|---|---|
| LR-01 | List opens with data | P |
| LR-02 | Search LR | NT |
| LR-03 | Sales Order filter control present | P | UI observed |
| LR-04 | Open existing Draft detail | PW | SO loading; nav overlap (BUG-016) |
| LR-05 | New form validation | NT |
| LR-06 | Save Draft | NT |
| LR-07 | Send for transporter / approval | F/Risk | BUG-010, BUG-011 |
| LR-08 | Bottom nav does not hide fields | F | BUG-016 |

### 8. Transport Confirmation

| ID | Case | Result |
|---|---|---|
| TC-01–TC-10 | List / filter / create / approve / reject | NT |
| TC-11 | Create button semantics | Risk | BUG-021 |

### 9. Vehicle Reporting Entry

| ID | Case | Result |
|---|---|---|
| VR-01–VR-10 | List / form / approve / reject | NT |
| VR-11 | Dropdown UniqueKey stability | Risk | BUG-018 |

### 10. Dispatch Loading

| ID | Case | Result |
|---|---|---|
| DL-01–DL-08 | List / form / photos | NT |
| DL-09 | Pallet/box scan flow | NT |
| DL-10 | Save control | Risk | BUG-020 |
| DL-11 | Context after async | Risk | BUG-033 |

### 11. Proof of Delivery

| ID | Case | Result |
|---|---|---|
| POD-01–POD-08 | List / form / photos | NT |
| POD-09 | Geo permission forever → Allow | F | BUG-009 (code) |
| POD-10 | Distance / location failure messaging | NT |

### 12. Gate Management

| ID | Case | Result |
|---|---|---|
| GM-01–GM-08 | List / form / photos / save | NT |
| GM-09 | Empty state copy | F | BUG-023 |

### 13. Pallet Creation

| ID | Case | Result |
|---|---|---|
| PC-01–PC-10 | List / SO / lines / save / submit | NT |

### 14. Shutter Packaging

| ID | Case | Result |
|---|---|---|
| SP-01–SP-08 | List / form / scan / OCR | NT |
| SP-09 | Save vs Submit API mapping | F | BUG-012 |
| SP-10 | PopScope back confirmation | NT |

### 15. Frame Packaging

| ID | Case | Result |
|---|---|---|
| FP-01–FP-08 | List / form / scan / OCR | NT |
| FP-09 | Save vs Submit API mapping | F | BUG-012 |

### 16. Storage Allocation

| ID | Case | Result |
|---|---|---|
| SA-01–SA-08 | List / form / QR pallet+zone | NT |
| SA-09 | Uses correct doctype vs Zone | Risk | BUG-014 |
| SA-10 | Confirm dialog wording | F | BUG-026 |

### 17. Zone Transfer

| ID | Case | Result |
|---|---|---|
| ZT-01 | Reachable from Home | F | BUG-013 |
| ZT-02–ZT-08 | List / create / scan | B / NT | Blocked discoverability |

### 18. Installation Packaging

| ID | Case | Result |
|---|---|---|
| IN-01–IN-10 | List / form / camera / save / submit | NT |

### 19. Accessories Packaging (Vision Panel)

| ID | Case | Result |
|---|---|---|
| AP-01–AP-10 | List / form / images / save / submit | NT |

### 20. Hardware Packaging

| ID | Case | Result |
|---|---|---|
| HW-01–HW-08 | List / form / MES scan | NT |
| HW-09 | MES guide string validation unit tests | P | Automated helpers pass |
| HW-10 | Document scanner permission denial | NT |

### 21. Where Is My Material?

| ID | Case | Result |
|---|---|---|
| WM-01 | Opens WebView | NT |
| WM-02 | Desk session login succeeds | NT |
| WM-03 | Timeout / failure UI (45s) | NT |
| WM-04 | Bottom nav covered | NT | parentNavigatorKey expected |

### 22. Notifications

| ID | Case | Result |
|---|---|---|
| N-01 | List opens | NT |
| N-02 | Empty / error states | NT |

### 23. Scanning / QR / OCR (cross-cutting)

| ID | Case | Result |
|---|---|---|
| SC-01 | Camera permission deny messaging | NT |
| SC-02 | Invalid barcode handling | NT |
| SC-03 | Duplicate scan prevention | NT |
| SC-04 | MES OCR mismatch SO | NT |
| SC-05 | Works on physical device (not emulator camera) | NT |

### 24. Responsive / UX cross-cutting

| ID | Case | Result |
|---|---|---|
| R-01 | 360–430 phone portrait | PW | Single AVD smoke |
| R-02 | 320 px width | NT |
| R-03 | Tablet | NT |
| R-04 | Long SAP / MES strings no overflow | NT |
| R-05 | Keyboard does not hide primary CTA | NT |
| R-06 | Safe area / status bar | PW | OK on smoke screens |
| R-07 | Bottom nav never hides primary actions | F | Logistic detail (BUG-016) |

### 25. Security checklist (QA + AppSec)

| ID | Case | Result |
|---|---|---|
| SEC-01 | No secrets in SharedPreferences | F | BUG-001 |
| SEC-02 | Password not retained longer than needed | F | BUG-002 |
| SEC-03 | Logs redact auth | F | BUG-003 |
| SEC-04 | Unauthorized route blocked client-side | F | BUG-004 |
| SEC-05 | Role accounts cannot open other modules via URL | NT | Expect fail today |

---

## Execution summary (this audit)

| Status | Approx. count |
|---|---|
| P | 12 |
| PW | 4 |
| F | 12 |
| B | 1 |
| NT | Majority of module write/scan cases |

**Do not compute release quality from NT rows.**
