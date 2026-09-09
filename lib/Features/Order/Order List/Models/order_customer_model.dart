class OrderCustomerModel {
  const OrderCustomerModel({
    required this.id,
    required this.name,
    this.email,
    this.phone,
    this.avatarUrl,
  });

  final String id;
  final String name;
  final String? email;
  final String? phone;
  final String? avatarUrl;

  factory OrderCustomerModel.fromJson(Map<String, dynamic> json) {
    return OrderCustomerModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString(),
      phone: json['phone']?.toString(),
      avatarUrl: json['avatar_url']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'avatar_url': avatarUrl,
    };
  }

  OrderCustomerModel copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? avatarUrl,
  }) {
    return OrderCustomerModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }
}
