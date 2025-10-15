import 'package:shakti_hormann/core/model/pair.dart';
import 'package:shakti_hormann/core/utils/typedefs.dart';
import 'package:shakti_hormann/features/logistic_request/model/sales_order.dart';
import 'package:shakti_hormann/features/transport_confirmation/model/transport_confirmation_form.dart';

abstract interface class TransportConfrimationRepo {
  AsyncValueOf<List<TransportConfirmationForm>> fetchTransports(
    int start,
    String? status,
    String? search,
  );

  AsyncValueOf<Pair<String, String>> submitTransport(TransportConfirmationForm form);
  AsyncValueOf<Pair<String, String>> rejectTransport(TransportConfirmationForm form);
  AsyncValueOf<List<SalesOrder>> fetchSales(String name);

}
