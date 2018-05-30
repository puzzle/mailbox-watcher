# Anwendungsfall 1: 

| Beschreibung | Benutzer öffnet Projekt-Endpoint um den Zustand der Mailbox mit Systemmeldungen zu prüfen |
| ------------- | --- |
| Vorbedingungen | <ul><li> Der Service ist für das gewünschte Projekt vollständig konfiguriert (Mailbox, Folder, Regeln, IMAP Credentials)</li><li>Ein gültiges Token wurde in der URL mitgeschickt</li></ul> |
| Akteur | Verantwortlicher, Monitoring System |
| Auslöser | Der Verantwortliche möchte den Status der konfigurierten Projekt-Mailboxen überprüfen |
| Ablauf | 1. Aufruf Projekt-Mailbox URL (z.B. my-mailbox-watcher42/hitobito?token=823892398) <br/> 2. Prüfung Mails von Projekt-Mailbox |
| Ergebnisse | <ul><li>Erwartet: Generiert Report und zeigt Mails pro Subordner an bei denen eine Aktion durch den Verantwortlichen erforderlich ist</li> <li>Fehler: Mailserver nicht erreichbar</li> <li>Fehler: Verbindung zur Projekt-Mailbox per IMAP fehlgeschlagen</li></ul> |
