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
          List model = ['charge with code'];
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
                  BottomSheetHelper.gShowModalBottomSheet(
                    context: context,
                    handleColor: AppColors.kPrimary,
                    maxHeight: MediaQuery.of(context).size.height * 0.4,
                    content: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Column(
                        children: [
                          if (model?.isNotEmpty ?? true)
                            ...List.generate(model?.length ?? 0, (i) {
                              return MasterButton(
                                margin: EdgeInsets.only(
                                  left: 20.sp,
                                  right: 20.sp,
                                  bottom: 10.sp,
                                ),
                                borderColor: AppColors.kGrayText,
                                buttonRadius: 12.sp,
                                buttonColor: AppColors.kWhite,
                                onPressed: () {
                                  NamedNavigatorImpl.pop();
                                  NamedNavigatorImpl.push(
                                    ChargeWalletScreen(cubit: cubit),
                                  );
                                },
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    AppText(
                                      model[i] ?? '',
                                      style: TextStyle(
                                        color: AppColors.kPrimary,
                                        fontSize: 14.sp,
                                        fontWeight: w600,
                                      ),
                                    ),
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      color: AppColors.kPrimary,
                                      size: 16,
                                    ),
                                  ],
                                ),
                              );
                            }),
                        ],
                      ),
                    ),
                  );
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
