import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tmdb_app/model/favorite.dart';
import 'package:get/get.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:hive/hive.dart';

import '../base/constants.dart';

class Listpagecontoller extends GetxController{


  var MovieList = [].obs;
  var AllFavList = [].obs;

  var selectedMovie = {}.obs;
  var selectedId = "".obs;
  RxMap selectedFavMovie = {}.obs;
  var isInternet = true.obs;
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult>? connectivitySubscription;

  final dio = Dio();

  getMoviesListApi() async {
    if(isInternet==false){
      getAllFavMovie();
    }
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

  Future<void> checkConnectivity() async {
    final result = await _connectivity.checkConnectivity();
    _updateConnectionStatus(result);
  }

  void _updateConnectionStatus(ConnectivityResult result) {
    if (result == ConnectivityResult.none) {
      isInternet.value = false;
    } else {
      isInternet.value = true;
      if(MovieList.isEmpty){
        getMoviesListApi();

      }

    }
  }


  setMovieList(Favorite jsonFav, data) async {
    final box = Hive.box(HiveBoxKey.MOVIES);
    List<dynamic> list = box.get(HiveBoxKey.MOVIES_List)??[];
    var checkAvail = list.where((s)=> s['fav']==data['fav']).toList();

    if(checkAvail.isEmpty){
      jsonFav.fav = true;
      list.add(jsonFav.toJson());
    }else{
      jsonFav.fav = false;
      list.add(jsonFav.toJson());
    }

    await box.put(HiveBoxKey.FAV_MOVIES_List,list);
  }

  setFavorites(Favorite jsonFav, data) async {

    final box = Hive.box(HiveBoxKey.FAV_MOVIES);
    List<dynamic> list = box.get(HiveBoxKey.FAV_MOVIES_List)??[];
    var checkAvail= list.where((s)=> s['id']==jsonFav.id).toList();

    if(checkAvail.isEmpty){
      list.add(jsonFav.toJson());
    }else{
      list.removeWhere((s)=> s['id']==jsonFav.id);
    }

    await box.put(HiveBoxKey.FAV_MOVIES_List,list);
  }

  getAllFavMovie()  async {
    final box = Hive.box(HiveBoxKey.FAV_MOVIES);
    List<dynamic> list = box.get(HiveBoxKey.FAV_MOVIES_List)??[];
    AllFavList.value = list;
    if(MovieList.isEmpty){
      MovieList.value = AllFavList.value;
    }
  }

  checkIsFav1(int id) {
    var  dd= (AllFavList.where((s)=> s['id']==id).toList().isNotEmpty);
    return dd.obs;
  }







  openHiveBox () async{
    await Hive.openBox(HiveBoxKey.FAV_MOVIES);
    getAllFavMovie();
  }

  @override
  void onInit() {

    connectivitySubscription = _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    checkConnectivity();

    openHiveBox();

    dio.options.headers['Authorization'] = Constants.TOKEN;

    
    super.onInit();
  }

  @override
  void onClose() {
    connectivitySubscription?.cancel();
    super.onClose();
  }


}