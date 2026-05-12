class ProductsEntity {
  ProductsEntity({
    required this.products,
    required this.total,
    required this.skip,
    required this.limit,
  });

  final List<ProductEntity> products;
  final int total;
  final int skip;
  final int limit;
}

class ProductEntity {
  ProductEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.price,
    required this.discountPercentage,
    required this.rating,
    required this.stock,
    this.tags,
    required this.brand,
    required this.sku,
    this.weight,
    this.dimensions,
    this.warrantyInformation,
    this.shippingInformation,
    this.availabilityStatus,
    this.reviews,
    this.returnPolicy,
    this.minimumOrderQuantity,
    this.meta,
    this.thumbnail,
    this.images,
    this.isDeleted,
    this.deletedOn,
  });

  final int id;
  final String title;
  final String description;
  final String category;
  final double price;
  final double discountPercentage;
  final double rating;
  final int stock;
  final List<String>? tags;
  final String brand;
  final String sku;
  final int? weight;
  final ProductDimensionsEntity? dimensions;
  final String? warrantyInformation;
  final String? shippingInformation;
  final String? availabilityStatus;
  final List<ProductReviewEntity>? reviews;
  final String? returnPolicy;
  final int? minimumOrderQuantity;
  final ProductMetaEntity? meta;
  final String? thumbnail;
  final List<String>? images;
  final bool? isDeleted;
  final DateTime? deletedOn;
}

class ProductDimensionsEntity {
  ProductDimensionsEntity({
    required this.width,
    required this.height,
    required this.depth,
  });

  final double width;
  final double height;
  final double depth;
}

class ProductReviewEntity {
  ProductReviewEntity({
    required this.rating,
    required this.comment,
    required this.date,
    required this.reviewerName,
    required this.reviewerEmail,
  });

  final int rating;
  final String comment;
  final DateTime? date;
  final String reviewerName;
  final String reviewerEmail;
}

class ProductMetaEntity {
  ProductMetaEntity({
    required this.createdAt,
    required this.updatedAt,
    required this.barcode,
    required this.qrCode,
  });

  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String barcode;
  final String qrCode;
}
