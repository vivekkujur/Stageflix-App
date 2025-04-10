import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../base/constants.dart';

class Listpagecontoller extends GetxController{


  var MovieList = [].obs;
  var selectedMovie = {}.obs;
  var selectedId = "".obs;



  final dio = Dio();


  getMoviesListApi() async {
    try{
      final response = await dio.get("${Constants.BASEURL}/movie/now_playing?language=en-US&page=1");
      MovieList.value  = response.data["results"];

    }on DioException catch(e){
      throw Exception( "Failed to login $e");
    }
  }

  getMoviesDetailsApi() async {
    try{
      print(selectedId.value);

      final response = await dio.get("${Constants.BASEURL}/movie/${selectedId.value}");
      print(response.data);
      selectedMovie.value  = response.data;

    }on DioException catch(e){
      throw Exception( "Failed to login $e");
    }
  }





  @override
  void onInit() {
    dio.options.headers['Authorization'] = Constants.TOKEN;
    getMoviesListApi();
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
  }


}