import 'package:flutter_dotenv/flutter_dotenv.dart';

final class EnvLoader {
  const EnvLoader._();

  static Future<bool> load({String fileName = '.env'}) async {
    try {
      await dotenv.load(fileName: fileName);
      return true;
    } catch (_) {
      return false;
    }
  }
}
