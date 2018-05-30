# Ordnerspezifische Regeln verwalten

## Anwendungsfall 4.1:

| Beschreibung | Ordnerspezifische Regeln hinzufügen |
| ------------- | --- |
| Vorbedingungen | Git Repository für projektspezifische Konfigurationen vorhanden |
| Akteur | Verantwortlicher |
| Auslöser | Der Verantwortliche möchte Ordnerspezifische Regeln hinzufügen |
| Ablauf | 1. Konfiguration erstellen und in Config Repo pushen (IMAP-Subordner, Regeln) <br/> 2. Service neu deployen |
| Ergebnisse | Service wird mit neuen Ordnerspezifischen Regeln konfiguriert |

## Anwendungsfall 4.2:

| Beschreibung | Ordnerspezifische Regeln ändern |
| ------------- | --- |
| Vorbedingungen | Git Repository für projektspezifische Konfigurationen vorhanden |
| Akteur | Verantwortlicher |
| Auslöser | Der Verantwortliche möchte Ordnerspezifische Regeln ändern |
| Ablauf | 1. Konfiguration ändern und in Config Repo pushen <br/> 2. Service neu deployen |
| Ergebnisse | Die konfigurierten Ordnerspezifischen Regeln wurden geändert |

## Anwendungsfall 4.3:

| Beschreibung | Ordnerspezifische Regeln löschen |
| ------------- | --- |
| Vorbedingungen | Git Repository für projektspezifische Konfigurationen vorhanden |
| Akteur | Verantwortlicher |
| Auslöser | Der Verantwortliche möchte Ordnerspezifische Regeln löschen |
| Ablauf | 1. Konfiguration löschen und in Config Repo pushen <br/> 2. Service neu deployen |
| Ergebnisse | Ordnerspezifische Regeln wurden aus der Config gelöscht |
