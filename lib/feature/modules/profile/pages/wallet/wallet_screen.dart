part of '../../profile_imports.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'المحفظة'),
      body: BlocProvider.value(
        value: di<WalletCubit>()..getWalletHistory(),
        child: BlocConsumer<WalletCubit, WalletState>(
          listener: (context, state) {
            if (state is GetWalletHistoryErrorState) {
              showErrorToast(state.error);
            }
          },
          builder: (context, state) {
            final cubit = WalletCubit.of(context);
            final model = cubit.wallet;
            if (state is GetWalletHistoryLoadingState) return const AppLoader();

            final currency = model?.wallet?.currencyCode ?? 'ج.م';
            final transactions = model?.transactions ?? [];

            return RefreshIndicator(
              onRefresh: () async {
                cubit.getWalletHistory();
              },
              color: AppColors.kPrimary,
              child: AdaptiveContainer(
                maxWidth: ResponsiveBreakpoints.maxCardWidth,
                child: CustomScrollView(
                  physics: const AlwaysScrollableScrollPhysics(
                    parent: BouncingScrollPhysics(),
                  ),
                  slivers: [
                  SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Hero Wallet Card
                        Container(
                          margin: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 14.h,
                          ),
                          padding: EdgeInsets.all(20.w),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppColors.kPrimary,
                                const Color(0xFF1E293B),
                                const Color(0xFF0F172A),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(20.r),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.kPrimary.withOpacity(0.25),
                                blurRadius: 16,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(8.r),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.12),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(
                                          Icons.account_balance_wallet_rounded,
                                          color: Colors.white,
                                          size: 18.sp,
                                        ),
                                      ),
                                      8.sbW,
                                      AppText(
                                        'المحفظة الإلكترونية',
                                        color: Colors.white.withOpacity(0.85),
                                        size: 13.sp,
                                        weight: FontWeight.w500,
                                      ),
                                    ],
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 10.w,
                                      vertical: 4.h,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.15),
                                      borderRadius: BorderRadius.circular(20.r),
                                    ),
                                    child: AppText(
                                      currency,
                                      color: Colors.white,
                                      size: 11.sp,
                                      weight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              16.sbH,
                              AppText(
                                'الرصيد المتاح',
                                color: Colors.white.withOpacity(0.7),
                                size: 12.sp,
                                weight: FontWeight.w400,
                              ),
                              6.sbH,
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.baseline,
                                textBaseline: TextBaseline.alphabetic,
                                children: [
                                  AppText(
                                    '${model?.wallet?.balance ?? "0.00"}',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 30.sp,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                  8.sbW,
                                  AppText(
                                    currency,
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.9),
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              20.sbH,
                              // Recharge Button
                              SizedBox(
                                width: double.infinity,
                                height: 44.h,
                                child: ElevatedButton.icon(
                                  onPressed: () {
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
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    foregroundColor: AppColors.kPrimary,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12.r),
                                    ),
                                  ),
                                  icon: Icon(
                                    Icons.add_circle_outline_rounded,
                                    size: 18.sp,
                                    color: AppColors.kPrimary,
                                  ),
                                  label: AppText(
                                    'شحن رصيد المحفظة',
                                    color: AppColors.kPrimary,
                                    size: 13.5.sp,
                                    weight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 18.w,
                            vertical: 8.h,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              AppText(
                                'سجل العمليات والمعاملات',
                                style: TextStyles.textViewBold(
                                  size: 16.sp,
                                  color: AppColors.textColor,
                                ),
                              ),
                              if (transactions.isNotEmpty)
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 8.w,
                                    vertical: 3.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF1F5F9),
                                    borderRadius: BorderRadius.circular(12.r),
                                  ),
                                  child: AppText(
                                    '${transactions.length} معاملة',
                                    color: AppColors.textColor4,
                                    size: 11.sp,
                                    weight: FontWeight.w500,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (transactions.isEmpty)
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 24.w,
                            vertical: 32.h,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.receipt_long_outlined,
                                size: 48.sp,
                                color: AppColors.textColor4.withOpacity(0.5),
                              ),
                              12.sbH,
                              AppText(
                                'لا توجد معاملات سابقة',
                                style: TextStyles.textViewBold(
                                  size: 15.sp,
                                  color: AppColors.textColor,
                                ),
                              ),
                              6.sbH,
                              AppText(
                                'ستظهر هنا تفاصيل عمليات الشحن والاشتراكات السابقة فور إتمامها.',
                                style: TextStyles.textViewRegular(
                                  fontSize: 12.5.sp,
                                  color: AppColors.textColor4,
                                ),
                                align: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  else
                    SliverPadding(
                      padding: EdgeInsets.only(bottom: 40.h),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final item = transactions[index];
                            return WalletHistoryItem(
                              item: item,
                              currency: currency,
                            );
                          },
                          childCount: transactions.length,
                        ),
                      ),
                    ),
                ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class WalletHistoryItem extends StatelessWidget {
  final Transaction item;
  final String currency;

  const WalletHistoryItem({
    super.key,
    required this.item,
    this.currency = 'ج.م',
  });

  @override
  Widget build(BuildContext context) {
    final bool isCredit = item.type == 'credit' ||
        item.type == 'deposit' ||
        item.type == 'charge' ||
        (double.tryParse(item.amount ?? '0') ?? 0) > 0;
    final double amountVal = (double.tryParse(item.amount ?? '0') ?? 0).abs();

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 5.h),
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: AppColors.kWhite,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: const Color(0xFFE2E8F0),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 42.w,
            height: 42.w,
            decoration: BoxDecoration(
              color: isCredit
                  ? const Color(0xFFECFDF5)
                  : const Color(0xFFFEF2F2),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Center(
              child: Icon(
                isCredit
                    ? Icons.arrow_downward_rounded
                    : Icons.arrow_upward_rounded,
                color: isCredit
                    ? const Color(0xFF10B981)
                    : const Color(0xFFEF4444),
                size: 20.sp,
              ),
            ),
          ),
          12.sbW,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  (item.description != null && item.description!.isNotEmpty)
                      ? item.description!
                      : (isCredit ? 'شحن رصيد' : 'عملية شراء / اشتراك'),
                  style: TextStyles.textViewBold(
                    size: 13.5.sp,
                    color: AppColors.textColor,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  align: TextAlign.start,
                ),
                4.sbH,
                AppText(
                  item.createdAt == null
                      ? ''
                      : DateFormat('yyyy-MM-dd • hh:mm a', 'en')
                          .format(item.createdAt!),
                  style: TextStyles.textViewRegular(
                    fontSize: 11.5.sp,
                    color: AppColors.textColor4,
                  ),
                  align: TextAlign.start,
                ),
              ],
            ),
          ),
          8.sbW,
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              AppText(
                '${isCredit ? "+" : "-"} $amountVal $currency',
                style: TextStyle(
                  color: isCredit
                      ? const Color(0xFF059669)
                      : const Color(0xFFDC2626),
                  fontSize: 13.5.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (item.balanceAfter != null && item.balanceAfter!.isNotEmpty) ...[
                2.sbH,
                AppText(
                  'الرصيد: ${item.balanceAfter}',
                  style: TextStyle(
                    color: AppColors.textColor4,
                    fontSize: 10.sp,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
