# Trigger in Postgres
Mario Fentler 5CHIT  
03.04.2019  

## Unterschied zu MySQL Triggern
- Bei Update-Triggern kann auch nur auf die Änderung einzelner Spalten in einer Tabelle gewartet werden.  
- Postgres kann Trigger auch für Truncate-Statements setzen.
- Es gibt __INSTEAD OF__-Trigger -> Ohne das ich das Program bei einem Fehler neu ausliefern muss kann ich im Hintergrund einen InsteadOF-Trigger einsetzen. Dadurch muss nur im Hintergrund was geändert werden.

## Trigger erstellen
Kein BEGIN/END wie bei MySQL, sondern der Trigger muss eine StoredRoutine ausführen. -> __Execute Procedure function_name(argument)__  
''PL/pgSQL can be used to define trigger procedures. A trigger procedure is created with the CREATE FUNCTION command, declaring it as a function with no arguments and a return type of trigger. Note that the function must be declared with no arguments even if it expects to receive arguments specified in CREATE TRIGGER — trigger arguments are passed via TG_ARGV, as described below.''

```SQL
DROP TRIGGER IF EXISTS trigger_a;
CREATE TRIGGER trigger_a
    BEFORE INSERT
    ON rechnung
    FOR EACH ROW
    WHEN (NEW.datum IS NULL)
    EXECUTE PROCEDURE setCurrentDate();
```

## Trigger Funktionen
Trigger executen Funktionen. Auch wenn diese eigentlich Parameter erwarten, __deklariert man sie ohne__ und mit dem Rückgabetyp __TRIGGER__.  
Die Funktion bekommt automatisch OLD und NEW mitgeliefert. - [1]

Bsp:  
```SQL
CREATE OR REPLACE FUNCTION setCurrentDate() RETURNS TRIGGER AS $$
    BEGIN
        NEW.datum = CURRENT_DATE();
        RETURN NEW;
    END;
$$ LANGUAGE SQL;
```

## Ausführen der Aufgaben
Zum Testen der Trigger -> einfach die SQL Files ausführen. Diese erstellen zuerst die Datenbank neu, erstellen dann die Funktionen und Trigger und testen dann mit Select-Klauseln, ob das Ergebis stimmt.

## Quellen
[1] [https://stackoverflow.com/questions/7726237/postgresql-trigger-function-with-parameters](https://stackoverflow.com/questions/7726237/postgresql-trigger-function-with-parameters)

# Aufgaben
Zum Testen der Aufgaben wieder wie gehabt die SQL Files ausführen.

## AU10 - a)
---
__Lösungsvorgang:__  
Es wird überprüft ob bei einem neuen Eintrag der Wert des Datums NULL ist. Falls das so ist, wird es korrigiert.

__Funktion:__  
In der Funktion wird für diesen Eintrag das Datum auf das aktuelle Datum gesetzt.
```sql
CREATE OR REPLACE FUNCTION setCurrentDate() RETURNS trigger AS $$
    BEGIN
        NEW.datum = CURRENT_DATE;
        RETURN NEW;
    END;
$$ LANGUAGE PLPGSQL;
```

__Trigger:__  
Im Trigger wird überprüft ob das Datum NULL ist. Wenn ja, dann wird die Funktion aufgerufen. 
```SQL
DROP TRIGGER IF EXISTS trigger_a ON rechnung;
CREATE TRIGGER trigger_a
    BEFORE INSERT
    ON rechnung
    FOR EACH ROW
    WHEN (NEW.datum IS NULL)
    EXECUTE PROCEDURE setCurrentDate();
```

__Testen:__  
```SQL
-- Testing
SELECT * FROM rechnung;
INSERT INTO rechnung(rnr,datum,tisch,status,knr) VALUES (7,NULL,2,'offen',1);
SELECT * FROM rechnung WHERE rnr = 7;
-- Datum ist nicht NULL -> passt
```
