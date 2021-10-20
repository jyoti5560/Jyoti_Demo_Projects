import 'dart:async';
import 'dart:convert' as convert;
import 'package:flutter/foundation.dart' as foundation;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled3/dependency_injection.dart';
import 'package:untitled3/models/cart_base.dart';
import 'package:untitled3/services/services.dart';
import 'package:intl/intl.dart';

// import '../common/config.dart';
// import '../common/constants.dart';
// import '../common/tools.dart';
// import '../common/wrappers/advertisement/index.dart' show AdvertisementConfig;
// import '../dependecy_injection.dart';
// import '../services/index.dart';
// import 'cart/cart_model.dart';
// import 'category_model.dart';

enum VendorType { single, multi}

Map get kAdvanceConfig => Configurations.advanceConfig;

class Configurations{
  static Map _advanceConfig = DefaultConfig.advanceConfig;


  static Map get advanceConfig => _advanceConfig;
}

class DefaultConfig{
  static Map advanceConfig = {};
}


class AppModel with ChangeNotifier {
  Map<String, dynamic> ? appConfig;
  bool ? isLoading = true;
  String ? message;

  // bool darkTheme = kDefaultDarkTheme ?? false;
  //String _langCode = Configurations.defaultLanguage;
  List<String>? categories;
  String ? categoryLayout;
  List<String> ? categoriesIcons;
  String ? productListLayout;
  double ? ratioProductImage;
  String ? currency; //USD, VND
  String ? currencyCode;
  int ? smallestUnitRate;
  Map<String, dynamic> ? currencyRate = <String, dynamic>{};
  bool ? showDemo = false;
  String ? username;
  bool ? isInit = false;
  Map<String, dynamic> ? drawer;
  Map ? deeplink;
  VendorType ? vendorType;
  //AdvertisementConfig advertisement;
  // ListingType listingType;

 // String get langCode => _langCode;
  ThemeMode ? themeMode;

  AppModel([String lang = 'en']) {
   /* _langCode = lang;
    getPrefConfig(lang: lang);
    advertisement = AdvertisementConfig.fromJson(adConfig: kAdConfig);
    vendorType = kFluxStoreMV.contains(serverConfig['type'])
        ? VendorType.multi
        : VendorType.single;*/
  }

  bool get darkTheme => themeMode == ThemeMode.dark;

  set darkTheme(bool value) =>
      themeMode = value ? ThemeMode.dark : ThemeMode.light;

  /// Get persist config from Share Preference
  Future<bool> getPrefConfig({ String? lang}) async {
    try {
      var prefs = injector<SharedPreferences>();

      var defaultCurrency = kAdvanceConfig['DefaultCurrency'] as Map;
      /*_langCode = prefs.getString('language').isNotEmpty
          ? prefs.getString('language')
          : lang ?? kAdvanceConfig['DefaultLanguage'];

      await prefs.setString(
          'language', _langCode.split('-').first.toLowerCase());

      darkTheme = prefs.getBool('darkTheme') ?? kDefaultDarkTheme ?? false;*/
      currency = prefs.getString('currency') ?? defaultCurrency['currency'];
      currencyCode =
          prefs.getString('currencyCode') ?? defaultCurrency['currencyCode'];
      smallestUnitRate = defaultCurrency['smallestUnitRate'];
      isInit = true;
      //await updateTheme(darkTheme);
      return true;
    } catch (err) {
      return false;
    }
  }

  /*Future<bool> changeLanguage(String languageCode, BuildContext context) async {
    try {
      _langCode = languageCode;
      var prefs = injector<SharedPreferences>();
      await prefs.setString('language', _langCode);

      await loadAppConfig(isSwitched: true);
      await loadCurrency();
      eventBus.fire(const EventChangeLanguage());

      await Provider.of<CategoryModel>(context, listen: false)
          .getCategories(lang: languageCode, sortingList: categories);

      return true;
    } catch (err) {
      return false;
    }
  }*/

  Future<void> changeCurrency(String item, BuildContext context,
      {String? code}) async {
    try {
      Provider.of<CartModel>(context, listen: false).changeCurrency(item);
      var prefs = injector<SharedPreferences>();
      currency = item;
      currencyCode = code!;
      await prefs.setString('currencyCode', currencyCode!);
      await prefs.setString('currency', currency!);
      notifyListeners();
    } catch (error) {
      printLog('[changeCurrency] error: ${error.toString()}');
    }
  }

 /* Future<void> updateTheme(bool theme) async {
    try {
      // revert to fix temporary
      // var prefs = injector<SharedPreferences>();

      var prefs = await SharedPreferences.getInstance();
      darkTheme = theme;
      Utils.changeStatusBarColor(themeMode);
      await prefs.setBool('darkTheme', theme);
      notifyListeners();
    } catch (error) {
      printLog('[updateTheme] error: ${error.toString()}');
    }
  }*/

  void updateShowDemo(bool value) {
    showDemo = value;
    notifyListeners();
  }

  void updateUsername(String user) {
    username = user;
    notifyListeners();
  }

  void loadStreamConfig(config) {
    appConfig = config;
    productListLayout = appConfig!['Setting']['ProductListLayout'];
    isLoading = false;
    notifyListeners();
  }

  // Future<Map> loadAppConfig({isSwitched = false, config}) async {
  //   var startTime = DateTime.now();
  //   _langCode = _langCode == '' ? 'en' : _langCode;
  //
  //   try {
  //     if (!isInit || _langCode.isEmpty) {
  //       await getPrefConfig();
  //     }
  //     if (config != null) {
  //       appConfig = Map<String, dynamic>.from(config);
  //     } else {
  //       /// we only apply the http config if isUpdated = false, not using switching language
  //       // ignore: prefer_contains
  //       if (kAppConfig.indexOf('http') != -1) {
  //         // load on cloud config and update on air
  //         var path = kAppConfig;
  //         if (path.contains('.json')) {
  //           path = path.substring(0, path.lastIndexOf('/'));
  //           path += '/config_$langCode.json';
  //         }
  //         final appJson = await httpGet(Uri.encodeFull(path).toUri(),
  //             headers: {'Accept': 'application/json'});
  //         appConfig =
  //             convert.jsonDecode(convert.utf8.decode(appJson.bodyBytes));
  //       } else {
  //         // load local config
  //         var path = 'lib/config/config_$langCode.json';
  //         try {
  //           final appJson = await rootBundle.loadString(path);
  //           appConfig = convert.jsonDecode(appJson);
  //         } catch (e) {
  //           final appJson = await rootBundle.loadString(kAppConfig);
  //           appConfig = convert.jsonDecode(appJson);
  //         }
  //       }
  //     }
  //
  //     /// Load Product ratio from config file
  //     productListLayout = appConfig['Setting']['ProductListLayout'];
  //     ratioProductImage = appConfig['Setting']['ratioProductImage'] ??
  //         kAdvanceConfig['RatioProductImage'] ??
  //         1.2;
  //
  //     drawer = appConfig['Drawer'] != null
  //         ? Map<String, dynamic>.from(appConfig['Drawer'])
  //         : kDefaultDrawer;
  //
  //     /// Load categories config for the Tabbar menu
  //     /// User to sort the category Setting
  //     var categoryTab = List.from(appConfig['TabBar']).firstWhere(
  //             (e) => e['layout'] == 'category' || e['layout'] == 'vendors',
  //         orElse: () => {});
  //     if (categoryTab['categories'] != null) {
  //       categories = List<String>.from(categoryTab['categories'] ?? []);
  //       categoryLayout = categoryTab['categoryLayout'];
  //       categoriesIcons = List<String>.from(categoryTab['images'] ?? []);
  //     }
  //
  //     /// apply App Caching if isCaching is enable
  //     /// not use for Fluxbuilder
  //     if (!Config().isBuilder) {
  //       await Services().widget.onLoadedAppConfig(langCode, (configCache) {
  //         appConfig = configCache;
  //       });
  //     }
  //
  //     isLoading = false;
  //
  //     notifyListeners();
  //     printLog('[Debug] Finish Load AppConfig', startTime);
  //     return appConfig;
  //   } catch (err, trace) {
  //     printLog(trace);
  //     isLoading = false;
  //     message = err.toString();
  //     notifyListeners();
  //     return null;
  //   }
  // }

  Future<void> loadCurrency() async {
    /// Load the Rate for Product Currency
    final rates = await Services().api!.getCurrencyRate();
    if (rates != null) {
      currencyRate = rates;
    }
  }

  void updateProductListLayout(layout) {
    productListLayout = layout;
    notifyListeners();
  }

  void printLog([dynamic data, DateTime? startTime]) {
    if (foundation.kDebugMode) {
      var time = '';
      if (startTime != null) {
        final endTime = DateTime.now().difference(startTime);
        final icon = endTime.inMilliseconds > 2000
            ? '⌛️Slow-'
            : endTime.inMilliseconds > 1000
            ? '⏰Medium-'
            : '⚡️Fast-';
        time = '[$icon${endTime.inMilliseconds}ms]';
      }

      try {
        final now = DateFormat('h:mm:ss-ms').format(DateTime.now());
        debugPrint('ℹ️[${now}ms]$time${data.toString()}');
      } catch (e) {
        debugPrint('${data.toString()}');
      }
    }
  }
}
