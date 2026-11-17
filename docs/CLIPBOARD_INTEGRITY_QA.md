# GeniaClipboard 0.5.9 RC1 — Clipboard integrity QA (Windows)

This document covers the **isolated test build only**. Version 0.5.8 remains the stable release. Do not merge or publish 0.5.9 until the owner completes a real-Windows desktop QA pass.

## Goal and threat model

Check that data **written by GeniaClipboard's own Copy/Paste actions** is still exactly what GeniaClipboard intended:

- Immediately after writing the clipboard, compare Unicode text exactly using ordinal .NET string comparison and verify that the clipboard sequence number has not changed.
- Immediately before GeniaClipboard sends Ctrl+V, repeat both checks. Also verify contents before giving the manual paste fallback.
- An unreadable, missing or unexpectedly rewritten clipboard causes a **warning** and suppresses GeniaClipboard's automatic Ctrl+V.
- Do not change or restore the clipboard automatically. Do not store copied text or fingerprints separately. No background watcher, OCR, keyboard hook, online check, security alert log, changes to Vault or Data schema.

**Important limitations:**

- This does **not** observe ordinary Ctrl+C/Ctrl+V exchanges between other apps. It does **not** read the target's actual pasted text.
- Clipboard content may be altered in the interval after the last check and before the target reads it (TOCTOU). An attacker operating in the same Windows session can also tamper with the target application.
- If an attacker already changed text before GeniaClipboard first captures it, the original cannot be reconstructed.
- False warnings may occur if the clipboard is unavailable or other software legitimately rewrites the clipboard.
- For crypto transactions, verify the final recipient in the wallet or on a hardware wallet's trusted screen.

## Safe setup

1. Exit 0.5.8 through its system-tray menu. Do **not** copy, move, replace, rename or remove existing production `Data` or Portable Vault files.
2. Clone the RC1 source branch or download the full source archive into a **new empty directory**. Verify the pinned commit used for the test.
3. Run `dotnet publish GeniaClipboard.csproj -c Release -o TEST_PUBLISH` in that isolated directory.
4. Verify Windows Defender reports active protection and no new detection for this EXE. Never disable SmartScreen/Defender.
5. Start only the isolated `TEST_PUBLISH/GeniaClipboard.exe`. Choose a new test Vault and use **synthetic clipboard strings only**.

## Acceptance tests

| ID | Action | Expected outcome |
|---|---|---|
| C1 | Select a demo history entry and click **Copy**. Paste manually to Notepad. | Text is unchanged, including Unicode, whitespace and newlines. No warning. |
| C2 | Select a demo entry, activate Notepad as target, then use GeniaClipboard's **Paste** action. | Exact intended text is in Notepad. No warning. |
| C3 | Repeat C1/C2 with two selected entries, Cyrillic, emoji and multiline text. | Entire text matches with correct order and line breaks. |
| C4 | Trigger a normal external Ctrl+C/Ctrl+V while GeniaClipboard is running. | No new intrusive popup merely because the buffer changed. History capture still follows existing privacy settings. |
| C5 | Toggle Private Session and test Copy/Paste with demo data. | Works; persistent Vault and real data remain untouched. |
| C6 | Reopen from tray, test hotkey, close with X and exit from tray. | Baseline 0.5.8 window/tray behaviors remain intact. |
| C7 | Simulate clipboard replacement **during GeniaClipboard-controlled paste** using a benign local test harness (separate from any production wallet). | If replacement is observed before the final check: visible warning, Ctrl+V not sent. This timing-sensitive case needs a controlled harness; not proven by compiling alone. |
| C8 | Simulate clipboard lock/unavailable while verifying. | Warning rather than silently performing automatic Ctrl+V. |
| C9 | Exit test copy and relaunch stable 0.5.8 in its own original folder. | Stable Vault and Data remain intact. |

## Results record

- Build commit SHA:
- CI Windows build run and result:
- Microsoft Defender result:
- C1–C9: PASS / FAIL / NOT TESTED, with short notes:
- Idle CPU / process private memory before and after:
- UI screenshots, if needed, must contain **dummy data only**.

Do not call RC1 a universal clipboard anti-clipper solution or represent C7/C8 as passed without an actual controlled test.
