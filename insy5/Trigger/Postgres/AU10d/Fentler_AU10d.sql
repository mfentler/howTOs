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
INSERT INTO rechnung VALUES (5, CURRENT_DATE, 1, 'bezahlt', 1);
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


-- Aufgabe AU10d
-- Autor: Mario Fentler
DROP TABLE IF EXISTS statistik;
CREATE TABLE statistik(
    datum DATE PRIMARY KEY,
    anzahl INTEGER
);

CREATE OR REPLACE FUNCTION updateStatistik() RETURNS TRIGGER AS $$
    BEGIN
        IF EXISTS(SELECT * FROM statistik WHERE datum=CURRENT_DATE) THEN
            UPDATE statistik
            SET anzahl=(SELECT count(*) FROM speise);
        ELSE
            INSERT INTO statistik (datum,anzahl)
            SELECT
                CURRENT_DATE,count(*)
            FROM speise;
        END IF;
        RETURN OLD;
    END;
$$ LANGUAGE PLPGSQL;

DROP TRIGGER IF EXISTS trigger_d_1 ON speise;
CREATE TRIGGER trigger_d_1
    AFTER INSERT
    ON speise
    FOR EACH ROW
    EXECUTE PROCEDURE updateStatistik();

DROP TRIGGER IF EXISTS trigger_d_2 ON speise;
CREATE TRIGGER trigger_d_2
    AFTER DELETE
    ON speise
    FOR EACH ROW
    EXECUTE PROCEDURE updateStatistik();

-- Testing
SELECT * FROM statistik;
INSERT INTO speise(snr,bezeichnung,preis) VALUES (9, 'Test menue', 14.5);
SELECT * FROM statistik;
INSERT INTO speise(snr,bezeichnung,preis) VALUES (10, 'Pizza', 3.99);
SELECT * FROM statistik;

-- Now deleting one speise
DELETE FROM speise WHERE snr = 10;
SELECT * FROM statistik;
