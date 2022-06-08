import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/core/enums/network_result.dart';
import 'package:flutter_clean_architecture/core/global_widgets/input_search_text_field.dart';
import 'package:flutter_clean_architecture/feature/movie_list/layout.dart';
import 'package:flutter_clean_architecture/feature/movie_list/movie_list_notifier.dart';
import 'package:provider/provider.dart';

class MovieListPage extends StatefulWidget {
  const MovieListPage({Key? key}) : super(key: key);

  @override
  State<MovieListPage> createState() => _MovieListPageState();
}

class _MovieListPageState extends State<MovieListPage> {
  final TextEditingController _searchTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    await Future.delayed(const Duration(seconds: 0));
    context.read<MovieListNotifier>().loadMainData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          children: [
            Material(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: InputSearchTextField(
                  controller: _searchTextController,
                  onChanged: (value) {
                    context.read<MovieListNotifier>().changeQuery(value);
                  },
                  hintText: "Search",
                ),
              ),
            ),
            Expanded(child: Consumer<MovieListNotifier>(
              builder: (context, state, _) {
                // Error
                if (state.mainNetworkResult is ResultError) {
                  return ErrorLayout(
                    message: state.mainNetworkResult.message!,
                    onPress: () {
                      context.read<MovieListNotifier>().loadMainData();
                    },
                  );
                }

                // Loading
                if (state.mainNetworkResult is ResultLoading) {
                  return const LoadingLayout();
                }

                // HasData
                if (state.mainNetworkResult is ResultHasData) {
                  if (state.movieList.isEmpty) {
                    return const NoDataLayout();
                  } else {
                    Widget bottomWidget = () {
                      if (state.paginationNetworkResult is ResultError) {
                        return ErrorLayout(
                          message: state.paginationNetworkResult.message!,
                          onPress: () {
                            context
                                .read<MovieListNotifier>()
                                .loadPaginationData();
                          },
                        );
                      }

                      if (state.paginationNetworkResult is ResultLoading) {
                        return const LoadingPaginationLayout();
                      }

                      // Init
                      return const SizedBox();
                    }();

                    return DataListLayout(
                      movieList: state.movieList,
                      onPressItem: () {
              
                      },
                      bottomWidget: bottomWidget,
                      onScrollEnd: (){
                        if (state.canLoadPagination()){
                          context.read<MovieListNotifier>().loadPaginationData();
                        }
                      },
                    );
                  }
                }

                // Init
                return const SizedBox();
              },
            )),
          ],
        ),
      ),
    );
  }
}
