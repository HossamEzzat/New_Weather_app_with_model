import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_weather_app/controller/degree_cubit/degree_cubit.dart';
import 'package:flutter_weather_app/controller/home_cubit/home_cubit.dart';
import 'package:flutter_weather_app/controller/model_cubit/model_cubit.dart';
import 'package:flutter_weather_app/core/extensions/extensions.dart';
import 'package:flutter_weather_app/data/models/request_model.dart';
import 'package:flutter_weather_app/data/models/uv_index_model.dart';
import 'package:flutter_weather_app/data/models/weather_model.dart';
import 'package:flutter_weather_app/view/widgets/custom_error_widget.dart';
import 'package:flutter_weather_app/view/widgets/loading_widget.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../core/utils/theme/app_colors.dart';

class ModelScreen extends StatelessWidget {
  const ModelScreen({super.key});


  Future<String> sendDataToAPI(double temperature, double humidity, double uvIndex) async {
    const apiUrl = 'https://b3c4-197-54-224-144.ngrok-free.app/virusModel';

    final requestData = PredictionRequest(
      temperature: temperature,
      humidity: humidity,
      uvIndex: uvIndex,
    ).toJson();

    final response = await http.post(
      Uri.parse(apiUrl),
      body: json.encode(requestData),
      headers: {'Content-Type': 'application/json'},
    );

    // Handle the API response
    if (response.statusCode == 200) {
      // Success
      if (kDebugMode) {
        print('Data sent successfully');
      }
      if (kDebugMode) {
        print(response.body);
      }
      // Extract the "result" value from the response body
      final responseBody = json.decode(response.body);
      final result = responseBody['result'];
      return result; // Return the "result" value
    } else {
      // Error
      if (kDebugMode) {
        print('Failed to send data. Error: ${response.statusCode}');
      }
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
   return Scaffold(
     body: SafeArea(
       child: BlocBuilder<ModelCubit, ModelState>(
           builder: (context, state){
             if (state is GetCityUvSuccessState) {
               UvIndex uvIndex = state.uvIndex;
               return  SingleChildScrollView(
                 child: Column(
                   mainAxisAlignment: MainAxisAlignment.center,
                   children: [
                     const Padding(
                       padding: EdgeInsets.only(top: 50),
                       child: Row(
                         mainAxisAlignment: MainAxisAlignment.center,
                         children: [
                           Text('Virus Possibility',
                               style: TextStyle(
                                   fontSize: 36 ,
                                   fontWeight: FontWeight.bold,
                                   color: Colors.white)
                           ),
                         ],
                       ),
                     ),
                     20.0.h(context),
                     SizedBox(
                       child: Column(
                         children: [
                           // UV index, Temperature & Humidity Card
                           SizedBox(
                             height: 200,
                             width: 500,
                             child: Padding(
                               padding: const EdgeInsets.fromLTRB(22, 22, 20, 20),
                               child: Card(
                                 color:AppColors.primaryLight,
                                 elevation: 5,
                                 shape: RoundedRectangleBorder(
                                   borderRadius: BorderRadius.circular(25),
                                 ),
                                 child: Column(
                                   crossAxisAlignment:
                                   CrossAxisAlignment.center,
                                   children: [
                                     Container(
                                       padding: const EdgeInsets.only(
                                           top: 15, left: 20, right: 20),
                                       child: Column(
                                         crossAxisAlignment:
                                         CrossAxisAlignment.start,
                                         children: [
                                           // UV Index
                                           Row(
                                             children: [
                                               const Text(
                                                 'UV Index',
                                                 style: TextStyle(
                                                   fontSize: 22,
                                                   fontWeight: FontWeight.bold,
                                                   color: Color(0xff141332),
                                                 ),
                                               ),
                                               130.0.w(context),
                                               Text(
                                                 uvIndex.uvi.toString(),
                                                 style: const TextStyle(
                                                     fontSize: 22,
                                                     fontWeight: FontWeight.bold,
                                                     color: Colors.white
                                                 ),
                                               ),
                                             ],
                                           ),
                                           20.0.h(context),
                                           // Temperature & Humidity
                                           BlocBuilder<HomeCubit, HomeState>(
                                             builder: (context, state) {
                                               if (state is GetCityWeatherSuccessState) {
                                                 WeatherModel weatherModel = state.weatherModel;
                                                 return  BlocBuilder<DegreeCubit, DegreeState>(
                                                   builder: (context, state) {
                                                     var cubit = DegreeCubit.get(context);
                                                     return Column(
                                                       children: [
                                                         // Temperature
                                                         Row(
                                                           children: [
                                                             const Text(
                                                               'Temperature',
                                                               style: TextStyle(
                                                                 fontSize: 22,
                                                                 fontWeight: FontWeight.bold,
                                                                 color: Color(0xff141332),
                                                               ),
                                                             ),
                                                             100.0.w(context),
                                                             Text(
                                                               cubit.getDegreeType(
                                                                   weatherModel.weatherDayData[0].temp
                                                               ),
                                                               style: const TextStyle(
                                                                   fontSize: 22,
                                                                   fontWeight: FontWeight.bold,
                                                                   color: Colors.white
                                                               ),
                                                             ),
                                                           ],
                                                         ),
                                                         20.0.h(context),
                                                         // Humidity
                                                         Row(
                                                           children: [
                                                             const Text(
                                                               'Humidity',
                                                               style: TextStyle(
                                                                 fontSize: 22,
                                                                 fontWeight: FontWeight.bold,
                                                                 color: Color(0xff141332),
                                                               ),
                                                             ),
                                                             140.0.w(context),
                                                             Text(
                                                               weatherModel.weatherDayData[0].humidity.toString(),
                                                               style: const TextStyle(
                                                                   fontSize: 22,
                                                                   fontWeight: FontWeight.bold,
                                                                   color: Colors.white
                                                               ),
                                                             ),

                                                           ],
                                                         ),
                                                       ]
                                                     );
                                                   },
                                                 );
                                               }else if (state is GetCityWeatherErrorState) {
                                                 return CustomErrorWidget(error: state.error);
                                               } else {
                                                 return const LoadingWidget();
                                               }
                                             },
                                           ),
                                         ],
                                       ),
                                     ),
                                   ],
                                 ),
                               ),
                             ),
                           ),
                           BlocBuilder<HomeCubit, HomeState>(
                             builder: (context, state) {
                               if (state is GetCityWeatherSuccessState) {
                                 WeatherModel weatherModel = state.weatherModel;
                                 return  BlocBuilder<DegreeCubit, DegreeState>(
                                   builder: (context, state) {
                                     var tempC = (weatherModel.weatherDayData[0].temp - 273.15).toDouble();                             return Column(
                                       children: [
                                         SizedBox(
                                           height: 220,
                                           width: 500,
                                           child: Padding(
                                             padding: const EdgeInsets.fromLTRB(22, 22, 20, 20),
                                             child: Card(
                                               color:AppColors.primaryLight,
                                               elevation: 5,
                                               shape: RoundedRectangleBorder(
                                                 borderRadius: BorderRadius.circular(25),
                                               ),
                                               child: Column(
                                                 crossAxisAlignment:
                                                 CrossAxisAlignment.center,
                                                 children: [
                                                   Container(
                                                     padding: const EdgeInsets.only(
                                                         top: 20, left: 20, right: 20),
                                                     child: Column(
                                                       crossAxisAlignment:
                                                       CrossAxisAlignment.start,
                                                       children: [
                                                         const Row(
                                                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                           children: [
                                                             Text('Virus Data', style:
                                                             TextStyle(
                                                                 fontSize: 22 ,
                                                                 fontWeight: FontWeight.bold,
                                                                 color: Colors.white)),
                                                           ],
                                                         ),
                                                         const SizedBox(height: 10),
                                                         const Row(
                                                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                           children: [
                                                             Text('Virus Type',
                                                                 style: TextStyle(
                                                                     color: Color(0xff141332),
                                                                     fontSize: 18 ,
                                                                     fontWeight: FontWeight.bold
                                                                 )),
                                                             Text('Corona',style: TextStyle(
                                                                 fontSize: 18 ,
                                                                 fontWeight: FontWeight.bold,
                                                                 color: Colors.white
                                                             ))
                                                           ],),
                                                         const SizedBox(height: 10),
                                                         Row(
                                                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                           children: [
                                                             const Text('Infection Possibility',
                                                                 style: TextStyle(
                                                                     color: Color(0xff141332),
                                                                     fontSize: 18 ,
                                                                     fontWeight: FontWeight.bold
                                                                 )
                                                             ),
                                                             FutureBuilder<String>(
                                                               future: sendDataToAPI(
                                                                 tempC,
                                                                 weatherModel.weatherDayData[0].humidity,
                                                                 uvIndex.uvi!.toDouble(),
                                                               ),
                                                               builder: (context, snapshot) {
                                                                 if (snapshot.connectionState == ConnectionState.waiting) {
                                                                   // While waiting for the future to complete, display a loading indicator
                                                                   return const CircularProgressIndicator();
                                                                 } else if (snapshot.hasData) {
                                                                   // If the future completes successfully, display the response value
                                                                   return Text(
                                                                     snapshot.data!,
                                                                     style: const TextStyle(
                                                                       fontSize: 18,
                                                                       fontWeight: FontWeight.bold,
                                                                       color: Colors.white,
                                                                     ),
                                                                   );
                                                                 } else if (snapshot.hasError) {
                                                                   // If an error occurs, display an error message
                                                                   return Text(
                                                                     'Error: ${snapshot.error}',
                                                                     style: const TextStyle(
                                                                       fontSize: 18,
                                                                       fontWeight: FontWeight.bold,
                                                                       color: Colors.red,
                                                                     ),
                                                                   );
                                                                 } else {
                                                                   // If the future is null, display an empty container
                                                                   return Container();
                                                                 }
                                                               },
                                                             ),
                                                           ],
                                                         ),
                                                         const SizedBox(height: 10),
                                                         const Row(
                                                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                           children: [
                                                             Text('Vaccine Availability',
                                                                 style: TextStyle(
                                                                     color: Color(0xff141332),
                                                                     fontSize: 18 ,
                                                                     fontWeight: FontWeight.bold
                                                                 )),
                                                             Text('Available',
                                                                 style: TextStyle(
                                                                     fontSize: 18 ,
                                                                     fontWeight: FontWeight.bold,
                                                                     color: Colors.white
                                                                 ))
                                                           ],),
                                                       ],
                                                     ),
                                                   ),
                                                 ],
                                               ),
                                             ),
                                           ),
                                         ),
                                       ],
                                     );
                                   },
                                 );
                               }else if (state is GetCityWeatherErrorState) {
                                 return CustomErrorWidget(error: state.error);
                               } else {
                                 return const LoadingWidget();
                               }
                             },
                           ),
                         ],
                       ),
                     ),
                   ],
                 ),
               );
             } else if (state is GetCityUvErrorState) {
               return CustomErrorWidget(error: state.error);
             } else {
               return const LoadingWidget();
             }
           }
       ),
     ),
   );
  }
}

