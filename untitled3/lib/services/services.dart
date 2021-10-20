import 'package:untitled3/services/service_config.dart';

class Services with ConfigMixin/*, WooMixin*/ {
  static final Services _instance = Services._internal();

  factory Services() => _instance;

  Services._internal();
}