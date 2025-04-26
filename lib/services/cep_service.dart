import 'dart:convert';
import 'package:http/http.dart' as http;

class CepService {
  static Future<Map<String, dynamic>?> getAddressByCep(String cep) async {
    final formattedCep = cep.replaceAll(RegExp(r'[^0-9]'), '');
    final url = Uri.parse("https://viacep.com.br/ws/$formattedCep/json/");

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data.containsKey("erro")) {
        return null;
      }
      return data;
    } else {
      return null;
    }
  }
}
