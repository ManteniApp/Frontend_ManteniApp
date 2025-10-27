class UserRegisterModel {
  final String email;
  final String password;
  final String nombre;
  final String phone;

  UserRegisterModel({
    required this.email,
    required this.password,
    required this.nombre,
    required this.phone,
  });

  Map<String, dynamic> toJson() => {
        "email": email,
        "password": password,
        "nombre": nombre,
        "telefono": phone,
      };
}