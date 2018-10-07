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
Für das Beispiel wird nun für jede Rolle ein User erstellt..
	CREATE USER kunde1;
	GRANT Kunde TO kunde1;
	
	CREATE USER mitarbeiter1;
	GRANT Mitarbeiter TO mitarbeiter1;
	
	CREATE USER mitarbeiter2;
	GRANT Mitarbeiter TO mitarbeiter2;
	GRANT Admin To mitarbeiter2;
	
	CREATE USER admin1;
	GRANT Admin TO admin1;
	
	CREATE USER redakteur1;
	GRANT Redakteur TO redakteur1;
## Accounts erstellen

## Berechtigungen über die Datei "pg_hba.conf"

## View und Policy

## Quellen
