// weather service class api call
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:minimal_weather_app/models/weather_model.dart';
   
class WeatherService {
  static const BASE_URL = 'https://api.openweathermap.org/data/2.5/weather';
  final String apiKey;

  WeatherService({required this.apiKey});

  Future<Weather> getWeather(String cityName) async {
    final url = '$BASE_URL?q=$cityName&appid=$apiKey&units=metric';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return Weather.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load weather data');
    }
  } 

  Future<String> getCurrentCity() async {
    
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        await Geolocator.requestPermission();

      } 
      // fetch the current location 
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      // convert the current location to a list of placement objects 
      List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
       
      // extract the city name from the first placement object
      String? city = placemarks[0].locality;

      return city?? "";    


  }


}     