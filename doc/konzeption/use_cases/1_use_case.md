# Anwendungsfall 1: 

| Beschreibung | Benutzer öffnet Projekt-Endpoint um den Zustand der Mailbox mit Systemmeldungen zu prüfen |
| ------------- | --- |
| Vorbedingungen | <ul><li> Die Config ist bereits in einem separatem Projekt vorhanden.</li> Ein gültiges Token wurde in der URL mitgeschickt</li></ul> |
| Akteur | Verantwortlicher, Monitoring System |
| Auslöser | Der Verantwortliche möchte die Systemmeldungen seines Projektes überprüfen |
| Ablauf | 1. Aufruf Projekt-Mailbox URL <br/> 2. Prüfung Mails von Projekt-Mailbox |
| Ergebnisse | <ul><li> Anzeige Mails pro Subordner bei denen eine Aktion durch den Verantwortlichen erforderlich ist</li> <li> Mailserver nicht erreichbar</li> <li> Verbindung zur Projekt-Mailbox per IMAP fehlgeschlagen</li></ul> |
