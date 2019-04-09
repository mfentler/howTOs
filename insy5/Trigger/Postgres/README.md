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
Die Funktion bekommt automatisch OLD und NEW mitgeliefert. - [2]

Bsp:  
```SQL
CREATE OR REPLACE FUNCTION setCurrentDate() RETURNS TRIGGER AS $$
    BEGIN
        NEW.datum = CURRENT_DATE();
        RETURN NEW;
    END;
$$ LANGUAGE SQL;
```

## Quellen
[1] jjj  
[2] [https://stackoverflow.com/questions/7726237/postgresql-trigger-function-with-parameters](https://stackoverflow.com/questions/7726237/postgresql-trigger-function-with-parameters)