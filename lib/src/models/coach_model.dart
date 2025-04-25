class CoachModel {
  final String name;
  final String? avatar;

  const CoachModel({required this.name, this.avatar});

  factory CoachModel.fromJson(Map<String, dynamic> json) => CoachModel(
    name: json['name'] as String,
    avatar: json['avatar'] as String?,
  );

  Map<String, dynamic> toJson() => {'name': name, 'avatar': avatar};
}
