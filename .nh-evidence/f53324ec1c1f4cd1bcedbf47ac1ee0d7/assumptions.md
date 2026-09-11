# Assumptions

_Harness-captured record for task `f53324ec`, commit `ab37e69724048a6f2560f0ee2fd71045e5220ef4` — not model-authored: no_human wrote this file from the intake step's recorded questions and assumptions. It records what the gate produced; it is not a verdict of the model that wrote the code._

<details><summary>⚠️ 3 assumptions made on your behalf — verify at review</summary>

- **Q:** Is the root cause of the bug in (a) Neovim's 'language' option allowing invalid values, (b) system LANG/locale environment variable not being handled properly, (c) clipboard encoding logic, or (d) some combination of these? **A:** (d) a combination of these factors. The root cause involves Neovim not properly handling system locales that lack UTF-8 encoding (b) — specifically, when LANG is set to a non-UTF-8 locale (e.g., LANG=en_GB), Neovim's language/locale initialization does not force UTF-8 fallback, causing the clipboard encoding logic (c) to encode multibyte UTF-8 text using the wrong encoding. The 'language' option ( _(assumption)_
- **Q:** Does the fix need to be validated specifically on macOS, or is validation on Linux CI sufficient? **A:** HUMAN-GATED: not self-answerable
- **Q:** Should the fix force Nvim to always use UTF-8 internally for clipboard operations regardless of system locale, or should it properly detect and handle non-UTF-8 locale encoding? **A:** The fix should force Nvim to always use UTF-8 internally for clipboard operations regardless of system locale. This is the simpler, more robust approach that aligns with Vim's proven behavior. Rather than attempting to detect and handle arbitrary non-UTF-8 encodings (which is error-prone), Neovim should validate or override the locale/language settings at startup to ensure UTF-8 is used for all st _(assumption)_

</details>

