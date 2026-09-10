class DashboardMerchantModel {
  const DashboardMerchantModel({
    this.id,
    this.name,
    this.slug,
    this.email,
    this.phone,
    this.logo,
    this.about,
    this.status,
    this.kycStatus,
    this.primaryCategoryId,
    this.warehouseAddress,
    this.businessType,
  });

  final int? id;
  final String? name;
  final String? slug;
  final String? email;
  final String? phone;
  final String? logo;
  final String? about;
  final String? status;
  final String? kycStatus;
  final int? primaryCategoryId;
  final String? warehouseAddress;
  final String? businessType;

  factory DashboardMerchantModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const DashboardMerchantModel();
    }

    return DashboardMerchantModel(
      id: _parseInt(json['id']),
      name: _parseString(json['name']),
      slug: _parseString(json['slug']),
      email: _parseString(json['email']),
      phone: _parseString(json['phone']),
      logo: _parseString(json['logo']),
      about: _parseString(json['about']),
      status: _parseString(json['status']),
      kycStatus: _parseString(json['kyc_status']),
      primaryCategoryId: _parseInt(json['primary_category_id']),
      warehouseAddress: _parseString(json['warehouse_address']),
      businessType: _parseString(json['business_type']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
      'email': email,
      'phone': phone,
      'logo': logo,
      'about': about,
      'status': status,
      'kyc_status': kycStatus,
      'primary_category_id': primaryCategoryId,
      'warehouse_address': warehouseAddress,
      'business_type': businessType,
    };
  }

  static String? _parseString(dynamic value) {
    if (value == null) return null;

    if (value is String) {
      return value;
    }

    return value.toString();
  }

  static int? _parseInt(dynamic value) {
    if (value is int) return value;

    if (value is num) {
      return value.toInt();
    }

    if (value is String) {
      return int.tryParse(value);
    }

    return null;
  }
}
