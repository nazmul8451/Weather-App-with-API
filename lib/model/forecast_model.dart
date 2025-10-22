class ForeCastModel {
  Location? location;
  Current? current;
  Forecast? forecast;

  ForeCastModel({this.location, this.current, this.forecast});

  ForeCastModel.fromJson(Map<String, dynamic> json) {
    location = json['location'] != null
        ? Location.fromJson(json['location'])
        : null;
    current =
    json['current'] != null ? Current.fromJson(json['current']) : null;
    forecast = json['forecast'] != null
        ? Forecast.fromJson(json['forecast'])
        : null;
  }

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = {};
  //   if (location != null) data['location'] = location!.toJson();
  //   if (current != null) data['current'] = current!.toJson();
  //   if (forecast != null) data['forecast'] = forecast!.toJson();
  //   return data;
  // }
}

class Location {
  String? name;
  String? region;
  String? country;
  double? lat;
  double? lon;
  String? tzId;
  int? localtimeEpoch;
  String? localtime;

  Location(
      {this.name,
        this.region,
        this.country,
        this.lat,
        this.lon,
        this.tzId,
        this.localtimeEpoch,
        this.localtime});

  Location.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    region = json['region'];
    country = json['country'];
    lat = (json['lat'] as num?)?.toDouble();
    lon = (json['lon'] as num?)?.toDouble();
    tzId = json['tz_id'];
    localtimeEpoch = json['localtime_epoch'];
    localtime = json['localtime'];
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'region': region,
    'country': country,
    'lat': lat,
    'lon': lon,
    'tz_id': tzId,
    'localtime_epoch': localtimeEpoch,
    'localtime': localtime,
  };
}

class Current {
  int? lastUpdatedEpoch;
  String? lastUpdated;
  double? tempC;
  double? tempF;
  int? isDay;
  Condition? condition;
  double? windMph;
  double? windKph;
  int? windDegree;
  String? windDir;
  double? pressureMb;
  double? pressureIn;
  double? precipMm;
  double? precipIn;
  int? humidity;
  int? cloud;
  double? feelslikeC;
  double? feelslikeF;
  double? windchillC;
  double? windchillF;
  double? heatindexC;
  double? heatindexF;
  double? dewpointC;
  double? dewpointF;
  double? visKm;
  double? visMiles;
  double? uv;
  double? gustMph;
  double? gustKph;

  Current.fromJson(Map<String, dynamic> json) {
    lastUpdatedEpoch = json['last_updated_epoch'];
    lastUpdated = json['last_updated'];
    tempC = (json['temp_c'] as num?)?.toDouble();
    tempF = (json['temp_f'] as num?)?.toDouble();
    isDay = json['is_day'];
    condition =
    json['condition'] != null ? Condition.fromJson(json['condition']) : null;
    windMph = (json['wind_mph'] as num?)?.toDouble();
    windKph = (json['wind_kph'] as num?)?.toDouble();
    windDegree = json['wind_degree'];
    windDir = json['wind_dir'];
    pressureMb = (json['pressure_mb'] as num?)?.toDouble();
    pressureIn = (json['pressure_in'] as num?)?.toDouble();
    precipMm = (json['precip_mm'] as num?)?.toDouble();
    precipIn = (json['precip_in'] as num?)?.toDouble();
    humidity = json['humidity'];
    cloud = json['cloud'];
    feelslikeC = (json['feelslike_c'] as num?)?.toDouble();
    feelslikeF = (json['feelslike_f'] as num?)?.toDouble();
    windchillC = (json['windchill_c'] as num?)?.toDouble();
    windchillF = (json['windchill_f'] as num?)?.toDouble();
    heatindexC = (json['heatindex_c'] as num?)?.toDouble();
    heatindexF = (json['heatindex_f'] as num?)?.toDouble();
    dewpointC = (json['dewpoint_c'] as num?)?.toDouble();
    dewpointF = (json['dewpoint_f'] as num?)?.toDouble();
    visKm = (json['vis_km'] as num?)?.toDouble();
    visMiles = (json['vis_miles'] as num?)?.toDouble();
    uv = (json['uv'] as num?)?.toDouble();
    gustMph = (json['gust_mph'] as num?)?.toDouble();
    gustKph = (json['gust_kph'] as num?)?.toDouble();
  }
}

class Condition {
  String? text;
  String? icon;
  int? code;

  Condition({this.text, this.icon, this.code});

  Condition.fromJson(Map<String, dynamic> json) {
    text = json['text'];
    icon = json['icon'];
    code = json['code'];
  }
}

class Forecast {
  List<Forecastday>? forecastday;

  Forecast.fromJson(Map<String, dynamic> json) {
    if (json['forecastday'] != null) {
      forecastday = <Forecastday>[];
      json['forecastday'].forEach((v) {
        forecastday!.add(Forecastday.fromJson(v));
      });
    }
  }
}

class Forecastday {
  String? date;
  int? dateEpoch;
  Day? day;
  Astro? astro;
  List<Hour>? hour;

  Forecastday.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    dateEpoch = json['date_epoch'];
    day = json['day'] != null ? Day.fromJson(json['day']) : null;
    astro = json['astro'] != null ? Astro.fromJson(json['astro']) : null;
    if (json['hour'] != null) {
      hour = <Hour>[];
      json['hour'].forEach((v) {
        hour!.add(Hour.fromJson(v));
      });
    }
  }
}

class Day {
  double? maxtempC;
  double? maxtempF;
  double? mintempC;
  double? mintempF;
  double? avgtempC;
  double? avgtempF;
  double? maxwindMph;
  double? maxwindKph;
  double? totalprecipMm;
  double? totalprecipIn;
  double? totalsnowCm;
  double? avgvisKm;
  double? avgvisMiles;
  int? avghumidity;
  int? dailyWillItRain;
  int? dailyChanceOfRain;
  int? dailyWillItSnow;
  int? dailyChanceOfSnow;
  Condition? condition;
  double? uv;

  Day.fromJson(Map<String, dynamic> json) {
    maxtempC = (json['maxtemp_c'] as num?)?.toDouble();
    maxtempF = (json['maxtemp_f'] as num?)?.toDouble();
    mintempC = (json['mintemp_c'] as num?)?.toDouble();
    mintempF = (json['mintemp_f'] as num?)?.toDouble();
    avgtempC = (json['avgtemp_c'] as num?)?.toDouble();
    avgtempF = (json['avgtemp_f'] as num?)?.toDouble();
    maxwindMph = (json['maxwind_mph'] as num?)?.toDouble();
    maxwindKph = (json['maxwind_kph'] as num?)?.toDouble();
    totalprecipMm = (json['totalprecip_mm'] as num?)?.toDouble();
    totalprecipIn = (json['totalprecip_in'] as num?)?.toDouble();
    totalsnowCm = (json['totalsnow_cm'] as num?)?.toDouble();
    avgvisKm = (json['avgvis_km'] as num?)?.toDouble();
    avgvisMiles = (json['avgvis_miles'] as num?)?.toDouble();
    avghumidity = json['avghumidity'];
    dailyWillItRain = json['daily_will_it_rain'];
    dailyChanceOfRain = json['daily_chance_of_rain'];
    dailyWillItSnow = json['daily_will_it_snow'];
    dailyChanceOfSnow = json['daily_chance_of_snow'];
    condition =
    json['condition'] != null ? Condition.fromJson(json['condition']) : null;
    uv = (json['uv'] as num?)?.toDouble();
  }
}

class Astro {
  String? sunrise;
  String? sunset;
  String? moonrise;
  String? moonset;
  String? moonPhase;
  int? moonIllumination;
  int? isMoonUp;
  int? isSunUp;

  Astro.fromJson(Map<String, dynamic> json) {
    sunrise = json['sunrise'];
    sunset = json['sunset'];
    moonrise = json['moonrise'];
    moonset = json['moonset'];
    moonPhase = json['moon_phase'];
    moonIllumination = json['moon_illumination'];
    isMoonUp = json['is_moon_up'];
    isSunUp = json['is_sun_up'];
  }
}

class Hour {
  int? timeEpoch;
  String? time;
  double? tempC;
  double? tempF;
  int? isDay;
  Condition? condition;
  double? windMph;
  double? windKph;
  int? windDegree;
  String? windDir;
  double? pressureMb;
  double? pressureIn;
  double? precipMm;
  double? precipIn;
  double? snowCm;
  int? humidity;
  int? cloud;
  double? feelslikeC;
  double? feelslikeF;
  double? windchillC;
  double? windchillF;
  double? heatindexC;
  double? heatindexF;
  double? dewpointC;
  double? dewpointF;
  int? willItRain;
  int? chanceOfRain;
  int? willItSnow;
  int? chanceOfSnow;
  double? visKm;
  double? visMiles;
  double? gustMph;
  double? gustKph;
  double? uv;

  Hour.fromJson(Map<String, dynamic> json) {
    timeEpoch = json['time_epoch'];
    time = json['time'];
    tempC = (json['temp_c'] as num?)?.toDouble();
    tempF = (json['temp_f'] as num?)?.toDouble();
    isDay = json['is_day'];
    condition =
    json['condition'] != null ? Condition.fromJson(json['condition']) : null;
    windMph = (json['wind_mph'] as num?)?.toDouble();
    windKph = (json['wind_kph'] as num?)?.toDouble();
    windDegree = json['wind_degree'];
    windDir = json['wind_dir'];
    pressureMb = (json['pressure_mb'] as num?)?.toDouble();
    pressureIn = (json['pressure_in'] as num?)?.toDouble();
    precipMm = (json['precip_mm'] as num?)?.toDouble();
    precipIn = (json['precip_in'] as num?)?.toDouble();
    snowCm = (json['snow_cm'] as num?)?.toDouble();
    humidity = json['humidity'];
    cloud = json['cloud'];
    feelslikeC = (json['feelslike_c'] as num?)?.toDouble();
    feelslikeF = (json['feelslike_f'] as num?)?.toDouble();
    windchillC = (json['windchill_c'] as num?)?.toDouble();
    windchillF = (json['windchill_f'] as num?)?.toDouble();
    heatindexC = (json['heatindex_c'] as num?)?.toDouble();
    heatindexF = (json['heatindex_f'] as num?)?.toDouble();
    dewpointC = (json['dewpoint_c'] as num?)?.toDouble();
    dewpointF = (json['dewpoint_f'] as num?)?.toDouble();
    willItRain = json['will_it_rain'];
    chanceOfRain = json['chance_of_rain'];
    willItSnow = json['will_it_snow'];
    chanceOfSnow = json['chance_of_snow'];
    visKm = (json['vis_km'] as num?)?.toDouble();
    visMiles = (json['vis_miles'] as num?)?.toDouble();
    gustMph = (json['gust_mph'] as num?)?.toDouble();
    gustKph = (json['gust_kph'] as num?)?.toDouble();
    uv = (json['uv'] as num?)?.toDouble();
  }
}
