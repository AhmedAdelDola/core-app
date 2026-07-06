class Rating {
  final int? rate;
  final int? subscribers;
  final int? raters;
  String get totalRate => '${rate ?? 0.0} (${raters ?? 0.0})';

  Rating({this.rate, this.subscribers, this.raters});

  factory Rating.fromJson(Map<String, dynamic> json) =>
      Rating(rate: json['rate'], subscribers: json['subscribers'], raters: json['raters']);

  Map<String, dynamic> toJson() => {'rate': rate, 'subscribers': subscribers, 'raters': raters};
}
