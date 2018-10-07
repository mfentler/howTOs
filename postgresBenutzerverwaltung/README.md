# Benutzerverwaltung in PostgreSQL

In der Übung werden folgende Benutzerrollen angelegt, Berechtigungen erstellt und Beispielaufgaben gelöst.  
Rollen:
- Kunde  
darf die Spalte "replacement_cost" __nicht sehen__
- Mitarbeiter  
Zahlungen einsehen und anlegen
- Admin  
Zahlungen einsehen und anlegen  
Zahlungen ändern & löschen
- Redakteur

## Rollen erstellen
Eine Rolle in Postgres kann man wie einen User oder eine Gruppe sehen. Dieser Rolle kann man dann bestimmte Berechtigungen geben.  
Zuerst muss man sich mit der Datenbank verbinden.

	psql -h localhost -U Mario -W -d dvdrental
Anschließend können die Rollen erstellt werden. Bei Rollen kann man viele verschieden Optionen bei der Erstellung wählen.  
Für Gruppenrollen werden meistens die "Login"-Option ausgelassen. Diese findet man bei User-Rollen.

	CREATE ROLE Kunde;
	CREATE ROLE Mitarbeiter;
	CREATE ROLE Admin;
	CREATE ROLE Redakteur;
Diese Rollen kann man Usern geben oder wieder wegnehmen mit folgenden Commands:

	GRANT rolename TO username;
	REVOKE rolename FROM username;

## Accounts erstellen
In Postgres sind Rollen mit der "Login"-Option dasselbe wie User.  
Man kann nun entscheiden wie man sie erstellt. Für das Beispiel wurde CREATE USER verwendet.

	REATE USER kunde1 WITH PASSWORD 'kunde123';
	GRANT Kunde TO kunde1;
	
	CREATE USER mitarbeiter1 WITH PASSWORD 'ma123';
	GRANT Mitarbeiter TO mitarbeiter1;
	
	CREATE USER mitarbeiter2 WITH PASSWORD 'ma123';
	GRANT Mitarbeiter TO mitarbeiter2;
	GRANT Admin To mitarbeiter2;
	
	CREATE USER admin1 WITH PASSWORD 'admin';
	GRANT Admin TO admin1;
	
	CREATE USER redakteur1 WITH PASSWORD 'red123';
	GRANT Redakteur TO redakteur1;
	
## Zugriffsberechtigungen
Zahlungen einsehen und anlegen

	GRANT SELECT ON ALL TABLES IN SCHEMA public TO <Rolle>; //Für alle Rollen
	GRANT INSERT ON payment TO Admin;
	GRANT INSERT ON payment TO Mitarbeiter;
	
	GRANT UPDATE ON payment TO Admin;
	GRANT DELETE ON payment TO Admin;
	
	REVOKE SELECT ON payment FROM Kunde;
	REVOKE SELECT ON payment FROM Redakteur;
	
Überprüfen kann man das mit dem Befehl __\dp__ indem man sich die Permissions anzeigen lässt. Alternativ kann man es auch einfach ausprobieren ob man die Rechte hat.

## Berechtigungen über die Datei "pg_hba.conf"

## View und Policy

## Quellen
[1] https://www.postgresql.org/docs/9.1/static/index.html  
