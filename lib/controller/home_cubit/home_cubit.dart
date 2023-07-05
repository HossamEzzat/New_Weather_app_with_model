import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_weather_app/core/error/exception_handlers.dart';
import 'package:flutter_weather_app/data/datasource/location_service.dart';
import 'package:flutter_weather_app/data/datasource/search_service.dart';
import 'package:flutter_weather_app/data/datasource/service.dart';
import 'package:flutter_weather_app/data/models/weather_model.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final Service service;
  final LocationService locationService;

  HomeCubit( {
    required this.service,
    required this.locationService,
  }) : super(HomeInitial());

  static HomeCubit get(context) => BlocProvider.of(context);


  Future<void> getCityWeather() async {
    emit(GetCityWeatherLoadingState());
    //Cairo by default
    try {
      var res = await service.getWeatherByCityName('Cairo');
      if (kDebugMode) {
        print(res);
      }
      emit(GetCityWeatherSuccessState(weatherModel: res));
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      emit(GetCityWeatherErrorState(error: ExceptionHandlers().getExceptionString(e)));
    }
  }

  Future<void> getCityWeatherByLatLong(double lat ,double long) async {
    emit(GetCityWeatherLoadingState());
    try {
      var res = await service.getWeatherByLatLong(lat, long);
      if (kDebugMode) {
        print(res);
      }
      emit(GetCityWeatherSuccessState(weatherModel: res));
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      emit(GetCityWeatherErrorState(error: e.toString()));
    }
  }

 Future<void> getCurrentPosition()async{
    emit(GetCurrentPositionLoadingState());
    try{
      var res = await locationService.getCurrentPosition();
      if (kDebugMode) {
        print(res);
      }
      if(res !=null){
        getCityWeatherByLatLong(res.latitude, res.longitude);
      }
    }catch(e){
      if (kDebugMode) {
        print(e);
      }
      emit(GetCurrentPositionErrorState(error: e.toString()));
    }
 }

}
