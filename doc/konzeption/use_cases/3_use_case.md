# Postfach verwalten

## Anwendungsfall 3.1:

| Beschreibung | Postfach hinzufügen |
| ------------- | --- |
| Vorbedingungen | Git Repository für projektspezifische Konfigurationen vorhanden |
| Akteur | Verantwortlicher |
| Auslöser | Der Verantwortliche möchte ein Postfach hinzufügen |
| Ablauf | 1. In der Config das Postfach angeben <br/> 2. Auf OpenShift Secret File erstellen (Username, Passwort, IMAP-Server, Port, SSL Options) <br/> 3. Projekt neu deployen |
| Ergebnisse | Postfach wurde hinzugefügt |

## Anwendungsfall 3.2:

| Beschreibung | Postfach ändern |
| ------------- | --- |
| Vorbedingungen | Git Repository für projektspezifische Konfigurationen vorhanden |
| Akteur | Verantwortlicher |
| Auslöser | Der Verantwortliche möchte ein Postfach ändern |
| Ablauf | 1. In der Config das Postfach ändern <br/> 2. Auf OpenShift Secret File überarbeiten falls nötig (Username, Passwort, IMAP-Server, Port, SSL Options) <br/> 3. Projekt neu deployen |
| Ergebnisse | Postfach wurde geändert |

## Anwendungsfall 3.3:

| Beschreibung | Postfach löschen |
| ------------- | --- |
| Vorbedingungen | Git Repository für projektspezifische Konfigurationen vorhanden |
| Akteur | Verantwortlicher |
| Auslöser | Der Verantwortliche möchte ein Postfach löschen |
| Ablauf | 1. In der Config das Postfach löschen <br/> 2. Auf OpenShift Secret File anpassen / löschen falls nötig (Username, Passwort, IMAP-Server, Port, SSL Options) <br/> 3. Projekt neu deployen |
| Ergebnisse | Postfach wurde gelöscht |
