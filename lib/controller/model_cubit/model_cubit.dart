import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_weather_app/controller/home_cubit/home_cubit.dart';
import 'package:flutter_weather_app/core/error/exception_handlers.dart';
import 'package:flutter_weather_app/data/datasource/location_service.dart';
import 'package:flutter_weather_app/data/datasource/search_service.dart';
import 'package:flutter_weather_app/data/datasource/service.dart';
import 'package:flutter_weather_app/data/models/uv_index_model.dart';
import 'package:flutter_weather_app/data/models/weather_model.dart';

import '../../data/datasource/uv_service.dart';

part 'model_state.dart';


class ModelCubit extends Cubit<ModelState> {
  final Service service;
  final UvService uvService;

  ModelCubit({
    required this.service,
    required this.uvService,
  }) : super(ModelInitial());


  static ModelCubit get(context) => BlocProvider.of(context);

  // Future<void> getCityWeather() async {
  //   emit(GetCityWeatherLoadingState());
  //   //Cairo by default
  //   try {
  //     var res = await service.getWeatherByCityName('Cairo');
  //     if (kDebugMode) {
  //       print(res);
  //     }
  //     emit(GetCityWeatherSuccessState(weatherModel: res));
  //   } catch (e) {
  //     if (kDebugMode) {
  //       print(e);
  //     }
  //     emit(GetCityWeatherErrorState(error: ExceptionHandlers().getExceptionString(e)));
  //   }
  // }

  Future<void> getCityUvIndex(String cityName) async {
    emit(GetCityUvLoadingState());
    try {
      var res = await uvService.getUVIndexByCity(cityName);
      if (kDebugMode) {
        print(res);
      }
      emit(GetCityUvSuccessState(uvIndex: res));
    } catch (e) {
      if (kDebugMode){
        print(e);
      }
      emit(GetCityUvErrorState(error: ExceptionHandlers().getExceptionString(e)));
    }

  }
}