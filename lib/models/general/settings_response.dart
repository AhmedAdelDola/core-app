class SettingsResponse {
    Tenant? tenant;
    Settings? settings;
    Branding? branding;
    Legal? legal;
    List<Contact>? contacts;

    SettingsResponse({
        this.tenant,
        this.settings,
        this.branding,
        this.legal,
        this.contacts,
    });

    factory SettingsResponse.fromJson(Map<String, dynamic> json) => SettingsResponse(
        tenant: json["tenant"] == null ? null : Tenant.fromJson(json["tenant"]),
        settings: json["settings"] == null ? null : Settings.fromJson(json["settings"]),
        branding: json["branding"] == null ? null : Branding.fromJson(json["branding"]),
        legal: json["legal"] == null ? null : Legal.fromJson(json["legal"]),
        contacts: json["contacts"] == null ? [] : List<Contact>.from(json["contacts"]!.map((x) => Contact.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "tenant": tenant?.toJson(),
        "settings": settings?.toJson(),
        "branding": branding?.toJson(),
        "legal": legal?.toJson(),
        "contacts": contacts == null ? [] : List<dynamic>.from(contacts!.map((x) => x.toJson())),
    };
}

class Branding {
    String? displayName;
    String? slogan;
    dynamic logoPath;
    dynamic faviconPath;
    int? logoMediaAssetId;
    int? faviconMediaAssetId;
    int? heroMediaAssetId;
    String? primaryColor;
    String? accentColor;
    String? logoUrl;
    String? faviconUrl;
    String? heroImageUrl;
    PublicSite? publicSite;

    Branding({
        this.displayName,
        this.slogan,
        this.logoPath,
        this.faviconPath,
        this.logoMediaAssetId,
        this.faviconMediaAssetId,
        this.heroMediaAssetId,
        this.primaryColor,
        this.accentColor,
        this.logoUrl,
        this.faviconUrl,
        this.heroImageUrl,
        this.publicSite,
    });

    factory Branding.fromJson(Map<String, dynamic> json) => Branding(
        displayName: json["display_name"],
        slogan: json["slogan"],
        logoPath: json["logo_path"],
        faviconPath: json["favicon_path"],
        logoMediaAssetId: json["logo_media_asset_id"],
        faviconMediaAssetId: json["favicon_media_asset_id"],
        heroMediaAssetId: json["hero_media_asset_id"],
        primaryColor: json["primary_color"],
        accentColor: json["accent_color"],
        logoUrl: json["logo_url"],
        faviconUrl: json["favicon_url"],
        heroImageUrl: json["hero_image_url"],
        publicSite: json["public_site"] == null ? null : PublicSite.fromJson(json["public_site"]),
    );

    Map<String, dynamic> toJson() => {
        "display_name": displayName,
        "slogan": slogan,
        "logo_path": logoPath,
        "favicon_path": faviconPath,
        "logo_media_asset_id": logoMediaAssetId,
        "favicon_media_asset_id": faviconMediaAssetId,
        "hero_media_asset_id": heroMediaAssetId,
        "primary_color": primaryColor,
        "accent_color": accentColor,
        "logo_url": logoUrl,
        "favicon_url": faviconUrl,
        "hero_image_url": heroImageUrl,
        "public_site": publicSite?.toJson(),
    };
}

class PublicSite {
    Topbar? topbar;
    Hero? hero;
    List<Section>? sections;
    Footer? footer;

    PublicSite({
        this.topbar,
        this.hero,
        this.sections,
        this.footer,
    });

    factory PublicSite.fromJson(Map<String, dynamic> json) => PublicSite(
        topbar: json["topbar"] == null ? null : Topbar.fromJson(json["topbar"]),
        hero: json["hero"] == null ? null : Hero.fromJson(json["hero"]),
        sections: json["sections"] == null ? [] : List<Section>.from(json["sections"]!.map((x) => Section.fromJson(x))),
        footer: json["footer"] == null ? null : Footer.fromJson(json["footer"]),
    );

    Map<String, dynamic> toJson() => {
        "topbar": topbar?.toJson(),
        "hero": hero?.toJson(),
        "sections": sections == null ? [] : List<dynamic>.from(sections!.map((x) => x.toJson())),
        "footer": footer?.toJson(),
    };
}

class Footer {
    String? text;
    List<PrimaryCta>? links;
    bool? isVisible;
    bool? showContacts;

    Footer({
        this.text,
        this.links,
        this.isVisible,
        this.showContacts,
    });

    factory Footer.fromJson(Map<String, dynamic> json) => Footer(
        text: json["text"],
        links: json["links"] == null ? [] : List<PrimaryCta>.from(json["links"]!.map((x) => PrimaryCta.fromJson(x))),
        isVisible: json["is_visible"],
        showContacts: json["show_contacts"],
    );

    Map<String, dynamic> toJson() => {
        "text": text,
        "links": links == null ? [] : List<dynamic>.from(links!.map((x) => x.toJson())),
        "is_visible": isVisible,
        "show_contacts": showContacts,
    };
}

class PrimaryCta {
    String? url;
    String? label;

    PrimaryCta({
        this.url,
        this.label,
    });

    factory PrimaryCta.fromJson(Map<String, dynamic> json) => PrimaryCta(
        url: json["url"],
        label: json["label"],
    );

    Map<String, dynamic> toJson() => {
        "url": url,
        "label": label,
    };
}

class Hero {
    String? title;
    String? ctaUrl;
    String? eyebrow;
    String? subtitle;
    String? ctaLabel;

    Hero({
        this.title,
        this.ctaUrl,
        this.eyebrow,
        this.subtitle,
        this.ctaLabel,
    });

    factory Hero.fromJson(Map<String, dynamic> json) => Hero(
        title: json["title"],
        ctaUrl: json["cta_url"],
        eyebrow: json["eyebrow"],
        subtitle: json["subtitle"],
        ctaLabel: json["cta_label"],
    );

    Map<String, dynamic> toJson() => {
        "title": title,
        "cta_url": ctaUrl,
        "eyebrow": eyebrow,
        "subtitle": subtitle,
        "cta_label": ctaLabel,
    };
}

class Section {
    String? body;
    dynamic icon;
    String? type;
    String? title;
    String? value;
    bool? isActive;
    int? sortOrder;
    int? imageMediaAssetId;
    String? imageUrl;

    Section({
        this.body,
        this.icon,
        this.type,
        this.title,
        this.value,
        this.isActive,
        this.sortOrder,
        this.imageMediaAssetId,
        this.imageUrl,
    });

    factory Section.fromJson(Map<String, dynamic> json) => Section(
        body: json["body"],
        icon: json["icon"],
        type: json["type"],
        title: json["title"],
        value: json["value"],
        isActive: json["is_active"],
        sortOrder: json["sort_order"],
        imageMediaAssetId: json["image_media_asset_id"],
        imageUrl: json["image_url"],
    );

    Map<String, dynamic> toJson() => {
        "body": body,
        "icon": icon,
        "type": type,
        "title": title,
        "value": value,
        "is_active": isActive,
        "sort_order": sortOrder,
        "image_media_asset_id": imageMediaAssetId,
        "image_url": imageUrl,
    };
}

class Topbar {
    List<dynamic>? links;
    bool? isVisible;
    PrimaryCta? primaryCta;

    Topbar({
        this.links,
        this.isVisible,
        this.primaryCta,
    });

    factory Topbar.fromJson(Map<String, dynamic> json) => Topbar(
        links: json["links"] == null ? [] : List<dynamic>.from(json["links"]!.map((x) => x)),
        isVisible: json["is_visible"],
        primaryCta: json["primary_cta"] == null ? null : PrimaryCta.fromJson(json["primary_cta"]),
    );

    Map<String, dynamic> toJson() => {
        "links": links == null ? [] : List<dynamic>.from(links!.map((x) => x)),
        "is_visible": isVisible,
        "primary_cta": primaryCta?.toJson(),
    };
}

class Contact {
    int? id;
    int? tenantId;
    String? type;
    String? label;
    String? value;
    bool? isActive;
    DateTime? createdAt;
    DateTime? updatedAt;

    Contact({
        this.id,
        this.tenantId,
        this.type,
        this.label,
        this.value,
        this.isActive,
        this.createdAt,
        this.updatedAt,
    });

    factory Contact.fromJson(Map<String, dynamic> json) => Contact(
        id: json["id"],
        tenantId: json["tenant_id"],
        type: json["type"],
        label: json["label"],
        value: json["value"],
        isActive: json["is_active"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "tenant_id": tenantId,
        "type": type,
        "label": label,
        "value": value,
        "is_active": isActive,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
    };
}

class Legal {
    PrivacyPolicy? privacyPolicy;
    PrivacyPolicy? termsConditions;

    Legal({
        this.privacyPolicy,
        this.termsConditions,
    });

    factory Legal.fromJson(Map<String, dynamic> json) => Legal(
        privacyPolicy: json["privacy_policy"] == null ? null : PrivacyPolicy.fromJson(json["privacy_policy"]),
        termsConditions: json["terms_conditions"] == null ? null : PrivacyPolicy.fromJson(json["terms_conditions"]),
    );

    Map<String, dynamic> toJson() => {
        "privacy_policy": privacyPolicy?.toJson(),
        "terms_conditions": termsConditions?.toJson(),
    };
}

class PrivacyPolicy {
    String? title;
    String? url;
    bool? isVisible;

    PrivacyPolicy({
        this.title,
        this.url,
        this.isVisible,
    });

    factory PrivacyPolicy.fromJson(Map<String, dynamic> json) => PrivacyPolicy(
        title: json["title"],
        url: json["url"],
        isVisible: json["is_visible"],
    );

    Map<String, dynamic> toJson() => {
        "title": title,
        "url": url,
        "is_visible": isVisible,
    };
}

class Settings {
    int? id;
    int? tenantId;
    bool? studentSelfRegistrationEnabled;
    bool? otpLoginEnabled;
    bool? passwordLoginEnabled;
    int? loginWindowMinutes;
    int? maxLoginsPerWindow;
    int? banDurationMinutes;
    int? defaultWatchedAfterPercent;
    String? currencyCode;
    dynamic examIntegration;
    dynamic wapilotToken;
    dynamic wapilotInstance;
    String? otpMessageTemplate;
    DateTime? createdAt;
    DateTime? updatedAt;

    Settings({
        this.id,
        this.tenantId,
        this.studentSelfRegistrationEnabled,
        this.otpLoginEnabled,
        this.passwordLoginEnabled,
        this.loginWindowMinutes,
        this.maxLoginsPerWindow,
        this.banDurationMinutes,
        this.defaultWatchedAfterPercent,
        this.currencyCode,
        this.examIntegration,
        this.wapilotToken,
        this.wapilotInstance,
        this.otpMessageTemplate,
        this.createdAt,
        this.updatedAt,
    });

    factory Settings.fromJson(Map<String, dynamic> json) => Settings(
        id: json["id"],
        tenantId: json["tenant_id"],
        studentSelfRegistrationEnabled: json["student_self_registration_enabled"],
        otpLoginEnabled: json["otp_login_enabled"],
        passwordLoginEnabled: json["password_login_enabled"],
        loginWindowMinutes: json["login_window_minutes"],
        maxLoginsPerWindow: json["max_logins_per_window"],
        banDurationMinutes: json["ban_duration_minutes"],
        defaultWatchedAfterPercent: json["default_watched_after_percent"],
        currencyCode: json["currency_code"],
        examIntegration: json["exam_integration"],
        wapilotToken: json["wapilot_token"],
        wapilotInstance: json["wapilot_instance"],
        otpMessageTemplate: json["otp_message_template"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "tenant_id": tenantId,
        "student_self_registration_enabled": studentSelfRegistrationEnabled,
        "otp_login_enabled": otpLoginEnabled,
        "password_login_enabled": passwordLoginEnabled,
        "login_window_minutes": loginWindowMinutes,
        "max_logins_per_window": maxLoginsPerWindow,
        "ban_duration_minutes": banDurationMinutes,
        "default_watched_after_percent": defaultWatchedAfterPercent,
        "currency_code": currencyCode,
        "exam_integration": examIntegration,
        "wapilot_token": wapilotToken,
        "wapilot_instance": wapilotInstance,
        "otp_message_template": otpMessageTemplate,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
    };
}

class Tenant {
    int? id;
    String? name;
    String? slug;
    String? status;

    Tenant({
        this.id,
        this.name,
        this.slug,
        this.status,
    });

    factory Tenant.fromJson(Map<String, dynamic> json) => Tenant(
        id: json["id"],
        name: json["name"],
        slug: json["slug"],
        status: json["status"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "slug": slug,
        "status": status,
    };
}