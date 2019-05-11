package kaffeehaus;

public abstract class Coffee {
    protected String description;

    public String getDescription(){
        return description;
    }
    public abstract double cost();
}
