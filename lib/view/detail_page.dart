import 'package:fluentui_icons/fluentui_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tmdb_app/base/constants.dart';
import 'package:flutter_tmdb_app/base/styles/app_styles.dart';
import 'package:flutter_tmdb_app/components/no_internet_component.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

import '../controller/listPageContoller.dart';
import '../model/favorite.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({super.key});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final Listpagecontoller listpagecontoller = Get.find();

  @override
  void initState() {
    listpagecontoller.getMoviesDetailsApi();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body:
        Obx(
          () =>
            Stack(
            children: [
              if (!listpagecontoller.isInternet.value) Container( margin: EdgeInsets.symmetric(vertical: 100),child: NoInternetComponent()) else Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      height: Get.height / 3,
                      width: Get.width,
                      child: Image.network(
                        '${Constants.image500}${listpagecontoller.selectedMovie['backdrop_path']??""}',
                        fit: BoxFit.cover,
                      )),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          width: Get.width / 3,
                          height: Get.height / 4,
                          transform: Matrix4.translationValues(20, -20.0, 0.0),
                          child: Image.network(
                            '${Constants.image500}${listpagecontoller.selectedMovie['poster_path']??""}',
                            fit: BoxFit.fill,
                          )),
                      Expanded(
                          child: Padding(
                        padding: const EdgeInsets.only(left: 40, top: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              listpagecontoller.selectedMovie['original_title']??"",
                              style: AppStyles.headerTextStyle1,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              listpagecontoller.selectedMovie['release_date']??"",
                              style: AppStyles.textStyleGreyH2,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            )
                          ],
                        ),
                      )),
                      Padding(
                        padding: const EdgeInsets.only(top: 20, right: 20),
                        child: Container(
                          child: Obx(()=>
                             InkWell(
                               onTap: () async {
                                 Favorite json = Favorite(
                                   id: listpagecontoller.selectedMovie["id"],
                                   title: listpagecontoller.selectedMovie["original_title"],
                                   posterPath:
                                   listpagecontoller.selectedMovie["poster_path"],
                                 );
                                 await listpagecontoller.setFavorites(
                                     json, listpagecontoller.selectedMovie);
                                 setState(() {

                                 });
                               },
                               child: Icon(
                                FluentSystemIcons.ic_fluent_heart_filled,
                                size: 30,
                                color: listpagecontoller.checkIsFav1(listpagecontoller.selectedMovie['id']??"").value? AppStyles.red:AppStyles.gray2,
                                                           ),
                             ),
                          ),
                        ),
                      )
                    ],
                  ),
                  Divider(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      listpagecontoller.selectedMovie['overview']??'',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20,left: 20),
                child: InkWell(
                  onTap: (){
                    Navigator.pop(context);
                  },
                  child: Icon(FluentSystemIcons.ic_fluent_arrow_left_filled,color: !listpagecontoller.isInternet.value?
                    Colors.black: Colors.white,),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
