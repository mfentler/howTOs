# Continous Integration mit Travis-CI

Hier wurde ein Gradle Projekt erstellt, auf GitHub gepusht, mit Travis-CI verbunden und getestet.

## Arbeitsschritte

	gradle init --type java-application
	gradle run //Die Applikation ausführen
	gradle test //Die Tests lokal ausführen
	
	GitHub Repo clonen
Als nächstes werden noch zwei eigene Unit Tests geschrieben. Diese kommen in das File "src/test/java/AppTest":

	@Test public void TestWillPassNow(){
        	assertNull(null);
	}
	@Test public void TestWillBeOk(){
		assertNotNull("Hallo");
    	}
## Travis Konfig
Auf der Webseite von Travis muss man zuerst das Github Repository mit Travis verbinden. Dort kann man auch auswählen auf welche Repos die Webseite dann Zugriff hat. Ich würde hier empfehlen nur das Repo, dass man gerade benötigt auszuwählen und nicht gleich alle.  
Als nächstes wird ein ".travis.yml" File erstellt mit folgendem Inhalt:

	language: java
Damit wird Travis übergeben um welche Sprache es sich bei diesem Projekt handelt. Dieses File wird nun auf GitHub gepusht.  

### Travis Build triggern
Travis wird durch einen Git Push getriggert. Danach führt es die Tests aus und schickt einem eine Email-Notification, die den Status des Tests enthält. Somit muss man während des Tests nicht einmal anwesend sein.

## Quellen
[1] https://guides.gradle.org/building-java-applications/  
[2] https://docs.travis-ci.com/user/getting-started
