class UserModelResponse {
    Student? student;
    State? state;
    Wallet? wallet;

    UserModelResponse({
        this.student,
        this.state,
        this.wallet,
    });

    factory UserModelResponse.fromJson(Map<String, dynamic> json) => UserModelResponse(
        student: json["student"] == null ? null : Student.fromJson(json["student"]),
        state: json["state"] == null ? null : State.fromJson(json["state"]),
        wallet: json["wallet"] == null ? null : Wallet.fromJson(json["wallet"]),
    );

    Map<String, dynamic> toJson() => {
        "student": student?.toJson(),
        "state": state?.toJson(),
        "wallet": wallet?.toJson(),
    };
}

class State {
    String? status;
    dynamic blockedReason;
    dynamic bannedUntil;

    State({
        this.status,
        this.blockedReason,
        this.bannedUntil,
    });

    factory State.fromJson(Map<String, dynamic> json) => State(
        status: json["status"],
        blockedReason: json["blocked_reason"],
        bannedUntil: json["banned_until"],
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "blocked_reason": blockedReason,
        "banned_until": bannedUntil,
    };
}

class Student {
    int? id;
    int? tenantId;
    int? levelId;
    String? name;
    String? phone;
    String? email;
    dynamic imageMediaAssetId;
    String? status;
    DateTime? approvedAt;
    dynamic bannedUntil;
    DateTime? createdAt;
    DateTime? updatedAt;
    dynamic imageUrl;
    Level? level;
    dynamic image;

    Student({
        this.id,
        this.tenantId,
        this.levelId,
        this.name,
        this.phone,
        this.email,
        this.imageMediaAssetId,
        this.status,
        this.approvedAt,
        this.bannedUntil,
        this.createdAt,
        this.updatedAt,
        this.imageUrl,
        this.level,
        this.image,
    });

    factory Student.fromJson(Map<String, dynamic> json) => Student(
        id: json["id"],
        tenantId: json["tenant_id"],
        levelId: json["level_id"],
        name: json["name"],
        phone: json["phone"],
        email: json["email"],
        imageMediaAssetId: json["image_media_asset_id"],
        status: json["status"],
        approvedAt: json["approved_at"] == null ? null : DateTime.parse(json["approved_at"]),
        bannedUntil: json["banned_until"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        imageUrl: json["image_url"],
        level: json["level"] == null ? null : Level.fromJson(json["level"]),
        image: json["image"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "tenant_id": tenantId,
        "level_id": levelId,
        "name": name,
        "phone": phone,
        "email": email,
        "image_media_asset_id": imageMediaAssetId,
        "status": status,
        "approved_at": approvedAt?.toIso8601String(),
        "banned_until": bannedUntil,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "image_url": imageUrl,
        "level": level?.toJson(),
        "image": image,
    };
}

class Level {
    int? id;
    int? tenantId;
    int? stageId;
    String? name;
    int? sortOrder;
    bool? isActive;
    DateTime? createdAt;
    DateTime? updatedAt;
    Level? stage;

    Level({
        this.id,
        this.tenantId,
        this.stageId,
        this.name,
        this.sortOrder,
        this.isActive,
        this.createdAt,
        this.updatedAt,
        this.stage,
    });

    factory Level.fromJson(Map<String, dynamic> json) => Level(
        id: json["id"],
        tenantId: json["tenant_id"],
        stageId: json["stage_id"],
        name: json["name"],
        sortOrder: json["sort_order"],
        isActive: json["is_active"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        stage: json["stage"] == null ? null : Level.fromJson(json["stage"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "tenant_id": tenantId,
        "stage_id": stageId,
        "name": name,
        "sort_order": sortOrder,
        "is_active": isActive,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "stage": stage?.toJson(),
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
