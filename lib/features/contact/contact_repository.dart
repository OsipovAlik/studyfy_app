import 'package:studify/core/network/api_client.dart';

/// The public "get in touch" request a school sends before it has
/// an account (`POST /contact`, 5 per 10 minutes per device).
class ContactRepository {
  ContactRepository(this._client);

  final ApiClient _client;

  Future<void> sendRequest({required String email, required String phone}) =>
      _client.post('/contact', data: {'email': email, 'phone': phone});
}
