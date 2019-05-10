package example1;

public class AngularObjectFactory extends AbstractFactory {
    @Override
    Shape generateObject(String type) {
        if(type.toLowerCase().equals("cube")){
            return new Cube();
        }else if(type.toLowerCase().equals("rectangle")){
            return new Rectangle();
        }else{
            return null;
        }
    }
}
