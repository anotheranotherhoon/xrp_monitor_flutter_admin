enum ServerType {
  dev,
  beta,
  prod,
}

class ApiPath {

  static const String devDomain = 'http://localhost:3000';
  static const String betaDomain = 'http://localhost:3000';
  static const String prodDomain = 'http://localhost:3000';


  static ServerType currentServer = ServerType.dev;

  static String get apiDomain {
    switch (currentServer) {
      case ServerType.prod:
        return ApiPath.prodDomain;
      case ServerType.beta:
        return ApiPath.betaDomain;
      case ServerType.dev:
        return ApiPath.devDomain;
    }
  }

  static String get apiUrl {
    String url = apiDomain;
    url += '/';
    return url;
  }



  static void setServerType(ServerType type) {
    currentServer = type;
  }
}
