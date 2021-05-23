import 'package:flutter/material.dart';
import 'package:history_app/widgets/widgets.dart';
import 'package:shimmer/shimmer.dart';

class CartoonBodyPlaceholder extends StatelessWidget {
  const CartoonBodyPlaceholder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    final shortBodyIndexes = [0, 2];
    final shortBodyWidth = width / 5;
    final longBodyWidth = width;

    final headerWidth = width / 3;
    final multiBodyIndexes = [3];

    final imageHeight = height / 3;
    final bodyHeight = height - imageHeight;

    final itemCount = 4;

    return Shimmer.fromColors(
      baseColor: theme.dividerColor,
      highlightColor: theme.backgroundColor,
      direction: ShimmerDirection.ltr,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            height: imageHeight,
            width: double.infinity,
            color: theme.colorScheme.background,
          ),
          Container(
            height: bodyHeight,
            width: double.infinity,
            child:  ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: itemCount,
                itemBuilder: (_, index) {
                  return SectionPlaceholder(
                    headerPlaceholderWidth: headerWidth,
                    bodyPlaceholderWidth: shortBodyIndexes.contains(index)
                        ? shortBodyWidth
                        : longBodyWidth,
                    shouldAddExtra: multiBodyIndexes.contains(index),
                  );
                }
            ),
          ),
        ],
      ),
    );
  }
}
