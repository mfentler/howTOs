package pizzaStore;

public class Client {
    public static void main(String[] args){
        PizzaStore store = PizzaStoreMaker.getPizzaStore("Vienna");
        store.createPizza("SALAMI").eat();
        store.createPizza("CHEESE").eat();

        store = PizzaStoreMaker.getPizzaStore("NY");
        store.createPizza("SALAMI").eat();
    }
}
