import 'package:shakti_hormann/core/model/pair.dart';
import 'package:shakti_hormann/core/utils/typedefs.dart';
import 'package:shakti_hormann/features/gate_exit/model/sales_invoice_form.dart';
import 'package:shakti_hormann/features/proof_of_delivery/model/proof_of_delivery.dart';

abstract interface class ProofOfDeliveryRepo {
  AsyncValueOf<List<ProofOfDelivery>> fetchPod(
    int start,
    int? docStatus,
    String? search,
  );
  AsyncValueOf<Pair<String, String>> createPod(ProofOfDelivery form);
  AsyncValueOf<Pair<String, String>> submitPod(ProofOfDelivery form);
  AsyncValueOf<List<SalesInvoiceForm>> fetchSalesInvoice(String name);
}