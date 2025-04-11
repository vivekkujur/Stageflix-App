import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../base/styles/app_styles.dart';
import '../controller/listPageContoller.dart';

class SearchComponent extends StatelessWidget {
  const SearchComponent({super.key});

  @override
  Widget build(BuildContext context) {
    final Listpagecontoller listpagecontoller = Get.find();
    final TextEditingController searchController = TextEditingController();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: TextField(
        controller: searchController,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: 'Search movies...',
          hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
          prefixIcon: Icon(
            Icons.search,
            color: Colors.white.withOpacity(0.7),
          ),
          filled: true,
          fillColor: AppStyles.red_main.withOpacity(0.8),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        onChanged: (value) {
          if (value.isEmpty) {
            listpagecontoller.getMoviesListApi();
          } else {
            final filteredList = listpagecontoller.MovieList.where((movie) =>
                movie['original_title']??movie["title"].toString().toLowerCase().contains(value.toLowerCase())).toList();
            listpagecontoller.MovieList.value = filteredList;
          }
        },
      ),
    );
  }
}
