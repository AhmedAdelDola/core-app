class LibraryCoursesResponse {
    StudentState? studentState;
    String? walletBalance;
    List<Course>? courses;

    LibraryCoursesResponse({
        this.studentState,
        this.walletBalance,
        this.courses,
    });

    factory LibraryCoursesResponse.fromJson(Map<String, dynamic> json) => LibraryCoursesResponse(
        studentState: json["student_state"] == null ? null : StudentState.fromJson(json["student_state"]),
        walletBalance: json["wallet_balance"],
        courses: json["courses"] == null ? [] : List<Course>.from(json["courses"]!.map((x) => Course.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "student_state": studentState?.toJson(),
        "wallet_balance": walletBalance,
        "courses": courses == null ? [] : List<dynamic>.from(courses!.map((x) => x.toJson())),
    };
}

class Course {
    int? id;
    String? title;
    dynamic description;
    String? price;
    bool? hasActiveSubscription;
    bool? hasCourseSubscription;
    bool? hasSessionSubscription;
    bool? canViewCourseContent;
    Level? stage;
    Level? level;
    Teacher? teacher;
    String? imageUrl;
    dynamic promoUrl;

    Course({
        this.id,
        this.title,
        this.description,
        this.price,
        this.hasActiveSubscription,
        this.hasCourseSubscription,
        this.hasSessionSubscription,
        this.canViewCourseContent,
        this.stage,
        this.level,
        this.teacher,
        this.imageUrl,
        this.promoUrl,
    });

    factory Course.fromJson(Map<String, dynamic> json) => Course(
        id: json["id"],
        title: json["title"],
        description: json["description"],
        price: json["price"],
        hasActiveSubscription: json["has_active_subscription"],
        hasCourseSubscription: json["has_course_subscription"],
        hasSessionSubscription: json["has_session_subscription"],
        canViewCourseContent: json["can_view_course_content"],
        stage: json["stage"] == null ? null : Level.fromJson(json["stage"]),
        level: json["level"] == null ? null : Level.fromJson(json["level"]),
        teacher: json["teacher"] == null ? null : Teacher.fromJson(json["teacher"]),
        imageUrl: json["image_url"],
        promoUrl: json["promo_url"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "description": description,
        "price": price,
        "has_active_subscription": hasActiveSubscription,
        "has_course_subscription": hasCourseSubscription,
        "has_session_subscription": hasSessionSubscription,
        "can_view_course_content": canViewCourseContent,
        "stage": stage?.toJson(),
        "level": level?.toJson(),
        "teacher": teacher?.toJson(),
        "image_url": imageUrl,
        "promo_url": promoUrl,
    };
}

class Level {
    int? id;
    String? name;

    Level({
        this.id,
        this.name,
    });

    factory Level.fromJson(Map<String, dynamic> json) => Level(
        id: json["id"],
        name: json["name"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
    };
}

class Teacher {
    int? id;
    String? name;
    dynamic imageUrl;

    Teacher({
        this.id,
        this.name,
        this.imageUrl,
    });

    factory Teacher.fromJson(Map<String, dynamic> json) => Teacher(
        id: json["id"],
        name: json["name"],
        imageUrl: json["image_url"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "image_url": imageUrl,
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
