# Projekt verwalten

## Anwendungsfall 2.1:

| Beschreibung | Projekt hinzufügen |
| ------------- | --- |
| Vorbedingungen | Git Repository für projektspezifische Konfigurationen vorhanden |
| Akteur | Verantwortlicher |
| Auslöser | Der Verantwortliche möchte ein Projekt hinzufügen |
| Ablauf | 1. Auf Github ein Repo für die Config erstellen <br/> 2. In der Config den Endpoint des Projektes angeben <br/> 3. Auf OpenShift das Config Repo angeben <br/> 4. Projekt neu deployen |
| Ergebnisse | Projekt Endpoint wurde erstellt |

## Anwendungsfall 2.2:

| Beschreibung | Projekt ändern |
| ------------- | --- |
| Vorbedingungen | Git Repository für projektspezifische Konfigurationen vorhanden |
| Akteur | Verantwortlicher |
| Auslöser | Der Verantwortliche möchte den Endpoint eines Projektes ändern |
| Ablauf | 1. In der Config den Endpoint des Projektes ändern <br/> 2. Projekt neu deployen |
| Ergebnisse | Projekt Endpoint wurde geändert |


## Anwendungsfall 2.3:

| Beschreibung | Projekt löschen |
| ------------- | --- |
| Vorbedingungen | Git Repository für projektspezifische Konfigurationen vorhanden |
| Akteur | Verantwortlicher |
| Auslöser | Der Verantwortliche möchte ein Projekt löschen |
| Ablauf | 1. In der Config den Endpoint des Projektes löschen <br/> 2. Projekt neu deployen |
| Ergebnisse | Projekt Endpoint wurde gelöscht |
