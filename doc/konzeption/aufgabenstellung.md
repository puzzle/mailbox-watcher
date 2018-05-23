# Detaillierte Aufgabenstellung

## Titel der Arbeit

Mailbox Monitoring Applikation

## Thematik

Webservice für das Monitoring von IMAP-Postfächern

## Ausgangslage

Momentan gibt es eine riesige Menge an System-Mails von mehreren Projekten welche den Verantwortlichen gesendet werden. Beispielsweise Backup Reports oder Service Monitoring Notifications. Es gibt sehr viele Benachrichtigungen von verschiedenen Diensten, bei denen man nicht sicher ist, ob jemand schon darauf reagiert hat und was der aktuelle Stand davon ist. Wenn von einem Dienst keine Mails mehr eintreffen, weil irgendetwas schief gelaufen ist, kriegt man auch nicht mit.

![Project](https://raw.githubusercontent.com/puzzle/mailbox-watcher/master/doc/konzeption/project.jpg)

## Detaillierte Aufgabenstellung

Es soll nun eine Mailbox Monitoring Applikation entwickelt werden, welche die eintreffenden Mails von verschiedenen Projekten mit verschiedenen Diensten überprüft und diese behandelt.
Somit wissen die Verantwortlichen immer bestens über den aktuellen Stand der Projekte bescheid.

## Funktionale Anforderungen

Es sollen mehrere IMAP Konten sowie deren Subfolder geprüft werden können.

Im Fehlerfall soll eine Fehlermeldung erscheinen.
(z.B. wenn die jüngste Mail älter ist als sie sein darf.)

Der Zugriff soll über ein API Token geschützt werden.

## Nicht funktionale Anforderungen

Es wird die Technologie Ruby verwendet.

Die Applikation soll über Openshift laufen.

Die Testabdeckung soll über 90% sein.

Die Config soll sich in einem separaten Projekt befinden.

## Aufgabenstellung

1. Webservice erstellen

2. Authentifizierung via Token inklusive Anti Brute-force

3. Einstellungen aus Config File auslesen (Dauer, Regex, Postfach/Postfächer, Endpoint/Endpoints, IMAP-Subordner)

4. Endpoint spezifisches Postfach prüfen

5. Der Zeitpunkt des zuletzt eingetroffenen Mails überprüfen

6. Den Betreff der eintreffenden Mails überprüfen

7. Formatierte Error- / Statusmeldungen

8. Anti Brute-force (lock)

## Mittel / Methoden / Projektmethode

Als Projektmethode werden wir HERMES 5 brauchen.
 
Wir werden folgende Technologien brauchen:

- Ruby

- Javascript

- Openshift / Docker

- YAML

Entwickeln werden wir mit:

- Vim

- Rake

- Curl (Webapplikation per HTTP-Requests testen)

- RVM

- Git

## Datenbank

Für diese Webapplikation wird keine Datenbank verwendet, deshalb werden wir das Webframework Ruby on Rails nicht verwenden und begnügen uns mit Ruby.

## Vorarbeiten

Auf Github existiert ein Repository namens Mailbox-Watcher, ansonsten haben wir noch keine Vorarbeiten geleistet.

-> https://github.com/puzzle/mailbox-watcher
