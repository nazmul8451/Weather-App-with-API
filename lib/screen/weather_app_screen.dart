import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';
import 'package:untitled1/model/forecast_model.dart';
import 'package:untitled1/model/weather_data_model.dart';
import 'package:untitled1/screen/full_report_screen.dart';
import 'package:untitled1/services/Api_service.dart';
import 'package:geocoding/geocoding.dart';

class WeatherApp extends StatefulWidget {
  const WeatherApp({super.key});

  @override
  State<WeatherApp> createState() => _WeatherAppState();
}

class _WeatherAppState extends State<WeatherApp> {
  ForeCastModel? _weatherData;
  NetworkCaller networkCaller = NetworkCaller();

  double? lat;
  double? lng;
  String? placeName; // ✅ Added this line for readable address

  @override
  void initState() {
    super.initState();
    getLocationAndLoadWeather();
  }

  /// Step 1: Get user location
  Future<void> getLocationAndLoadWeather() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if service is enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Location service is disabled!")),
      );
      return;
    }

    // Check & request permission
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Location permission denied!")),
        );
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Location permission permanently denied!"),
        ),
      );
      return;
    }

    // ✅ Get current position
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    lat = position.latitude;
    lng = position.longitude;

    print("User location: Lat=$lat, Lng=$lng");


    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat!, lng!);
      Placemark place = placemarks.first;
      setState(() {
        placeName = "${place.locality}, ${place.country}";
      });
      print("User location name: $placeName");
    } catch (e) {
      print("Geocoding error: $e");
    }
    //fetch weather using provider;
    await loadWeather();
  }

  /// Step 2: Fetch weather data
  Future<void> loadWeather() async {
    if (lat == null || lng == null) return;
    try {
      final data = await networkCaller.fetchWeatherData(lat!, lng!);
      setState(() {
        _weatherData = data;
      });
    } catch (e) {
      print('Error loading weather: $e');
    }
  }

  /// Step 3: Format date for UI
  String formatData(String dateString) {
    try {
      final dateTime = DateFormat("yyyy-MM-dd HH:mm").parse(dateString);
      return DateFormat('EEE d MMM').format(dateTime);
    } catch (e) {
      print("Date parse error: $e");
      return dateString;
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.menu),
          color: Colors.white,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.light_mode_outlined, color: Colors.white),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 15.0),
            child: Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(100),
              ),
              child: IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.nights_stay_outlined,
                  color: Colors.white70,
                ),
              ),
            ),
          ),
        ],
      ),
      body: _weatherData == null
          ? const Center(
              child: Text(
                'Fetching your location & weather...',
                style: TextStyle(fontSize: 18, color: Colors.white70),
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: SafeArea(child: Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              placeName ?? _weatherData!.location!.name.toString(),
                              style: TextStyle(
                                fontSize: height * 0.04,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: height * 0.01),
                            Text(
                              "Today, ${formatData(_weatherData!.location!.localtime.toString())}",
                              style: TextStyle(
                                fontSize: height * 0.02,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey,
                              ),
                            ),
                            SizedBox(height: height * 0.01),
                            Image.network(
                              "https:${_weatherData!.current!.condition!.icon}",
                              width: 200,
                              height: 200,
                              fit: BoxFit.contain,
                            ),
                            ShaderMask(
                              shaderCallback: (bounds) => const LinearGradient(
                                colors: [Colors.white, Colors.white30],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ).createShader(bounds),
                              child: Text(
                                '${_weatherData!.current!.tempC}°',
                                style: TextStyle(
                                  fontSize: height * 0.08,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            SizedBox(height: height * 0.01),
                            Text(
                              _weatherData!.current!.condition!.text.toString(),
                              style: TextStyle(
                                fontSize: height * 0.035,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: height * 0.03),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                infoColumn(
                                  'Temp',
                                  '${_weatherData!.current!.tempF}°',
                                ),
                                infoColumn(
                                  'Wind',
                                  '${_weatherData!.current!.windKph} km/h',
                                ),
                                infoColumn(
                                  'Humidity',
                                  '${_weatherData!.current!.humidity}%',
                                ),
                              ],
                            ),

                            SizedBox(height: height * 0.03),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Today',
                                  style: TextStyle(
                                    fontSize: 25,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: (){
                                    Navigator.push(context,MaterialPageRoute(builder: (_)=>FullReportScreen()));
                                  },
                                  child: Text(
                                    'View Full Report',
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.blue,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: height * 0.03),
                            SizedBox(
                              height: height * 0.15,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: _weatherData!.forecast!.forecastday![0].hour!.length,
                                itemBuilder: (context, index) {
                                  final hourData = _weatherData!.forecast!.forecastday![0].hour![index];
                                  return Container(
                                    width: 100,
                                    margin: const EdgeInsets.symmetric(horizontal: 8),
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Colors.white12,
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          DateFormat('h a').format(DateTime.parse(hourData.time!)),
                                          style: const TextStyle(color: Colors.white70, fontSize: 14),
                                        ),
                                        SizedBox(height: height * 0.01),
                                        Image.network(
                                          "https:${hourData.condition!.icon}",
                                          width: height * 0.05,
                                          height: height * 0.05,
                                          fit: BoxFit.contain,
                                        ),
                                        SizedBox(height: height * 0.01),
                                        Text(
                                          "${hourData.tempC?.round() ?? '--'}°C",
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),

                          ],
                        ),
                      ),

                    ),
              )
            ),
    );
  }

  /// Small reusable widget for info rows
  Widget infoColumn(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 15,
            color: Colors.grey,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          value,
          style: const TextStyle(
            fontSize: 22,
            color: Colors.white,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
