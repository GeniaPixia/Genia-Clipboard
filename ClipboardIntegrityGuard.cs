using System.Runtime.InteropServices;

namespace GeniaClipboard;

/// <summary>
/// Lightweight, read-only verification for clipboard operations initiated by
/// GeniaClipboard. No history, file I/O, hooks, hashes or background service.
///
/// Verifies both the exact Unicode text and the Windows clipboard sequence:
/// a different sequence is treated as an intervening write even if the text
/// happens to look the same. Fails closed if the clipboard cannot be read.
///
/// This cannot prove what a different application ultimately pasted: another
/// process can modify the clipboard after the final check (TOCTOU).
/// </summary>
internal static class ClipboardIntegrityGuard
{
    public static bool MatchesClipboard(string expectedText, uint expectedSequenceNumber)
    {
        if (expectedSequenceNumber == 0 ||
            NativeMethods.GetClipboardSequenceNumber() != expectedSequenceNumber)
        {
            return false;
        }

        try
        {
            var data = Clipboard.GetDataObject();
            if (data is null ||
                !data.GetDataPresent(DataFormats.UnicodeText, autoConvert: true))
            {
                return false;
            }

            var actualText = data.GetData(DataFormats.UnicodeText, autoConvert: true) as string;

            return actualText is not null &&
                   string.Equals(actualText, expectedText, StringComparison.Ordinal) &&
                   NativeMethods.GetClipboardSequenceNumber() == expectedSequenceNumber;
        }
        catch (ExternalException)
        {
            // Another process may be holding the clipboard. Do not silently paste.
            return false;
        }
    }
}
