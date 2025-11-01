enum AppEnvironment {
  local,
}

const appEnvironment = AppEnvironment.local;

class EnvironmentService {
  static String get baseUrl {
    var baseUrl = '';

    switch (appEnvironment) {
      case AppEnvironment.local:
        baseUrl =
            'https://fakestoreapi.com';
        break;
    }

    return baseUrl;
  }
}
