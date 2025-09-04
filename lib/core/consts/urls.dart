import 'package:shakti_hormann/core/di/injector.dart';

final _reqisteredUrl = $sl.get<Urls>(instanceName: 'baseUrl');

class Urls {
  // factory Urls.shaktiHormannUAT() =>
  //     const Urls('https://aparnagmuat.easycloud.co.in/api');
  // factory Urls.prod() => const Urls('https://rucoprd.sunpure.in/api');
  factory Urls.local() => const Urls('http://65.21.243.18:8000/api');

  const Urls(this.url);
  static String filepath(String path) =>
      '${baseUrl.replaceAll('api', '')}/$path';

  final String url;

  static bool get isTest => Uri.parse(
    _reqisteredUrl.url,
  ).authority.split('.').first.toLowerCase().contains('uat');
  static final baseUrl = _reqisteredUrl.url;
  static final jsonWs = '$baseUrl/resource';
  static final cusWs = '$baseUrl/method';

  static final login = '$cusWs/login';
  static final getList = '$cusWs/frappe.client.get_list';
  static final getUsers = '$cusWs/shaktihormann.api.getUsers';

  static final appVersion = '$cusWs/easy_common.api.get_app_version';

  static final companyName = '$jsonWs/Company';
  static final createGateEntry = '$cusWs/shaktihormann.api.createGateEntry';
  static final submitGateEntry = '$cusWs/shaktihormann.api.submit_gate_entry';
  static final createGateExit = '$cusWs/shaktihormann.api.create_gate_exit';
  static final submitGateExit = '$cusWs/shaktihormann.api.submit_gate_exit';
  static final createLogisticPlanning =
      '$cusWs/shaktihormann.api.create_logistic_planning';
  static final updateLogisticPlanning =
      '$cusWs/shaktihormann.api.update_logistic_planning';
  static final updateTransport='$cusWs/shaktihormann.api.update_logistic_transporter';
  static final createVehicleReporting='$cusWs/shaktihormann.api.create_vehicle_reporting';
  static final updateVehicleReporting = '$cusWs/shaktihormann.api.update_vehicle_reporting';
  static final createLoadingConfirmation ='$cusWs/shaktihormann.api.create_items_loaded';
  static final submitLoadingConfirmation = '$cusWs/shaktihormann.api.submit_vehicle_loading';
  static final getLodedItems = '$cusWs/shaktihormann.api.get_loaded_items';

}
