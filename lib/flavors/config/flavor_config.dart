import 'build_flavor.dart';

/// Initialise and assign values to each specific flavor here
/// Current flavors [dev, prod]
class FlavorConfig {
  static final FlavorConfig _obj = FlavorConfig._internal();

  static FlavorConfig get instance => _obj;

  //flavor variables
  BuildFlavor? buildFlavor;

  String? baseUrl;
  String appName = "APP_NAME";
  //TODO: Handle the null
  String? dynamicLink;
  String? packageName;
  String? appStoreId;
  String? fcmServerKey;

  factory FlavorConfig() {
    return _obj;
  }

  FlavorConfig._internal();

  Future<void> setupFlavor({required BuildFlavor flavorConfig}) async {
    switch (flavorConfig) {
      case BuildFlavor.dev:
        {
          buildFlavor = BuildFlavor.dev;
          baseUrl = "https://fakestoreapi.com/";
          appName = "Elmore-Shopping (Dev)";
          packageName = "com.elmore.dev";
        }
        break;
      case BuildFlavor.prod:
        {
          buildFlavor = BuildFlavor.prod;
          baseUrl = "https://fakestoreapi.com/";
          appName = "Elmore-Shopping";
          packageName = "com.elmore.prod";
        }
        break;
    }
  }
}
