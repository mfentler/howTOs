package example1;

public class RoundObjectFactory extends AbstractFactory {
    @Override
    Shape generateObject(String type) {
        if(type.toLowerCase().equals("circle")){
            return new Circle();
        }else{
            return null;
        }
    }
}
