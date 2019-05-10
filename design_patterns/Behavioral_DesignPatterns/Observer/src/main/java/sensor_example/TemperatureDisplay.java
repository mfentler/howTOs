package sensor_example;

public class TemperatureDisplay extends Observer {

    public TemperatureDisplay(Subject s){
        this.subject = s;
        s.attach(this);
    }

    @Override
    public void update(double temperature, double humidity) {
        System.out.println("Current temperature: "+temperature+" Celsius\nCurrent Humidity: "+humidity*100+"%");
    }
}
