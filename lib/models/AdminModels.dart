class Admin {
  String? key;
  AdminData? adminData;

  Admin(this.key, this.adminData);

  Map<String, dynamic> toJson() {
    return {
      'key': key,
      'adminData': adminData?.toJson(),
    };
  }

  factory Admin.fromJson(Map<String, dynamic> json) {
    return Admin(
      json['key'],
      AdminData.fromJson(json['adminData']),
    );
  }
}

class AdminData {
  String? name;
  String? email;
  String? phoneNumber;
  String? address;
  String? password;


  AdminData( this.name,this.email, this.phoneNumber, this.address,this.password);

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "email": email,
      "phoneNumber": phoneNumber,
      "address": address,
      "password": password,

    };
  }

  AdminData.fromJson(Map<dynamic, dynamic> json) {
    name = json["name"];
    email = json["email"];
    phoneNumber = json["phoneNumber"];
    address = json["address"];
    password = json["password"];

  }
}

