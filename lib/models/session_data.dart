class SessionData {
  final String session;
  final String csrf;
  final String reactToken;
  SessionData({
    required this.reactToken,
    required this.session,
    required this.csrf,
  });
}
