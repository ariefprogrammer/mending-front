class ApiConstants {
  // Jika suatu saat ganti ke produksi, cukup ganti di sini
  static const String baseUrl = "http://10.244.247.103:8000/api";
  
  // Auth
  static const String register = "$baseUrl/v1/register";
  static const String login = "$baseUrl/v1/login";
  static const String logout = "$baseUrl/v1/logout";

  // Outlets
  static const String outlets = "$baseUrl/v1/outlets";
  static String showOutlet(int id) => "$baseUrl/v1/outlets/$id";
  static String configureOutlet(int id) => "$baseUrl/v1/outlets/$id/configuration";
  static String getOutletConfiguration(int id) => "$baseUrl/v1/outlets/$id/configuration";

}

