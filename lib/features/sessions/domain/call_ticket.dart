/// `POST /session/{id}/join` → a one-time ticket to connect to the
/// class's LiveKit room. [token] is only valid for 10 minutes of
/// connecting; LiveKit keeps the call alive after that.
class CallTicket {
  const CallTicket({
    required this.url,
    required this.token,
    required this.room,
    required this.identity,
  });

  factory CallTicket.fromJson(Map<String, dynamic> json) => CallTicket(
    url: json['url'] as String? ?? '',
    token: json['token'] as String? ?? '',
    room: json['room'] as String? ?? '',
    identity: json['identity'] as String? ?? '',
  );

  final String url;
  final String token;
  final String room;
  final String identity;

  bool get isValid => url.isNotEmpty && token.isNotEmpty;
}
