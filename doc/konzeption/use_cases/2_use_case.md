# Projekt verwalten

## Anwendungsfall 2.1:

| Beschreibung | Projekt hinzufügen |
| ------------- | --- |
| Vorbedingungen | Git Repository für projektspezifische Konfigurationen vorhanden |
| Akteur | Verantwortlicher |
| Auslöser | Der Verantwortliche möchte ein Projekt hinzufügen |
| Ablauf | 1. Konfiguration erstellen und in Config Repo pushen <br/> 2. Service neu deployen |
| Ergebnisse | Service wird mit neuer Projekt-Config konfiguriert |

## Anwendungsfall 2.2:

| Beschreibung | Projekt ändern |
| ------------- | --- |
| Vorbedingungen | Git Repository für projektspezifische Konfigurationen vorhanden |
| Akteur | Verantwortlicher |
| Auslöser | Der Verantwortliche möchte den Endpoint eines Projektes ändern |
| Ablauf | 1. Konfiguration ändern und in Config Repo pushen <br/> 2. Service neu deployen |
| Ergebnisse | Projekt ist unter einem neuen Endpointnamen erreichbar |


## Anwendungsfall 2.3:

| Beschreibung | Projekt löschen |
| ------------- | --- |
| Vorbedingungen | Git Repository für projektspezifische Konfigurationen vorhanden |
| Akteur | Verantwortlicher |
| Auslöser | Der Verantwortliche möchte ein Projekt löschen |
| Ablauf | 1. Konfiguration löschen und in Config Repo pushen <br/> 2. Service neu deployen |
| Ergebnisse | Projekt-Config wurde gelöscht |
