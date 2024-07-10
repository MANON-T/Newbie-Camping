class UserModel {
  String id;
  String exp;
  final String name;
  final String email;
  UserModel({required this.id, required this.exp , required this.name , required this.email});

  factory UserModel.fromMap(Map<String, dynamic>? user) {
    if (user != null) {
      String id = user['id'];
      String exp = user['exp'];
      String name = user['name'];
      String email = user['email'];
      return UserModel(id: id, exp: exp , name: name, email: email);
    } else {
      throw ArgumentError('Unexpected type for product');
    }
  }
  Map<String, dynamic> toMap() {
    return {'id': id, 'exp': exp , 'name': name, 'email': email};
  }

  Map<String, dynamic> toJson() {
    print(
        'Converting UserModel to JSON with exp: $exp'); // พิมพ์ค่า exp ก่อนแปลงเป็น JSON
    return {
      'id': id,
      'exp': exp, // ตรวจสอบว่ามีค่าถูกต้อง
      'name': name,
      'email': email
    };
  }
}
