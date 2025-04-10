import 'package:fluentui_icons/fluentui_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tmdb_app/base/constants.dart';
import 'package:flutter_tmdb_app/controller/listPageContoller.dart';
import 'package:flutter_tmdb_app/view/detail_page.dart';
import 'package:get/get.dart';

import '../base/styles/app_styles.dart';

class ListPage extends StatefulWidget {
  const ListPage({super.key});

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  @override
  Widget build(BuildContext context) {
    final Listpagecontoller listpagecontoller = Get.put(Listpagecontoller());

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppStyles.red_main,
        leading: Icon(
          FluentSystemIcons.ic_fluent_data_bar_horizontal_filled,
          color: AppStyles.white,
        ),
        title: Text(
          "Favorits",
          style: TextStyle(color: AppStyles.white),
          textAlign: TextAlign.left,
        ),
        centerTitle: false,
        elevation: 0,
      ),
      body: Obx(() => GridView.builder(
            itemCount: listpagecontoller.MovieList.length,
            itemBuilder: (context, index) {
              var data = listpagecontoller.MovieList[index];
              return Container(
                child: Stack(
                  children: [
                    InkWell(
                      onTap: (){
                        listpagecontoller.selectedId.value = data['id'].toString();
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) =>  DetailPage()),
                        );

                      },
                      child: Image.network(
                        '${Constants.image500}${data["poster_path"]}',
                        fit: BoxFit.fill,
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            alignment: Alignment.bottomLeft,
                            color: Color(0x80000000),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8),
                                    child: Text(
                                      "${data["original_title"]}",
                                      style: TextStyle(
                                        color: AppStyles.white,
                                        fontSize: 18,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {

                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Icon(
                                      FluentSystemIcons.ic_fluent_heart_filled,
                                      size: 30,
                                      color: AppStyles.white,
                                    ),
                                  ),
                                )
                              ],
                            )),
                      ],
                    ),
                  ],
                ),
              );
            },
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 2 / 3,
            ),
          )),
    );
  }
}
