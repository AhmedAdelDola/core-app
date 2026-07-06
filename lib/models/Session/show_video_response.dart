class ShowVideo {
    String? playerUrl;

    ShowVideo({
        this.playerUrl,
    });

    factory ShowVideo.fromJson(Map<String, dynamic> json) => ShowVideo(
        playerUrl: json["player_url"],
    );

    Map<String, dynamic> toJson() => {
        "player_url": playerUrl,
    };
}
