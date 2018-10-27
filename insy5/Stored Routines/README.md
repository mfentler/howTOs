# Stored Routines

### Vorteile Stored Routines:
- __Performanter__:
    - Syntax-Check beim Bauen der Procedure
    - Optimierung/Query-Plan Erstellung bereits vor der Ausführung
- __Sicherer__:  
    - Funktionen sind schon in der Datenbank drinnen.
    - Es kann nicht auf den Update Befehl von einem Administrator vergessen werden.

## Unterschiede MySQL - PostgreSQL
- __MySQL:__
    - Stored Procedure CALL bla(param1, param2, param3, ...);
    - Stored Functions -> eingebettet in SELECT  

            SELECT I,D,U
            SELECT * FROM bla();
- __Postgres:__  
    Eingebettet in SQL (wie SF bei MySQL)
    - __Query Language Functions (QLF)__ ... "plain" SQL  
    -> Kein if/while/variablen
    - __Procedural Language Functions (PLF)__ .. PLI/pqSQL  
    -> If/While/Variablen __möglich__
    - C-Language Functions (CLF)
    - Internal Functions (IF)

## Funktionsdefinition
    CREATE FUNCTION preiserhoehung() RETURNS VOID AS '
    UPDATE speise SET preis = preis * 1.05; ' LANGUAGE SQL;

### Erstellte Funktion ausführen
Um die Funktionen auszuführen muss man sie selecten:

    SELECT * FROM preiserhoehung();
Um die Änderungen dann zu sehen, selected man nochmal die Tabelle, die man mit der Funktion geändert hat.