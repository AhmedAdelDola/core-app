// part of '../../../profile_imports.dart';

// class ChargeWithVodafoneScreen extends StatefulWidget {
//   final int id;
//   final String title, accountNumber, title2, accountId;

//   const ChargeWithVodafoneScreen({
//     super.key,
//     required this.id,
//     required this.title,
//     required this.accountNumber,
//     required this.title2,
//     required this.accountId,
//   });

//   @override
//   State<ChargeWithVodafoneScreen> createState() => _ChargeWithVodafoneScreenState();
// }

// class _ChargeWithVodafoneScreenState extends State<ChargeWithVodafoneScreen> {
//   final formKey = GlobalKey<FormState>();
//   TextEditingController transferNumberController = TextEditingController();
//   TextEditingController amountController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: CustomAppBar(title: widget.title),
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
//           final cubit = WalletCubit.of(context);
//           return SingleChildScrollView(
//             padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
//             child: Form(
//               key: formKey,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     children: [
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           AppText(
//                             widget.title2,
//                             style: TextStyles.textViewBold(color: AppColors.textColor5),
//                           ),
//                           12.sbH,
//                           AppText(
//                             'رقم التحويل',
//                             style: TextStyles.textViewBold(color: AppColors.textColor5),
//                           ),
//                           12.sbH,
//                           AppText(
//                             widget.accountNumber,
//                             style: TextStyles.textViewBold(color: AppColors.textColor5),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                   20.sbH,
//                   UploadImgCard(cubit: cubit),
//                   20.sbH,
//                   AppText(
//                     'الرقم الذي قمت بالارسال منه',
//                     style: TextStyles.textViewRegular(color: AppColors.textColor5),
//                   ),
//                   12.sbH,
//                   MasterTextField(
//                     controller: transferNumberController,
//                     labelText: 'رقم التحويل',
//                     keyboardType: TextInputType.number,
//                     validate: Validator.defaultValidator,
//                   ),
//                   20.sbH,
//                   MasterTextField(
//                     controller: amountController,
//                     labelText: 'المبلغ',
//                     keyboardType: TextInputType.number,
//                     validate: Validator.defaultValidator,
//                   ),
//                   20.sbH,
//                   MasterButton(
//                     text: 'تأكيد',
//                     textColor: Colors.white,
//                     isLoading: state is ChargeWalletLoadingState,
//                     onPressed: () {
//                       if (formKey.currentState!.validate()) {
//                         if (cubit.image == null) {
//                           showErrorToast('برجاء اختيار صورة');
//                           return;
//                         } else {
//                           cubit.chargeWalletVodafone(
//                             amount: amountController.text,
//                             transferNumber: transferNumberController.text,
//                             paymentWayId: widget.id.toString(),
//                             accountId: widget.accountId,
//                           );
//                         }
//                       }
//                     },
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
