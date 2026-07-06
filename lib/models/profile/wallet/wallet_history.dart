class WalletResponse {
    Wallet? wallet;
    List<Transaction>? transactions;

    WalletResponse({
        this.wallet,
        this.transactions,
    });

    factory WalletResponse.fromJson(Map<String, dynamic> json) => WalletResponse(
        wallet: json["wallet"] == null ? null : Wallet.fromJson(json["wallet"]),
        transactions: json["transactions"] == null ? [] : List<Transaction>.from(json["transactions"]!.map((x) => Transaction.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "wallet": wallet?.toJson(),
        "transactions": transactions == null ? [] : List<dynamic>.from(transactions!.map((x) => x.toJson())),
    };
}

class Transaction {
    int? id;
    int? tenantId;
    int? walletId;
    int? studentId;
    String? type;
    String? amount;
    String? balanceBefore;
    String? balanceAfter;
    String? referenceType;
    int? referenceId;
    String? description;
    dynamic createdBy;
    DateTime? createdAt;
    DateTime? updatedAt;

    Transaction({
        this.id,
        this.tenantId,
        this.walletId,
        this.studentId,
        this.type,
        this.amount,
        this.balanceBefore,
        this.balanceAfter,
        this.referenceType,
        this.referenceId,
        this.description,
        this.createdBy,
        this.createdAt,
        this.updatedAt,
    });

    factory Transaction.fromJson(Map<String, dynamic> json) => Transaction(
        id: json["id"],
        tenantId: json["tenant_id"],
        walletId: json["wallet_id"],
        studentId: json["student_id"],
        type: json["type"],
        amount: json["amount"],
        balanceBefore: json["balance_before"],
        balanceAfter: json["balance_after"],
        referenceType: json["reference_type"],
        referenceId: json["reference_id"],
        description: json["description"],
        createdBy: json["created_by"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "tenant_id": tenantId,
        "wallet_id": walletId,
        "student_id": studentId,
        "type": type,
        "amount": amount,
        "balance_before": balanceBefore,
        "balance_after": balanceAfter,
        "reference_type": referenceType,
        "reference_id": referenceId,
        "description": description,
        "created_by": createdBy,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
    };
}

class Wallet {
    int? id;
    int? tenantId;
    int? studentId;
    String? balance;
    String? currencyCode;
    DateTime? createdAt;
    DateTime? updatedAt;

    Wallet({
        this.id,
        this.tenantId,
        this.studentId,
        this.balance,
        this.currencyCode,
        this.createdAt,
        this.updatedAt,
    });

    factory Wallet.fromJson(Map<String, dynamic> json) => Wallet(
        id: json["id"],
        tenantId: json["tenant_id"],
        studentId: json["student_id"],
        balance: json["balance"],
        currencyCode: json["currency_code"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "tenant_id": tenantId,
        "student_id": studentId,
        "balance": balance,
        "currency_code": currencyCode,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
    };
}
