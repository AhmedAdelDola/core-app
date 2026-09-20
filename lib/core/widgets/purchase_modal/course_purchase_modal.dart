import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../feature/modules/profile/cubit/wallet_cubit/wallet_cubit.dart';
import '../../../feature/modules/profile/pages/wallet/pages/charge_wallet_widgets.dart';
import '../../../feature/modules/profile/pages/wallet/pages/in_app_purchase_screen.dart';
import '../../consts/strings.dart';
import '../../navigator/named_navigator_impl.dart';
import '../../services/di.dart';
import '../../theme/colors/app_colors.dart';
import '../../theme/theme.dart';
import '../../util/text_input_formatter.dart';
import '../app_buttons/master_button.dart';
import '../app_texts/app_text.dart';
import '../text_field/master_text_field.dart';
import '../ui_helpers/alert_message.dart';
import '../ui_helpers/extensions.dart';

enum PurchaseTargetType { course, session }

class CoursePurchaseModal extends StatefulWidget {
  final PurchaseTargetType type;
  final String id;
  final String title;
  final String price;
  final VoidCallback? onSuccess;

  const CoursePurchaseModal({
    super.key,
    required this.type,
    required this.id,
    required this.title,
    required this.price,
    this.onSuccess,
  });

  static Future<bool?> show({
    required BuildContext context,
    required PurchaseTargetType type,
    required String id,
    required String title,
    required String price,
    VoidCallback? onSuccess,
  }) {
    return showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return CoursePurchaseModal(
          type: type,
          id: id,
          title: title,
          price: price,
          onSuccess: onSuccess,
        );
      },
    );
  }

  @override
  State<CoursePurchaseModal> createState() => _CoursePurchaseModalState();
}

class _CoursePurchaseModalState extends State<CoursePurchaseModal> {
  int _selectedTabIndex = 0; // 0: Wallet, 1: Code
  final TextEditingController _codeController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final cubit = di<WalletCubit>();
    if (cubit.wallet == null) {
      cubit.getWalletHistory();
    }
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _handlePurchaseWithWallet(WalletCubit walletCubit) async {
    setState(() => _isLoading = true);
    bool success = false;

    if (widget.type == PurchaseTargetType.course) {
      success = await walletCubit.purchaseCourse(
        courseId: widget.id,
        paymentMethod: 'wallet',
      );
    } else {
      success = await walletCubit.purchaseSession(
        sessionId: widget.id,
        paymentMethod: 'wallet',
      );
    }

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (success) {
      widget.onSuccess?.call();
      Navigator.of(context).pop(true);
    }
  }

  Future<void> _handlePurchaseWithCode(WalletCubit walletCubit) async {
    final code = _codeController.text.trim();
    if (code.isEmpty) {
      showErrorToast(Strings.pleaseEnterCode);
      return;
    }

    setState(() => _isLoading = true);
    bool success = false;

    if (widget.type == PurchaseTargetType.course) {
      success = await walletCubit.purchaseCourse(
        courseId: widget.id,
        paymentMethod: 'code',
        code: code,
      );
    } else {
      success = await walletCubit.purchaseSession(
        sessionId: widget.id,
        paymentMethod: 'code',
        code: code,
      );
    }

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (success) {
      widget.onSuccess?.call();
      Navigator.of(context).pop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final itemPrice = double.tryParse(widget.price) ?? 0.0;
    final priceLabel = itemPrice > 0 ? '$itemPrice ${Strings.egp}' : Strings.free;

    return BlocProvider.value(
      value: di<WalletCubit>(),
      child: BlocConsumer<WalletCubit, WalletState>(
        listener: (context, state) {
          if (state is PurchaseProductSuccessState) {
            showSuccessToast(state.message);
          } else if (state is PurchaseProductErrorState) {
            showErrorToast(state.error);
          }
        },
        builder: (context, state) {
          final walletCubit = context.read<WalletCubit>();
          final walletBalance = double.tryParse(
                '${walletCubit.wallet?.wallet?.balance ?? '0'}',
              ) ??
              0.0;
          final isBalanceSufficient = walletBalance >= itemPrice;

          return Container(
            padding: EdgeInsets.only(
              bottom: bottomInset > 0 ? bottomInset + 16.h : 24.h,
              top: 12.h,
              left: 20.w,
              right: 20.w,
            ),
            decoration: BoxDecoration(
              color: AppColors.kWhite,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24.r),
                topRight: Radius.circular(24.r),
              ),
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Top Drag Handle
                  Center(
                    child: Container(
                      width: 44.w,
                      height: 4.h,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(2.r),
                      ),
                    ),
                  ),
                  12.sbH,

                  // Header with Title and Close button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: AppText(
                          widget.type == PurchaseTargetType.course
                              ? Strings.purchaseTitleCourse
                              : Strings.purchaseTitleSession,
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: w700,
                            color: AppColors.textColor,
                          ),
                          align: TextAlign.start,
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.close_rounded),
                        color: AppColors.textColor2,
                        splashRadius: 20.r,
                      ),
                    ],
                  ),
                  8.sbH,

                  // Item Info Card
                  Container(
                    padding: EdgeInsets.all(14.w),
                    decoration: BoxDecoration(
                      color: AppColors.kPrimary.withOpacity(0.06),
                      borderRadius: BorderRadius.circular(14.r),
                      border: Border.all(
                        color: AppColors.kPrimary.withOpacity(0.15),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AppText(
                                widget.title,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 15.sp,
                                  fontWeight: w600,
                                  color: AppColors.textColor,
                                ),
                                align: TextAlign.start,
                              ),
                            ],
                          ),
                        ),
                        12.sbW,
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12.w,
                            vertical: 6.h,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.kPrimary,
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          child: AppText(
                            priceLabel,
                            style: TextStyle(
                              color: AppColors.kWhite,
                              fontSize: 14.sp,
                              fontWeight: w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  16.sbH,

                  // Tab Selector
                  Container(
                    padding: EdgeInsets.all(4.w),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: _buildTabButton(
                            title: Strings.walletTab,
                            icon: Icons.account_balance_wallet_outlined,
                            isSelected: _selectedTabIndex == 0,
                            onTap: () => setState(() => _selectedTabIndex = 0),
                          ),
                        ),
                        Expanded(
                          child: _buildTabButton(
                            title: Strings.codeTab,
                            icon: Icons.vpn_key_outlined,
                            isSelected: _selectedTabIndex == 1,
                            onTap: () => setState(() => _selectedTabIndex = 1),
                          ),
                        ),
                      ],
                    ),
                  ),
                  20.sbH,

                  // Tab Content
                  if (_selectedTabIndex == 0)
                    _buildWalletTabContent(
                      context,
                      walletCubit,
                      walletBalance,
                      itemPrice,
                      isBalanceSufficient,
                    )
                  else
                    _buildCodeTabContent(context, walletCubit),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTabButton({
    required String title,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(vertical: 10.h),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.kWhite : Colors.transparent,
          borderRadius: BorderRadius.circular(10.r),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 18.sp,
              color: isSelected ? AppColors.kPrimary : AppColors.textColor2,
            ),
            6.sbW,
            AppText(
              title,
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: isSelected ? w600 : w400,
                color: isSelected ? AppColors.kPrimary : AppColors.textColor2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWalletTabContent(
    BuildContext context,
    WalletCubit walletCubit,
    double walletBalance,
    double itemPrice,
    bool isBalanceSufficient,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Balance Display Box
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    Strings.currentBalance,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: AppColors.textColor2,
                    ),
                  ),
                  4.sbH,
                  AppText(
                    '$walletBalance ${walletCubit.wallet?.wallet?.currencyCode ?? Strings.egp}',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: w700,
                      color: isBalanceSufficient ? AppColors.kGreen : AppColors.kRed,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  AppText(
                    Strings.requiredAmount,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: AppColors.textColor2,
                    ),
                  ),
                  4.sbH,
                  AppText(
                    itemPrice > 0 ? '$itemPrice ${Strings.egp}' : Strings.free,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: w700,
                      color: AppColors.textColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        16.sbH,

        if (!isBalanceSufficient && itemPrice > 0) ...[
          // Insufficient balance warning
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: AppColors.kRed.withOpacity(0.08),
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(color: AppColors.kRed.withOpacity(0.2)),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: AppColors.kRed, size: 20.sp),
                8.sbW,
                Expanded(
                  child: AppText(
                    Strings.insufficientBalance,
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: AppColors.kRed,
                      fontWeight: w500,
                    ),
                    align: TextAlign.start,
                  ),
                ),
              ],
            ),
          ),
          16.sbH,
          MasterButton(
            text: Strings.chargeWalletNow,
            textColor: Colors.white,
            onPressed: () {
              Navigator.of(context).pop();
              NamedNavigatorImpl.push(
                walletCubit.isCodeAvailable
                    ? ChargeWalletScreen(cubit: walletCubit)
                    : InAppPurchaseScreen(cubit: walletCubit),
              );
            },
          ),
        ] else ...[
          MasterButton(
            text: Strings.confirmWalletPurchase,
            textColor: Colors.white,
            isLoading: _isLoading,
            onPressed: _isLoading ? null : () => _handlePurchaseWithWallet(walletCubit),
          ),
        ],
      ],
    );
  }

  Widget _buildCodeTabContent(BuildContext context, WalletCubit walletCubit) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppText(
            'أدخل كود التفعيل المباشر الخاص بالكورس أو الحصة لتفعيل اشتراكك فوراً:',
            style: TextStyle(
              fontSize: 13.sp,
              color: AppColors.textColor2,
              height: 1.4,
            ),
            align: TextAlign.start,
          ),
          14.sbH,
          MasterTextField(
            controller: _codeController,
            labelText: Strings.enterActivationCode,
            hintText: Strings.codeHint,
            keyboardType: TextInputType.text,
            inputFormatters: [WalletCodeTextInputFormatter()],
            prefixWidget: Icon(
              Icons.vpn_key_rounded,
              color: AppColors.kPrimary,
              size: 20.sp,
            ),
          ),
          18.sbH,
          MasterButton(
            text: Strings.activateCodeBtn,
            textColor: Colors.white,
            isLoading: _isLoading,
            onPressed: _isLoading ? null : () => _handlePurchaseWithCode(walletCubit),
          ),
        ],
      ),
    );
  }
}
