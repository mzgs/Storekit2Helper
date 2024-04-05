import 'package:flutter_test/flutter_test.dart';
import 'package:storekit2/storekit2.dart';
import 'package:storekit2/storekit2_platform_interface.dart';
import 'package:storekit2/storekit2_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockStorekit2Platform
    with MockPlatformInterfaceMixin
    implements Storekit2Platform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final Storekit2Platform initialPlatform = Storekit2Platform.instance;

  test('$MethodChannelStorekit2 is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelStorekit2>());
  });

  test('getPlatformVersion', () async {
    Storekit2 storekit2Plugin = Storekit2();
    MockStorekit2Platform fakePlatform = MockStorekit2Platform();
    Storekit2Platform.instance = fakePlatform;

    expect(await storekit2Plugin.getPlatformVersion(), '42');
  });
}
