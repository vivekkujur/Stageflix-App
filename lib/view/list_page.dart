import 'package:fluentui_icons/fluentui_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tmdb_app/base/constants.dart';
import 'package:flutter_tmdb_app/components/no_internet_component.dart';
import 'package:flutter_tmdb_app/controller/listPageContoller.dart';
import 'package:flutter_tmdb_app/model/favorite.dart';
import 'package:flutter_tmdb_app/model/movie.dart';
import 'package:flutter_tmdb_app/view/detail_page.dart';
import 'package:get/get.dart';
import '../components/search_component.dart';
import '../base/styles/app_styles.dart';

class ListPage extends StatefulWidget {
  const ListPage({super.key});

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  @override
  Widget build(BuildContext context) {



    print("render");
    final Listpagecontoller listpagecontoller = Get.put(Listpagecontoller());


    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppStyles.red_main,
        leading: InkWell(
          onTap: (){
            listpagecontoller.showFav.value  =   !listpagecontoller.showFav.value;

            listpagecontoller.toggleList();
          },
          child: Icon(
            FluentSystemIcons.ic_fluent_data_bar_horizontal_filled,
            color: AppStyles.white,
          ),
        ),
        title: Obx(()=>
           Text(
            listpagecontoller.showFav.value? "Favorits" :"Now Playing",
            style: TextStyle(color: AppStyles.white),
            textAlign: TextAlign.left,
          ),
        ),
        centerTitle: false,
        elevation: 0,
      ),
      body: Column(
        children: [
          const SearchComponent(),
          Obx(() => !listpagecontoller.isInternet.value
              ? const NoInternetComponent()
              : const SizedBox.shrink()),
          Expanded(
            child: Obx(() => GridView.builder(
              controller: listpagecontoller.scrollController,
                  itemCount: listpagecontoller.MovieList.length,
                  itemBuilder: (context, index) {
                    var data = listpagecontoller.MovieList[index];


                    return Container(
                      child: Stack(
                        children: [
                          InkWell(
                            onTap: () {
                          
                              
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => DetailPage(id: data.id,index: index,)),
                              );
                            },
                            child: listpagecontoller.isInternet==true
                                ? Image.network(
                                    '${Constants.image500}${data.posterPath}',
                                    fit: BoxFit.fill,

                                  )
                                : Container(
                                    alignment: Alignment.center,
                                    child: Icon(
                                      FluentSystemIcons
                                          .ic_fluent_photo_filter_filled,
                                      size: 50,
                                    )),
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
                                            "${data.title}",
                                            // "${data["original_title"]??data["title"]}",
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
                                        onTap: () async {

                                          await listpagecontoller.setFavorites2(
                                               data);
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: data.isFavorite == true
                                              ? Icon(
                                                  FluentSystemIcons
                                                      .ic_fluent_heart_filled,
                                                  size: 30,
                                                  color: AppStyles.red)
                                              : Icon(
                                                  FluentSystemIcons
                                                      .ic_fluent_heart_filled,
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
          ),
        ],
      ),
    );
  }
}
