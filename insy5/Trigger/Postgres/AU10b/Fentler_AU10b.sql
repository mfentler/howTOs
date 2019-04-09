-- Resetting DB now ...

\c template1
DROP DATABASE restaurant;
CREATE DATABASE restaurant;
\c restaurant

DROP TABLE IF EXISTS kellner CASCADE;
CREATE TABLE kellner (
             knr         INTEGER,
             name        VARCHAR(255),
             PRIMARY KEY (knr)
             );

INSERT INTO kellner VALUES (1, 'Kellner1');
INSERT INTO kellner VALUES (2, 'Kellner2');
INSERT INTO kellner VALUES (3, 'Kellner3');

DROP TABLE IF EXISTS speise CASCADE;
CREATE TABLE speise (
             snr         INTEGER,
             bezeichnung VARCHAR(255),
             preis       DECIMAL(6,2),
             PRIMARY KEY (snr)
             );

INSERT INTO speise VALUES (1, 'Heisse Liebe',         3);
INSERT INTO speise VALUES (2, 'Schoko Palatschinken', 4);
INSERT INTO speise VALUES (3, 'Pute gebacken',        7);
INSERT INTO speise VALUES (4, 'Pute natur',           8);
INSERT INTO speise VALUES (5, 'Puten-Cordon',         9);
INSERT INTO speise VALUES (6, 'Menue fuer 2',        15);
INSERT INTO speise VALUES (7, 'Menue fuer 3',        19);
INSERT INTO speise VALUES (8, 'Menue fuer 4',        22);

DROP TABLE IF EXISTS rechnung CASCADE;
CREATE TABLE rechnung (
             rnr         INTEGER,
             datum       DATE,
             tisch       SMALLINT,
             status      CHAR(8),
             knr         INTEGER,
             PRIMARY KEY (rnr),
             FOREIGN KEY (knr) REFERENCES kellner (knr)
                               ON UPDATE CASCADE ON DELETE CASCADE
             );

INSERT INTO rechnung VALUES (1, '2013-03-07', 1, 'bezahlt', 1);
INSERT INTO rechnung VALUES (2, '2013-03-07', 2, 'offen', 2);
INSERT INTO rechnung VALUES (3, '2013-03-07', 1, 'gedruckt', 3);
INSERT INTO rechnung VALUES (4, '2013-03-07', 1, 'gedruckt', 1);
INSERT INTO rechnung VALUES (5, '2013-03-07', 1, 'bezahlt', 1);
INSERT INTO rechnung VALUES (6, '2013-03-07', 2, 'offen', 2);

DROP TABLE IF EXISTS bestellung CASCADE;
CREATE TABLE bestellung (
             anzahl      SMALLINT,
             rnr         INTEGER,
             snr         INTEGER,
             PRIMARY KEY (rnr, snr),
             FOREIGN KEY (rnr) REFERENCES rechnung (rnr)
                               ON UPDATE CASCADE ON DELETE CASCADE,
             FOREIGN KEY (snr) REFERENCES speise (snr)
                               ON UPDATE CASCADE ON DELETE CASCADE
             );

INSERT INTO bestellung VALUES (9, 1, 1);
INSERT INTO bestellung VALUES (1, 1, 4);
INSERT INTO bestellung VALUES (1, 1, 5);
INSERT INTO bestellung VALUES (1, 2, 7);
INSERT INTO bestellung VALUES (1, 3, 8);
INSERT INTO bestellung VALUES (9, 4, 1);
INSERT INTO bestellung VALUES (9, 5, 1);
INSERT INTO bestellung VALUES (9, 6, 2);

-- Reset finished, ready for trigger tasks ..

-- Aufgabe AU09b
-- Autor: Mario Fentler
DROP TABLE IF EXISTS preisaenderung;
CREATE TABLE preisaenderung(
    datum DATE,
    snr INTEGER,
    bezeichnung VARCHAR(255),
    preisVorher DECIMAL(6,2),
    preisNachher DECIMAL(6,2),
    PRIMARY KEY(datum,snr)
);

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

DROP TRIGGER IF EXISTS trigger_b ON speise;
CREATE TRIGGER trigger_b
    AFTER UPDATE
    ON speise
    FOR EACH ROW
    EXECUTE PROCEDURE notePriceChange();

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
