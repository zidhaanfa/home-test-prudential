class ProfileEntity {
  ProfileEntity({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.maidenName,
    required this.age,
    required this.gender,
    required this.email,
    required this.phone,
    required this.username,
    required this.password,
    required this.birthDate,
    required this.image,
    required this.bloodGroup,
    required this.height,
    required this.weight,
    required this.eyeColor,
    required this.hair,
    required this.ip,
    required this.address,
    required this.macAddress,
    required this.university,
    required this.bank,
    required this.company,
    required this.ein,
    required this.ssn,
    required this.userAgent,
    required this.crypto,
    required this.role,
  });

  final int id;
  final String firstName;
  final String lastName;
  final String maidenName;
  final int age;
  final String gender;
  final String email;
  final String phone;
  final String username;
  final String password;
  final String birthDate;
  final String image;
  final String bloodGroup;
  final double height;
  final double weight;
  final String eyeColor;
  final HairEntity? hair;
  final String ip;
  final AddressEntity? address;
  final String macAddress;
  final String university;
  final BankEntity? bank;
  final CompanyEntity? company;
  final String ein;
  final String ssn;
  final String userAgent;
  final CryptoEntity? crypto;
  final String role;
}

class AddressEntity {
  AddressEntity({
    required this.address,
    required this.city,
    required this.state,
    required this.stateCode,
    required this.postalCode,
    required this.coordinates,
    required this.country,
  });

  final String address;
  final String city;
  final String state;
  final String stateCode;
  final String postalCode;
  final CoordinatesEntity? coordinates;
  final String country;
}

class CoordinatesEntity {
  CoordinatesEntity({required this.lat, required this.lng});

  final double lat;
  final double lng;
}

class BankEntity {
  BankEntity({
    required this.cardExpire,
    required this.cardNumber,
    required this.cardType,
    required this.currency,
    required this.iban,
  });

  final String cardExpire;
  final String cardNumber;
  final String cardType;
  final String currency;
  final String iban;
}

class CompanyEntity {
  CompanyEntity({
    required this.department,
    required this.name,
    required this.title,
    required this.address,
  });

  final String department;
  final String name;
  final String title;
  final AddressEntity? address;
}

class HairEntity {
  HairEntity({required this.color, required this.type});

  final String color;
  final String type;
}

class CryptoEntity {
  CryptoEntity({
    required this.coin,
    required this.wallet,
    required this.network,
  });

  final String coin;
  final String wallet;
  final String network;
}
