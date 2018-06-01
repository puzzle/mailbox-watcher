# Konzept

## Phasen

![Phasen](https://raw.githubusercontent.com/puzzle/mailbox-watcher/master/doc/konzeption/phasen.jpg)

## Arbeitsschritte

### Webservice erstellen

Einlesen in Ruby Netzwerk Programmierung: http://www.rubyguides.com/2015/04/ruby-network-programming/

Erstelle einen einfachen Webservice bei dem man mit einem Get-Request eine Antwort à la Hello World erhält.

### Authentifizierung via Token

Der Benutzer kann sich via Token authentifizieren. Dieses Token ist einmalig und in einem Secret File im Container hinterlegt.
das Token wird bei jedem Request in der URL mitgeschickt. Die Applikation prüft ob das mitgegebene Token gleich ist wie die vorhandene Umgebungsvariable.
Wenn das Token nicht stimmt wird eine Fehlermeldung angezeigt und der Zugriff verweigert.

### IMAP Komponente bauen

Die Applikation soll sich per IMAP mit einer Mailbox verbinden können. Dazu muss ein IMAP Connector gebaut werden.
Falls der Verbindungsaufbau fehlschlägt, soll eine Fehlermeldung erstellt werden.


### Einstellungen aus Config File auslesen (Dauer, Regex, Postfach/Postfächer, Endpoint/Endpoints, IMAP-Subordner)

Die Einstellungen sollen aus dem Config File ausgelesen werden können. Das Config File ist ein YAML-File.
Im Config File werden die zu überprüfenden Postfächer mit den IMAP Subordnern und die Endpoints gespeichert.
Ausserdem ist die Dauer und die Regex hinterlegt um ein Mail zu überprüfen.

### Passwörter / Zugangsdaten aus Secrets File auslesen (User, Password, IMAP-Server, Port, SSL Options, ...)

Die Applikation soll das Secrets File welches sich auf OpenShift befindet auslesen können. Im Secrets File sind die nötigen
Informationen, um sich mit einem Mailserver verbinden zu können.

### Der Zeitpunkt des zuletzt eingetroffenen Mails überprüfen

Im Config-File wird angeben wie alt das zuletzt erhaltene Mail sein darf.
Es soll überprüft werden ob das letzte Mail zu alt ist.
Wenn eine Mail zu alt ist soll eine Fehlermeldung erstellt werden.

### Den Betreff der eintreffenden Mails überprüfen

Im Config-File wird mit einem Regex angegeben.
Falls der Regex mit dem Betreff einer Mail übereinstimmt soll eine Fehlermeldung erstellt werden.

### Formatierte Error- / Statusmeldungen (JSON)

Die Error- / Statusmeldungen sollen per JSON formatiert werden. 

### Simples UI mit Javascript

Der User soll über ein Simples Interface die verschiedenen Projekte mit den aufgelisteten Fehlermeldungen sehen können.

Auf der Hauptseite sind alle Projekte aufgelistet. Die Projekte werden aus der Config welche sich in einem separaten Git Repo befindet, ausgelesen. Wenn man auf ein Projekt klickt kommt man auf den Endpoint des Projektes zB. /hitobito
Von den Statusmeldungen werden nur die Fehlermeldungen angezeigt.
