public class SimpleFactory {
    public Shape getObject(String type){
        if(type.toLowerCase().equals("cube")){
            return new Cube();
        }else if(type.toLowerCase().equals("rectangle")){
            return new Rectangle();
        }else{
            return null;
        }
    }
}
