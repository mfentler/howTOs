# PostgreSQL Inject SQL File

## Vorarbeit
Zuerst wird die Datenbank in psql angelegt und ein User erstellt, der darauf Zugriff hat.

	CREATE USER mario WITH LOGIN PASSWORD '****';
	CREATE DATABASE dvdrental OWNER mario;
	GRANT ALL PRIVILEGES ON DATABASE dvdrental TO mario;
	
## Zip-File auf die Linux Maschine bekommen und entpacken
Das Zip File von E-learning wird auf der Windows Maschine entpackt. Man erhält ein .tar File.  
Dieses wird mit der Software "Win-SCP" auf die virtuelle Maschine transferiert und dort mit folgendem Command in ein beliebiges Verzeichnis entpackt.

	tar -xvf datei.tar
	
## SQL Datei injecten
In diesem Verzeichnis befindet sich eine "restore.sql" Datei. Diese muss zuerst adaptiert werden.  
Der $$Path$$ zu den anderen Dateien __muss zuerst noch im File gesetzt werden.__
__Diesen Pfad auf "/tmp/database/-datei-" legen.__

Nun wird der Ordner in den /tmp Ordner kopiert, da sonst der psql copy Command kein Zugriffsrecht auf die Dateien hat. Anschließend werden dort dann auch noch die Zugriffsrechte gesetzt.

	cp -r database /tmp/database/
	chmod -R a+rX /tmp/database/
	chmod -R a+rX /tmp/database/*
Jetzt kann das File in die Datenbank gepipt werden. 

	psql -h localhost -U mario -W -d dvdrental
	\i /tmp/database/restore.sql
