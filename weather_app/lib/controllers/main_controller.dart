import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:weather_app/services/api_services.dart';

class MainController extends GetxController{

  @override
  void onInit() async {
    await getUserLocation();
    currentWeatherData = getCurrentWeather(latitude.value, longitude.value);
    hourlyWeatherData = getHourlyWeather(latitude.value, longitude.value);
    super.onInit();
  }

  var isDark = false.obs;
  var currentWeatherData;
  var hourlyWeatherData;
  var latitude = 0.0.obs;
  var longitude = 0.0.obs;

  var isLoaded = false.obs;

  changeTheme(){
    isDark.value = !isDark.value;
    Get.changeThemeMode(isDark.value ? ThemeMode.dark: ThemeMode.light);
  }

  getUserLocation() async {
    var isLocationEnabled;
    var userPermissions;

    isLocationEnabled = await Geolocator.isLocationServiceEnabled();
    if(!isLocationEnabled){
      return Future.error('Location is not enabled');
    }
    userPermissions = await Geolocator.checkPermission();

    if(userPermissions == LocationPermission.deniedForever){
      return Future.error('Permission is denied forever');
    }
    else if(userPermissions == LocationPermission.denied){
      userPermissions = await Geolocator.requestPermission();
      if(userPermissions == LocationPermission.denied){
        return Future.error('Permission is denied');
      }
    }
    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high).then((value) {
      latitude.value = value.latitude;
      longitude.value = value.longitude;
      isLoaded.value = true;
    });
  }
}