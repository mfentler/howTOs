# AU02 - AU03
Autor: Mario Fentler  
Datum: 07.11.2018

## Aufgabe AU02
_Erstelle eine Funktion mit zwei Parametern: Speisen die billiger als der Durchschnittspreis aller Speisen sind, sollen um einen fixen Betrag erhöht werden. Speisen die teurer als der Durchschnittspreis sind, sollen um einen Prozentwert erhöht werden (AU02a). Achte darauf, dass sich die beiden Erhöhungen nicht gegenseitig beeinflussen (AU02b)!_  

Dazu werden zwei Funktionen erstellt. Die erste hat zwei Parameter. Diese wird vom User angesprochen.  
In dieser Funktion wird eine Helferfunktion aufgerufen, die dann die Updates durchführt.

    CREATE OR REPLACE FUNCTION preisErhoehungHelper(NUMERIC,INTEGER,INTEGER) RETURNS VOID AS $$
        UPDATE speise SET preis = preis + $2 WHERE preis <= $1;
        UPDATE speise SET preis = preis + preis * $3 / 100 WHERE preis > $1; $$ LANGUAGE SQL;

    CREATE OR REPLACE FUNCTION preisErhoehung(INTEGER,INTEGER) RETURNS VOID AS $$
        SELECT * FROM preisErhoehungHelper((SELECT avg(preis) FROM speise),$1,$2);$$ LANGUAGE SQL;
### Überprüfen
Überprüft werden kann das ganze mit selects.  

    SELECT * FROM speise;
    -- preisErhoehung2(preisErhoehung für preise < durchschnitt, für preise > durchschnitt)
    SELECT * FROM preisErhoehung(1,5);

    SELECT * FROM speise;

## Aufgabe AU03
_Der Tagesumsatz für einen bestimmten Kellner soll für den aktuellen Tag ermittelt werden. Verwende die Kellner-Nr als Parameter, den aktuellen Tag via CURRENT_DATE (AU03)._

    -- umsatz(kellnerNr)
    CREATE OR REPLACE FUNCTION umsatz(INTEGER) RETURNS NUMERIC AS $$
        SELECT SUM(speise.preis)
        FROM speise,rechnung,bestellung
        WHERE speise.snr = bestellung.snr
        AND rechnung.rnr = bestellung.rnr
        AND rechnung.status = 'bezahlt'
        AND rechnung.knr = $1
        AND rechnung.datum = CURRENT_DATE;
    $$ LANGUAGE SQL;

### Überprüfen
Um das zu überprüfen muss die Tabelle Rechnung noch überarbeitet werden, da dort die Rechnungen alle auf ein fixes Datum gesetzt wurden. Dazu wird dort einfach ein Datum auf CURRENT_DATE gesetzt und dann beim selecten nach dem dazugehörigen Kellner selected.

    -- dazu wurde bei den rechnungen das Datum noch auf das current Date gesetzt.
    SELECT * FROM umsatz(1);