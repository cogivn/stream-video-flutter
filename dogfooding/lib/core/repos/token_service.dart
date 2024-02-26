// 🎯 Dart imports:
import 'dart:convert';

// 📦 Package imports:
import 'package:http/http.dart' as http;

enum Environment {
  pronto(
    'Pronto',
    aliases: ['stream-calls-dogfood'],
  ),
  demo(
    'Demo',
    aliases: [''],
  ),
  staging(
    'Staging',
  );

  final String displayName;
  final List<String> aliases;

  const Environment(
    this.displayName, {
    this.aliases = const [],
  });

  factory Environment.fromHost(String host) {
    final hostParts = host.split('.');
    final String envAlias = hostParts.length < 2 ? '' : hostParts[0];

    return Environment.values.firstWhere(
      (env) => env.name == envAlias || env.aliases.contains(envAlias),
      orElse: () => Environment.demo,
    );
  }
}

class TokenResponse {
  final String token;
  final String apiKey;

  const TokenResponse(this.token, this.apiKey);

  factory TokenResponse.fromJson(Map<String, dynamic> json) =>
      TokenResponse(json['token'], json['apiKey']);
}

class TokenService {
  static Environment environment = Environment.pronto;

  const TokenService();

  Future<TokenResponse> loadToken({
    required String userId,
    Duration? expiresIn,
  }) async {
    final queryParameters = <String, dynamic>{
      'environment': environment.name,
      'user_id': userId,
    };

    if (expiresIn != null) {
      queryParameters['exp'] = expiresIn.inSeconds.toString();
    }

    final uri = Uri(
      scheme: 'https',
      host: 'pronto.getstream.io',
      path: '/api/auth/create-token',
      queryParameters: queryParameters,
    );

    final response = await http.get(uri);
    final body = json.decode(response.body) as Map<String, dynamic>;
    return TokenResponse.fromJson(body);
  }
}
