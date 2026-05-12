import '../entities/products_entity.dart';

class ProductsModel extends ProductsEntity {
  ProductsModel({
    required super.products,
    required super.total,
    required super.skip,
    required super.limit,
  });

  factory ProductsModel.fromJson(Map<String, dynamic> json) {
    return ProductsModel(
      products: json["products"] == null
          ? []
          : List<ProductModel>.from(
              json["products"]!.map((x) => ProductModel.fromJson(x)),
            ),
      total: json["total"] ?? 0,
      skip: json["skip"] ?? 0,
      limit: json["limit"] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    "products": products.map((x) => (x as ProductModel).toJson()).toList(),
    "total": total,
    "skip": skip,
    "limit": limit,
  };
}

class ProductModel extends ProductEntity {
  ProductModel({
    required super.id,
    required super.title,
    required super.description,
    required super.category,
    required super.price,
    required super.discountPercentage,
    required super.rating,
    required super.stock,
    required super.tags,
    required super.brand,
    required super.sku,
    required super.weight,
    required super.dimensions,
    required super.warrantyInformation,
    required super.shippingInformation,
    required super.availabilityStatus,
    required super.reviews,
    required super.returnPolicy,
    required super.minimumOrderQuantity,
    required super.meta,
    required super.thumbnail,
    required super.images,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json["id"] ?? 0,
      title: json["title"] ?? "",
      description: json["description"] ?? "",
      category: json["category"] ?? "",
      price: (json["price"] ?? 0.0).toDouble(),
      discountPercentage: (json["discountPercentage"] ?? 0.0).toDouble(),
      rating: (json["rating"] ?? 0.0).toDouble(),
      stock: json["stock"] ?? 0,
      tags: json["tags"] == null
          ? []
          : List<String>.from(json["tags"]!.map((x) => x)),
      brand: json["brand"] ?? "",
      sku: json["sku"] ?? "",
      weight: json["weight"] ?? 0,
      dimensions: json["dimensions"] == null
          ? null
          : DimensionsModel.fromJson(json["dimensions"]),
      warrantyInformation: json["warrantyInformation"] ?? "",
      shippingInformation: json["shippingInformation"] ?? "",
      availabilityStatus: json["availabilityStatus"] ?? "",
      reviews: json["reviews"] == null
          ? []
          : List<ReviewModel>.from(
              json["reviews"]!.map((x) => ReviewModel.fromJson(x)),
            ),
      returnPolicy: json["returnPolicy"] ?? "",
      minimumOrderQuantity: json["minimumOrderQuantity"] ?? 0,
      meta: json["meta"] == null ? null : MetaModel.fromJson(json["meta"]),
      thumbnail: json["thumbnail"] ?? "",
      images: json["images"] == null
          ? []
          : List<String>.from(json["images"]!.map((x) => x)),
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "description": description,
    "category": category,
    "price": price,
    "discountPercentage": discountPercentage,
    "rating": rating,
    "stock": stock,
    "tags": tags.map((x) => x).toList(),
    "brand": brand,
    "sku": sku,
    "weight": weight,
    "dimensions": (dimensions as DimensionsModel?)?.toJson(),
    "warrantyInformation": warrantyInformation,
    "shippingInformation": shippingInformation,
    "availabilityStatus": availabilityStatus,
    "reviews": reviews.map((x) => (x as ReviewModel).toJson()).toList(),
    "returnPolicy": returnPolicy,
    "minimumOrderQuantity": minimumOrderQuantity,
    "meta": (meta as MetaModel?)?.toJson(),
    "thumbnail": thumbnail,
    "images": images.map((x) => x).toList(),
  };
}

class DimensionsModel extends ProductDimensionsEntity {
  DimensionsModel({
    required super.width,
    required super.height,
    required super.depth,
  });

  factory DimensionsModel.fromJson(Map<String, dynamic> json) {
    return DimensionsModel(
      width: (json["width"] ?? 0.0).toDouble(),
      height: (json["height"] ?? 0.0).toDouble(),
      depth: (json["depth"] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
    "width": width,
    "height": height,
    "depth": depth,
  };
}

class MetaModel extends ProductMetaEntity {
  MetaModel({
    required super.createdAt,
    required super.updatedAt,
    required super.barcode,
    required super.qrCode,
  });

  factory MetaModel.fromJson(Map<String, dynamic> json) {
    return MetaModel(
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
      barcode: json["barcode"] ?? "",
      qrCode: json["qrCode"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "barcode": barcode,
    "qrCode": qrCode,
  };
}

class ReviewModel extends ProductReviewEntity {
  ReviewModel({
    required super.rating,
    required super.comment,
    required super.date,
    required super.reviewerName,
    required super.reviewerEmail,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      rating: json["rating"] ?? 0,
      comment: json["comment"] ?? "",
      date: DateTime.tryParse(json["date"] ?? ""),
      reviewerName: json["reviewerName"] ?? "",
      reviewerEmail: json["reviewerEmail"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "rating": rating,
    "comment": comment,
    "date": date?.toIso8601String(),
    "reviewerName": reviewerName,
    "reviewerEmail": reviewerEmail,
  };
}
