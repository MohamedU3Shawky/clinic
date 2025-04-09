class ClinicListRes {
  bool status;
  List<ClinicData> data;
  String message;

  ClinicListRes({
    this.status = false,
    this.data = const <ClinicData>[],
    this.message = "",
  });

  factory ClinicListRes.fromJson(Map<String, dynamic> json) {
    // Log the structure to help debug
    print("ClinicListRes.fromJson received structure with keys: ${json.keys.toList()}");
    
    // Handle the nested data.data array structure which is the primary format now
    if (json.containsKey('status') && json.containsKey('data')) {
      if (json['data'] is Map && json['data'].containsKey('data')) {
        print("Processing nested data.data structure");
        var nestedData = json['data']['data'];
        
        if (nestedData is List) {
          print("Found nested data array with ${nestedData.length} items");
          return ClinicListRes(
            status: json['status'] is bool ? json['status'] : false,
            data: List<ClinicData>.from(nestedData.map((x) => ClinicData.fromJson(x))),
            message: json['message'] is String ? json['message'] : "",
          );
        }
      }
      
      // Regular structure without nesting
      return ClinicListRes(
        status: json['status'] is bool ? json['status'] : false,
        data: json['data'] is List 
            ? List<ClinicData>.from(json['data'].map((x) => ClinicData.fromJson(x))) 
            : json['data'] is Map 
                ? _extractClinicsFromMap(json['data'])
                : [],
        message: json['message'] is String ? json['message'] : "",
      );
    }
    
    // Case 2: Response with clinics at root level
    if (json.containsKey('clinics') && json['clinics'] is List) {
      return ClinicListRes(
        status: true,
        data: List<ClinicData>.from(json['clinics'].map((x) => ClinicData.fromJson(x))),
        message: "Clinics retrieved successfully",
      );
    }
    
    // Case 3: When the response itself is a map of clinics (key-value pairs where values are clinic objects)
    List<ClinicData> clinicsFromMap = _extractClinicsFromMap(json);
    if (clinicsFromMap.isNotEmpty) {
      return ClinicListRes(
        status: true,
        data: clinicsFromMap,
        message: "Clinics retrieved successfully",
      );
    }
    
    // Case 4: If no recognized structure, return empty result
    print("Warning: Unrecognized clinic response structure");
    return ClinicListRes(
      status: false,
      data: [],
      message: "Failed to parse clinic data",
    );
  }
  
  // Helper method to extract clinics from a map structure
  static List<ClinicData> _extractClinicsFromMap(Map<String, dynamic> map) {
    List<ClinicData> result = [];
    
    map.forEach((key, value) {
      if (value is Map<String, dynamic>) {
        // If the value has required clinic properties, treat it as a clinic
        if (value.containsKey('id') && (value.containsKey('name') || value.containsKey('label'))) {
          // Use name if available, otherwise use label
          if (!value.containsKey('name') && value.containsKey('label')) {
            value['name'] = value['label'];
          }
          
          try {
            result.add(ClinicData.fromJson(value));
            print("Extracted clinic with ID: ${value['id']} and name: ${value['name']}");
          } catch (e) {
            print("Error parsing clinic from map: $e");
          }
        }
      }
    });
    
    return result;
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'data': data.map((e) => e.toJson()).toList(),
      'message': message,
    };
  }
}

class ClinicData {
  dynamic id;
  String slug;
  String name;
  String email;
  String description;
  int systemServiceCategory;
  String specialty;
  String contactNumber;
  String? phone;
  String? QRCode;
  List<dynamic> openingHours;
  int countryId;
  int stateId;
  int cityId;
  String countryName;
  String stateName;
  String cityName;
  String address;
  String pincode;
  String latitude;
  String longitude;
  String distance;
  String distanceFormate;
  int status;
  String clinicStatus;
  String clinicImage;
  int timeSlot;
  int totalServices;
  int totalDoctors;
  int totalGalleryImages;
  int createdBy;
  int updatedBy;
  int deletedBy;
  String createdAt;
  String updatedAt;
  String deletedAt;
  String? customerId;
  String? branchLat;
  String? branchLng;

  ClinicData({
    this.id = -1,
    this.slug = "",
    this.name = "",
    this.email = "",
    this.description = "",
    this.systemServiceCategory = -1,
    this.specialty = "",
    this.contactNumber = "",
    this.phone,
    this.QRCode,
    this.openingHours = const [],
    this.countryId = -1,
    this.stateId = -1,
    this.cityId = -1,
    this.countryName = "",
    this.stateName = "",
    this.cityName = "",
    this.address = "",
    this.pincode = "",
    this.latitude = "",
    this.longitude = "",
    this.distance = "",
    this.distanceFormate = "",
    this.status = -1,
    this.clinicStatus = "",
    this.clinicImage = "",
    this.timeSlot = -1,
    this.totalServices = 0,
    this.totalDoctors = 0,
    this.totalGalleryImages = 0,
    this.createdBy = -1,
    this.updatedBy = -1,
    this.deletedBy = -1,
    this.createdAt = "",
    this.updatedAt = "",
    this.deletedAt = "",
    this.customerId,
    this.branchLat,
    this.branchLng,
  });

  factory ClinicData.fromJson(Map<String, dynamic> json) {
    // Handle id (can be int or string)
    dynamic clinicId = json['id'] ?? -1;
    
    // Handle status (can be int or string)
    int statusValue = -1;
    if (json['status'] is int) {
      statusValue = json['status'];
    } else if (json['status'] is String) {
      // Convert string status to int (Active = 1, Inactive = 0)
      statusValue = json['status']?.toString().toLowerCase() == 'active' ? 1 : 0;
    }
    
    return ClinicData(
      id: clinicId,
      slug: json['slug'] is String ? json['slug'] : "",
      name: json['name'] is String ? json['name'] : "",
      email: json['email'] is String ? json['email'] : "",
      description: json['description'] is String ? json['description'] : "",
      systemServiceCategory: json['system_service_category'] is int ? json['system_service_category'] : -1,
      specialty: json['specialty'] is String ? json['specialty'] : "",
      contactNumber: json['contact_number'] is String ? json['contact_number'] : "",
      phone: json['phone'] is String ? json['phone'] : null,
      QRCode: json['QRCode'] is String ? json['QRCode'] : null,
      openingHours: json['openingHours'] is List ? json['openingHours'] : [],
      countryId: _parseIntValue(json['country_id']),
      stateId: _parseIntValue(json['state_id']),
      cityId: _parseIntValue(json['city_id']),
      countryName: json['country_name'] is String ? json['country_name'] : "",
      stateName: json['state_name'] is String ? json['state_name'] : "",
      cityName: json['city_name'] is String ? json['city_name'] : "",
      address: json['address'] is String ? json['address'] : "",
      pincode: json['pincode'] is String ? json['pincode'] : "",
      latitude: json['latitude'] is String ? json['latitude'] : "",
      longitude: json['longitude'] is String ? json['longitude'] : "",
      distance: json['distance'] is String ? json['distance'] : "",
      distanceFormate: json['distance_formate'] is String ? json['distance_formate'] : "",
      status: statusValue,
      clinicStatus: json['status'] is String ? json['status'] : "",
      clinicImage: json['clinic_image'] is String ? json['clinic_image'] : 
                  (json['image'] is String ? json['image'] : ""),
      timeSlot: _parseIntValue(json['time_slot']),
      totalServices: _parseIntValue(json['total_services']),
      totalDoctors: _parseIntValue(json['total_doctors']),
      totalGalleryImages: _parseIntValue(json['total_gallery_images']),
      updatedBy: _parseIntValue(json['updated_by']),
      deletedBy: _parseIntValue(json['deleted_by']),
      createdBy: _parseIntValue(json['created_by']),
      createdAt: json['createdAt'] is String ? json['createdAt'] : json['created_at'] is String ? json['created_at'] : "",
      updatedAt: json['updatedAt'] is String ? json['updatedAt'] : json['updated_at'] is String ? json['updated_at'] : "",
      deletedAt: json['deletedAt'] is String ? json['deletedAt'] : json['deleted_at'] is String ? json['deleted_at'] : "",
      customerId: json['customerId'] is String ? json['customerId'] : null,
      branchLat: json['branchLat'] is String ? json['branchLat'] : null,
      branchLng: json['branchLng'] is String ? json['branchLng'] : null,
    );
  }
  
  static int _parseIntValue(dynamic value) {
    if (value is int) {
      return value;
    } else if (value is String) {
      try {
        return int.parse(value);
      } catch (e) {
        return -1;
      }
    }
    return -1;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'slug': slug,
      'name': name,
      'email': email,
      'description': description,
      'system_service_category': systemServiceCategory,
      'specialty': specialty,
      'contact_number': contactNumber,
      'phone': phone,
      'QRCode': QRCode,
      'openingHours': openingHours,
      'country_id': countryId,
      'state_id': stateId,
      'city_id': cityId,
      'country_name': countryName,
      'state_name': stateName,
      'city_name': cityName,
      'address': address,
      'pincode': pincode,
      'latitude': latitude,
      'longitude': longitude,
      'distance': distance,
      'distance_formate': distanceFormate,
      'status': status,
      'clinic_status': clinicStatus,
      'clinic_image': clinicImage,
      'time_slot': timeSlot,
      'total_services': totalServices,
      'total_doctors': totalDoctors,
      'total_gallery_images': totalGalleryImages,
      'created_by': createdBy,
      'updated_by': updatedBy,
      'deleted_by': deletedBy,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'deleted_at': deletedAt,
      'customerId': customerId,
      'branchLat': branchLat,
      'branchLng': branchLng,
    };
  }
}
