part of 'model_cubit.dart';

abstract class ModelState extends Equatable {
  const ModelState();
}

class ModelInitial extends ModelState {
  @override
  List<Object> get props => [];

}
//
//
// class GetCityWeatherLoadingState extends ModelState {
//   @override
//   List<Object> get props => [];
// }
//
// class GetCityWeatherSuccessState extends ModelState {
//   final WeatherModel weatherModel;
//
//   const GetCityWeatherSuccessState({required this.weatherModel});
//   @override
//   List<Object> get props => [weatherModel];
// }
//
// class GetCityWeatherErrorState extends ModelState {
//   final String error;
//
//   const GetCityWeatherErrorState({required this.error});
//   @override
//   List<Object> get props => [error];
// }


class GetCityUvLoadingState extends ModelState {
  @override
  List<Object> get props => [];
}

class GetCityUvSuccessState extends ModelState {
  final UvIndex uvIndex;

  const GetCityUvSuccessState({required this.uvIndex});
  @override
  List<Object> get props => [uvIndex];
}

class GetCityUvErrorState extends ModelState {
  final String error;

  const GetCityUvErrorState({required this.error});
  @override
  List<Object> get props => [error];
}

