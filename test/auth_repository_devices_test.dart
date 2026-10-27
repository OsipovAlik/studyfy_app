import 'package:flutter_test/flutter_test.dart';
import 'package:studify/features/auth/data/auth_repository.dart';

import 'support/fakes.dart';

void main() {
  late FakeApi api;
  late AuthRepository repository;

  setUp(() {
    api = FakeApi();
    repository = AuthRepository(fakeClient(api));
  });

  test('registerDevice sends the token and platform', () async {
    api.on('POST /devices', [
      const FakeResponse(200, {'message': 'Device registered'}),
    ]);

    await repository.registerDevice(token: 'fcm-token-1', platform: 'android');

    final request = api.requestsTo('POST /devices').single;
    expect(api.bodyOf(request), {
      'token': 'fcm-token-1',
      'platform': 'android',
    });
  });

  test('unregisterDevice sends the token', () async {
    api.on('DELETE /devices', [
      const FakeResponse(200, {'message': 'Device unregistered'}),
    ]);

    await repository.unregisterDevice('fcm-token-1');

    final request = api.requestsTo('DELETE /devices').single;
    expect(api.bodyOf(request), {'token': 'fcm-token-1'});
  });
}
