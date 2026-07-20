class StoreProductsResponse {
  final List<StoreProduct>? products;

  StoreProductsResponse({this.products});

  factory StoreProductsResponse.fromJson(Map<String, dynamic> json) => StoreProductsResponse(
        products: json["products"] == null
            ? []
            : List<StoreProduct>.from(
                json["products"]!.map((x) => StoreProduct.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "products": products == null
            ? []
            : List<dynamic>.from(products!.map((x) => x.toJson())),
      };
}

class StoreProduct {
  final String? key;
  final num? creditAmount;
  final String? currencyCode;

  StoreProduct({
    this.key,
    this.creditAmount,
    this.currencyCode,
  });

  factory StoreProduct.fromJson(Map<String, dynamic> json) => StoreProduct(
        key: json["key"],
        creditAmount: json["credit_amount"] is num ? json["credit_amount"] : null,
        currencyCode: json["currency_code"],
      );

  Map<String, dynamic> toJson() => {
        "key": key,
        "credit_amount": creditAmount,
        "currency_code": currencyCode,
      };
}
