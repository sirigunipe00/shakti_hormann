import 'package:shakti_hormann/core/di/injector.dart';

final _reqisteredUrl = $sl.get<Urls>(instanceName: 'baseUrl');

class Urls {
  factory Urls.local() =>
      const Urls('http://192.168.1.132:8000/api');
  factory Urls.shaktiHormannUAT() =>
   const Urls('https://shaktihormannuat.easycloud.co.in/api');
   factory Urls.live() =>  const Urls('https://shaktihormannlive.easycloud.co.in/api');

  const Urls(this.url);


  static String filepath(String path) {
    return '${baseUrl.replaceAll('api', '')}/${path.replaceAll('/private', '').replaceAll("///", '/')}';
  }


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
  static final defaultShutter = '$jsonWs/Shutter Packing';

  static final companyName = '$jsonWs/Company';
  static final dashBoard = '$cusWs/shaktihormann.api.gate_dashboard';
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
    static final updateLoading = '$cusWs/shaktihormann.api.update_items_loaded';
  static final submitLoadingConfirmation = '$cusWs/shaktihormann.api.submit_vehicle_loading';
  static final getLodedItems = '$cusWs/shaktihormann.api.get_loaded_items';
  static final createproofOfDelivery = '$cusWs/shaktihormann.api.createProofOfDelivery';
  static final submitproofOfDelivery = '$cusWs/shaktihormann.api.submitProofOfDelivery';
  static final creategateManagement = '$cusWs/shaktihormann.api.create_gate_management';
  static final submitGateManagement = '$cusWs/shaktihormann.api.submit_and_update_gate_management';


  static final oneSignal = '$cusWs/onesignal.api.save_user_device';

  static final createShutter = '$cusWs/shaktihormann.p2_api.create_shutter_packing';
  static final updateShutter = '$cusWs/shaktihormann.p2_api.update_shutter_packing';
  static final submitShutter = '$cusWs/shaktihormann.p2_api.submit_shutter_packing';

  static final createFrame = '$cusWs/shaktihormann.p2_api.create_frame_packing';
  static final updateFrame = '$cusWs/shaktihormann.p2_api.update_frame_packing';
  static final submitFrame =  '$cusWs/shaktihormann.p2_api.submit_frame_packing';

  static final storageAllocation = '$cusWs/shaktihormann.p2_api.create_storage_zone';
  static final getSales = '$cusWs/shaktihormann.p2_api.get_pallet_sales_orders';
  static final zoneTransfer = '$cusWs/shaktihormann.p2_api.create_zone_transfer';

  static final createHardware = '$cusWs/shaktihormann.p2_api.create_hardware_packing';
  static final updateHardware = '$cusWs/shaktihormann.p2_api.update_hardware_packing';
  static final submitHardware = '$cusWs/shaktihormann.p2_api.submit_hardware_packing';
  static final getMesValues = '$cusWs/shaktihormann.p2_api.extract_packing_label_api';

  static final createPallet = '$cusWs/shaktihormann.p2_api.create_pallet';
  static final updatePallet = '$cusWs/shaktihormann.p2_api.update_pallet';
  static final submitPallet = '$cusWs/shaktihormann.p2_api.submit_pallet';

  static final printShutterSticker = '$cusWs/shaktihormann.network_print.print_shutter_pallet_over_network';
  static final printFrameSticker = '$cusWs/shaktihormann.network_print.print_frame_pallet_over_network';
  static final printinstalltionStciker = '$cusWs/shaktihormann.network_print.print_installation_pallet_over_network';
  static final printVisionSticker = '$cusWs/shaktihormann.network_print.print_vision_panel_pallet_over_network';
  static final getPalletCode = '$cusWs/shaktihormann.p2_api.get_pallet_codes';

  static final createVision = '$cusWs/shaktihormann.p2_api.create_vision_panel';
  static final updateVision = '$cusWs/shaktihormann.p2_api.update_vision_panel';
  static final submitVision = '$cusWs/shaktihormann.p2_api.submit_vision_panel';

  static final createInstallation = '$cusWs/shaktihormann.p2_api.create_installation_entry';
  static final updateInstallation = '$cusWs/shaktihormann.p2_api.update_installation_entry';
  static final submitInstallation = '$cusWs/shaktihormann.p2_api.submit_installation_entry';

}
