import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;

class TundukRemoteDataSource {
  // Переименуем класс позже, но пока оставим
  Future<Map<String, String>?> checkVehicle(String plateNumber) async {
    try {
      final cleanPlate = plateNumber.toUpperCase().trim().replaceAll(' ', '');

      final response = await http.get(
        Uri.parse('https://mashina.kg/carcheck?vinPlate=$cleanPlate'),
        headers: {
          'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36',
        },
      );

      if (response.statusCode != 200) return null;

      final document = parser.parse(response.body);

      String? extract(String label) {
        final elements = document.querySelectorAll('td, p, div, strong, span');
        for (var el in elements) {
          final text = el.text.trim();
          if (text.contains(label)) {
            final next = el.nextElementSibling?.text.trim() ??
                el.parent?.text.split(':').last.trim() ?? '';
            if (next.isNotEmpty) return next;
          }
        }
        return null;
      }

      return {
        'markaModel': extract('Марка/модель') ?? extract('Марка') ?? '',
        'year': extract('Год выпуска') ?? extract('Год') ?? '',
      };
    } catch (e) {
      print('Mashina.kg parsing error: $e');
      return null;
    }
  }
}