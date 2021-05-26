import 'package:geolocator/geolocator.dart';

class UserLocationService{
  String strlocation;
  getLocation() async{
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    strlocation = '${position.latitude} : ${position.longitude}';
  }
}