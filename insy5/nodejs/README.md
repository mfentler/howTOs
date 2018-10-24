# NODE.js Mitschrift
- Traditionell:  
 wird der Server über Threads kontaktiert. Das ist für REST Webseiten, bei denen durchgehend irgendwelche kleine Abfragen gemacht werden tötlich, da für jede Abfrage immer der Thread blockiert wird.
 - Node.js:  
 Es gibt nur einen Thread. In diesem Thread ist eine kleine Queue drinnen, die nacheinander abgearbeitet wird. Alle Anfragen gelangen zu dem Thread.  
 Dieser Thread arbeitet __parallel__ die Tasks ab.  
 __Vorteile__: wenig RAM nötig, nur ein Thread

 Aktueller JavaScript Standard: es6