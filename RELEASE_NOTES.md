# GeniaClipboard v0.5.8 — Window activation and startup fix

[Русская версия ниже](#русский)

## English

GeniaClipboard is a free, MIT-licensed portable **text-only** clipboard history manager for Windows 10/11 x64. Version 0.5.8 fixes invisible main-window startup while preserving the bilingual UI, protected Paste behavior and encrypted history from v0.5.7.

### What's fixed

- **Normal launch is visible:** starting `GeniaClipboard.exe` manually now opens the main history window.
- **Second launch reuses the running app:** an additional EXE invocation activates the existing window instead of displaying an unhelpful already-running warning or launching a second vault instance.
- **Quiet Windows autostart:** `--tray` explicitly starts in the system tray without automatically opening the main window. The app registers this argument for Windows autostart.
- **Tray dialogs:** Settings, About, Private Session and Clear History now show the main window first, so their dialogs have a visible owner.
- **Author and version:** the About window displays the running product version and credits GeniaPixia, with updated GitHub links.

### Verification and limitations

- The v0.5.8 release candidate passed Windows x64 CI and was built from verified source on the project owner's Windows PC.
- Owner-reported desktop **PASS** for normal window launch, hide to tray, restore from tray, global Ctrl+Shift+V and second EXE activation. Screenshots confirmed visible Settings/About dialogs and the updated author/version.
- Not separately confirmed in the reported test: quiet `--tray` startup, the full hidden-state tray-dialog flow and a clean-exit scenario. These remain areas to verify after installation.
- The binary is **not Authenticode-signed**; security filters may flag an unfamiliar executable. Compare the official SHA-256 checksums in `SHA256SUMS.txt` and verify the download's origin. Do not disable security protections to install it.

### Privacy, compatibility and updating

- **No Vault, encrypted-history, master-password, data-format or migration changes.** Existing saved clipboard data is not altered by these code changes.
- Windows Vault (DPAPI) and Portable Vault continue to provide local encrypted storage; Private Session retains records only in memory.
- Text exports and optional TXT journals remain unencrypted. Clipboard secret detection is heuristic, not guaranteed.
- **To update:** exit the running app using the tray menu, make an independent backup of the entire `Data` folder, and replace the EXE in the existing program directory only after confirming the backup. Keep your Portable Vault password.
- The unchanged [v0.5.7 release](https://github.com/GeniaPixia/Genia-Clipboard/releases/tag/v0.5.7) remains available for rollback.

Report reproducible issues on [GitHub Issues](https://github.com/GeniaPixia/Genia-Clipboard/issues/new/choose) using fictional clipboard data, never passwords, tokens, private history, or Vault files.

---

## Русский

GeniaClipboard — бесплатный портативный менеджер **текстовой** истории буфера обмена для Windows 10/11 x64 под лицензией MIT. Версия 0.5.8 исправляет запуск без видимого главного окна, сохраняя двуязычный интерфейс, защищённую вставку и зашифрованную историю версии 0.5.7.

### Что исправлено

- **Обычный запуск:** после запуска `GeniaClipboard.exe` открывается главное окно истории.
- **Повторный запуск:** открывается уже работающий экземпляр вместо бесполезного уведомления; второй экземпляр Vault не создаётся.
- **Тихий автозапуск Windows:** параметр `--tray` запускает приложение в трее без автоматического открытия окна. Для записи автозапуска используется этот параметр.
- **Диалоги из трея:** перед открытием настроек, окна «О программе», Private Session и подтверждения очистки истории показывается главное окно.
- **Автор и версия:** окно «О программе» отображает текущую версию и авторство GeniaPixia; ссылки GitHub обновлены.

### Проверки и ограничения

- Кандидат в релиз прошёл CI Windows x64 и был собран автором на Windows из исходников с проверенным коммитом.
- Автор подтвердил **PASS** для появления окна, скрытия и восстановления через трей, сочетания Ctrl+Shift+V и активации через повторный запуск EXE. Скриншоты подтвердили отображение настроек и окна «О программе».
- Отдельно не подтверждены в присланном отчёте: запуск с `--tray`, полный сценарий открытия диалогов из скрытого состояния и корректное завершение. Их рекомендуется проверить после установки.
- EXE **не имеет цифровой подписи Authenticode**; фильтры безопасности могут предупреждать о неизвестном приложении. Проверяйте происхождение файла и SHA-256 по `SHA256SUMS.txt`. Не отключайте защиту ради установки.

### Конфиденциальность и обновление

- **Формат Vault, зашифрованная история, мастер-пароли и миграция данных не изменялись.** Исправление окна не требует преобразования данных.
- Windows Vault использует DPAPI, Portable Vault — мастер-пароль; Private Session хранит новые записи только в памяти.
- TXT-экспорт и опциональный TXT-журнал не шифруются; Sensitive detector не гарантирует обнаружение каждого секрета.
- **Обновление:** закройте GeniaClipboard через трей, сделайте независимую резервную копию всей папки `Data` и только после этого замените EXE в папке программы. Сохраните мастер-пароль Portable Vault.
- Неизменённая [версия 0.5.7](https://github.com/GeniaPixia/Genia-Clipboard/releases/tag/v0.5.7) доступна для отката.

Сообщить об ошибке можно через [GitHub Issues](https://github.com/GeniaPixia/Genia-Clipboard/issues/new/choose). Не прикладывайте настоящие пароли, токены, личную историю и файлы Vault.
