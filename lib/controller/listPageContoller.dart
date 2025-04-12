import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tmdb_app/model/movie.dart';
import 'package:get/get.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:hive/hive.dart';
import '../base/constants.dart';

class Listpagecontoller extends GetxController {
  var MovieList = [].obs;
  var selectedMovie = Movie(id: 0).obs;
  var showFav = false.obs;
  var isInternet = true.obs;

  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult>? connectivitySubscription;
  final ScrollController scrollController = ScrollController();

  final dio = Dio();

  getMoviesListApi() async {
    if (isInternet == false) {
      getAllFavMovie();
    }

    try {
      final response = await dio
          .get("${Constants.BASEURL}/movie/now_playing?language=en-US&page=1");
      saveMoveListToDb(response.data["results"]);
    } on DioException catch (e) {
      throw Exception("Failed to login $e");
    }
  }

  saveMoveListToDb(data) async {
    MovieList.value.clear();
    final box = Hive.box(HiveBoxKey.MOVIES);
    final moviewList = await box.get(HiveBoxKey.MOVIES_List) ?? [];
    final list = [];
    print(moviewList.length);

    if (moviewList.length > 0) {
      final listObj = [];

      for (final item in moviewList) {
        final isAvail =
            (data.where((s) => s["id"] == item['id']).toList().length > 0);

        final movie = Movie.fromJson(item);

        if (!isAvail) {
          list.add(item);
          listObj.add(movie);
        }

        MovieList.value.add(movie);
      }
      moviewList.addAll(list); // add json
      MovieList.value.addAll(listObj); // a dd obj

      await box.put(HiveBoxKey.MOVIES_List, moviewList);
    } else {
      for (final item in data) {
        final movie = Movie.fromJson(item);
        list.add(item);
        MovieList.value.add(movie);
      }
      await box.put(HiveBoxKey.MOVIES_List, list);
    }
    MovieList.refresh();
  }

  getMoviewListFromDb() async {
    final box = Hive.box(HiveBoxKey.MOVIES);
    final moviewList = await box.get(HiveBoxKey.MOVIES_List) ?? [];
    for (final item in moviewList) {
      final movie = Movie.fromJson(item);
      MovieList.value.add(movie);
    }
    MovieList.refresh();
  }

  getMoviesDetailsApi(id) async {
    try {
      final response = await dio.get("${Constants.BASEURL}/movie/${id}");
      final d = Movie.fromJson(response.data);
      selectedMovie.value = d;
    } on DioException catch (e) {
      throw Exception("Failed to login $e");
    }
  }

  //connectivity
  Future<void> checkConnectivity() async {
    final result = await _connectivity.checkConnectivity();
    _updateConnectionStatus(result);
  }

  void _updateConnectionStatus(ConnectivityResult result) {
    if (result == ConnectivityResult.none) {
      isInternet.value = false;
    } else {
      isInternet.value = true;
      getMoviesListApi();
    }
  }

  setFavorites2(Movie data) async {
    final box = Hive.box(HiveBoxKey.MOVIES);
    final list = box.get(HiveBoxKey.MOVIES_List) ?? [];
    data.isFavorite = !data.isFavorite;
    int index = list.indexWhere((m) => m['id'] == data.id); //find index
    list[index] = data.toJson();
    box.put(HiveBoxKey.MOVIES_List, list);
    MovieList.refresh();

  }

  getAllFavMovie() async {
    showFav.value = true;
    toggleList();
  }

  checkIsFav1(int id) {
    final dd = MovieList.value.where((s) => s.id == id).toList();
    return dd.first.isFavorite ?? false;
  }

  toggleList() {
    final box = Hive.box(HiveBoxKey.MOVIES);
    final list = box.get(HiveBoxKey.MOVIES_List);

    var showMovie = [];
    if (showFav.value == true) {
      showMovie = list.where((s) => s["is_favorite"] == true).toList();
    } else {
      showMovie = list;
    }

    MovieList.value.clear();
    for (final item in showMovie) {
      final movie = Movie.fromJson(item);
      MovieList.value.add(movie);
    }
    MovieList.refresh();
  }

  openHiveBox() async {
    await Hive.openBox(HiveBoxKey.MOVIES);

    getMoviewListFromDb();
    getMoviesListApi();
  }

  //for load next page
  getMoreMoviews() {}

  @override
  void onInit() {
    connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    checkConnectivity();

    openHiveBox();

    dio.options.headers['Authorization'] = Constants.TOKEN;

    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent) {
        getMoreMoviews(); // for paginaationn and load more  movie
      }
    });
    super.onInit();
  }

  @override
  void onClose() {
    connectivitySubscription?.cancel();
    super.onClose();
  }
}
