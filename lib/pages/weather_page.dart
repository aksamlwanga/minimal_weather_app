

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:minimal_weather_app/models/weather_model.dart';
import 'package:minimal_weather_app/services/weather_service.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  // api key 

  final _weatherService = WeatherService(apiKey: '8b670a1b3fc0cd4800dc182122bd9ee8');
  
  Weather? _weather;
  // fetch the weather data

   bool _isLoading = true;

  _fetchWeather() async {
    // get the current city
    String cityName = await _weatherService.getCurrentCity();

    // get the weather data for the current city
    try {
      Weather weather = await _weatherService.getWeather(cityName);
      setState(() {
        _weather = weather;
        _isLoading = false; // set isLoading to false when data is loaded
      });
    } catch (e) {
      // any error handling
      print(e);
      setState(() {
        _isLoading = false; // set isLoading to false when error occurs
      });
    }
  }



   
  // weather animation 


  String getWeatherAnimation(String? mainCondition) {
    if (mainCondition == null) {
      return 'assets/sunny.json';
    }
    switch (mainCondition) {
     // use the one for open weather map
      case 'clouds':
        return 'assets/cloudy.json';
      case 'mist':
        return 'assets/cloudy.json';
      case 'rain':
        return 'assets/rainy.json';
      case 'snow':
        return 'assets/sunny.json';
      case 'clear':
        return 'assets/sunny.json';
      case 'thunderstorm':
        return 'assets/thunder.json';
      case 'drizzle':
        return 'assets/cloudy.json';
      case 'fog':
        return 'assets/rainy.json';
      default:
        return 'assets/sunny.json';
    }
  }

  // init state
   
  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Minimal Weather App',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blue,
        elevation: 0,
      ),
      backgroundColor: Colors.grey[400],
      body: Center(
        child: _isLoading // show loading indicator while data is being fetched
            ? CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // city name
                  Text(
                    _weather?.cityName ?? 'Loading city...',
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  // animation
                  Lottie.asset(
                    getWeatherAnimation(_weather?.mainCondition),
                    height: 200,
                  ),

                  // temperature
                  Text(
                    '${_weather?.temperature.round() ?? 0}°C',
                    style: const TextStyle(
                      fontSize: 30,
                    ),
                  ),

                  // weather condition
                  Text(
                    _weather?.mainCondition ?? 'Loading weather...',
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}