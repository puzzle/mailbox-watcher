# Deployment

Die Applikation läuft unter Ruby 2.4.

## Mailbox-Watcher auf OpenShift deployen

Neues OpenShift-Projekt erstellen:

```
oc new-project [projectname]
```

User zu Projekt hinzufügen:

```
oc policy add-role-to-user [role] [username]
```

Template instanzieren:

```
oc new-app -f mailbox-watcher-deployment.yml -p APPLICATION_DOMAIN=[domain]
```

### Add Config- and Secret-Files to Project

Create ConfigMap:

```
oc create configmap project-config --from-file=/path_to_config_file1/project1.yml --from-file=/path_to_config_file2/project2.yml
```

Mount Config-Files:

```
oc volume dc/mailbox-watcher --add --name project-config -t configmap --configmap-name=project-config -m /mnt/config
```

Create Secret:

```
oc create secret generic project-secret --from-file=/path_to_secret_file1/project1.yml --from-file=/path_to_secret_file2/project2.yml
```

Mount Secret-Files:

```
oc volume dc/mailbox-watcher --add --name project-secret -t secret --secret-name=project-secret -m /mnt/secret
```

Delete ConfigMap:

```
oc delete configmap project-config
```

Delete Secret:

```
oc delete secret project-secret
```

### Umgebungsvariablen

Die Umgebungsvariablen werden beim Initialisieren des Templates gesetzt.

| Umgebungsvariable | Beschreibung | Wert |
| --- | --- | --- |
| MAIL_MON_TOKEN | Random generiertes Token für Authentifizierung  | Bsp: `4QMebK89qeq7oblXt1PDNHiS7gdkD0V2gatd1dp` |
| CONFIG_PATH | Pfad zu Config-Files | `/mnt/config` |
| SECRET_PATH | Pfad zu Secret-Files  | `/mnt/secret` |
