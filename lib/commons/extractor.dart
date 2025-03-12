String extractSession(Map<String, String> headers) {
    if (headers.containsKey('set-cookie')) {
      final cookie = headers['set-cookie'];
      final sessionMatch = RegExp(r'SESSION=([^;]+)').firstMatch(cookie!);
      if (sessionMatch != null) {
        return sessionMatch.group(1)!;
      }
    }
    throw Exception('Session not found in response headers');
  }

  String extractReactToken(Map<String, String> headers) {
    if (headers.containsKey('set-cookie')) {
      final cookie = headers['set-cookie'];
      final reactMatch = RegExp(r'react-token=([^;]+)').firstMatch(cookie!);
      if (reactMatch != null) {
        return reactMatch.group(1)!;
      }
    }
    throw Exception('React Token not found in response headers');
  }

  String extractCsrf(String body) {
    final csrfMatch =
        RegExp(r'<meta name="_csrf" content="([^"]+)"/>').firstMatch(body);
    if (csrfMatch != null) {
      return csrfMatch.group(1)!;
    }
    throw Exception('CSRF token not found in response body');
  }