// Rating component, displays user or post ratings in the form of stars

import 'package:flutter/material.dart';

class RatingBar extends StatefulWidget {
  final double initialRating;
  final ValueChanged<int>? onRatingSelected;
  final bool isReadOnly;

  const RatingBar({
    required this.initialRating,
    this.onRatingSelected,
    this.isReadOnly = false,
    Key? key,
  }) : super(key: key);

  @override
  State<RatingBar> createState() => _RatingBarState();
}

class _RatingBarState extends State<RatingBar> {
  late int _currentRating;

  @override
  void initState() {
    super.initState();
    _currentRating = widget.initialRating.round();
  }

  void _onStarTap(int index) {
    if (widget.isReadOnly) return;
    setState(() {
      _currentRating = index + 1;
    });
    if (widget.onRatingSelected != null) {
      widget.onRatingSelected!(_currentRating);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(5, (index) {
        return IconButton(
          icon: Icon(
            index < _currentRating ? Icons.star : Icons.star_border,
            color: Colors.amber,
          ),
          onPressed: widget.isReadOnly ? null : () => _onStarTap(index),
          splashRadius: 18,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        );
      }),
    );
  }
}
