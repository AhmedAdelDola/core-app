part of '../../profile_imports.dart';

class WalletProfileItem extends StatelessWidget {
  const WalletProfileItem({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: di<WalletCubit>()..getWalletHistory(),
      child: BlocBuilder<WalletCubit, WalletState>(
        builder: (context, state) {
          final cubit = WalletCubit.of(context);
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
            decoration: BoxDecoration(
              color: const Color(0xFF10B981).withOpacity(0.08),
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(
                color: const Color(0xFF10B981).withOpacity(0.25),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppText(
                  '${cubit.wallet?.wallet?.balance ?? 0} ${cubit.wallet?.wallet?.currencyCode ?? 'ج.م'}',
                  style: TextStyle(
                    color: const Color(0xFF059669),
                    fontSize: 12.5.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                6.sbW,
                GestureDetector(
                  onTap: () {
                    if (cubit.isCodeAvailable) {
                      NamedNavigatorImpl.push(
                        ChargeWalletScreen(cubit: cubit),
                      );
                    } else {
                      NamedNavigatorImpl.push(
                        InAppPurchaseScreen(cubit: cubit),
                      );
                    }
                  },
                  child: Container(
                    width: 22.w,
                    height: 22.w,
                    decoration: const BoxDecoration(
                      color: Color(0xFF10B981),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 14,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
