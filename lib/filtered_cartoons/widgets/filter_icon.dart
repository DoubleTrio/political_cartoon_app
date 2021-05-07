import 'package:flutter/material.dart';

class FilterIcon extends StatelessWidget {
  FilterIcon({Key? key, required this.onPressed, this.size = 20})
      : super(key: key);

  final VoidCallback onPressed;
  final double size;
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.filter_list),
      onPressed: onPressed,
      iconSize: size,
      splashRadius: size * 0.80,
      splashColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
      color: Colors.white,
    );
  }
}
