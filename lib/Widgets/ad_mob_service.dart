import 'dart:io' show Platform;

import 'package:flutter/cupertino.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdMobService {
  // static String? get bannerAdUnitId {
  //   if (Platform.isAndroid) {
  //     return 'ca-app-pub-3940256099942544/6300978111';
  //   } else if (Platform.isIOS) {
  //     return 'ca-app-pub-3940256099942544/2934735716';
  //   }
  //   return null;
  // }

  static String? get interstitialAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-9694725992788510/6124006636';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-9694725992788510/5539830507';
    }
    return null;
  }

  // static String? get rewardedAdUnitId {
  //   if (Platform.isAndroid) {
  //     return 'ca-app-pub-3940256099942544/5224354917';
  //   } else if (Platform.isIOS) {
  //     return 'ca-app-pub-3940256099942544/1712485313';
  //   }
  //   return null;
  // }

  // static final BannerAdListener bannerListener = BannerAdListener(
  //   onAdLoaded: (ad) => debugPrint('Ad loaded'),
  //   onAdFailedToLoad: (ad, error) {
  //     ad.dispose();
  //     debugPrint('Ad failed to load: $error');
  //   },
  //   onAdOpened: (ad) => debugPrint('Ad opened'),
  //   onAdClosed: (ad) => debugPrint('Ad closed'),
  // );
}
