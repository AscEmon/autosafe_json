// To parse this JSON data, do
//
//     final testResponse = testResponseFromJson(jsonString);

import 'dart:convert';
import 'package:autosafe_json/autosafe_json.dart';

TestResponse testResponseFromJson(String str) =>
    TestResponse.fromJson(json.decode(str));

String testResponseToJson(TestResponse data) => json.encode(data.toJson());

class TestResponse {
  final String? id;
  final String? name;
  final String? email;
  final String? age;
  final String? salary;
  final String? isActive;
  final String? isVerified;
  final String? profileImageUrl;
  final List<dynamic>? tags;
  final Metadata? metadata;
  final Business? business;
  final List<Department>? departments;
  final List<QrCode>? qrCodes;
  final List<bool?>? permissions;
  final List<double?>? scores;
  final List<dynamic>? mixedArray;
  final EmptyObject? emptyObject;
  final List<dynamic>? emptyArray;
  final DeepNesting? deepNesting;

  TestResponse({
    this.id,
    this.name,
    this.email,
    this.age,
    this.salary,
    this.isActive,
    this.isVerified,
    this.profileImageUrl,
    this.tags,
    this.metadata,
    this.business,
    this.departments,
    this.qrCodes,
    this.permissions,
    this.scores,
    this.mixedArray,
    this.emptyObject,
    this.emptyArray,
    this.deepNesting,
  });

  factory TestResponse.fromJson(Map<String, dynamic> json) {
    json = json.autoSafe.raw;
    return TestResponse(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    age: json["age"],
    salary: json["salary"],
    isActive: json["is_active"],
    isVerified: json["is_verified"],
    profileImageUrl: json["profile_image_url"],
    tags: json["tags"] == null || json["tags"] == "" ? []
        : List<dynamic>.from(SafeJson.asList(json["tags"]).map((x) => x)),
    metadata: json["metadata"] == null || json["metadata"] == "" ? null
        : Metadata.fromJson(SafeJson.asMap(json["metadata"])),
    business: json["business"] == null || json["business"] == "" ? null
        : Business.fromJson(SafeJson.asMap(json["business"])),
    departments: json["departments"] == null || json["departments"] == "" ? []
        : List<Department>.from(
            json["departments"]!.map((x) => Department.fromJson(x)),
          ),
    qrCodes: json["qr_codes"] == null || json["qr_codes"] == "" ? []
        : List<QrCode>.from(SafeJson.asList(json["qr_codes"]).map((x) => QrCode.fromJson(x))),
    permissions: json["permissions"] == null || json["permissions"] == "" ? []
        : List<bool?>.from(SafeJson.asList(json["permissions"]).map((x) => x)),
    scores: json["scores"] == null || json["scores"] == "" ? []
        : List<double?>.from(SafeJson.asList(json["scores"]).map((x) => x)),
    mixedArray: json["mixed_array"] == null || json["mixed_array"] == "" ? []
        : List<dynamic>.from(SafeJson.asList(json["mixed_array"]).map((x) => x)),
    emptyObject: json["empty_object"] == null || json["empty_object"] == "" ? null
        : EmptyObject.fromJson(SafeJson.asMap(json["empty_object"])),
    emptyArray: json["empty_array"] == null || json["empty_array"] == "" ? []
        : List<dynamic>.from(SafeJson.asList(json["empty_array"]).map((x) => x)),
    deepNesting: json["deep_nesting"] == null || json["deep_nesting"] == "" ? null
        : DeepNesting.fromJson(SafeJson.asMap(json["deep_nesting"])),
  );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "age": age,
    "salary": salary,
    "is_active": isActive,
    "is_verified": isVerified,
    "profile_image_url": profileImageUrl,
    "tags": tags == null ? [] : List<dynamic>.from(tags!.map((x) => x)),
    "metadata": metadata?.toJson(),
    "business": business?.toJson(),
    "departments": departments == null
        ? []
        : List<dynamic>.from(departments!.map((x) => x.toJson())),
    "qr_codes": qrCodes == null
        ? []
        : List<dynamic>.from(qrCodes!.map((x) => x.toJson())),
    "permissions": permissions == null
        ? []
        : List<dynamic>.from(permissions!.map((x) => x)),
    "scores": scores == null ? [] : List<dynamic>.from(scores!.map((x) => x)),
    "mixed_array": mixedArray == null
        ? []
        : List<dynamic>.from(mixedArray!.map((x) => x)),
    "empty_object": emptyObject?.toJson(),
    "empty_array": emptyArray == null
        ? []
        : List<dynamic>.from(emptyArray!.map((x) => x)),
    "deep_nesting": deepNesting?.toJson(),
  };
}

class Business {
  final String? id;
  final String? name;
  final String? legalName;
  final String? businessTypeId;
  final String? salesEstimationRangeId;
  final String? averageTransactionValue;
  final String? isActive;
  final String? employeeCount;
  final String? rating;
  final Address? address;
  final Status? status;

  Business({
    this.id,
    this.name,
    this.legalName,
    this.businessTypeId,
    this.salesEstimationRangeId,
    this.averageTransactionValue,
    this.isActive,
    this.employeeCount,
    this.rating,
    this.address,
    this.status,
  });

  factory Business.fromJson(Map<String, dynamic> json) => Business(
    id: json["id"],
    name: json["name"],
    legalName: json["legal_name"],
    businessTypeId: json["business_type_id"],
    salesEstimationRangeId: json["sales_estimation_range_id"],
    averageTransactionValue: json["average_transaction_value"],
    isActive: json["is_active"],
    employeeCount: json["employee_count"],
    rating: json["rating"],
    address: json["address"] == null || json["address"] == "" ? null : Address.fromJson(SafeJson.asMap(json["address"])),
    status: json["status"] == null || json["status"] == "" ? null : Status.fromJson(SafeJson.asMap(json["status"])),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "legal_name": legalName,
    "business_type_id": businessTypeId,
    "sales_estimation_range_id": salesEstimationRangeId,
    "average_transaction_value": averageTransactionValue,
    "is_active": isActive,
    "employee_count": employeeCount,
    "rating": rating,
    "address": address?.toJson(),
    "status": status?.toJson(),
  };
}

class Address {
  final String? street;
  final String? city;
  final String? postcode;
  final String? country;
  final Coordinates? coordinates;

  Address({
    this.street,
    this.city,
    this.postcode,
    this.country,
    this.coordinates,
  });

  factory Address.fromJson(Map<String, dynamic> json) => Address(
    street: json["street"],
    city: json["city"],
    postcode: json["postcode"],
    country: json["country"],
    coordinates: json["coordinates"] == null || json["coordinates"] == "" ? null
        : Coordinates.fromJson(SafeJson.asMap(json["coordinates"])),
  );

  Map<String, dynamic> toJson() => {
    "street": street,
    "city": city,
    "postcode": postcode,
    "country": country,
    "coordinates": coordinates?.toJson(),
  };
}

class Coordinates {
  final String? lat;
  final String? long;
  final String? altitude;

  Coordinates({this.lat, this.long, this.altitude});

  factory Coordinates.fromJson(Map<String, dynamic> json) => Coordinates(
    lat: json["lat"],
    long: json["long"],
    altitude: json["altitude"],
  );

  Map<String, dynamic> toJson() => {
    "lat": lat,
    "long": long,
    "altitude": altitude,
  };
}

class Status {
  final String? value;
  final String? label;
  final String? color;
  final String? isDefault;

  Status({this.value, this.label, this.color, this.isDefault});

  factory Status.fromJson(Map<String, dynamic> json) => Status(
    value: json["value"],
    label: json["label"],
    color: json["color"],
    isDefault: json["is_default"],
  );

  Map<String, dynamic> toJson() => {
    "value": value,
    "label": label,
    "color": color,
    "is_default": isDefault,
  };
}

class DeepNesting {
  final Level1? level1;

  DeepNesting({this.level1});

  factory DeepNesting.fromJson(Map<String, dynamic> json) => DeepNesting(
    level1: json["level1"] == null || json["level1"] == "" ? null : Level1.fromJson(SafeJson.asMap(json["level1"])),
  );

  Map<String, dynamic> toJson() => {"level1": level1?.toJson()};
}

class Level1 {
  final String? id;
  final String? name;
  final Level2? level2;

  Level1({this.id, this.name, this.level2});

  factory Level1.fromJson(Map<String, dynamic> json) => Level1(
    id: json["id"],
    name: json["name"],
    level2: json["level2"] == null || json["level2"] == "" ? null : Level2.fromJson(SafeJson.asMap(json["level2"])),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "level2": level2?.toJson(),
  };
}

class Level2 {
  final String? id;
  final String? value;
  final String? active;
  final Level3? level3;

  Level2({this.id, this.value, this.active, this.level3});

  factory Level2.fromJson(Map<String, dynamic> json) => Level2(
    id: json["id"],
    value: json["value"],
    active: json["active"],
    level3: json["level3"] == null || json["level3"] == "" ? null : Level3.fromJson(SafeJson.asMap(json["level3"])),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "value": value,
    "active": active,
    "level3": level3?.toJson(),
  };
}

class Level3 {
  final String? id;
  final String? data;
  final String? count;
  final Level4? level4;

  Level3({this.id, this.data, this.count, this.level4});

  factory Level3.fromJson(Map<String, dynamic> json) => Level3(
    id: json["id"],
    data: json["data"],
    count: json["count"],
    level4: json["level4"] == null || json["level4"] == "" ? null : Level4.fromJson(SafeJson.asMap(json["level4"])),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "data": data,
    "count": count,
    "level4": level4?.toJson(),
  };
}

class Level4 {
  final String? id;
  final String? finalValue;
  final String? isComplete;

  Level4({this.id, this.finalValue, this.isComplete});

  factory Level4.fromJson(Map<String, dynamic> json) => Level4(
    id: json["id"],
    finalValue: json["final_value"],
    isComplete: json["is_complete"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "final_value": finalValue,
    "is_complete": isComplete,
  };
}

class Department {
  final String? id;
  final String? name;
  final String? description;
  final String? headCount;
  final String? budget;
  final String? isActive;

  Department({
    this.id,
    this.name,
    this.description,
    this.headCount,
    this.budget,
    this.isActive,
  });

  factory Department.fromJson(Map<String, dynamic> json) => Department(
    id: json["id"],
    name: json["name"],
    description: json["description"],
    headCount: json["head_count"],
    budget: json["budget"],
    isActive: json["is_active"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "description": description,
    "head_count": headCount,
    "budget": budget,
    "is_active": isActive,
  };
}

class EmptyObject {
  EmptyObject();

  factory EmptyObject.fromJson(Map<String, dynamic> json) => EmptyObject();

  Map<String, dynamic> toJson() => {};
}

class Metadata {
  final String? createdBy;
  final String? updatedBy;
  final String? version;
  final String? isPublished;
  final Settings? settings;

  Metadata({
    this.createdBy,
    this.updatedBy,
    this.version,
    this.isPublished,
    this.settings,
  });

  factory Metadata.fromJson(Map<String, dynamic> json) => Metadata(
    createdBy: json["created_by"],
    updatedBy: json["updated_by"],
    version: json["version"],
    isPublished: json["is_published"],
    settings: json["settings"] == null || json["settings"] == "" ? null
        : Settings.fromJson(SafeJson.asMap(json["settings"])),
  );

  Map<String, dynamic> toJson() => {
    "created_by": createdBy,
    "updated_by": updatedBy,
    "version": version,
    "is_published": isPublished,
    "settings": settings?.toJson(),
  };
}

class Settings {
  final String? theme;
  final String? notificationsEnabled;
  final String? maxItems;
  final String? price;
  final String? nestedNull;

  Settings({
    this.theme,
    this.notificationsEnabled,
    this.maxItems,
    this.price,
    this.nestedNull,
  });

  factory Settings.fromJson(Map<String, dynamic> json) => Settings(
    theme: json["theme"],
    notificationsEnabled: json["notifications_enabled"],
    maxItems: json["max_items"],
    price: json["price"],
    nestedNull: json["nested_null"],
  );

  Map<String, dynamic> toJson() => {
    "theme": theme,
    "notifications_enabled": notificationsEnabled,
    "max_items": maxItems,
    "price": price,
    "nested_null": nestedNull,
  };
}

class MixedArrayClass {
  final String? nestedId;
  final String? nestedName;
  final String? nestedActive;

  MixedArrayClass({this.nestedId, this.nestedName, this.nestedActive});

  factory MixedArrayClass.fromJson(Map<String, dynamic> json) =>
      MixedArrayClass(
        nestedId: json["nested_id"],
        nestedName: json["nested_name"],
        nestedActive: json["nested_active"],
      );

  Map<String, dynamic> toJson() => {
    "nested_id": nestedId,
    "nested_name": nestedName,
    "nested_active": nestedActive,
  };
}

class QrCode {
  final String? id;
  final String? code;
  final String? type;
  final String? typeLabel;
  final String? amountType;
  final String? amountTypeLabel;
  final String? currency;
  final String? scanCount;
  final String? successfulPaymentCount;
  final String? totalAmountCollected;
  final String? isActive;
  final String? isStatic;
  final String? isDynamic;
  final String? hasExpired;
  final String? canAcceptPayments;
  final String? metadata;
  final String? expiresAt;
  final DateTime? createdAt;
  final CreatedBy? store;
  final CreatedBy? createdBy;

  QrCode({
    this.id,
    this.code,
    this.type,
    this.typeLabel,
    this.amountType,
    this.amountTypeLabel,
    this.currency,
    this.scanCount,
    this.successfulPaymentCount,
    this.totalAmountCollected,
    this.isActive,
    this.isStatic,
    this.isDynamic,
    this.hasExpired,
    this.canAcceptPayments,
    this.metadata,
    this.expiresAt,
    this.createdAt,
    this.store,
    this.createdBy,
  });

  factory QrCode.fromJson(Map<String, dynamic> json) => QrCode(
    id: json["id"],
    code: json["code"],
    type: json["type"],
    typeLabel: json["type_label"],
    amountType: json["amount_type"],
    amountTypeLabel: json["amount_type_label"],
    currency: json["currency"],
    scanCount: json["scan_count"],
    successfulPaymentCount: json["successful_payment_count"],
    totalAmountCollected: json["total_amount_collected"],
    isActive: json["is_active"],
    isStatic: json["is_static"],
    isDynamic: json["is_dynamic"],
    hasExpired: json["has_expired"],
    canAcceptPayments: json["can_accept_payments"],
    metadata: json["metadata"],
    expiresAt: json["expires_at"],
    createdAt: json["created_at"] == null || json["created_at"] == "" ? null
        : DateTime.parse(json["created_at"]),
    store: json["store"] == null || json["store"] == "" ? null : CreatedBy.fromJson(SafeJson.asMap(json["store"])),
    createdBy: json["created_by"] == null || json["created_by"] == "" ? null
        : CreatedBy.fromJson(SafeJson.asMap(json["created_by"])),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "code": code,
    "type": type,
    "type_label": typeLabel,
    "amount_type": amountType,
    "amount_type_label": amountTypeLabel,
    "currency": currency,
    "scan_count": scanCount,
    "successful_payment_count": successfulPaymentCount,
    "total_amount_collected": totalAmountCollected,
    "is_active": isActive,
    "is_static": isStatic,
    "is_dynamic": isDynamic,
    "has_expired": hasExpired,
    "can_accept_payments": canAcceptPayments,
    "metadata": metadata,
    "expires_at": expiresAt,
    "created_at": createdAt?.toIso8601String(),
    "store": store?.toJson(),
    "created_by": createdBy?.toJson(),
  };
}

class CreatedBy {
  final String? id;
  final String? name;

  CreatedBy({this.id, this.name});

  factory CreatedBy.fromJson(Map<String, dynamic> json) =>
      CreatedBy(id: json["id"], name: json["name"]);

  Map<String, dynamic> toJson() => {"id": id, "name": name};
}
