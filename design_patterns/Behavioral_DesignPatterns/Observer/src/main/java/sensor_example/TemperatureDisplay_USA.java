package sensor_example;

public class TemperatureDisplay_USA extends Observer {

    public TemperatureDisplay_USA(Subject s){
        this.subject = s;
        this.subject.attach(this);
    }

    @Override
    public void update(double temperature, double humidity) {
        double usa_temp = (temperature * (9/5)) + 32;
        System.out.println("Current temperature: "+usa_temp+" Fahrenheit\nHumidity: "+humidity*100+"%");
    }
}
