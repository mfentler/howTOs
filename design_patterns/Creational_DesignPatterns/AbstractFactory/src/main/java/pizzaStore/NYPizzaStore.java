package pizzaStore;

public class NYPizzaStore extends PizzaStore {
    @Override
    public Pizza createPizza(String type) {
        if(type.equalsIgnoreCase("CHEESE")){
            return new NYCheesePizza();
        }else if(type.equalsIgnoreCase("SALAMI")){
            return new NYSalamiPizza();
        }else if(type.equalsIgnoreCase("HAM")){
            return new NYHamPizza();
        }else {
            return null;
        }
    }
}
