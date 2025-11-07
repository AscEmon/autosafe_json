// To parse this JSON data, do
//
//     final testResponse = testResponseFromJson(jsonString);

import 'dart:convert';
import 'package:autosafe_json/autosafe_json.dart';

List<TestResponse> testResponseFromJson(String str) => List<TestResponse>.from(json.decode(str).map((x) => TestResponse.fromJson(x)));

String testResponseToJson(List<TestResponse> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TestResponse {
    final String? code;
    final String? message;
    final Data? data;

    TestResponse({
        this.code,
        this.message,
        this.data,
    });

    factory TestResponse.fromJson(Map<String, dynamic> json) {
    json = json.autoSafe.raw;
    return TestResponse(
        code: SafeJson.asString(json["code"]),
        message: SafeJson.asString(json["message"]),
        data: json["data"] == null || json["data"] == "" ? null : Data.fromJson(SafeJson.asMap(json["data"])),
    );
  }

    Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "data": data?.toJson(),
    };
}

class Data {
    final int? id;
    final String? name;
    final String? email;
    final String? age;
    final String? salary;
    final IsActive? isActive;
    final bool? isVerified;
    final String? profileImageUrl;
    final String? tags;
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

    Data({
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

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: SafeJson.asInt(json["id"]),
        name: SafeJson.asString(json["name"]),
        email: SafeJson.asString(json["email"]),
        age: SafeJson.asString(json["age"]),
        salary: SafeJson.asString(json["salary"]),
        isActive: json["is_active"] == null || json["is_active"] == "" ? null : IsActive.fromJson(SafeJson.asMap(json["is_active"])),
        isVerified: SafeJson.asBool(json["is_verified"]),
        profileImageUrl: SafeJson.asString(json["profile_image_url"]),
        tags: SafeJson.asString(json["tags"]),
        metadata: json["metadata"] == null || json["metadata"] == "" ? null : Metadata.fromJson(SafeJson.asMap(json["metadata"])),
        business: json["business"] == null || json["business"] == "" ? null : Business.fromJson(SafeJson.asMap(json["business"])),
        departments: json["departments"] == null || json["departments"] == "" ? [] : List<Department>.from(SafeJson.asList(json["departments"]).map((x) => Department.fromJson(x))),
        qrCodes: json["qr_codes"] == null || json["qr_codes"] == "" ? [] : List<QrCode>.from(SafeJson.asList(json["qr_codes"]).map((x) => QrCode.fromJson(x))),
        permissions: json["permissions"] == null || json["permissions"] == "" ? [] : List<bool?>.from(SafeJson.asList(json["permissions"]).map((x) => x)),
        scores: json["scores"] == null || json["scores"] == "" ? [] : List<double?>.from(SafeJson.asList(json["scores"]).map((x) => x)),
        mixedArray: json["mixed_array"] == null || json["mixed_array"] == "" ? [] : List<dynamic>.from(SafeJson.asList(json["mixed_array"]).map((x) => x)),
        emptyObject: json["empty_object"] == null || json["empty_object"] == "" ? null : EmptyObject.fromJson(SafeJson.asMap(json["empty_object"])),
        emptyArray: json["empty_array"] == null || json["empty_array"] == "" ? [] : List<dynamic>.from(SafeJson.asList(json["empty_array"]).map((x) => x)),
        deepNesting: json["deep_nesting"] == null || json["deep_nesting"] == "" ? null : DeepNesting.fromJson(SafeJson.asMap(json["deep_nesting"])),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "age": age,
        "salary": salary,
        "is_active": isActive?.toJson(),
        "is_verified": isVerified,
        "profile_image_url": profileImageUrl,
        "tags": tags,
        "metadata": metadata?.toJson(),
        "business": business?.toJson(),
        "departments": departments == null ? [] : List<dynamic>.from(departments!.map((x) => x.toJson())),
        "qr_codes": qrCodes == null ? [] : List<dynamic>.from(qrCodes!.map((x) => x.toJson())),
        "permissions": permissions == null ? [] : List<dynamic>.from(permissions!.map((x) => x)),
        "scores": scores == null ? [] : List<dynamic>.from(scores!.map((x) => x)),
        "mixed_array": mixedArray == null ? [] : List<dynamic>.from(mixedArray!.map((x) => x)),
        "empty_object": emptyObject?.toJson(),
        "empty_array": emptyArray == null ? [] : List<dynamic>.from(emptyArray!.map((x) => x)),
        "deep_nesting": deepNesting?.toJson(),
    };
}

class Business {
    final int? id;
    final String? name;
    final String? legalName;
    final int? businessTypeId;
    final String? salesEstimationRangeId;
    final double? averageTransactionValue;
    final bool? isActive;
    final int? employeeCount;
    final double? rating;
    final Address? address;
    final List<bool>? status;

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
        id: SafeJson.asInt(json["id"]),
        name: SafeJson.asString(json["name"]),
        legalName: SafeJson.asString(json["legal_name"]),
        businessTypeId: SafeJson.asInt(json["business_type_id"]),
        salesEstimationRangeId: SafeJson.asString(json["sales_estimation_range_id"]),
        averageTransactionValue: SafeJson.asDouble(json["average_transaction_value"]),
        isActive: SafeJson.asBool(json["is_active"]),
        employeeCount: SafeJson.asInt(json["employee_count"]),
        rating: SafeJson.asDouble(json["rating"]),
        address: json["address"] == null || json["address"] == "" ? null : Address.fromJson(SafeJson.asMap(json["address"])),
        status: json["status"] == null || json["status"] == "" ? [] : List<bool>.from(json["status"]!.map((x) => x)),
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
        "status": status == null ? [] : List<dynamic>.from(status!.map((x) => x)),
    };
}

class Address {
    final String? street;
    final String? city;
    final int? postcode;
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
        street: SafeJson.asString(json["street"]),
        city: SafeJson.asString(json["city"]),
        postcode: SafeJson.asInt(json["postcode"]),
        country: SafeJson.asString(json["country"]),
        coordinates: json["coordinates"] == null || json["coordinates"] == "" ? null : Coordinates.fromJson(SafeJson.asMap(json["coordinates"])),
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
    final double? long;
    final String? altitude;

    Coordinates({
        this.lat,
        this.long,
        this.altitude,
    });

    factory Coordinates.fromJson(Map<String, dynamic> json) => Coordinates(
        lat: SafeJson.asString(json["lat"]),
        long: SafeJson.asDouble(json["long"]),
        altitude: SafeJson.asString(json["altitude"]),
    );

    Map<String, dynamic> toJson() => {
        "lat": lat,
        "long": long,
        "altitude": altitude,
    };
}

class DeepNesting {
    final Level1? level1;

    DeepNesting({
        this.level1,
    });

    factory DeepNesting.fromJson(Map<String, dynamic> json) => DeepNesting(
        level1: json["level1"] == null || json["level1"] == "" ? null : Level1.fromJson(SafeJson.asMap(json["level1"])),
    );

    Map<String, dynamic> toJson() => {
        "level1": level1?.toJson(),
    };
}

class Level1 {
    final int? id;
    final String? name;
    final Level2? level2;

    Level1({
        this.id,
        this.name,
        this.level2,
    });

    factory Level1.fromJson(Map<String, dynamic> json) => Level1(
        id: SafeJson.asInt(json["id"]),
        name: SafeJson.asString(json["name"]),
        level2: json["level2"] == null || json["level2"] == "" ? null : Level2.fromJson(SafeJson.asMap(json["level2"])),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "level2": level2?.toJson(),
    };
}

class Level2 {
    final int? id;
    final double? value;
    final bool? active;
    final Level3? level3;

    Level2({
        this.id,
        this.value,
        this.active,
        this.level3,
    });

    factory Level2.fromJson(Map<String, dynamic> json) => Level2(
        id: SafeJson.asInt(json["id"]),
        value: SafeJson.asDouble(json["value"]),
        active: SafeJson.asBool(json["active"]),
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
    final int? id;
    final String? data;
    final int? count;
    final Level4? level4;

    Level3({
        this.id,
        this.data,
        this.count,
        this.level4,
    });

    factory Level3.fromJson(Map<String, dynamic> json) => Level3(
        id: SafeJson.asInt(json["id"]),
        data: SafeJson.asString(json["data"]),
        count: SafeJson.asInt(json["count"]),
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
    final int? id;
    final String? finalValue;
    final bool? isComplete;

    Level4({
        this.id,
        this.finalValue,
        this.isComplete,
    });

    factory Level4.fromJson(Map<String, dynamic> json) => Level4(
        id: SafeJson.asInt(json["id"]),
        finalValue: SafeJson.asString(json["final_value"]),
        isComplete: SafeJson.asBool(json["is_complete"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "final_value": finalValue,
        "is_complete": isComplete,
    };
}

class Department {
    final int? id;
    final String? name;
    final String? description;
    final int? headCount;
    final int? budget;
    final bool? isActive;

    Department({
        this.id,
        this.name,
        this.description,
        this.headCount,
        this.budget,
        this.isActive,
    });

    factory Department.fromJson(Map<String, dynamic> json) => Department(
        id: SafeJson.asInt(json["id"]),
        name: SafeJson.asString(json["name"]),
        description: SafeJson.asString(json["description"]),
        headCount: SafeJson.asInt(json["head_count"]),
        budget: SafeJson.asInt(json["budget"]),
        isActive: SafeJson.asBool(json["is_active"]),
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

    factory EmptyObject.fromJson(Map<String, dynamic> json) => EmptyObject(
    );

    Map<String, dynamic> toJson() => {
    };
}

class IsActive {
    final List<String>? v;

    IsActive({
        this.v,
    });

    factory IsActive.fromJson(Map<String, dynamic> json) => IsActive(
        v: json["v"] == null || json["v"] == "" ? [] : List<String>.from(json["v"]!.map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "v": v == null ? [] : List<dynamic>.from(v!.map((x) => x)),
    };
}

class Metadata {
    final int? createdBy;
    final String? updatedBy;
    final double? version;
    final bool? isPublished;
    final Settings? settings;

    Metadata({
        this.createdBy,
        this.updatedBy,
        this.version,
        this.isPublished,
        this.settings,
    });

    factory Metadata.fromJson(Map<String, dynamic> json) => Metadata(
        createdBy: SafeJson.asInt(json["created_by"]),
        updatedBy: SafeJson.asString(json["updated_by"]),
        version: SafeJson.asDouble(json["version"]),
        isPublished: SafeJson.asBool(json["is_published"]),
        settings: json["settings"] == null || json["settings"] == "" ? null : Settings.fromJson(SafeJson.asMap(json["settings"])),
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
    final bool? notificationsEnabled;
    final int? maxItems;
    final double? price;
    final String? nestedNull;

    Settings({
        this.theme,
        this.notificationsEnabled,
        this.maxItems,
        this.price,
        this.nestedNull,
    });

    factory Settings.fromJson(Map<String, dynamic> json) => Settings(
        theme: SafeJson.asString(json["theme"]),
        notificationsEnabled: SafeJson.asBool(json["notifications_enabled"]),
        maxItems: SafeJson.asInt(json["max_items"]),
        price: SafeJson.asDouble(json["price"]),
        nestedNull: SafeJson.asString(json["nested_null"]),
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
    final int? nestedId;
    final String? nestedName;
    final bool? nestedActive;

    MixedArrayClass({
        this.nestedId,
        this.nestedName,
        this.nestedActive,
    });

    factory MixedArrayClass.fromJson(Map<String, dynamic> json) => MixedArrayClass(
        nestedId: SafeJson.asInt(json["nested_id"]),
        nestedName: SafeJson.asString(json["nested_name"]),
        nestedActive: SafeJson.asBool(json["nested_active"]),
    );

    Map<String, dynamic> toJson() => {
        "nested_id": nestedId,
        "nested_name": nestedName,
        "nested_active": nestedActive,
    };
}

class QrCode {
    final int? id;
    final String? code;
    final int? type;
    final String? typeLabel;
    final int? amountType;
    final String? amountTypeLabel;
    final String? currency;
    final int? scanCount;
    final String? successfulPaymentCount;
    final double? totalAmountCollected;
    final bool? isActive;
    final bool? isStatic;
    final bool? isDynamic;
    final bool? hasExpired;
    final bool? canAcceptPayments;
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
        id: SafeJson.asInt(json["id"]),
        code: SafeJson.asString(json["code"]),
        type: SafeJson.asInt(json["type"]),
        typeLabel: SafeJson.asString(json["type_label"]),
        amountType: SafeJson.asInt(json["amount_type"]),
        amountTypeLabel: SafeJson.asString(json["amount_type_label"]),
        currency: SafeJson.asString(json["currency"]),
        scanCount: SafeJson.asInt(json["scan_count"]),
        successfulPaymentCount: SafeJson.asString(json["successful_payment_count"]),
        totalAmountCollected: SafeJson.asDouble(json["total_amount_collected"]),
        isActive: SafeJson.asBool(json["is_active"]),
        isStatic: SafeJson.asBool(json["is_static"]),
        isDynamic: SafeJson.asBool(json["is_dynamic"]),
        hasExpired: SafeJson.asBool(json["has_expired"]),
        canAcceptPayments: SafeJson.asBool(json["can_accept_payments"]),
        metadata: SafeJson.asString(json["metadata"]),
        expiresAt: SafeJson.asString(json["expires_at"]),
        createdAt: json["created_at"] == null || json["created_at"] == "" ? null : DateTime.parse(json["created_at"]),
        store: json["store"] == null || json["store"] == "" ? null : CreatedBy.fromJson(SafeJson.asMap(json["store"])),
        createdBy: json["created_by"] == null || json["created_by"] == "" ? null : CreatedBy.fromJson(SafeJson.asMap(json["created_by"])),
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
    final int? id;
    final String? name;

    CreatedBy({
        this.id,
        this.name,
    });

    factory CreatedBy.fromJson(Map<String, dynamic> json) => CreatedBy(
        id: SafeJson.asInt(json["id"]),
        name: SafeJson.asString(json["name"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
    };
}
