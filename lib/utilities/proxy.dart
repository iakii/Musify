// Dart imports:
import 'dart:io';

// Flutter imports:
import 'package:flutter/foundation.dart';

class ProxyClient extends HttpOverrides {
  ProxyClient({required this.proxyAddress});
  final String proxyAddress;

  @override
  HttpClient createHttpClient(SecurityContext? context) {
    final client = super.createHttpClient(context);
    // ignore: avoid_print
    print('设置代理==========================');
    // ignore: cascade_invocations
    client
      ..findProxy = (url) {
        return 'PROXY $proxyAddress';
      }
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true; // 忽略证书错误
    return client;
  }

  static void toggle() {
    if (defaultTargetPlatform == TargetPlatform.windows)
      HttpOverrides.global = ProxyClient(proxyAddress: '127.0.0.1:1080');
    // HttpOverrides.global = null;
  }
}
