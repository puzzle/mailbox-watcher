# Use Cases

## Authentifizierung

### Aktor

Verantwortlicher

### Beschreibung

Der Verantwortliche gibt das einmalige Token in der URL mit.

Beispiel: www.mailbox-watcher.ch/token=12345678

### Vorbereitung

Der Verantwortliche ist nicht angemeldet.

### Ablauf

1. Aufruf Seite
1. Eingabe Token in der URL
1. Authentifizierung
1. Projekt-Mailbox URL kann aufgeruft werden


## Verbindung zur Mailbox aufbauen

### Aktor

Verantwortlicher

### Beschreibung

Das Config File wird ausgelesen und der Mailbox-Watcher
baut per IMAP eine Verbindung zur Mailbox auf.

### Vorbereitung

Der Verantwortliche ist angemeldet.

### Ablauf

1. Aufruf Projekt-Mailbox URL
1. Config File auslesen
1. Verbindung zur Mailbox aufbauen
1. Mailbox kann überprüft werden


## Mailbox überprüfen, OK

### Aktor

Verantwortlicher

### Beschreibung

Der Verantwortliche prüft die Postfächer.
Es ist alles Ok.

### Vorbereitung

Der Verantwortliche ist angemeldet.
Eine Verbindung zur Mailbox wurde aufgebaut.

### Ablauf

1. Aufruf Projekt-Mailbox URL
1. Postfächer werden geprüft
1. Eine OK-Meldung wird zurück gegeben


## Mailbox überprüfen, Error

### Aktor

Verantwortlicher

### Beschreibung

Der Verantwortliche prüft die Postfächer.
Ein Fehler tritt auf.

### Vorbereitung

Der Verantwortliche ist angemeldet.
Eine Verbindung zur Mailbox wurde aufgebaut.

### Ablauf

1. Aufruf Projekt-Mailbox URL
1. Postfächer werden geprüft
1. Eine Fehlermeldung wird zurück gegeben


## Mailserver down

### Aktor

Verantwortlicher

### Beschreibung

Das Config File wird ausgelesen und der Mailbox-Watcher
versucht per IMAP eine Verbindung zur Mailbox aufzubauen.
Da der Mailserver down ist, kann keine Verbindung aufgebaut werden.

### Vorbereitung

Der Verantwortliche ist angemeldet.

### Ablauf

1. Aufruf Projekt-Mailbox URL
1. Config File auslesen
1. Verbindung zur Mailbox fehlgeschlagen
1. Eine Fehlermeldung wird zurück gegeben


## Postfach erstellen

### Aktor

Verantwortlicher

### Beschreibung

### Vorbereitung

### Ablauf
