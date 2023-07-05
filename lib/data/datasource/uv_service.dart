import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_weather_app/core/utils/constants/strings_manager.dart';
import 'package:flutter_weather_app/data/datasource/service.dart';
import 'package:flutter_weather_app/data/models/uv_index_model.dart';
import 'package:flutter_weather_app/data/models/weather_model.dart';
import 'package:http/http.dart' as http;

abstract class UvService {
  Future<UvIndex> getUVIndexByCity(String cityName);
}

class UvServiceImpl extends UvService {
  final Dio dio;

  UvServiceImpl(this.dio);

  @override
  Future<UvIndex> getUVIndexByCity(String cityName) async {
    try {
      const googleApi = AppStrings.googleApiKey;
      // Use a geocoding API to get the latitude and longitude of the city
      final geocodingUrl = Uri.parse('https://maps.googleapis.com/maps/api/geocode/json?address=$cityName&key=$googleApi');
      final geocodingResponse = await http.get(geocodingUrl);
      final geocodingData = json.decode(geocodingResponse.body);
      final latitude = geocodingData['results'][0]['geometry']['location']['lat'];
      final longitude = geocodingData['results'][0]['geometry']['location']['lng'];

      // Use the latitude and longitude to get the UV index from the OpenUV API
      final openUVUrl = Uri.parse('https://api.openuv.io/api/v1/uv?lat=$latitude&lng=$longitude');
      final openUVResponse = await http.get(
        openUVUrl,
        headers: {'x-access-token': AppStrings.openUvApiKey},
      );
      print(openUVResponse);
      final openUVData = json.decode(openUVResponse.body);
      print(openUVData);
      return UvIndex.fromJson(openUVData);
    } on DioError catch (error) {
      print(error.type);
      print(error.message);
      return  processResponse(error.response);
    }
  }
}
