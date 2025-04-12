import 'package:fluentui_icons/fluentui_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tmdb_app/view/detail_page.dart';
import 'package:get/get.dart';
import 'package:flutter_tmdb_app/controller/listPageContoller.dart';
import 'package:flutter_tmdb_app/view/list_page.dart';
import 'package:flutter_tmdb_app/model/movie.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  late Listpagecontoller controller;
  late Box box;

  setUpAll(() async {
    final appDocumentDir = await getTemporaryDirectory();
    Hive.init(appDocumentDir.path);
    await Hive.openBox('movies');
    box = Hive.box('movies');
  });

  setUp(() {
    controller = Listpagecontoller();
    Get.put(controller);
  });

  tearDown(() {
    Get.reset();
    box.clear();
  });

  testWidgets('ListPage displays correct initial state', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: ListPage()));

    expect(find.text('Now Playing'), findsOneWidget);

    expect(find.byType(TextField), findsOneWidget);

    expect(find.byType(GridView), findsOneWidget);
  });

  testWidgets('ListPage shows offline indicator when offline', (WidgetTester tester) async {
    controller.isInternet.value = false;

    await tester.pumpWidget(const MaterialApp(home: ListPage()));

    expect(find.text('You are offline'), findsOneWidget);
  });

  testWidgets('ListPage toggles between favorites and now playing', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: ListPage()));

    expect(find.text('Now Playing'), findsOneWidget);

    await tester.tap(find.byIcon(FluentSystemIcons.ic_fluent_data_bar_horizontal_filled));
    await tester.pump();

    expect(find.text('Favorites'), findsOneWidget);
  });

  testWidgets('ListPage handles search functionality', (WidgetTester tester) async {
    final testMovies = [
      Movie(id: 1, title: 'Test Movie 1', posterPath: '/path1.jpg'),
      Movie(id: 2, title: 'Test Movie 2', posterPath: '/path2.jpg'),
    ];
    controller.MovieList.value = testMovies;

    await tester.pumpWidget(const MaterialApp(home: ListPage()));

    await tester.enterText(find.byType(TextField), 'Test Movie 1');
    await tester.pump();

    expect(find.text('Test Movie 1'), findsOneWidget);
    expect(find.text('Test Movie 2'), findsNothing);
  });

  testWidgets('ListPage handles favorite button taps', (WidgetTester tester) async {
    final testMovie = Movie(id: 1, title: 'Test Movie', posterPath: '/path.jpg');
    controller.MovieList.value = [testMovie];

    await tester.pumpWidget(const MaterialApp(home: ListPage()));

    await tester.tap(find.byIcon(FluentSystemIcons.ic_fluent_heart_filled));
    await tester.pump();

    expect(controller.MovieList.first.isFavorite, true);
  });

  testWidgets('ListPage handles movie item taps', (WidgetTester tester) async {
    final testMovie = Movie(id: 1, title: 'Test Movie', posterPath: '/path.jpg');
    controller.MovieList.value = [testMovie];

    await tester.pumpWidget(const MaterialApp(home: ListPage()));

    await tester.tap(find.text('Test Movie'));
    await tester.pumpAndSettle();

    expect(find.byType(DetailPage), findsOneWidget);
  });
} 