import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:flutter_tmdb_app/controller/listPageContoller.dart';
import 'package:flutter_tmdb_app/components/search_component.dart';
import 'package:flutter_tmdb_app/model/movie.dart';

void main() {
  late Listpagecontoller controller;

  setUp(() {
    controller = Listpagecontoller();
    Get.put(controller);
  });

  tearDown(() {
    Get.reset();
  });

  testWidgets('SearchComponent displays correctly', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: Scaffold(body: SearchComponent())));

    expect(find.byType(TextField), findsOneWidget);

    expect(find.byIcon(Icons.search), findsOneWidget);

    expect(find.text('Search movies...'), findsOneWidget);
  });

  testWidgets('SearchComponent filters movies correctly', (WidgetTester tester) async {
    final testMovies = [
      Movie(id: 1, title: 'Test Movie 1', posterPath: '/path1.jpg'),
      Movie(id: 2, title: 'Test Movie 2', posterPath: '/path2.jpg'),
      Movie(id: 3, title: 'Another Movie', posterPath: '/path3.jpg'),
    ];
    controller.MovieList.value = testMovies;

    await tester.pumpWidget(const MaterialApp(home: Scaffold(body: SearchComponent())));

    await tester.enterText(find.byType(TextField), 'Test');
    await tester.pump();

    expect(controller.MovieList.length, 2);
    expect(controller.MovieList.any((movie) => movie.title == 'Test Movie 1'), true);
    expect(controller.MovieList.any((movie) => movie.title == 'Test Movie 2'), true);
    expect(controller.MovieList.any((movie) => movie.title == 'Another Movie'), false);
  });

  testWidgets('SearchComponent clears filter when empty', (WidgetTester tester) async {
    final testMovies = [
      Movie(id: 1, title: 'Test Movie 1', posterPath: '/path1.jpg'),
      Movie(id: 2, title: 'Test Movie 2', posterPath: '/path2.jpg'),
    ];
    controller.MovieList.value = testMovies;

    await tester.pumpWidget(const MaterialApp(home: Scaffold(body: SearchComponent())));

    await tester.enterText(find.byType(TextField), 'Test');
    await tester.pump();

    await tester.enterText(find.byType(TextField), '');
    await tester.pump();

    expect(controller.MovieList.length, 2);
  });

} 