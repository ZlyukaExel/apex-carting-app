class Client {
  final String id;
  final String name;
  final String phone;
  final String? accessToken;
  final String? refreshToken;

  const Client({
    required this.id,
    required this.name,
    required this.phone,
    this.accessToken,
    this.refreshToken,
  });

  bool get isAuthenticated => accessToken != null;

  Client copyWith({
    String? id,
    String? name,
    String? phone,
    String? accessToken,
    String? refreshToken,
  }) {
    return Client(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
    );
  }
}
