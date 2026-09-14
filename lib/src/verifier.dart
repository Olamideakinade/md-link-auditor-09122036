import 'package:http/http.dart' as http;

class LinkVerifier {
  final http.Client _client = http.Client();

  Future<bool> isValid(String url) async {
    try {
      final response = await _client.head(Uri.parse(url)).timeout(const Duration(seconds: 5));
      return response.statusCode >= 200 && response.statusCode < 400;
    } catch (_) {
      return false;
    }
  }

  void close() => _client.close();
}