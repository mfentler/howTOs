package example1;

public class FactoryProducer {
    public static AbstractFactory generateFactory(boolean round){
        if(!round){
            return new AngularObjectFactory();
        }else{
            return new RoundObjectFactory();
        }
    }
}
