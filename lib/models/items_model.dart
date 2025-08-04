class ItemsResponse {
  final bool success;
  final List<ItemModel> data;
  final String message;

  ItemsResponse({
    required this.success,
    required this.data,
    required this.message,
  });

  factory ItemsResponse.fromJson(Map<String, dynamic> json) {
    return ItemsResponse(
      success: json['success'],
      data: (json['data'] as List)
          .map((item) => ItemModel.fromJson(item))
          .toList(),
      message: json['message'],
    );
  }
}

class ItemModel {
  final int id;
  final String? title;
  final String? description;
  final String? redemptionInstruction;
  final String? categoryId;
  final List? tags;
  final String? location;
  final List? affiliationId;
  final String? price;
  final String? eligibilityCriteria;
  final String? isFree;
  final String? status;
  final String? createdAt;
  final String? updatedAt;
  final String? brandId;
  final String? businessType;
  final String? locationUrl;
  final String? latitude;
  final String? longitude;
  final PromoCategory? categories;
  final List<PromoMedia>? media;

  ItemModel({
    required this.id,
    this.title,
    this.description,
    this.redemptionInstruction,
    this.categoryId,
    this.tags,
    this.location,
    this.affiliationId,
    this.price,
    this.eligibilityCriteria,
    this.isFree,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.brandId,
    this.businessType,
    this.locationUrl,
    this.latitude,
    this.longitude,
    this.categories,
    this.media,
  });

  factory ItemModel.fromJson(Map<String, dynamic> json) {
    return ItemModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      redemptionInstruction: json['redemption_instruction'],
      categoryId: json['category_id'],
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e.toString()).toList(),
      location: json['location'],
      affiliationId: (json['affiliation_id'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
      price: json['price'],
      eligibilityCriteria: json['eligibility_criteria'],
      isFree: json['is_free'],
      status: json['status'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      brandId: json['brand_id'],
      businessType: json['business_type'],
      locationUrl: json['location_url'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      categories: json['categories'] != null
          ? PromoCategory.fromJson(json['categories'])
          : null,
      media: json['media'] != null
          ? (json['media'] as List).map((m) => PromoMedia.fromJson(m)).toList()
          : null,
    );
  }
}

class PromoCategory {
  final int id;
  final String name;
  final DateTime createdAt;
  final DateTime updatedAt;

  PromoCategory({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PromoCategory.fromJson(Map<String, dynamic> json) {
    return PromoCategory(
      id: json['id'],
      name: json['name'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}

class PromoMedia {
  final int id;
  final String modelType;
  final String modelId;
  final String uuid;
  final String collectionName;
  final String name;
  final String fileName;
  final String mimeType;
  final String disk;
  final String conversionsDisk;
  final String size;
  final List<dynamic> manipulations;
  final List<dynamic> customProperties;
  final List<dynamic> generatedConversions;
  final List<dynamic> responsiveImages;
  final String orderColumn;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? originalUrl;
  final String? previewUrl;

  PromoMedia({
    required this.id,
    required this.modelType,
    required this.modelId,
    required this.uuid,
    required this.collectionName,
    required this.name,
    required this.fileName,
    required this.mimeType,
    required this.disk,
    required this.conversionsDisk,
    required this.size,
    required this.manipulations,
    required this.customProperties,
    required this.generatedConversions,
    required this.responsiveImages,
    required this.orderColumn,
    required this.createdAt,
    required this.updatedAt,
    required this.originalUrl,
    required this.previewUrl,
  });

  factory PromoMedia.fromJson(Map<String, dynamic> json) {
    return PromoMedia(
      id: json['id'],
      modelType: json['model_type'],
      modelId: json['model_id'],
      uuid: json['uuid'],
      collectionName: json['collection_name'],
      name: json['name'],
      fileName: json['file_name'],
      mimeType: json['mime_type'],
      disk: json['disk'],
      conversionsDisk: json['conversions_disk'],
      size: json['size'],
      manipulations: json['manipulations'],
      customProperties: json['custom_properties'],
      generatedConversions: json['generated_conversions'],
      responsiveImages: json['responsive_images'],
      orderColumn: json['order_column'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      originalUrl: json['original_url'],
      previewUrl: json['preview_url'],
    );
  }
}
