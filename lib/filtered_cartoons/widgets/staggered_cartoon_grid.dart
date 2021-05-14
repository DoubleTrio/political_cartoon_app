import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:history_app/filtered_cartoons/filtered_cartoons.dart';
import 'package:history_app/widgets/cartoon_scroll_bar.dart';
import 'package:history_app/widgets/page_header.dart';
import 'package:political_cartoon_repository/political_cartoon_repository.dart';

class StaggeredCartoonGrid extends StatefulWidget {
  StaggeredCartoonGrid({Key? key, required this.cartoons}) : super(key: key);

  final List<PoliticalCartoon> cartoons;

  @override
  _StaggeredCartoonGridState createState() => _StaggeredCartoonGridState();
}

class _StaggeredCartoonGridState extends State<StaggeredCartoonGrid> {
  late ScrollController _scrollController;
  // final _scrollThreshold = 200.0;
  final _headerKey = GlobalKey();

  // void _onScroll() {
  //   final maxScroll = _scrollController.position.maxScrollExtent;
  //   final currentScroll = _scrollController.position.pixels;
  //   if (maxScroll - currentScroll <= _scrollThreshold) {}
  // }

  @override
  void initState() {
    _scrollController = ScrollController();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      var renderBox =
          _headerKey.currentContext!.findRenderObject() as RenderBox;

      var height = renderBox.size.height;

      _scrollController.addListener(() {
        // var maxScroll = _scrollController.position.maxScrollExtent;
        var currentScroll = _scrollController.position.pixels;
        // var delta = 200.0;
        if (currentScroll > height) {
          context.read<ScrollHeaderCubit>().onScrollPastHeader();
        } else {
          context.read<ScrollHeaderCubit>().onScrollBeforeHeader();
        }
        // if (maxScroll - currentScroll <= delta) {}
      });
      _scrollController.position.isScrollingNotifier.addListener(() {
        if (!_scrollController.position.isScrollingNotifier.value) {
          print('scroll is stopped');
        } else {
          print('scroll is started');
        }
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: CartoonScrollBar(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: StaggeredGridView.countBuilder(
            controller: _scrollController,
            physics: const BouncingScrollPhysics(),
            crossAxisCount: 2,
            mainAxisSpacing: 3.0,
            crossAxisSpacing: 3.0,
            itemCount: widget.cartoons.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                return PageHeader(
                  header: 'All',
                  key: _headerKey,
                );
              }

              var cartoon = widget.cartoons[index - 1];
              return CartoonCard(
                cartoon: cartoon,
                onTap: () =>
                  context.read<SelectCartoonCubit>().selectCartoon(cartoon),
              );
            },
            staggeredTileBuilder: (index) =>
                StaggeredTile.fit(index == 0 ? 2 : 1),
          ),
        ),
      ),
    );
  }
}
