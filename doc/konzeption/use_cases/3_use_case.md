# Postfach verwalten

## Anwendungsfall 3.1:

| Beschreibung | Postfach hinzufügen |
| ------------- | --- |
| Vorbedingungen | Git Repository für projektspezifische Konfigurationen vorhanden |
| Akteur | Verantwortlicher |
| Auslöser | Der Verantwortliche möchte ein Postfach hinzufügen |
| Ablauf | 1. Konfiguration erstellen und in Config Repo pushen (Postfach, IMAP-Credentials) <br/> 2. Service neu deployen |
| Ergebnisse | Postfach wurde hinzugefügt |

## Anwendungsfall 3.2:

| Beschreibung | Postfach ändern |
| ------------- | --- |
| Vorbedingungen | Git Repository für projektspezifische Konfigurationen vorhanden |
| Akteur | Verantwortlicher |
| Auslöser | Der Verantwortliche möchte ein Postfach ändern |
| Ablauf | 1. Konfiguration ändern und in Config Repo pushen <br/> 2. Service neu deployen |
| Ergebnisse | Postfach wurde geändert |

## Anwendungsfall 3.3:

| Beschreibung | Postfach löschen |
| ------------- | --- |
| Vorbedingungen | Git Repository für projektspezifische Konfigurationen vorhanden |
| Akteur | Verantwortlicher |
| Auslöser | Der Verantwortliche möchte ein Postfach löschen |
| Ablauf | 1. Konfiguration ändern und in Config Repo pushen <br/> 2. Service neu deployen |
| Ergebnisse | Postfach wurde gelöscht |
