package basic_example;

import java.util.ArrayList;

public class Subject {
    private ArrayList<Observer> observers = new ArrayList<Observer>();
    private int state = 12;

    public void attach(Observer o){
        this.observers.add(o);
        notifyObservers();
    }

    public void detach(Observer o){
        this.observers.remove(o);
    }

    public int getState(){
        return this.state;
    }

    public void setState(int state){
        this.state = state;
        notifyObservers();
    }

    public void notifyObservers(){
        for(Observer o: observers){
            o.update();
        }
    }
}
