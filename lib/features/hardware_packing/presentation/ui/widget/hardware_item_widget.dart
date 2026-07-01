import 'package:flutter/material.dart';
import 'package:shakti_hormann/features/hardware_packing/model/hardware_item.dart';

class HardwareItemWidget extends StatelessWidget {
  const HardwareItemWidget({
    super.key,
    required this.items,
    required this.onDelete,
    this.isCompleted = false,
  });

  final List<HardwareItem> items;
  final ValueChanged<int> onDelete;
  final bool isCompleted;

@override
Widget build(BuildContext context) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: Colors.grey.shade300),
    ),
    child: SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        headingRowHeight: 40,
        headingTextStyle: const TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  dataTextStyle: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF1E293B),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  border: TableBorder.all(
                    color: const Color(0xFFE2E8F0),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  headingRowColor: WidgetStateProperty.all(
                    const Color(0xFF1A3C6B),
                  ),
        columns: const [
          DataColumn(
            label: Text(
              'Sl No',
              style: TextStyle(color:  Colors.white,fontWeight: FontWeight.bold,fontFamily: 'Urbanist'),
            ),
          ),
          DataColumn(
            label: Text(
              'SAP Code',
              style: TextStyle(color:  Colors.white,fontWeight: FontWeight.bold,fontFamily: 'Urbanist'),
            ),
          ),
          DataColumn(
            label: Text(
              'Description',
              style: TextStyle(color:  Colors.white,fontWeight: FontWeight.bold,fontFamily: 'Urbanist'),
            ),
          ),
          DataColumn(
            label: Text(
              'Qty',
              style: TextStyle(color:  Colors.white,fontWeight: FontWeight.bold,fontFamily: 'Urbanist'),
            ),
          ),
          DataColumn(
            label: Text(
              'UOM',
              style: TextStyle(color:  Colors.white,fontWeight: FontWeight.bold,fontFamily: 'Urbanist'),
            ),
          ),
          // DataColumn(
          //   label: Text(
          //     'Action',
          //     style: TextStyle(color:  Colors.white,fontWeight: FontWeight.bold,fontFamily: 'Urbanist'),
          //   ),
          // ),
        ],
        rows: items.asMap().entries.map((entry) {
           final index = entry.key;
           final item  = entry.value;
                return DataRow(
                  cells: [
                    DataCell(
                        Text(item.slNO ?? (index + 1).toString()),
                      ),
                    DataCell(Text(item.materialCode.toString())),
                    DataCell(
                      SizedBox(
                        width: 250,
                        child: Text(item.productName.toString()),
                      ),
                    ),
                    DataCell(Text(item.qtySticker.toString())),
                    DataCell(Text(item.uom.toString())),
                    // DataCell(
                    //   IconButton(
                    //     icon: const Icon(
                    //       Icons.delete,
                    //       color: Colors.red,
                    //     ),
                    //     onPressed: () => onDelete
                    //   ),
                    // ),
                  ],
                );
              }).toList(),
      ),
    ),
  );
}
}