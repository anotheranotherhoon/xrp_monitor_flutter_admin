enum StorageKey {
  // Secure Storage Keys (토큰 등 민감한 정보)
  token(name: 'accessToken'),
  refreshToken(name: 'refreshToken');

  const StorageKey({
    required this.name,
  });

  final String name;
}




