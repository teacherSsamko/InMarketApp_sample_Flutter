import 'dart:io' show Platform;

class AdManager {
  static String get appId {
    if (Platform.isAndroid) {
      return "ca-app-pub-";
    } else if (Platform.isIOS) {
      return "ca-app-pub-";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }

  static String get testBannerAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-";
    } else if (Platform.isIOS) {
      return "ca-app-pub-";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }

  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-";
    } else if (Platform.isIOS) {
      return "ca-app-pub-";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }
}
