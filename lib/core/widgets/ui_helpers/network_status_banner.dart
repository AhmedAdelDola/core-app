import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../network/cubit/cubit.dart';
import '../../network/cubit/state.dart';

class NetworkStatusBanner extends StatefulWidget {
  final Widget child;
  const NetworkStatusBanner({super.key, required this.child});

  @override
  State<NetworkStatusBanner> createState() => _NetworkStatusBannerState();
}

class _NetworkStatusBannerState extends State<NetworkStatusBanner> {
  bool _isOffline = false;

  @override
  Widget build(BuildContext context) {
    return BlocListener<NetworkCubit, NetworkStates>(
      listenWhen: (p, c) =>
          c is AppInternetDisconnectedState || c is AppInternetRestoredState,
      listener: (context, state) {
        setState(() {
          _isOffline = state is AppInternetDisconnectedState;
        });
      },
      child: Stack(
        children: [
          widget.child,
          if (_isOffline)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: SafeArea(
                bottom: false,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: 30.h,
                  width: double.infinity,
                  color: Colors.orange.shade800,
                  alignment: Alignment.center,
                  child: Text(
                    '⚠️ الاتصال بالإنترنت ضعيف',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.none,
                      fontFamily: 'DINNextLT',
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
