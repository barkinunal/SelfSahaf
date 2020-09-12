class Address {
  int addressID;
  String addressName;
  String addressLine;
  String postalCode;
  String city;
  String country;
  Address(
      {this.addressID,
      this.addressName,
      this.addressLine,
      this.postalCode,
      this.city,
      this.country});
  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      addressID: json['addressID'],
      addressName: json['addressName'],
      addressLine: json['addressLine'],
      postalCode: json['postalCode']['postalCode'],
      city: json['postalCode']['city'],
      country: json['postalCode']['country'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      "addressLine": this.addressLine,
      "addressName": this.addressName,
      "postalCode": {
        "postalCode": this.postalCode,
        "city": this.city,
        "country": this.country
      }
    };
  }
   Map<String, dynamic> toUpdateJson() {
    return {
      "addressLine": this.addressLine,
      "addressName": this.addressName,
       "addressID":addressID,
      "postalCode": {
        "postalCode": this.postalCode,
        "city": this.city,
        "country": this.country
      }
     
    };
  }
}
