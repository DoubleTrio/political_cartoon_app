import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:history_app/filtered_cartoons/blocs/blocs.dart';
import 'package:political_cartoon_repository/political_cartoon_repository.dart';

class DetailsPage extends Page {
  DetailsPage({required this.cartoon})
      : super(key: const ValueKey('DetailsPage'));

  final PoliticalCartoon cartoon;

  @override
  Route createRoute(BuildContext context) {
    return PageRouteBuilder(
      settings: this,
      pageBuilder: (context, animation, secondaryAnimation) =>
          DetailsScreen(cartoon: cartoon),
      transitionDuration: const Duration(milliseconds: 500),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = const Offset(1.0, 0.0);
        var end = Offset.zero;
        var curve = Curves.ease;

        var tween = Tween(begin: begin, end: end)
          ..chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }
}

class DetailsScreen extends StatelessWidget {
  DetailsScreen({required this.cartoon});

  final PoliticalCartoon cartoon;

  static MaterialPage page({required PoliticalCartoon selectedCartoon}) {
    return MaterialPage(
        child: DetailsScreen(cartoon: selectedCartoon),
        key: const ValueKey('DetailsScreenKey'));
  }

  @override
  Widget build(BuildContext context) {
    void _deselectCartoon() {
      context.read<SelectCartoonCubit>().deselectCartoon();
    }

    return Scaffold(
        appBar: AppBar(
            actions: [],
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_outlined,
              ),
              onPressed: _deselectCartoon,
            )),
        body: Center(
          child: Column(
            children: [
              GestureDetector(
                child: Center(
                  child: CachedNetworkImage(
                    imageUrl: cartoon.downloadUrl,
                    progressIndicatorBuilder:
                        (context, url, downloadProgress) =>
                            LinearProgressIndicator(
                                value: downloadProgress.progress),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                ),
                onTap: _deselectCartoon,
              ),
            ],
          ),
        ));
  }
}
