import '../entities/profile_entity.dart';

class ProfileModel extends ProfileEntity {
  ProfileModel({
    required super.id,
    required super.firstName,
    required super.lastName,
    required super.maidenName,
    required super.age,
    required super.gender,
    required super.email,
    required super.phone,
    required super.username,
    required super.password,
    required super.birthDate,
    required super.image,
    required super.bloodGroup,
    required super.height,
    required super.weight,
    required super.eyeColor,
    required super.hair,
    required super.ip,
    required super.address,
    required super.macAddress,
    required super.university,
    required super.bank,
    required super.company,
    required super.ein,
    required super.ssn,
    required super.userAgent,
    required super.crypto,
    required super.role,
  });
  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json["id"] ?? 0,
      firstName: json["firstName"] ?? "",
      lastName: json["lastName"] ?? "",
      maidenName: json["maidenName"] ?? "",
      age: json["age"] ?? 0,
      gender: json["gender"] ?? "",
      email: json["email"] ?? "",
      phone: json["phone"] ?? "",
      username: json["username"] ?? "",
      password: json["password"] ?? "",
      birthDate: json["birthDate"] ?? "",
      image: json["image"] ?? "",
      bloodGroup: json["bloodGroup"] ?? "",
      height: json["height"] ?? 0.0,
      weight: json["weight"] ?? 0.0,
      eyeColor: json["eyeColor"] ?? "",
      hair: json["hair"] == null ? null : Hair.fromJson(json["hair"]),
      ip: json["ip"] ?? "",
      address: json["address"] == null
          ? null
          : Address.fromJson(json["address"]),
      macAddress: json["macAddress"] ?? "",
      university: json["university"] ?? "",
      bank: json["bank"] == null ? null : Bank.fromJson(json["bank"]),
      company: json["company"] == null
          ? null
          : Company.fromJson(json["company"]),
      ein: json["ein"] ?? "",
      ssn: json["ssn"] ?? "",
      userAgent: json["userAgent"] ?? "",
      crypto: json["crypto"] == null ? null : Crypto.fromJson(json["crypto"]),
      role: json["role"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "firstName": firstName,
    "lastName": lastName,
    "maidenName": maidenName,
    "age": age,
    "gender": gender,
    "email": email,
    "phone": phone,
    "username": username,
    "password": password,
    "birthDate": birthDate,
    "image": image,
    "bloodGroup": bloodGroup,
    "height": height,
    "weight": weight,
    "eyeColor": eyeColor,
    "hair": hair,
    "ip": ip,
    "address": address,
    "macAddress": macAddress,
    "university": university,
    "bank": bank,
    "company": company,
    "ein": ein,
    "ssn": ssn,
    "userAgent": userAgent,
    "crypto": crypto,
    "role": role,
  };
}

class Address extends AddressEntity {
  Address({
    required super.address,
    required super.city,
    required super.state,
    required super.stateCode,
    required super.postalCode,
    required super.coordinates,
    required super.country,
  });
  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      address: json["address"] ?? "",
      city: json["city"] ?? "",
      state: json["state"] ?? "",
      stateCode: json["stateCode"] ?? "",
      postalCode: json["postalCode"] ?? "",
      coordinates: json["coordinates"] == null
          ? null
          : Coordinates.fromJson(json["coordinates"]),
      country: json["country"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "address": address,
    "city": city,
    "state": state,
    "stateCode": stateCode,
    "postalCode": postalCode,
    "coordinates": coordinates,
    "country": country,
  };
}

class Coordinates extends CoordinatesEntity {
  Coordinates({required super.lat, required super.lng});
  factory Coordinates.fromJson(Map<String, dynamic> json) {
    return Coordinates(lat: json["lat"] ?? 0.0, lng: json["lng"] ?? 0.0);
  }

  Map<String, dynamic> toJson() => {"lat": lat, "lng": lng};
}

class Bank extends BankEntity {
  Bank({
    required super.cardExpire,
    required super.cardNumber,
    required super.cardType,
    required super.currency,
    required super.iban,
  });

  factory Bank.fromJson(Map<String, dynamic> json) {
    return Bank(
      cardExpire: json["cardExpire"] ?? "",
      cardNumber: json["cardNumber"] ?? "",
      cardType: json["cardType"] ?? "",
      currency: json["currency"] ?? "",
      iban: json["iban"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "cardExpire": cardExpire,
    "cardNumber": cardNumber,
    "cardType": cardType,
    "currency": currency,
    "iban": iban,
  };
}

class Company extends CompanyEntity {
  Company({
    required super.department,
    required super.name,
    required super.title,
    required super.address,
  });

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      department: json["department"] ?? "",
      name: json["name"] ?? "",
      title: json["title"] ?? "",
      address: json["address"] == null
          ? null
          : Address.fromJson(json["address"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "department": department,
    "name": name,
    "title": title,
    "address": address,
  };
}

class Crypto extends CryptoEntity {
  Crypto({required super.coin, required super.wallet, required super.network});

  factory Crypto.fromJson(Map<String, dynamic> json) {
    return Crypto(
      coin: json["coin"] ?? "",
      wallet: json["wallet"] ?? "",
      network: json["network"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "coin": coin,
    "wallet": wallet,
    "network": network,
  };
}

class Hair extends HairEntity {
  Hair({required super.color, required super.type});

  factory Hair.fromJson(Map<String, dynamic> json) {
    return Hair(color: json["color"] ?? "", type: json["type"] ?? "");
  }

  Map<String, dynamic> toJson() => {"color": color, "type": type};
}
