import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// Note: Replace with your actual paths
import 'package:untitled1/model/forecast_model.dart';

import '../services/Api_service.dart';

class FullReportScreen extends StatefulWidget {
  const FullReportScreen({super.key});

  @override
  State<FullReportScreen> createState() => _FullReportScreenState();
}

class _FullReportScreenState extends State<FullReportScreen> {
  final double _lat = 23.777176;
  final double _lng = 90.399452;

  @override
  void initState() {
    super.initState();
    // Trigger the data fetch immediately.
    // listen: false because we are only calling a method, not watching for rebuilds here.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<NetworkCaller>(context, listen: false).fetchWeatherData(_lat, _lng);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Consumer<NetworkCaller>(
          builder: (context, networkCaller, child) {

            final weatherData = networkCaller.weatherData;

            if (weatherData == null) {
              return Center(


                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Failed to load weather data.', style: TextStyle(color: Colors.white70)),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        // Retry fetching data
                        networkCaller.fetchWeatherData(_lat, _lng);
                      },
                      child: const Text('Try Again'),
                    ),
                  ],
                ),
              );
            }

            // --- 3. Data Available State ---
            return _buildWeatherUI(context, weatherData);
          },
        ),
      ),
    );
  }
}

// ---------------------------------------------
// The rest of the UI code (_buildWeatherUI and DailyForecastCard)
// remains the same as it correctly uses the ForeCastModel data.
// ---------------------------------------------

// --- UI Building Function ---
Widget _buildWeatherUI(BuildContext context, ForeCastModel weatherData) {
  final screenWidth = MediaQuery.of(context).size.width;
  return SingleChildScrollView(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        // --- Header/App Bar ---
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Icon(Icons.arrow_back_ios, color: Colors.white, size: 24),
              Icon(Icons.settings, color: Colors.white, size: 24),
            ],
          ),
        ),

        // --- Main Weather Info (Tomorrow) ---
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Placeholder for the 3D Image
              Container(
                width: screenWidth * 0.4,
                height: screenWidth * 0.4,
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 33, 40, 68),
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                child: Center(
                  // Use the actual icon image from API
                  child: Image.network(
                    'fsdf',
                    scale: 0.5,
                  ),
                ),
              ),

              const SizedBox(width: 24),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Text(
                      'Tomorrow',
                      style: TextStyle(fontSize: 18, color: Colors.white70),
                    ),
                    Text(
                      "fsd",
                      style: const TextStyle(fontSize: 16, color: Colors.white54),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "",
                          style: const TextStyle(
                            fontSize: 70,
                            fontWeight: FontWeight.w300,
                            color: Colors.white,
                            height: 0.9,
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(top: 8.0),
                          child: Text(
                            '°',
                            style: TextStyle(fontSize: 30, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 30),

        // --- Today's Details (Temp, Wind, Humidity) ---
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              _buildDetailColumn('Temp', '°', screenWidth),
              _buildDetailColumn('Wind', 'km/h', screenWidth),
              _buildDetailColumn('Humidity', '%', screenWidth),
            ],
          ),
        ),

        const Padding(
          padding: EdgeInsets.fromLTRB(16.0, 30.0, 16.0, 10.0),
          child: Text(
            'In 7 Days',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),

        // --- 7-Day Forecast List ---
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: weatherData.forecast!.forecastday!.length,
          itemBuilder: (context, index) {

            return DailyForecastCard(
              day: '',
              iconUrl: 'http:',
              condition: '',
              temp: '°',
              wind: 'km/h',
            );
          },
        ),
        const SizedBox(height: 20),
      ],
    ),
  );
}

// Helper to convert date string to day name
String _getDayOfWeek(String dateString) {
  try {
    final date = DateTime.parse(dateString);
    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[date.weekday - 1];
  } catch (e) {
    return '';
  }
}

// Helper widget for Temp/Wind/Humidity columns
Widget _buildDetailColumn(String label, String value, double screenWidth) {
  return SizedBox(
    width: screenWidth / 3.5,
    child: Column(
      children: <Widget>[
        Text(
          label,
          style: const TextStyle(fontSize: 16, color: Colors.white70),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ],
    ),
  );
}

// --- Daily Forecast Item Widget ---
class DailyForecastCard extends StatelessWidget {
  final String day;
  final String iconUrl;
  final String condition;
  final String temp;
  final String wind;

  const DailyForecastCard({
    super.key,
    required this.day,
    required this.iconUrl,
    required this.condition,
    required this.temp,
    required this.wind,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          // Day and Icon/Condition (Left side)
          Row(
            children: [
              SizedBox(
                width: 50,
                child: Text(
                  day,
                  style: const TextStyle(fontSize: 16, color: Colors.white70),
                ),
              ),
              const SizedBox(width: 15),
              // Use Image.network for the weather icon
              Image.network(iconUrl, width: 30, height: 30),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  condition,
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),

          // Temperature and Wind (Right side)
          Row(
            children: [
              SizedBox(
                width: 60,
                child: Text(
                  temp,
                  textAlign: TextAlign.right,
                  style: const TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 15),
              SizedBox(
                width: 70,
                child: Text(
                  wind,
                  textAlign: TextAlign.right,
                  style: const TextStyle(fontSize: 16, color: Colors.white70),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}