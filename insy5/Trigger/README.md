# Trigger
Mario Fentler 5CHIT  
20.02.2019  
```SQL
INSERT INTO warenkorb;
UPDATE artikel SET anzvorhanden = anzvorhanden - anzgewünscht;
```

```SQL
DELETE FROM warenkorb;
UPDATE artikel SET anzvorhanden = anzvorhanden + anzgewünscht;
```

```SQL
UPDATE warenkorb SET anzgewüsncht = anzgewünscht NEU;
UPDATE artikel SET anzvorhanden = anzvorhanden + anzgewünscht NEU - anzgewünscht ALT;
```

Diese 3 Dinge können mit 3 Triggern automatisiert werden.

## Trigger Definition
__MySQL__
```SQL
DROP TRIGGER IF EXISTS <trigger_name>;

CREATE TRIGGER <trigger name>
    BEFORE | AFTER
    INSERT | DELETE | UPDATE
    ON <tab_name>
    FOR EACH ROW | STATEMENT

    BEGIN
        <trigger_verarbeitung>
    END;
```

### Trigger Definition für das obere Beispiel:
```SQL
DELIMITER //

CREATE TRIGGER t1
    AFTER INSERT
    ON warenkorb
    FOR EACH ROW
BEGIN
    UPDATE artikel SET anzvorhanden = anzvorhanden - anzgewünscht;
END; //

DELIMITER ;
```

![Trigger](trigger.jpg)