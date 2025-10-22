import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:untitled1/model/forecast_model.dart';
import 'package:untitled1/model/weather_data_model.dart';

class NetworkCaller extends ChangeNotifier {
  ForeCastModel? weatherData;
  //fetch weatheData
  Future<ForeCastModel> fetchWeatherData(double lat,double lng) async {

    String apiKey = "72e7e4f689134be0b3640336252309";
    try {
    final response = await get(
      Uri.parse(
        'http://api.weatherapi.com/v1/forecast.json?key=${apiKey}&q=$lat,$lng',
      ),
      //http://api.weatherapi.com/v1/forecast.json ?key=72e7e4f689134be0b3640336252309&q=Dhaka
    );
    print('status code: ${response.statusCode}');
      if (response.statusCode == 200) {
        final decodedData = jsonDecode(response.body);
        final weatherData = ForeCastModel.fromJson(decodedData);
        notifyListeners();
        // print(weatherData.current.tempF);
        // print(weatherData.location.lon);
        return weatherData;
      }
      else {
        notifyListeners();
        throw Exception('Failed to load weather data ');
      }
    }catch(e){
      print(e.toString());
      notifyListeners();
      throw e;
    }
  }
//fethc forecast data
}