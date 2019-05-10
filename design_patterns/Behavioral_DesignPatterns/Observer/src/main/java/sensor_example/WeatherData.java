package sensor_example;

import java.util.ArrayList;

public class WeatherData implements Subject {

    private ArrayList<Observer> observers = new ArrayList<Observer>();
    private double temperatute = 20.0;
    private double humidity = 0.30;

    public double getTemperatute() {
        return temperatute;
    }

    public void setTemperatute(double temperatute) {
        this.temperatute = temperatute;
        notifyObservers();
    }

    public double getHumidity() {
        return humidity;
    }

    public void setHumidity(double humidity) {
        this.humidity = humidity;
        notifyObservers();
    }

    @Override
    public void attach(Observer o){
        this.observers.add(o);
        notifyObservers();
    }
    @Override
    public void detach(Observer o){
        this.observers.remove(o);
    }
    @Override
    public void notifyObservers(){
        for(Observer o:this.observers){
            o.update(this.temperatute,this.humidity);
        }
    }
}
