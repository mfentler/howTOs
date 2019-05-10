package pizzaStore;

public class PizzaStoreMaker {
    public static PizzaStore getPizzaStore(String location){
        if(location.equalsIgnoreCase("VIENNA")){
            return new ViennaPizzaStore();
        }else if(location.equalsIgnoreCase("NY")){
            return new NYPizzaStore();
        }else{
            return null;
        }
    }
}
