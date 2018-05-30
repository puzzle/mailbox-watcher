# Projekt verwalten

## Anwendungsfall 2.1:

| Beschreibung | Projekt hinzufügen |
| ------------- | --- |
| Vorbedingungen | |
| Akteur | Verantwortlicher |
| Auslöser | Der Verantwortliche möchte ein Projekt hinzufügen |
| Ablauf | 1. Auf Github ein Repo für die Config erstellen <br/> 2. In der Config den Endpoint des Projektes angeben <br/> 3. Auf OpenShift das Config Repo angeben <br/> 4. Projekt neu deployen |
| Ergebnisse | <ul><li> Projekt Endpoint wurde erstellt</li></ul> |

## Anwendungsfall 2.2:

| Beschreibung | Projekt ändern |ndung zur Projekt-Mailbox per IMAP fehlgeschlagen</li></ul> |
| ------------- | --- |
| Vorbedingungen | <ul><li>Die Config mit dem Endpoint ist bereits in einem separatem Projekt vorhanden</li></ul>|
| Akteur | Verantwortlicher |
| Auslöser | Der Verantwortliche möchte den Endpoint eines Projektes ändern |
| Ablauf | 1. Auf Github ein Repo für die Config erstellen <br/> 2. In der Config den Endpoint des Projektes angeben <br/> 3. Auf OpenShift das Config Repo angeben <br/> 4. Projekt neu deployen |
| Ergebnisse | <ul><li> Projekt Endpoint wurde erstellt</li></ul> |


## Anwendungsfall 2.3:

| Beschreibung | Projekt löschen |
| ------------- | --- |
| Vorbedingungen | |
| Akteur | Verantwortlicher |
| Auslöser | Der Verantwortliche möchte ein Projekt löschen |
| Ablauf | 1. In der Config Endpoint angeben <br/> 2. Prüfung Mails von Projekt-Mailbox |
| Ergebnisse | <ul><li> Anzeige Mails pro Subordner bei denen eine Aktion durch den Verantwortlichen erforderlich ist</li> <li> Mailserver nicht erreichbar</li> <li> Verbindung zur Projekt-Mailbox per IMAP fehlgeschlagen</li></ul> |
