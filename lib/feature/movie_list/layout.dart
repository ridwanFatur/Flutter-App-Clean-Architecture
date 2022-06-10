import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/core/constants/asset_constants.dart';
import 'package:flutter_clean_architecture/core/constants/urls.dart';
import 'package:flutter_clean_architecture/domain/entities/movie.dart';

class ErrorLayout extends StatelessWidget {
  final String message;
  final VoidCallback onPress;
  const ErrorLayout({
    Key? key,
    required this.message,
    required this.onPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: double.infinity,
        height: 250,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              message,
              style: Theme.of(context).textTheme.bodyText2,
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: onPress,
              child: const Text("Reload"),
            ),
          ],
        ),
      ),
    );
  }
}

class NoDataLayout extends StatelessWidget {
  const NoDataLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: double.infinity,
        height: 250,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              AssetConstant.kIconNotFound,
              width: 80,
              height: 80,
            ),
            const SizedBox(height: 10),
            Text(
              "Empy Data",
              style: Theme.of(context).textTheme.bodyText2,
            ),
          ],
        ),
      ),
    );
  }
}

class LoadingLayout extends StatelessWidget {
  const LoadingLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}

class LoadingPaginationLayout extends StatelessWidget {
  const LoadingPaginationLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 10),
      alignment: Alignment.center,
      child: const CircularProgressIndicator(),
    );
  }
}

class DataListLayout extends StatelessWidget {
  final List<Movie> movieList;
  final VoidCallback onPressItem;
  final Widget bottomWidget;
  final VoidCallback onScrollEnd;
  const DataListLayout({
    Key? key,
    required this.movieList,
    required this.onPressItem,
    required this.bottomWidget,
    required this.onScrollEnd,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (scrollNotification) {
        if (scrollNotification is ScrollEndNotification) {
          final maxScroll = scrollNotification.metrics.maxScrollExtent;
          final currentScroll = scrollNotification.metrics.pixels;
          if (currentScroll == maxScroll) {
            onScrollEnd();
            return true;
          }
        }
        return false;
      },
      child: SingleChildScrollView(
        key: const Key('DataListLayout'),
        child: Column(
          children: [
            ...List.generate(
              movieList.length,
              (index) {
                Movie movie = movieList[index];
                return ItemMovieLayout(
                  key: Key("${movie.id}"),
                  movie: movie,
                  onPressItem: onPressItem,
                );
              },
            ),
            bottomWidget,
          ],
        ),
      ),
    );
  }
}

class ItemMovieLayout extends StatelessWidget {
  final Movie movie;
  final VoidCallback onPressItem;
  const ItemMovieLayout({
    required Key key,
    required this.movie,
    required this.onPressItem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: Material(
        borderRadius: BorderRadius.circular(10),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onPressItem,
          splashFactory: InkRipple.splashFactory,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(
                  movie.posterImageSmallPath ?? Urls.posterNotFound,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        movie.title,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
