class ModelUser{
  int? id;
  String? name;
  String? email;
  String? phone;
  DateTime? dob;
  String? gender;
  String? address;

  ModelUser({this.id,this.name,this.phone,this.email,this.dob,this.gender,this.address,});

  ModelUser.fromJson(json){
    id = json['id'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    dob = json['dob'];
    gender = json['gender'];
    address = json['address'];
  }



  Map<String,dynamic> toMap(){
    var map = <String,dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['email'] = email;
    map['phone'] = phone;
    map['dob'] = dob.toString();
    map['gender'] = gender;
    map['address'] = address;

    return map;
  }
}