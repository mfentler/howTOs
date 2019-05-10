package sensor_example;

public class Demo {
    public static void main(String[] args){
        WeatherData weatherdata = new WeatherData();

        //Create displays
        new TemperatureDisplay(weatherdata);
        new TemperatureDisplay_USA(weatherdata);

        //change temperature
        weatherdata.setTemperatute(31.0);
    }
}
