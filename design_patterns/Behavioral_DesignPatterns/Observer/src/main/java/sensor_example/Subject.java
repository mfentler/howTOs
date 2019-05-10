package sensor_example;

import java.util.ArrayList;

public interface Subject {
    public void attach(Observer o);
    public void detach(Observer o);
    public void notifyObservers();
}
