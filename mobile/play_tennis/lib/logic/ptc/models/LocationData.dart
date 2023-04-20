import 'package:play_tennis/logic/ptc/models/PlayerLocationData.dart';
import 'package:play_tennis/logic/ptc/models/cities/CityModel.dart';

class LocationData {
  late CountryNameModel? country;
  late CityModel? city;

  LocationData({
    required this.country,
    required this.city,
  });
}

class LocationDataMappingExtensions {
  static LocationData toLocationData(PlayerLocationData data) {
    return LocationData(
      country: data.country,
      city: data.city,
    );
  }
}
