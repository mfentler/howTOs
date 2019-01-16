# Stored Routines

### Vorteile Stored Routines:
- __Performanter__:
    - Syntax-Check beim Bauen der Procedure
    - Optimierung/Query-Plan Erstellung bereits vor der Ausführung -> beim Erzeugen der Stored Routine
- __Sicherer__:  
    - Funktionen sind schon in der Datenbank drinnen.
    - Es kann nicht auf den Update Befehl von einem Administrator vergessen werden.

## Unterschiede MySQL - PostgreSQL
- __MySQL:__
    - Stored Procedure CALL bla(param1, param2, param3, ...);  
    CALL xxxx()
    - Stored Functions -> eingebettet in SELECT  
    ```sql
    SELECT xxxx()
    SELECT I,D,U
    SELECT * FROM bla();
    ```
- __Postgres:__  
    Eingebettet in SQL (wie SF bei MySQL)
    - __Query Language Functions (QLF)__ ... "plain" SQL  
    -> Kein if/while/variablennamen (nur $1,$2,...)
    - __Procedural Language Functions (PLF)__ .. PLI/pqSQL  
    -> If/While/Variablennamen __möglich__
    - C-Language Functions (CLF)
    - Internal Functions (IF)

## Funktionsdefinition
```sql
CREATE FUNCTION preiserhoehung() RETURNS VOID AS '
UPDATE speise SET preis = preis * 1.05; ' LANGUAGE SQL;
```

### Erstellte Funktion ausführen
Um die Funktionen auszuführen muss man sie selecten:
```sql
SELECT * FROM preiserhoehung();
```
Um die Änderungen dann zu sehen, selected man nochmal die Tabelle, die man mit der Funktion geändert hat.

## Funktionen löschen
```sql
DROP FUNCTION xxxx();
DROP FUNCTION xxxx(INT);
```
Das kann sehr lästig werden. Aus diesem Grund wird die Syntax für die Erstellung von Funktionen abgeändert =>

## Funktionen erstellen V2
```sql
CREATE OR REPLACE xxx() RETURNS VOID AS $$...$$ LANG=SQL;
```

### Funktionsvariablen
Dazu muss man bei der Funktion, in der QLF, nur die Typen angeben da es keine Variablen gibt. Stattdessen werden Stellungsparameter verwendet.
```sql
... FUNCTION ()
... FUNCTION (INT)
... FUNCTION (INT,NUMERIC,TEXT,...)
```

#### Stellungsparameter
Die Paramater können über $1,$2,$3 angesprochen werden.

---
## Rückgabewerte

### __Void__
Gibt nichts zurück.
```sql
CREATE OR REPLACE FUNCTION VoidFunction RETURNS VOID AS $$
    ... 
$$ LANGUAGE SQL; 
```

### __Ein Wert__
Gibt einen Wert zurück. Kann im SELECT, WHERE, HAVING, ORDER BY und LIMIT eingesetzt werden.
```sql
CREATE OR REPLACE FUNCTION WertFunction RETURNS <VOID/INTEGER/TEXT/NUMERIC> AS $$
    ... 
$$ LANGUAGE SQL; 

CREATE OR REPLACE FUNCTION wert(INTEGER) RETURNS TEXT AS $$
    SELECT name FROM kellner
    WHERE knr = $1;
$$ LANGUAGE SQL;
```

### __Eine Spalte__
Gibt eine Spalte zurück und kann im SELECT und WHERE verwendet werden.
```sql
CREATE OR REPLACE FUNCTION SpalteFunction RETURNS SET OF <VOID/INTEGER/TEXT/NUMERIC> AS 
$$
    ... 
$$ LANGUAGE SQL; 

CREATE OR REPLACE FUNCTION spalte() RETURNS SETOF TEXT AS $$
    SELECT name FROM kellner;
$$ LANGUAGE SQL;
```

### __Eine Zeile__
Gibt eine Zeile zurück und kann in der SELECT Klausel verwendet werden.
```sql
CREATE OR REPLACE FUNCTION ZeileFunction RETURNS <Custom-Tabellenname> AS $$
... 
$$ LANGUAGE SQL; 

CREATE OR REPLACE FUNCTION zeile(INTEGER) RETURNS SETOF kellner AS $$
    SELECT * FROM kellner
    WHERE knr = $1
    LIMIT 1;
$$ LANGUAGE SQL;
```

### __Eine Tabelle__
Gibt eine ganze Tabelle zurück und kann in der SELECT-Klausel und in der FROM Anweisung verwendet werden.
```sql
CREATE OR REPLACE FUNCTION TableFunction RETURNS SETOF ... AS $$
... 
$$ LANGUAGE SQL; 

CREATE OR REPLACE FUNCTION tabellen() RETURNS SETOF kellner AS $$
    SELECT * FROM kellner;
$$ LANGuage SQL;
```