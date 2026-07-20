import 'dart:io';
import 'package:elhanbly/core/navigator/named_navigator_impl.dart';
import 'package:elhanbly/core/services/di.dart';
import 'package:elhanbly/core/util/validator/validator.dart';
import 'in_app_purchase_screen.dart';
import 'package:elhanbly/core/widgets/app_buttons/master_button.dart';
import 'package:elhanbly/core/widgets/text_field/master_text_field.dart';
import 'package:elhanbly/core/widgets/ui_helpers/alert_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/theme/colors/app_colors.dart';
import '../../../../../../core/theme/theme.dart';
import '../../../../../../core/util/text_input_formatter.dart';
import '../../../../../../core/widgets/app_texts/app_text.dart';
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
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      50.sbH,
                      AppText(
                        'رصيدك الحالي',
                        style: TextStyle(
                          color: AppColors.textColor,
                          fontSize: 16.sp,
                          fontWeight: w600,
                        ),
                      ),
                      8.sbH,
                      AppText(
                        '${cubit.wallet?.wallet?.balance ?? 0} ${cubit.wallet?.wallet?.currencyCode ?? 'EGP'}',
                        style: TextStyle(
                          color: AppColors.kPrimary,
                          fontSize: 14.sp,
                          fontWeight: w600,
                        ),
                      ),
                      20.sbH,
                      MasterTextField(
                        controller: codeController,
                        labelText: 'Code',
                        keyboardType: TextInputType.text,
                        inputFormatters: [WalletCodeTextInputFormatter()],
                        validate: Validator.walletCode,
                      ),
                      20.sbH,
                      MasterButton(
                        text: 'تأكيد',
                        textColor: Colors.white,
                        onPressed: () {
                          if (formKey.currentState?.validate() ?? false) {
                            context.read<WalletCubit>().chargeWallet(
                              Code: codeController.text.trim().toUpperCase(),
                            );
                          }
                        },
                      ),
                      16.sbH,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AppText(
                            'أو ',
                            style: TextStyle(
                              color: AppColors.textColor2,
                              fontSize: 14.sp,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              NamedNavigatorImpl.push(
                                InAppPurchaseScreen(cubit: cubit),
                                replace: true,
                              );
                            },
                            child: AppText(
                              Platform.isIOS ? 'الشحن عبر App Store' : 'الشحن عبر Google Play',
                              style: TextStyle(
                                color: AppColors.kPrimary,
                                fontSize: 14.sp,
                                fontWeight: w600,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ),
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
}
