import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'storekit2_platform_interface.dart';

/// An implementation of [Storekit2Platform] that uses method channels.
class MethodChannelStorekit2 extends Storekit2Platform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('storekit2helper');

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
