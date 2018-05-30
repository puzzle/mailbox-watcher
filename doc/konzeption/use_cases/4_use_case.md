# Ordnerspezifische Regeln verwalten

## Anwendungsfall 4.1:

| Beschreibung | Ordnerspezifische Regeln hinzufügen |
| ------------- | --- |
| Vorbedingungen | Git Repository für projektspezifische Konfigurationen vorhanden |
| Auslöser | Der Verantwortliche möchte Ordnerspezifische Regeln hinzufügen |
| Ablauf | 1. In der Config den IMAP-Subordner und die Regeln (Regex, Dauer) angeben <br/> 2. Projekt neu deployen |
| Ergebnisse | Ordnerspezifische Regeln wurden hinzugefügt |

## Anwendungsfall 4.2:

| Beschreibung | Ordnerspezifische Regeln ändern |
| ------------- | --- |
| Vorbedingungen | Git Repository für projektspezifische Konfigurationen vorhanden |
| Akteur | Verantwortlicher |
| Auslöser | Der Verantwortliche möchte Ordnerspezifische Regeln ändern |
| Ablauf | 1. In der Config den IMAP-Subordner und/oder die Regeln (Regex, Dauer) ändern <br/> 2. Projekt neu deployen |
| Ergebnisse | Ordnerspezifische Regeln wurden geändert |

## Anwendungsfall 4.3:

| Beschreibung | Ordnerspezifische Regeln löschen |
| ------------- | --- |
| Vorbedingungen | Git Repository für projektspezifische Konfigurationen vorhanden |
| Akteur | Verantwortlicher |
| Auslöser | Der Verantwortliche möchte Ordnerspezifische Regeln löschen |
| Ablauf | 1. In der Config den IMAP-Subordner und/oder die Regeln (Regex, Dauer) löschen <br/> 2. Projekt neu deployen |
| Ergebnisse | Ordnerspezifische Regeln wurden gelöscht |
