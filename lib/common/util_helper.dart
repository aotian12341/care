import 'dart:convert';
import 'dart:typed_data';

/// 工具库
class UtilHelper {
  /// 单例
  static UtilHelper? _instance;

  /// 单例
  factory UtilHelper() {
    _instance ??= UtilHelper._();
    return _instance!;
  }

  /// 构造
  UtilHelper._();

  /// 字符转换为字节数组
  static Uint8List stringToBytes(String str) {
    return Uint8List.fromList(utf8.encode(str));
  }

  /// 字节数组转换为字符
  static String bytesToString(Uint8List bytes) {
    return utf8.decode(bytes);
  }

  /// 字节数组转换为整形数字
  static BigInt bytesToBigInt(Uint8List bytes) {
    BigInt result = BigInt.from(0);
    for (int i = 0; i < bytes.length; i++) {
      result += BigInt.from(bytes[bytes.length - i - 1]) << (8 * i);
    }
    return result;
  }

  /// Base64字符转换为整形数字
  static BigInt base64ToBigInt(String b64) {
    final Uint8List bytes = base64.decode(b64);
    return bytesToBigInt(bytes);
  }
}
