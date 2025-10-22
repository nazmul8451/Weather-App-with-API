import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled1/screen/weather_app_screen.dart';
import 'package:device_preview/device_preview.dart';
import 'package:untitled1/services/Api_service.dart';


void main() {
  runApp(
    MultiProvider(providers: [
        ChangeNotifierProvider(create: (context) => NetworkCaller()),
    ],
    child: DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) => const MaterialApp(
        useInheritedMediaQuery: true,
        debugShowCheckedModeBanner: false,
        home:MyApp(),
      ),
    ),
    )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const WeatherApp(),
    );
  }
}
