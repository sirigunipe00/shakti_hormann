import 'package:flutter/material.dart';
import 'package:shakti_hormann/features/logistic_request/model/sales_order.dart';

class SalesOrderTable extends StatelessWidget {

  const SalesOrderTable({
    super.key,
    required this.salesOrders,
    this.widthFactor = 1.5, // default width expansion
  });
  final List<SalesOrder> salesOrders;
  final double widthFactor;

  @override
  Widget build(BuildContext context) {
    if (salesOrders.isEmpty) {
      return const Center(
        child: Text(
          'No Sales Orders Selected',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    return SizedBox(
      width: MediaQuery.of(context).size.width * widthFactor,
      child: DataTable(
        headingRowColor: WidgetStateProperty.all(Colors.grey.shade200),
        border: TableBorder.all(color: Colors.grey.shade300),
        columnSpacing: 20,
        horizontalMargin: 10,
        columns: const [
          DataColumn(
            label: Text(
              'Sales Order No',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          DataColumn(
            label: Text(
              'State',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          DataColumn(
            label: Text(
              'City',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
        rows: salesOrders.map((order) {
          return DataRow(
            cells: [
              DataCell(
                Text(order.name?.isNotEmpty == true ? order.name! : '-'),
              ),
              DataCell(
                ConstrainedBox(
                  constraints: const BoxConstraints(minWidth: 100),
                  child: Text(order.state?.isNotEmpty == true ? order.state! : '-'),
                ),
              ),
              DataCell(
                ConstrainedBox(
                  constraints: const BoxConstraints(minWidth: 100),
                  child: Text(order.city?.isNotEmpty == true ? order.city! : '-'),
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}
