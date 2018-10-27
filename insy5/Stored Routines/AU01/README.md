Mario Fentler 5CHIT  
27.10.2018
# Dokumentation AU01
## Aufgabenstellung
Die Mitschrift bzw. das DDL-Script für "Restaurant" soll um die beiden Funktionen

- preis99() - Schreibt die Nachkommastelle auf 99 um   
auf drei verschiedene Arten !

- loescheRechnung()

wie in der Vortragsunterlage ergänzt werden.

Inkl. INSERT bzw. Aufruf vorher/nachner...

## Aufgabendurchführung
Um die Aufgabe zu lösen wird eine Debian VM mit einer Postgres Datenbank verwendet.  
Die Datenbank wird durch das SQL-File aus dem E-Learning Kurs erstellt. Um sicherzustellen, dass die Funktionen auch korrekt funktionieren, wird die Tabelle Speise für jeden Task neu erstellt.

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

### Erstelle Funktionen ausführen
Um die Funktionen, die man erstellt hat, auszuführen schreibt man:

    SELECT * FROM <Funktionsname>();

### Task 1 - Preis
Dazu gibt es 3 verschiedene Arten die Aufgabenstellung umzusetzen.
- Preis aufrunden, - 1 Cent
- Preis abrunden, + 99 Cent
- Nachkommastelle vom Preis abschneiden, + 0.99

#### Variante 1
Der Preis wird aufgerundet und danach wird 1 Cent abgezogen.

    CREATE FUNCTION preis_var1() RETURNS VOID AS '
    UPDATE speise SET preis = ceil(preis) - 0.01; ' LANGUAGE SQL;
Davor/danach:  
![preis Variante 1](images/preisVar1.png)

#### Variante 2
Der Preis wird abgerundet und dann werden 99 Cent dazu addiert.

    CREATE FUNCTION preis_var2() RETURNS VOID AS '
    UPDATE speise SET preis = floor(preis) + 0.99; ' LANGUAGE SQL;
Davor/danach:  
![preis Variante 2](images/preisVar2.png)

#### Variante 3
Die Nachkommastellen werden abgeschnitten und anschließend werden 99 Cent dazu addiert.

    CREATE FUNCTION preis_var3() RETURNS VOID AS '
    UPDATE speise SET preis = trunc(preis) + 0.99; ' LANGUAGE SQL;
Davor/danach:  
![preis Variante 3](images/preisVar3.png)

### Task 2 - Rechnung loeschen
Der Task laut Angabe ist es die Rechnungen zu löschen, zu denen es keine Bestellung gibt.  
-> Ich schließe daraus, dass die Rechnungen gelöscht werden sollen, die schon bezahlt wurden.

Um diesen Task zu lösen muss die __Syntax__ für die Erstellung einer Funktion __geändert__ werden. Denn so, wie sie bis jetzt erstellt wurde kann man in der Funktion __keinen String__ angeben. Man muss allerdings nach dem String 'bezahlt' suchen.  
-> Neue Syntax "__$$ ... $$__"

    CREATE FUNCTION loeschePreis() RETURNS VOID AS $$
    DELETE FROM rechnung WHERE status='bezahlt'; $$
    LANGUAGE SQL;
Davor/danach:  
![Loesche Preis](images/loeschePreis.png)

## Quellen
[1] https://www.postgresql.org/docs/9.1/static/functions-math.html  
[2] http://www.postgresqltutorial.com/postgresql-delete/  