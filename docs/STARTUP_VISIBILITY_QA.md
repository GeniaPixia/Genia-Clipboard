# GeniaClipboard v0.5.8-rc.1 — startup and window visibility QA

This checklist is for the **test branch only**, not the released v0.5.7 binary.

## Safety and setup

- Keep the released v0.5.7 EXE/ZIP as your rollback.
- **Never remove, replace, move, rename or upload your existing `Data` directory or Portable Vault.**
- Download the Windows CI artifact and extract the **test EXE into a new empty directory**, separate from your production GeniaClipboard directory.
- Quit any running GeniaClipboard via the tray before launching a test copy (single-instance mutex).
- The test copy may create its **own new `Data`** directory as part of normal operation. Do not copy any existing `Data` into this test directory.
- Use only dummy clipboard strings. Do not share vault passwords, vault files or clipboard history in diagnostics.

## Acceptance matrix

| ID | Action | Expected |
|---|---|---|
| S1 | Launch `GeniaClipboard.exe` normally in the isolated directory. Complete any first-run dialog. | Main history window is visible and can receive focus. |
| S2 | Close the main window with X. | Window hides; process remains running and tray icon is present. |
| S3 | Double-click the tray icon, then hide with Esc; right-click tray icon and select Open. | Both routes reliably restore the same window. |
| S4 | Press configured global hotkey (default Ctrl+Shift+V). | Main window opens. If a different program owns the hotkey, tray routes still open it and the status reports unavailable registration. |
| S5 | With the app running but hidden, launch the EXE again. | Already-running instance opens its window, without a second process or second vault instance. Allow up to one timer interval (700 ms) for activation. |
| S6 | Quit from tray. Run `GeniaClipboard.exe --tray` from the test folder. | Starts in tray with main window hidden; tray/hotkey still restore it. |
| S7 | From a hidden state use tray Settings, About, Private Session or Clear History (no deletion confirmation). | Related dialogs open in front of a visible main window. Cancel any destructive prompt. |
| S8 | After tests, quit from tray. | Process exits cleanly. Production v0.5.7 and its Data remain untouched. |

## Windows CI scope

The pull request's Windows build checks .NET 8 restore and self-contained x64 publish. **GitHub Actions cannot establish interactive tray/foreground behavior**; the S1–S8 acceptance steps require a real Windows desktop.

## Owner's RC1 evidence and remaining coverage

On 2026-11-08, the owner confirmed on an isolated Windows build:

- S1 **PASS** — normal launch displays the main window.
- S2 **PASS** — X hides the window to the tray.
- S3 **PARTIAL PASS** — tray restore works; Esc and right-click Open were not separately reported.
- S4 **PASS** — the global hotkey restores the window.
- S5 **PASS** — second EXE launch activates the existing instance.
- S7 **PARTIAL PASS** — screenshots show About and Settings visible with the main window underneath, but do not establish that the dialogs were opened from hidden tray state.
- S6 and S8 — **NOT SEPARATELY REPORTED** in the owner's observations.

The owner subsequently indicated that the application is behaving correctly and requested to proceed. This is a release go-ahead, **not a claim that every S1–S8 test was performed**. The outstanding steps remain explicitly documented in v0.5.8 release notes for follow-up.

**Release handling:** do not change the published v0.5.7 tag or binary. Never modify, delete or migrate production Vault and Data as part of this startup fix.
