import 'package:http/http.dart' as http;

class LinkVerifier {
  final client = http.Client();

  Future<bool> isValid(String url) async {
    try {
      final response = await client.head(Uri.parse(url)).timeout(Duration(seconds: 5));
      return response.statusCode >= 200 && response.statusCode < 400;
    } catch (_) {
      return false;
    }
  }
}