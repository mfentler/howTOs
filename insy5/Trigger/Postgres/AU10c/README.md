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

## AU10 - b)
---
__Lösungsvorgang:__  
Neue Tabelle 'preisAenderung' erstellt. Dort werden die Preise jetzt gespeichert. Immer nach einem Update wird die Funktion getriggert, die den alten und den neuen Preis in die Tabelle schreibt. Wenn es an diesem Tag für die Speise schon einen Eintrag gibt, dann wird das überschrieben.

__Hilfstabelle:__
```SQL
DROP TABLE IF EXISTS preisaenderung;
CREATE TABLE preisaenderung(
    datum DATE,
    snr INTEGER,
    bezeichnung VARCHAR(255),
    preisVorher DECIMAL(6,2),
    preisNachher DECIMAL(6,2),
    PRIMARY KEY(datum,snr)
);
```

__Funktion:__  
In der Funktion wird überprüft ob es für den Tag und die Speise schon einen Eitrag gibt. Wenn ja, dann wird update ausgeführt sonst insert.
```sql
CREATE OR REPLACE FUNCTION notePriceChange() RETURNS TRIGGER AS $$
    BEGIN
        IF EXISTS(SELECT * FROM preisaenderung WHERE datum=CURRENT_DATE) THEN
            UPDATE preisaenderung SET preisVorher=OLD.preis,preisNachher=NEW.preis
            WHERE datum=CURRENT_DATE AND snr=NEW.snr;
        ELSE
            INSERT INTO preisaenderung(datum,snr,bezeichnung,preisVorher,preisNachher) 
            VALUES(CURRENT_DATE,OLD.snr,OLD.bezeichnung,OLD.preis,NEW.preis);
        END IF;
        RETURN NEW;
    END;
$$ LANGUAGE PlPGSQL;
```

__Trigger:__ 
```SQL
DROP TRIGGER IF EXISTS trigger_b ON speise;
CREATE TRIGGER trigger_b
    AFTER UPDATE
    ON speise
    FOR EACH ROW
    EXECUTE PROCEDURE notePriceChange();
```

__Testen:__
```sql
-- Testing
-- SELECT standard preis
SELECT * FROM speise WHERE snr = 4;
-- update preis pute natur
UPDATE speise SET preis = 5.5 WHERE snr = 4;
-- show in table
SELECT * FROM preisaenderung;
-- UPDATE preis nochmal um zu sehen ob in der preisänderung das richtige gespeichert wurde
UPDATE speise SET preis = 10 WHERE snr = 4;
-- show in table again
SELECT * FROM preisaenderung;
```

## AU10 - c)
---
__Lösungsvorgang:__  
Insert in die Storno Tabelle. Wenn es das schon gibt, dann update.

__Hilfstabelle:__  
Die Einträge werden in diese Tabelle geschrieben.
```SQL
DROP TABLE IF EXISTS bestellstorno;
CREATE TABLE bestellstorno(
    datum DATE,
    anzahl SMALLINT,
    rnr         INTEGER,
    snr         INTEGER,
    PRIMARY KEY (rnr, snr),
    FOREIGN KEY (rnr) REFERENCES rechnung (rnr)
                    ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (snr) REFERENCES speise (snr)
                    ON UPDATE CASCADE ON DELETE CASCADE
);
```

__Funktion:__
```sql
CREATE OR REPLACE FUNCTION updateBestellstorno() RETURNS TRIGGER AS $$
    BEGIN
        INSERT INTO bestellstorno (datum,anzahl,rnr,snr)
        VALUES (CURRENT_DATE,OLD.anzahl,OLD.rnr,OLD.snr);
        RETURN OLD;
    END;
$$ LANGUAGE PLPGSQL;
```

__Trigger:__ 
```SQL
DROP TRIGGER IF EXISTS trigger_c ON bestellung;
CREATE TRIGGER trigger_c
    BEFORE DELETE
    ON bestellung
    FOR EACH ROW
    EXECUTE PROCEDURE updateBestellstorno();
```

__Testen:__
```sql
-- Testing
SELECT * FROM bestellung WHERE rnr = 4;
DELETE FROM bestellung WHERE rnr = 4;
-- Datensatz wurde geloescht
SELECT * FROM bestellung WHERE rnr = 4;
-- Neuer Datensatz in der Stornotabelle
SELECT * FROM bestellstorno;
```

## AU10 - d)
---
__Lösungsvorgang:__  


__Funktion:__
```sql
```

__Trigger:__ 
```SQL
```

__Testen:__
```sql
```