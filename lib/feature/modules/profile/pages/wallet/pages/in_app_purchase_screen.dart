import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import '../../../../../../core/navigator/named_navigator_impl.dart';
import '../../../../../../core/theme/colors/app_colors.dart';
import '../../../../../../core/theme/theme.dart';
import '../../../../../../core/widgets/app_bar/custom_curved_appbar.dart';
import '../../../../../../core/widgets/app_buttons/master_button.dart';
import '../../../../../../core/widgets/app_texts/app_text.dart';
import '../../../../../../core/widgets/loader/app_loader.dart';
import '../../../../../../core/widgets/ui_helpers/alert_message.dart';
import '../../../../../../core/widgets/ui_helpers/extensions.dart';
import '../../../../../../models/profile/wallet/store_products.dart';
import '../../../cubit/wallet_cubit/wallet_cubit.dart';

class InAppPurchaseScreen extends StatefulWidget {
  final WalletCubit cubit;
  const InAppPurchaseScreen({super.key, required this.cubit});

  @override
  State<InAppPurchaseScreen> createState() => _InAppPurchaseScreenState();
}

class _InAppPurchaseScreenState extends State<InAppPurchaseScreen> {
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  late StreamSubscription<List<PurchaseDetails>> _subscription;
  List<ProductDetails> _storeProductsDetails = [];
  bool _iapAvailable = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    
    // Subscribe to purchase stream
    final Stream<List<PurchaseDetails>> purchaseUpdated = _inAppPurchase.purchaseStream;
    _subscription = purchaseUpdated.listen(
      (purchaseDetailsList) {
        _listenToPurchaseUpdated(purchaseDetailsList);
      },
      onDone: () {
        _subscription.cancel();
      },
      onError: (error) {
        showErrorToast(error.toString());
      },
    );

    // Initialize store and fetch products
    _initStoreAndFetch();
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  Future<void> _initStoreAndFetch() async {
    setState(() {
      _isLoading = true;
    });

    // 1. Fetch products list from backend
    await widget.cubit.getStoreProducts();

    // 2. Check if IAP is available
    final bool available = await _inAppPurchase.isAvailable();
    setState(() {
      _iapAvailable = available;
    });

    if (available && widget.cubit.storeProducts?.products != null) {
      // 3. Prepare product IDs to query from App Store / Google Play
      final Set<String> queryIds = {};
      for (var p in widget.cubit.storeProducts!.products!) {
        if (p.key != null && p.key!.isNotEmpty) {
          queryIds.add(p.key!);
          queryIds.add("com.tenant.${p.key!}"); // standard format
        }
      }

      try {
        final ProductDetailsResponse response =
            await _inAppPurchase.queryProductDetails(queryIds);
        
        if (response.notFoundIDs.isNotEmpty) {
          debugPrint('IAP NotFoundIDs: ${response.notFoundIDs}');
        }

        setState(() {
          _storeProductsDetails = response.productDetails;
        });
      } catch (e) {
        debugPrint('Error querying product details: $e');
      }
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
    for (var purchaseDetails in purchaseDetailsList) {
      if (purchaseDetails.status == PurchaseStatus.pending) {
        setState(() {
          _isLoading = true;
        });
      } else {
        if (purchaseDetails.status == PurchaseStatus.error) {
          setState(() {
            _isLoading = false;
          });
          showErrorToast(purchaseDetails.error?.message ?? "حدث خطأ أثناء عملية الشراء");
        } else if (purchaseDetails.status == PurchaseStatus.purchased ||
            purchaseDetails.status == PurchaseStatus.restored) {
          _verifyPurchase(purchaseDetails);
        } else if (purchaseDetails.status == PurchaseStatus.canceled) {
          setState(() {
            _isLoading = false;
          });
          showErrorToast("تم إلغاء عملية الشراء");
        }
        
        if (purchaseDetails.pendingCompletePurchase) {
          _inAppPurchase.completePurchase(purchaseDetails);
        }
      }
    }
  }

  void _verifyPurchase(PurchaseDetails purchaseDetails) {
    final provider = Platform.isIOS ? 'apple_app_store' : 'google_play';
    final productId = purchaseDetails.productID;
    
    // Find matching backend product to determine credit value
    final matchedProduct = widget.cubit.storeProducts?.products?.firstWhere(
      (p) => productId.endsWith(p.key ?? ''),
      orElse: () => StoreProduct(key: '', creditAmount: 0, currencyCode: ''),
    );

    final num value = matchedProduct?.creditAmount ?? 0;

    final Map<String, dynamic> body = {
      'provider': provider,
      'product_id': productId,
      'value': value,
    };

    if (Platform.isIOS) {
      body['transaction_id'] = purchaseDetails.purchaseID;
    } else {
      body['purchase_token'] = purchaseDetails.verificationData.serverVerificationData;
    }

    widget.cubit.verifyStorePurchase(
      data: body,
      onSuccess: () {
        setState(() {
          _isLoading = false;
        });
        showSuccessToast("تم شحن الرصيد بنجاح");
        NamedNavigatorImpl.pop();
      },
    );
  }

  void _buyProduct(String productKey) {
    // Attempt to find registered product details matching the key or com.tenant.key
    ProductDetails? details;
    for (var d in _storeProductsDetails) {
      if (d.id == productKey || d.id == "com.tenant.$productKey") {
        details = d;
        break;
      }
    }

    if (details != null) {
      final PurchaseParam purchaseParam = PurchaseParam(productDetails: details);
      _inAppPurchase.buyConsumable(purchaseParam: purchaseParam);
    } else {
      // Fallback/Simulated or direct buy if details not fetched (e.g. Sandbox is slow)
      // Since Google Play / App Store requires product details from query, we display warning
      showErrorToast("لم يتم العثور على المنتج في المتجر حالياً. يرجى المحاولة لاحقاً.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: widget.cubit,
      child: BlocConsumer<WalletCubit, WalletState>(
        listener: (context, state) {
          if (state is VerifyStorePurchaseErrorState) {
            setState(() {
              _isLoading = false;
            });
            showErrorToast(state.error);
          }
        },
        builder: (context, state) {
          final balance = widget.cubit.wallet?.wallet?.balance ?? '0';
          final currency = widget.cubit.wallet?.wallet?.currencyCode ?? 'EGP';
          final productsList = widget.cubit.storeProducts?.products ?? [];

          return Scaffold(
            appBar: CustomAppBar(
              title: Platform.isIOS ? 'شحن عبر App Store' : 'شحن عبر Google Play',
            ),
            body: Stack(
              children: [
                SingleChildScrollView(
                  padding: EdgeInsets.all(20.sp),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Balance Card
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(24.sp),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppColors.kPrimary,
                              AppColors.kPrimary.withOpacity(0.8),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(16.sp),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.kPrimary.withOpacity(0.3),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            )
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppText(
                              'رصيدك الحالي',
                              style: TextStyle(
                                color: AppColors.kWhite.withOpacity(0.9),
                                fontSize: 14.sp,
                                fontWeight: w400,
                              ),
                            ),
                            8.sbH,
                            AppText(
                              '$balance $currency',
                              style: TextStyle(
                                color: AppColors.kWhite,
                                fontSize: 24.sp,
                                fontWeight: w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                      24.sbH,
                      AppText(
                        'اختر باقة الشحن المناسبة',
                        style: TextStyle(
                          color: AppColors.textColor,
                          fontSize: 16.sp,
                          fontWeight: w600,
                        ),
                      ),
                      16.sbH,
                      if (!_isLoading && productsList.isEmpty)
                        Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 40.h),
                            child: AppText(
                              'لا توجد باقات متاحة حالياً',
                              style: TextStyle(
                                color: AppColors.kGrayText,
                                fontSize: 14.sp,
                              ),
                            ),
                          ),
                        )
                      else
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: productsList.length,
                          separatorBuilder: (context, index) => 12.sbH,
                          itemBuilder: (context, index) {
                            final product = productsList[index];
                            final String? key = product.key;
                            final num amount = product.creditAmount ?? 0;
                            final String currencyCode = product.currencyCode ?? 'EGP';

                            // Try to find matching ProductDetails for localized price
                            ProductDetails? details;
                            for (var d in _storeProductsDetails) {
                              if (d.id == key || d.id == "com.tenant.$key") {
                                details = d;
                                break;
                              }
                            }

                            final String displayPrice =
                                details != null ? details.price : '$amount $currencyCode';

                            return Container(
                              padding: EdgeInsets.all(16.sp),
                              decoration: BoxDecoration(
                                color: AppColors.kWhite,
                                borderRadius: BorderRadius.circular(12.sp),
                                border: Border.all(
                                  color: AppColors.borderColor.withOpacity(0.5),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.kBlack.withOpacity(0.02),
                                    blurRadius: 5,
                                    offset: const Offset(0, 2),
                                  )
                                ],
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 48.w,
                                    height: 48.h,
                                    decoration: BoxDecoration(
                                      color: AppColors.kPrimary.withOpacity(0.1),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.account_balance_wallet_outlined,
                                      color: AppColors.kPrimary,
                                      size: 24.sp,
                                    ),
                                  ),
                                  16.sbW,
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        AppText(
                                          'شحن رصيد بقيمة $amount $currencyCode',
                                          style: TextStyle(
                                            color: AppColors.textColor,
                                            fontSize: 14.sp,
                                            fontWeight: w600,
                                          ),
                                        ),
                                        4.sbH,
                                        AppText(
                                          'أضف $amount إلى رصيد محفظتك',
                                          style: TextStyle(
                                            color: AppColors.kGrayText,
                                            fontSize: 12.sp,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: 100.w,
                                    height: 38.h,
                                    child: MasterButton(
                                      text: displayPrice,
                                      textColor: AppColors.kWhite,
                                      buttonRadius: 20.sp,
                                      onPressed: () {
                                        if (key != null) {
                                          _buyProduct(key);
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                    ],
                  ),
                ),
                if (_isLoading)
                  Container(
                    color: AppColors.kBlack.withOpacity(0.3),
                    child: const Center(
                      child: AppLoader(),
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
