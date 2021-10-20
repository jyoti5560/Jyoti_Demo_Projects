import 'package:untitled3/services/base_services.dart';

class Config {
  ConfigType ? type;
  String ? url;
  String ? blog;
  String ? consumerKey;
  String ?consumerSecret;
  String ?forgetPassword;
  String ?accessToken;
  bool ?isCacheImage;
  bool ?isBuilder = false;

  static final Config _instance = Config._internal();

  factory Config() => _instance;

  static Map serverConfig1 = {};
  static Map _serverConfig = serverConfig1;
  static Map get serverConfig => _serverConfig;

  String get typeName => type!.typeName;

  Config._internal();

//  bool _cacheIsListing;

  bool get isListingType {
//    _cacheIsListing ??= [
//      ConfigType.listeo,
//      ConfigType.listpro,
//      ConfigType.mylisting,
//    ].contains(type);
    return [
      ConfigType.listeo,
      ConfigType.listpro,
      ConfigType.mylisting,
    ].contains(type);
  }

  bool get isWooType {
    return [
      ConfigType.listeo,
      ConfigType.listpro,
      ConfigType.mylisting,
      ConfigType.dokan,
      ConfigType.wcfm,
      ConfigType.woo,
    ].contains(type);
  }

  bool isVendorManagerType() {
    return ConfigType.vendorAdmin == type;
  }

  bool isVendorType() {
    return typeName == 'wcfm' || typeName == 'dokan';
  }

  void setConfig(config) {
    type = ConfigType.values.firstWhere(
          (element) => element.typeName == config['type'],
      orElse: () => ConfigType.woo,
    );
    url = config['url'];
    blog = config['blog'];
    consumerKey = config['consumerKey'];
    consumerSecret = config['consumerSecret'];
    forgetPassword = config['forgetPassword'];
    accessToken = config['accessToken'];
    isCacheImage = config['isCacheImage'];
    isBuilder = config['isBuilder'] ?? false;
  }
}

mixin ConfigMixin {
  BaseServices ? api;
  //BaseFrameworks widget;
  //BlogNewsApi blogApi;

  void configOpencart(appConfig) {}

  void configMagento(appConfig) {}

  void configShopify(appConfig) {}

  void configPrestashop(appConfig) {}

  void configTrapi(appConfig) {}

  void configDokan(appConfig) {}

  void configWCFM(appConfig) {}

  void configWoo(appConfig) {}

  void configListing(appConfig) {}

  void configVendorAdmin(appConfig) {}

  void setAppConfig(appConfig) {
    Config().setConfig(appConfig);
    //CartInject().init(appConfig);

    //printLog('[🌍appConfig] ${appConfig['type']} $appConfig');

    switch (appConfig['type']) {
      case 'opencart':
        configOpencart(appConfig);
        break;
      case 'magento':
        configMagento(appConfig);
        break;
      case 'shopify':
        configShopify(appConfig);
        break;
      case 'presta':
        configPrestashop(appConfig);
        break;
      case 'strapi':
        configTrapi(appConfig);
        break;
      case 'dokan':
        configDokan(appConfig);
        break;
      case 'wcfm':
        configWCFM(appConfig);
        break;
      case 'listeo':
        configListing(appConfig);
        break;
      case 'listpro':
        configListing(appConfig);
        break;
      case 'mylisting':
        configListing(appConfig);
        break;
      case 'vendorAdmin':
        configVendorAdmin(appConfig);
        break;
      case 'woo':
      default:
        configWoo(appConfig);
        break;
    }
  }
}

enum ConfigType {
  opencart,
  magento,
  shopify,
  presta,
  strapi,
  dokan,
  wcfm,
  listeo,
  listpro,
  mylisting,
  vendorAdmin,
  woo,
}

extension ConfigTypeExtension on ConfigType {
  String get typeName {
    return toString().replaceFirst('ConfigType.', '');
  }
}