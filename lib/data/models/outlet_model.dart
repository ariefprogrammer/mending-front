// lib/data/models/outlet_model.dart

class Outlet {
  final int id;
  final String name;
  final String outletCode;
  final String phone;
  final String address;

  Outlet({
    required this.id,
    required this.name,
    required this.outletCode,
    required this.phone,
    required this.address,
  });

  // Fungsi ini bertugas mengubah JSON dari Laravel menjadi Objek Flutter
  factory Outlet.fromJson(Map<String, dynamic> json) {
    return Outlet(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      outletCode: json['outlet_code'] ?? '',
      phone: json['phone'] ?? '',
      address: json['address'] ?? '',
    );
  }

  // (Opsional) Fungsi ini untuk mengubah Objek kembali ke JSON (saat Add Outlet)
  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "outlet_code": outletCode,
      "phone": phone,
      "address": address,
    };
  }
}