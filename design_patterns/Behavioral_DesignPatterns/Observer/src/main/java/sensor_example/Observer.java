package sensor_example;

public abstract class Observer {
    protected Subject subject;
    public abstract void update(double temperature,double humidity);
}
