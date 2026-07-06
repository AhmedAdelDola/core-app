import 'package:flutter/material.dart';

import '../../../../../../../../core/widgets/ui_helpers/extensions.dart';
import 'not_subscribe_slider.dart';
import 'price_container.dart';

class CourseImageWithData extends StatelessWidget {
  final bool isFree;
  final String title;
  final int imagesUrlsLength;

  const CourseImageWithData({
    super.key,
    required this.isFree,
    required this.title,
    required this.imagesUrlsLength,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomLeft,
      children: [
        const NotSubscribeSlider(),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 55),
          child: SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                dots(
                  imagesUrlsLength,
                ),
                0.sbH,
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      PriceContainer(title: title),
                      if (isFree == true) const PriceContainer(title: 'مجاني'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

Widget dots(
  int length,
) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: List.generate(
      length,
      (i) => Container(
        width: 8.0,
        height: 8.0,
        margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: length == i ? Colors.blueAccent : Colors.grey,
        ),
      ),
    ),
  );
}
