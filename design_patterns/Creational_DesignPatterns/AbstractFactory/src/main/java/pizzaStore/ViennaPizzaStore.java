package pizzaStore;

public class ViennaPizzaStore extends PizzaStore {
    @Override
    public Pizza createPizza(String type) {
        if(type.equalsIgnoreCase("CHEESE")){
            return new ViennaCheesePizza();
        }else if(type.equalsIgnoreCase("SALAMI")){
            return new ViennaSalamiPizza();
        }else if(type.equalsIgnoreCase("HAM")){
            return new ViennaHamPizza();
        }else{
            return null;
        }
    }
}
