// part of '../../../profile_imports.dart';

// class ChargeWithAppleScreen extends StatefulWidget {
//   const ChargeWithAppleScreen({super.key});

//   @override
//   State<ChargeWithAppleScreen> createState() => _ChargeWithAppleScreenState();
// }

// class _ChargeWithAppleScreenState extends State<ChargeWithAppleScreen> {
//   String os = Platform.operatingSystem;

//   final formKey = GlobalKey<FormState>();

//   TextEditingController amountController = TextEditingController();

//   String amount = '0';

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: CustomAppBar(
//           title: os == 'ios' ? 'الدفع عبر Apple Pay' : 'الدفع عبر Google Pay'),
//       body: BlocConsumer<WalletCubit, WalletState>(
//         listener: (context, state) {
//           if (state is ChargeWalletSuccessState) {
//             showSuccessToast(state.error);
//             NamedNavigatorImpl.pop();
//           }
//           if (state is ChargeWalletErrorState) {
//             showErrorToast(state.error);
//           }
//         },
//         builder: (context, state) {
//           return SingleChildScrollView(
//             padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
//             child: Form(
//               key: formKey,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   MasterTextField(
//                     controller: amountController,
//                     labelText: 'المبلغ',
//                     keyboardType: TextInputType.number,
//                     validate: Validator.defaultValidator,
//                   ),
//                   20.sbH,
//                   Padding(
//                     padding: const EdgeInsets.all(10),
//                     child: Center(
//                       child: ValueListenableBuilder<TextEditingValue>(
//                         valueListenable: amountController,
//                         builder: (context, value, _) {
//                           final payAmount = formatAmount(value.text);
//                           final isValid = num.tryParse(payAmount) != null &&
//                               num.parse(payAmount) > 0;

//                           final applePayButton = ApplePayButton(
//                             paymentConfiguration:
//                                 PaymentConfiguration.fromJsonString(
//                                     defaultApplePay),
//                             paymentItems: [
//                               PaymentItem(
//                                 label: 'Total',
//                                 amount: payAmount,
//                                 status: PaymentItemStatus.final_price,
//                               )
//                             ],
//                             style: ApplePayButtonStyle.black,
//                             width: double.infinity,
//                             height: 50,
//                             type: ApplePayButtonType.buy,
//                             margin: const EdgeInsets.only(top: 15.0),
//                             onPaymentResult: (result) =>
//                                 showSuccessToast(result.toString()),
//                             loadingIndicator: const Center(
//                               child: CircularProgressIndicator(),
//                             ),
//                           );

//                           final googlePayButton = GooglePayButton(
//                             paymentConfiguration:
//                                 PaymentConfiguration.fromJsonString(
//                                     defaultGooglePay),
//                             paymentItems: [
//                               PaymentItem(
//                                 label: 'Total',
//                                 amount: payAmount,
//                                 status: PaymentItemStatus.final_price,
//                               )
//                             ],
//                             cornerRadius: 5,
//                             type: GooglePayButtonType.pay,
//                             width: MediaQuery.of(context).size.width * 0.75,
//                             theme: GooglePayButtonTheme.dark,
//                             margin: const EdgeInsets.only(top: 15.0),
//                             onPressed: isValid
//                                 ? () {
//                                     print('Paying amount: $payAmount');
//                                   }
//                                 : null, // disables button if invalid
//                             onPaymentResult: (result) =>
//                                 showSuccessToast(result.toString()),
//                             onError: (error) {
//                               debugPrint('Payment Error: $error');
//                               showErrorToast(error.toString());
//                             },
//                             loadingIndicator: const Center(
//                               child: CircularProgressIndicator(),
//                             ),
//                           );

//                           return Platform.isIOS
//                               ? applePayButton
//                               : googlePayButton;
//                         },
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }

//   String formatAmount(String value) {
//     if (value.isEmpty) return '0.00';
//     final num? parsed = num.tryParse(value);
//     if (parsed == null) return '0.00';
//     return parsed.toStringAsFixed(2);
//   }
// }
