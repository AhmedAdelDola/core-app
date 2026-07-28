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
          return Row(
            children: [
              AppText(
                '${cubit.wallet?.wallet?.balance ?? 0} ${cubit.wallet?.wallet?.currencyCode ?? 'EGP'}',
                style: TextStyle(
                  color: AppColors.kPrimary,
                  fontSize: 14.sp,
                  fontWeight: w600,
                ),
              ),
              8.sbW,
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
                  width: 30.w,
                  height: 30.h,
                  decoration: BoxDecoration(
                    color: AppColors.kPrimary,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.add, color: AppColors.kWhite),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
