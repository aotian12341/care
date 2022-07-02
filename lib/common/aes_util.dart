import 'dart:convert';
import 'dart:typed_data';

import 'package:encrypt/encrypt.dart';

import '../controller/user_controller.dart';
import 'pugin_utils.dart';

class AesUtil {
  static Future<String?> aesDecode(String content) async {
    return await PluginUtils().aesDecode(content);
  }

  static String getTk() {
    final map = {
      "rt": DateTime.now().millisecondsSinceEpoch,
      "token": UserController().token ?? "",
      "vt": 40000000
    };
    final str = json.encode(map);
    final tk = aesD(str);
    return tk;
  }

  static String aesD(String content) {
    String _key = "0JrF8oS+Q/eeb5LczgMPlA==";
    final key = Key.fromBase64(_key);
    final encrypter = Encrypter(AES(key, mode: AESMode.ecb));
    final text = content;
    final iv = IV.fromLength(16);
    final encrypted = encrypter.encrypt(text, iv: iv);
    final decrypted = encrypter.decrypt(encrypted, iv: iv);

    print(decrypted);
    print(encrypted.base64);

    String temp = encrypted.base64.replaceAll("\\s*", "");
    temp = temp.replaceAll("\t", "");
    temp = temp.replaceAll("\r", "");
    temp = temp.replaceAll("\n", "");

    return temp;
  }

  String hex2base64(String hex) {
    String base64String = '';
    try {
      for (int i = 0; i < hex.length / 2; i++) {
        int code = int.parse(hex.substring(i * 2, i * 2 + 2), radix: 16);
        base64String += String.fromCharCode(code);
      }
      String str = '';
      Uint8List result = base64.decode(base64String);
      result.forEach((int v) {
        str += String.fromCharCode(v);
      });
      return str;
    } catch (err) {
      return "";
    }
  }
}
