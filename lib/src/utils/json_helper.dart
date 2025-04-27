T? castOrNull<T>(dynamic value) {
  if (value is T) return value;
  return null;
}

String getString(
  Map<String, dynamic> json,
  String key, {
  String defaultValue = '',
}) {
  return castOrNull<String>(json[key]) ?? defaultValue;
}

int getInt(Map<String, dynamic> json, String key, {int defaultValue = 0}) {
  return castOrNull<int>(json[key]) ??
      int.tryParse(json[key]?.toString() ?? '') ??
      defaultValue;
}

double? getDouble(Map<String, dynamic> json, String key) {
  if (json[key] is num) {
    return (json[key] as num).toDouble();
  }
  return double.tryParse(json[key]?.toString() ?? '');
}

List<String> getStringList(Map<String, dynamic> json, String key) {
  if (json[key] is List) {
    return (json[key] as List).map((e) => e.toString()).toList();
  }
  return [];
}

Map<String, dynamic>? getMap(Map<String, dynamic> json, String key) {
  return castOrNull<Map<String, dynamic>>(json[key]);
}
