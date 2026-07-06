class HomeResponse {
    List<dynamic>? notifications;
    List<RecommendedCourse>? recommendedCourses;
    List<SuggestedSession>? suggestedSessions;
    List<FeaturedFile>? featuredFiles;
    TopTeacher? topTeacher;
    List<NewestContent>? newestContent;

    HomeResponse({
        this.notifications,
        this.recommendedCourses,
        this.suggestedSessions,
        this.featuredFiles,
        this.topTeacher,
        this.newestContent,
    });

    factory HomeResponse.fromJson(Map<String, dynamic> json) => HomeResponse(
        notifications: json["notifications"] == null ? [] : List<dynamic>.from(json["notifications"]!.map((x) => x)),
        recommendedCourses: json["recommended_courses"] == null ? [] : List<RecommendedCourse>.from(json["recommended_courses"]!.map((x) => RecommendedCourse.fromJson(x))),
        suggestedSessions: json["suggested_sessions"] == null ? [] : List<SuggestedSession>.from(json["suggested_sessions"]!.map((x) => SuggestedSession.fromJson(x))),
        featuredFiles: json["featured_files"] == null ? [] : List<FeaturedFile>.from(json["featured_files"]!.map((x) => FeaturedFile.fromJson(x))),
        topTeacher: json["top_teacher"] == null ? null : TopTeacher.fromJson(json["top_teacher"]),
        newestContent: json["newest_content"] == null ? [] : List<NewestContent>.from(json["newest_content"]!.map((x) => NewestContent.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "notifications": notifications == null ? [] : List<dynamic>.from(notifications!.map((x) => x)),
        "recommended_courses": recommendedCourses == null ? [] : List<dynamic>.from(recommendedCourses!.map((x) => x.toJson())),
        "suggested_sessions": suggestedSessions == null ? [] : List<dynamic>.from(suggestedSessions!.map((x) => x.toJson())),
        "featured_files": featuredFiles == null ? [] : List<dynamic>.from(featuredFiles!.map((x) => x.toJson())),
        "top_teacher": topTeacher?.toJson(),
        "newest_content": newestContent == null ? [] : List<dynamic>.from(newestContent!.map((x) => x.toJson())),
    };
}

class FeaturedFile {
    String? id;
    int? assetId;
    String? name;
    String? type;
    String? kind;
    String? url;
    Course? session;
    Course? course;

    FeaturedFile({
        this.id,
        this.assetId,
        this.name,
        this.type,
        this.kind,
        this.url,
        this.session,
        this.course,
    });

    factory FeaturedFile.fromJson(Map<String, dynamic> json) => FeaturedFile(
        id: json["id"],
        assetId: json["asset_id"],
        name: json["name"],
        type: json["type"],
        kind: json["kind"],
        url: json["url"],
        session: json["session"] == null ? null : Course.fromJson(json["session"]),
        course: json["course"] == null ? null : Course.fromJson(json["course"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "asset_id": assetId,
        "name": name,
        "type": type,
        "kind": kind,
        "url": url,
        "session": session?.toJson(),
        "course": course?.toJson(),
    };
}

class Course {
    int? id;
    String? title;

    Course({
        this.id,
        this.title,
    });

    factory Course.fromJson(Map<String, dynamic> json) => Course(
        id: json["id"],
        title: json["title"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
    };
}

class NewestContent {
    int? id;
    String? title;
    String? type;
    dynamic publishedAt;
    Course? course;
    Course? lesson;

    NewestContent({
        this.id,
        this.title,
        this.type,
        this.publishedAt,
        this.course,
        this.lesson,
    });

    factory NewestContent.fromJson(Map<String, dynamic> json) => NewestContent(
        id: json["id"],
        title: json["title"],
        type: json["type"],
        publishedAt: json["published_at"],
        course: json["course"] == null ? null : Course.fromJson(json["course"]),
        lesson: json["lesson"] == null ? null : Course.fromJson(json["lesson"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "type": type,
        "published_at": publishedAt,
        "course": course?.toJson(),
        "lesson": lesson?.toJson(),
    };
}

class RecommendedCourse {
    int? id;
    String? title;
    dynamic description;
    String? price;
    bool? hasActiveSubscription;
    bool? canViewCourseContent;
    Level? stage;
    Level? level;
    Teacher? teacher;
    String? imageUrl;
    String? promoUrl;

    RecommendedCourse({
        this.id,
        this.title,
        this.description,
        this.price,
        this.hasActiveSubscription,
        this.canViewCourseContent,
        this.stage,
        this.level,
        this.teacher,
        this.imageUrl,
        this.promoUrl,
    });

    factory RecommendedCourse.fromJson(Map<String, dynamic> json) => RecommendedCourse(
        id: json["id"],
        title: json["title"],
        description: json["description"],
        price: json["price"],
        hasActiveSubscription: json["has_active_subscription"],
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

class SuggestedSession {
    int? id;
    String? title;
    String? type;
    String? deliveryType;
    Course? course;
    Course? lesson;
    Course? chapter;

    SuggestedSession({
        this.id,
        this.title,
        this.type,
        this.deliveryType,
        this.course,
        this.lesson,
        this.chapter,
    });

    factory SuggestedSession.fromJson(Map<String, dynamic> json) => SuggestedSession(
        id: json["id"],
        title: json["title"],
        type: json["type"],
        deliveryType: json["delivery_type"],
        course: json["course"] == null ? null : Course.fromJson(json["course"]),
        lesson: json["lesson"] == null ? null : Course.fromJson(json["lesson"]),
        chapter: json["chapter"] == null ? null : Course.fromJson(json["chapter"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "type": type,
        "delivery_type": deliveryType,
        "course": course?.toJson(),
        "lesson": lesson?.toJson(),
        "chapter": chapter?.toJson(),
    };
}

class TopTeacher {
    int? id;
    String? name;
    int? activeCoursesCount;

    TopTeacher({
        this.id,
        this.name,
        this.activeCoursesCount,
    });

    factory TopTeacher.fromJson(Map<String, dynamic> json) => TopTeacher(
        id: json["id"],
        name: json["name"],
        activeCoursesCount: json["active_courses_count"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "active_courses_count": activeCoursesCount,
    };
}
