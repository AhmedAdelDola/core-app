import 'package:flutter/material.dart';

import '../custom_shimmer.dart';

class ShimmerVerticalListWidget extends StatelessWidget {
  final int? count;
  final double? height;
  const ShimmerVerticalListWidget({super.key, this.count = 5, this.height = 300});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: count,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (BuildContext context, int index) => CustomShimmer(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Container(
            height: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            width: MediaQuery.of(context).size.width / 1.5,
          ),
        ),
      ),
    );
  }
}
