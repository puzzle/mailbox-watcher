# Anwendungsfall 1: 

| Beschreibung | Der Benutzer öffnet den Projekt-Endpoint um den Zustand der Mailbox mit Systemmeldungen zu prüfen |
| ------------- | --- |
| Vorbedingung | Die Config ist bereits in einem separatem Projekt vorhanden. Ein gültiges Token wurde in der URL mitgeschickt |
| Akteur | Verantwortlicher, Monitoring System |
| Auslöser | Der Verantwortliche möchte die Systemmeldungen seines Projektes überprüfen |
| Ablauf | 1. Aufruf Projekt-Mailbox URL <br/> 2. Prüfung Mails von Projekt-Mailbox |
| Ergebnisse | * Anzeige Mails pro Subordner bei denen eine Aktion durch den Verantwortlichen erforderlich ist <br/>               * Mailserver nicht erreichbar <br/> * Verbindung zur Projekt-Mailbox per IMAP fehlgeschlagen |
