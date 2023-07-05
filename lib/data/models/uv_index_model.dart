class UvIndex {
  final double? uvi;

  UvIndex({
    this.uvi,

  });

  factory UvIndex.fromJson(Map<String, dynamic> json) {
    var uvIndex = json['result']['uv']?.toDouble() ?? 0.0;
    return UvIndex(
        uvi: uvIndex
    );
  }
}
