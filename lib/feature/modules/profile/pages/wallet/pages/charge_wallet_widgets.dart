import 'dart:io';
import 'package:elhanbly/core/navigator/named_navigator_impl.dart';
import 'package:elhanbly/core/services/di.dart';
import 'package:elhanbly/core/util/validator/validator.dart';
import 'package:elhanbly/core/widgets/app_bar/custom_curved_appbar.dart';
import 'in_app_purchase_screen.dart';
import 'package:elhanbly/core/widgets/app_buttons/master_button.dart';
import 'package:elhanbly/core/widgets/text_field/master_text_field.dart';
import 'package:elhanbly/core/widgets/ui_helpers/alert_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../../core/consts/images.dart';
import '../../../../../../core/theme/colors/app_colors.dart';
import '../../../../../../core/theme/theme.dart';
import '../../../../../../core/util/launcher.dart';
import '../../../../../../core/util/responsive/responsive_helper.dart';
import '../../../../../../core/util/text_input_formatter.dart';
import '../../../../../../core/widgets/app_texts/app_text.dart';
import '../../../../../../core/widgets/loader/app_loader.dart';
import '../../../../../../core/widgets/ui_helpers/extensions.dart';
import '../../../../../../core/widgets/ui_helpers/pick_image_dialog.dart';
import '../../../../../../core/widgets/ui_helpers/show_dialog.dart';
import '../../../cubit/wallet_cubit/wallet_cubit.dart';

class ChargeWalletScreen extends StatelessWidget {
  final WalletCubit cubit;
  const ChargeWalletScreen({super.key, required this.cubit});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final codeController = TextEditingController();

    return Scaffold(
      appBar: const CustomAppBar(title: 'شحن المحفظة'),
      body: BlocProvider.value(
        value: di<WalletCubit>()..getWalletHistory(),
        child: BlocConsumer<WalletCubit, WalletState>(
          listener: (context, state) {
            if (state is ChargeWalletSuccessState) {
              showSuccessToast(state.error);
              NamedNavigatorImpl.pop();
            }
            if (state is ChargeWalletErrorState) {
              showErrorToast(state.error);
            }
          },
          builder: (context, state) {
            final currency = cubit.wallet?.wallet?.currencyCode ?? 'ج.م';
            final isLoading = state is ChargeWalletLoadingState;

            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
              physics: const BouncingScrollPhysics(),
              child: AdaptiveContainer(
                maxWidth: ResponsiveBreakpoints.maxFormWidth,
                child: Form(
                  key: formKey,
                  child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Balance Summary Card
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(16.r),
                        border: Border.all(
                          color: const Color(0xFFE2E8F0),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 48.w,
                            height: 48.w,
                            decoration: BoxDecoration(
                              color: const Color(0xFFECFDF5),
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Center(
                              child: Icon(
                                Icons.account_balance_wallet_rounded,
                                color: const Color(0xFF10B981),
                                size: 24.sp,
                              ),
                            ),
                          ),
                          14.sbW,
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AppText(
                                  'رصيدك الحالي بالمحفظة',
                                  style: TextStyles.textViewRegular(
                                    fontSize: 12.sp,
                                    color: AppColors.textColor4,
                                  ),
                                  align: TextAlign.start,
                                ),
                                4.sbH,
                                AppText(
                                  '${cubit.wallet?.wallet?.balance ?? 0} $currency',
                                  style: TextStyle(
                                    color: const Color(0xFF059669),
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  align: TextAlign.start,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    24.sbH,

                    // Card Input Container
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(18.w),
                      decoration: BoxDecoration(
                        color: AppColors.kWhite,
                        borderRadius: BorderRadius.circular(16.r),
                        border: Border.all(
                          color: const Color(0xFFE2E8F0),
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.02),
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(8.r),
                                decoration: BoxDecoration(
                                  color: AppColors.kPrimary.withOpacity(0.08),
                                  borderRadius: BorderRadius.circular(10.r),
                                ),
                                child: Icon(
                                  Icons.confirmation_number_outlined,
                                  color: AppColors.kPrimary,
                                  size: 20.sp,
                                ),
                              ),
                              10.sbW,
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    AppText(
                                      'إدخال كود الشحن',
                                      style: TextStyles.textViewBold(
                                        size: 15.sp,
                                        color: AppColors.textColor,
                                      ),
                                      align: TextAlign.start,
                                    ),
                                    2.sbH,
                                    AppText(
                                      'أدخل كود الكارت لإضافة الرصيد فوراً',
                                      style: TextStyles.textViewRegular(
                                        fontSize: 11.5.sp,
                                        color: AppColors.textColor4,
                                      ),
                                      align: TextAlign.start,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          16.sbH,
                          MasterTextField(
                            controller: codeController,
                            labelText: 'كود الشحن',
                            hintText: 'أدخل كود الكارت هنا',
                            keyboardType: TextInputType.text,
                            inputFormatters: [WalletCodeTextInputFormatter()],
                            validate: Validator.walletCode,
                            prefixWidget: Icon(
                              Icons.vpn_key_outlined,
                              color: AppColors.kPrimary,
                              size: 20.sp,
                            ),
                            suffixWidget: IconButton(
                              icon:  Icon(
                                Icons.content_paste_rounded,
                                color: AppColors.kPrimary,
                              ),
                              tooltip: 'لصق الكود',
                              onPressed: () async {
                                final data = await Clipboard.getData('text/plain');
                                if (data?.text != null && data!.text!.isNotEmpty) {
                                  codeController.text =
                                      data.text!.trim().toUpperCase();
                                }
                              },
                            ),
                          ),
                          20.sbH,
                          if (isLoading)
                            const Center(child: AppLoader())
                          else
                            MasterButton(
                              text: 'تأكيد وشحن الرصيد',
                              textColor: Colors.white,
                              buttonRadius: 12.r,
                              height: 50.h,
                              onPressed: () {
                                if (formKey.currentState?.validate() ?? false) {
                                  context.read<WalletCubit>().chargeWallet(
                                    Code: codeController.text.trim().toUpperCase(),
                                  );
                                }
                              },
                            ),
                        ],
                      ),
                    ),
                    24.sbH,

                    // Instructions & Alternative Payment Box
                    
                  ],
                ),
              ),
            ),
          );
          },
        ),
      ),
    );
  }

  Widget _buildInstructionRow(IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 15.sp,
          color: AppColors.textColor4,
        ),
        8.sbW,
        Expanded(
          child: AppText(
            text,
            style: TextStyles.textViewRegular(
              fontSize: 12.sp,
              color: AppColors.textColor4,
            ),
            align: TextAlign.start,
          ),
        ),
      ],
    );
  }
}
