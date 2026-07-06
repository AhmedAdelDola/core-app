import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../../../../../core/consts/images.dart';

class Commitment extends StatelessWidget {
  const Commitment({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Lottie.asset(AppJsonFiles.emptyState, fit: BoxFit.fill));
  }
}
