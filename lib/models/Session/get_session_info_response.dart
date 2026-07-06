class GetSessionInfoResponse {
    Session? session;
    StudentState? studentState;
    bool? canAccess;
    String? blockedReason;
    int? resumeFrom;
    dynamic remainingViews;
    Delivery? delivery;

    GetSessionInfoResponse({
        this.session,
        this.studentState,
        this.canAccess,
        this.blockedReason,
        this.resumeFrom,
        this.remainingViews,
        this.delivery,
    });

    factory GetSessionInfoResponse.fromJson(Map<String, dynamic> json) => GetSessionInfoResponse(
        session: json["session"] == null ? null : Session.fromJson(json["session"]),
        studentState: json["student_state"] == null ? null : StudentState.fromJson(json["student_state"]),
        canAccess: json["can_access"],
        blockedReason: json["blocked_reason"],
        resumeFrom: json["resume_from"],
        remainingViews: json["remaining_views"],
        delivery: json["delivery"] == null ? null : Delivery.fromJson(json["delivery"]),
    );

    Map<String, dynamic> toJson() => {
        "session": session?.toJson(),
        "student_state": studentState?.toJson(),
        "can_access": canAccess,
        "blocked_reason": blockedReason,
        "resume_from": resumeFrom,
        "remaining_views": remainingViews,
        "delivery": delivery?.toJson(),
    };
}

class Delivery {
    String? type;
    dynamic payload;

    Delivery({
        this.type,
        this.payload,
    });

    factory Delivery.fromJson(Map<String, dynamic> json) => Delivery(
        type: json["type"],
        payload: json["payload"],
    );

    Map<String, dynamic> toJson() => {
        "type": type,
        "payload": payload,
    };
}

class Session {
    int? id;
    int? tenantId;
    int? lessonId;
    dynamic mediaAssetId;
    String? youtubeUrl;
    int? pdfMediaAssetId;
    String? title;
    String? description;
    String? type;
    dynamic liveUrl;
    int? sortOrder;
    bool? isVisible;
    dynamic publishAt;
    dynamic startsAt;
    dynamic endsAt;
    dynamic maxCompletedViews;
    dynamic watchedAfterPercent;
    dynamic watchedAfterSeconds;
    String? singleSessionPrice;
    DateTime? createdAt;
    DateTime? updatedAt;
    Lesson? lesson;
    dynamic media;
    Pdf? pdf;

    Session({
        this.id,
        this.tenantId,
        this.lessonId,
        this.mediaAssetId,
        this.youtubeUrl,
        this.pdfMediaAssetId,
        this.title,
        this.description,
        this.type,
        this.liveUrl,
        this.sortOrder,
        this.isVisible,
        this.publishAt,
        this.startsAt,
        this.endsAt,
        this.maxCompletedViews,
        this.watchedAfterPercent,
        this.watchedAfterSeconds,
        this.singleSessionPrice,
        this.createdAt,
        this.updatedAt,
        this.lesson,
        this.media,
        this.pdf,
    });

    factory Session.fromJson(Map<String, dynamic> json) => Session(
        id: json["id"],
        tenantId: json["tenant_id"],
        lessonId: json["lesson_id"],
        mediaAssetId: json["media_asset_id"],
        youtubeUrl: json["youtube_url"],
        pdfMediaAssetId: json["pdf_media_asset_id"],
        title: json["title"],
        description: json["description"],
        type: json["type"],
        liveUrl: json["live_url"],
        sortOrder: json["sort_order"],
        isVisible: json["is_visible"],
        publishAt: json["publish_at"],
        startsAt: json["starts_at"],
        endsAt: json["ends_at"],
        maxCompletedViews: json["max_completed_views"],
        watchedAfterPercent: json["watched_after_percent"],
        watchedAfterSeconds: json["watched_after_seconds"],
        singleSessionPrice: json["single_session_price"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        lesson: json["lesson"] == null ? null : Lesson.fromJson(json["lesson"]),
        media: json["media"],
        pdf: json["pdf"] == null ? null : Pdf.fromJson(json["pdf"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "tenant_id": tenantId,
        "lesson_id": lessonId,
        "media_asset_id": mediaAssetId,
        "youtube_url": youtubeUrl,
        "pdf_media_asset_id": pdfMediaAssetId,
        "title": title,
        "description": description,
        "type": type,
        "live_url": liveUrl,
        "sort_order": sortOrder,
        "is_visible": isVisible,
        "publish_at": publishAt,
        "starts_at": startsAt,
        "ends_at": endsAt,
        "max_completed_views": maxCompletedViews,
        "watched_after_percent": watchedAfterPercent,
        "watched_after_seconds": watchedAfterSeconds,
        "single_session_price": singleSessionPrice,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "lesson": lesson?.toJson(),
        "media": media,
        "pdf": pdf?.toJson(),
    };
}

class Lesson {
    int? id;
    int? tenantId;
    int? chapterId;
    String? title;
    String? description;
    int? sortOrder;
    bool? isVisible;
    dynamic externalExamProvider;
    dynamic externalExamId;
    dynamic passingScore;
    DateTime? createdAt;
    DateTime? updatedAt;
    Chapter? chapter;

    Lesson({
        this.id,
        this.tenantId,
        this.chapterId,
        this.title,
        this.description,
        this.sortOrder,
        this.isVisible,
        this.externalExamProvider,
        this.externalExamId,
        this.passingScore,
        this.createdAt,
        this.updatedAt,
        this.chapter,
    });

    factory Lesson.fromJson(Map<String, dynamic> json) => Lesson(
        id: json["id"],
        tenantId: json["tenant_id"],
        chapterId: json["chapter_id"],
        title: json["title"],
        description: json["description"],
        sortOrder: json["sort_order"],
        isVisible: json["is_visible"],
        externalExamProvider: json["external_exam_provider"],
        externalExamId: json["external_exam_id"],
        passingScore: json["passing_score"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        chapter: json["chapter"] == null ? null : Chapter.fromJson(json["chapter"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "tenant_id": tenantId,
        "chapter_id": chapterId,
        "title": title,
        "description": description,
        "sort_order": sortOrder,
        "is_visible": isVisible,
        "external_exam_provider": externalExamProvider,
        "external_exam_id": externalExamId,
        "passing_score": passingScore,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "chapter": chapter?.toJson(),
    };
}

class Chapter {
    int? id;
    int? tenantId;
    int? courseId;
    String? title;
    String? description;
    int? sortOrder;
    bool? isVisible;
    DateTime? createdAt;
    DateTime? updatedAt;
    Course? course;

    Chapter({
        this.id,
        this.tenantId,
        this.courseId,
        this.title,
        this.description,
        this.sortOrder,
        this.isVisible,
        this.createdAt,
        this.updatedAt,
        this.course,
    });

    factory Chapter.fromJson(Map<String, dynamic> json) => Chapter(
        id: json["id"],
        tenantId: json["tenant_id"],
        courseId: json["course_id"],
        title: json["title"],
        description: json["description"],
        sortOrder: json["sort_order"],
        isVisible: json["is_visible"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        course: json["course"] == null ? null : Course.fromJson(json["course"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "tenant_id": tenantId,
        "course_id": courseId,
        "title": title,
        "description": description,
        "sort_order": sortOrder,
        "is_visible": isVisible,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "course": course?.toJson(),
    };
}

class Course {
    int? id;
    int? tenantId;
    int? levelId;
    int? teacherId;
    String? title;
    String? description;
    int? imageMediaAssetId;
    dynamic promoMediaAssetId;
    String? price;
    bool? isActive;
    bool? isFeatured;
    DateTime? createdAt;
    DateTime? updatedAt;

    Course({
        this.id,
        this.tenantId,
        this.levelId,
        this.teacherId,
        this.title,
        this.description,
        this.imageMediaAssetId,
        this.promoMediaAssetId,
        this.price,
        this.isActive,
        this.isFeatured,
        this.createdAt,
        this.updatedAt,
    });

    factory Course.fromJson(Map<String, dynamic> json) => Course(
        id: json["id"],
        tenantId: json["tenant_id"],
        levelId: json["level_id"],
        teacherId: json["teacher_id"],
        title: json["title"],
        description: json["description"],
        imageMediaAssetId: json["image_media_asset_id"],
        promoMediaAssetId: json["promo_media_asset_id"],
        price: json["price"],
        isActive: json["is_active"],
        isFeatured: json["is_featured"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "tenant_id": tenantId,
        "level_id": levelId,
        "teacher_id": teacherId,
        "title": title,
        "description": description,
        "image_media_asset_id": imageMediaAssetId,
        "promo_media_asset_id": promoMediaAssetId,
        "price": price,
        "is_active": isActive,
        "is_featured": isFeatured,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
    };
}

class Pdf {
    int? id;
    int? tenantId;
    int? uploadedBy;
    String? name;
    String? type;
    String? disk;
    String? path;
    String? mimeType;
    int? sizeBytes;
    dynamic metadata;
    DateTime? createdAt;
    DateTime? updatedAt;
    String? url;

    Pdf({
        this.id,
        this.tenantId,
        this.uploadedBy,
        this.name,
        this.type,
        this.disk,
        this.path,
        this.mimeType,
        this.sizeBytes,
        this.metadata,
        this.createdAt,
        this.updatedAt,
        this.url,
    });

    factory Pdf.fromJson(Map<String, dynamic> json) => Pdf(
        id: json["id"],
        tenantId: json["tenant_id"],
        uploadedBy: json["uploaded_by"],
        name: json["name"],
        type: json["type"],
        disk: json["disk"],
        path: json["path"],
        mimeType: json["mime_type"],
        sizeBytes: json["size_bytes"],
        metadata: json["metadata"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        url: json["url"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "tenant_id": tenantId,
        "uploaded_by": uploadedBy,
        "name": name,
        "type": type,
        "disk": disk,
        "path": path,
        "mime_type": mimeType,
        "size_bytes": sizeBytes,
        "metadata": metadata,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "url": url,
    };
}

class StudentState {
    String? status;
    dynamic blockedReason;
    dynamic bannedUntil;

    StudentState({
        this.status,
        this.blockedReason,
        this.bannedUntil,
    });

    factory StudentState.fromJson(Map<String, dynamic> json) => StudentState(
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
