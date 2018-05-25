# Detaillierte Aufgabenstellung

## Titel der Arbeit

Mailbox Monitoring Applikation

## Thematik

Webservice für das Monitoring von IMAP-Postfächern

## Ausgangslage

Momentan gibt es eine riesige Menge an System-Mails von mehreren Projekten welche den Verantwortlichen gesendet werden. z.B. Backup Reports oder Service Monitoring Notifications. Es gibt sehr viele Benachrichtigungen von verschiedenen Diensten, bei denen man nicht sicher ist, ob jemand schon darauf reagiert hat und was der aktuelle Stand davon ist. Backup-Reports sollten täglich ankommen, fällt ein Backup aus und es werden keine Nachrichten mehr gesendet, fällt das heute selten bis gar nicht auf.

![Project](https://raw.githubusercontent.com/puzzle/mailbox-watcher/master/doc/konzeption/project.jpg)

## Detaillierte Aufgabenstellung

Es soll nun eine webbasierte Mailbox Monitoring Applikation entwickelt werden, welche die vorhandenen Mails von verschiedenen Projekt-Mailboxen nach spezifischen Regeln prüft. Beim Aufruf der der Projekt-Mailbox URL wird das/werden die Postfächer geprüft und es wird ein Bericht zurück gegeben.  

## Funktionale Anforderungen

* Es sollen mehrere IMAP Konten sowie deren Subfolder geprüft werden können
* Regeln können für jeden Folder definiert werden
* Es wird ein Report im JSON Format zurück gegeben
* HTTP Status Codes: 200 OK oder bei Alerts 500
* Konfigurierbare Regel: Das jüngste Mail darf nicht älter sein als (in Stunden)
* Konfigurierbare Regel: Der Betreff der Nachricht matched definierte Regex
* Ein einfaches UI mit JavaScript macht den JSON Output human-readable

## Nicht funktionale Anforderungen

* Der Zugriff soll über ein API Token geschützt werden (1 Token für alle Projekte)
* Als Technologie wird Ruby verwendet
* Die Applikation soll auf Docker/Openshift laufen
* Die Testabdeckung soll > 90% sein
* Die Config soll sich in einem separaten Projekt befinden
* Die Credentials für die Postfächer werden über ein Secret File im Container verfügbar gemacht

## Aufgabenstellung

### Konzeption

1. Sämtliche Use Cases dokumentieren, vom PO absegnen lassen
1. Terminplanung
1. PoC erstellen (welche Gems, wie Webservice bauen, Config Files YAML ?)
1. Architektur konzipieren (Flussdiagramme, Klassendiagramme, usw.)

### Umsetzung

Hier ein Vorschlag für die technische Umsetzung: (kann während der Konzeption noch angepasst werden)

1. Webservice erstellen
1. Authentifizierung via Token
1. IMAP Komponente bauen (IMAP Connector)
1. Einstellungen aus Config File auslesen (Dauer, Regex, Postfach/Postfächer, Endpoint/Endpoints, IMAP-Subordner)
1. Passwörter / Zugangsdaten aus Secrets File auslesen (User, Password, IMAP-Server, Port, SSL Options, ...)
1. Der Zeitpunkt des zuletzt eingetroffenen Mails überprüfen
1. Den Betreff der eintreffenden Mails überprüfen
1. Formatierte Error- / Statusmeldungen (JSON)
1. Simples UI mit Javascript

## Mittel / Methoden / Projektmethode

Als Projektmethode werden wir HERMES 5 brauchen.
 
Wir werden folgende Technologien brauchen:

* Ruby
* Rubygems
* Javascript
* Openshift / Docker
* YAML

Entwickeln werden wir mit:

* Vim
* Rake
* Curl (Webapplikation per HTTP-Requests testen)
* RVM
* Git

## Datenbank

Die Applikation soll ohne Datebank auskommen. Die Konfiguration der Postfächer soll über eine Configdatei erfolgen. Die Credentials werden über ein Secret File zur Verfügung gestellt.

## Vorarbeiten

Repo/Projekt auf Github erstellt -> https://github.com/puzzle/mailbox-watcher
