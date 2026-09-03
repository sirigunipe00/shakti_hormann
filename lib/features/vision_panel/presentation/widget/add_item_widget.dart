import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shakti_hormann/features/vision_panel/model/product_type.dart';
import 'package:shakti_hormann/features/vision_panel/presentation/bloc/bloc_provider.dart';
import 'package:shakti_hormann/styles/app_color.dart';
import 'package:shakti_hormann/widgets/buttons/app_btn.dart';
import 'package:shakti_hormann/widgets/inputs/search_dropdown_widget.dart';

class AddVisionItemDialog extends StatefulWidget {
  const AddVisionItemDialog({super.key});

  @override
  State<AddVisionItemDialog> createState() => _AddVisionItemDialogState();
}

class _AddVisionItemDialogState extends State<AddVisionItemDialog> {
  ProductType? _selectedProduct;
  final TextEditingController _boxesController = TextEditingController();

  @override
  void dispose() {
    _boxesController.dispose();
    super.dispose();
  }

  bool get _canSubmit {
    final product = _selectedProduct;
    final boxes = int.tryParse(_boxesController.text);
    return product != null &&
        (product.name?.isNotEmpty ?? false) &&
        boxes != null &&
        boxes > 0;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: StatefulBuilder(
          builder: (context, setDialogState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Add Item',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Select a product type and enter the number of boxes.',
                  style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                ),
                const SizedBox(height: 16),
                BlocBuilder<ProductCubit, ProductState>(
                  builder: (_, productState) {
                    final products = productState.maybeWhen(
                      orElse: () => <ProductType>[],
                      success: (data) => data,
                    );
                    return SearchDropDownList<ProductType>(
                      title: 'Product Type',
                      hint: 'Select Product',
                      isRequired: true,
                      color: AppColors.black,
                      items: products,
                      futureRequest: (query) async {
                        if (query.isEmpty) return products;
                        final search = query.toLowerCase();
                        return products
                            .where(
                              (p) =>
                                  (p.name ?? '').toLowerCase().contains(search),
                            )
                            .toList();
                      },
                      headerBuilder:
                          (_, p, __) => Text(
                            p.name ?? '',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                      listItemBuilder:
                          (_, p, __, ___) => Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 10.0,
                              horizontal: 4.0,
                            ),
                            child: Text(p.name ?? ''),
                          ),
                      onSelected:
                          (p) => setDialogState(() => _selectedProduct = p),
                      focusNode: FocusNode(),
                    );
                  },
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _boxesController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'No. of Boxes',
                    hintText: 'Enter quantity',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onChanged: (_) => setDialogState(() {}),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text('Cancel'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: AppButton(
                        bgColor: AppColors.darkBlue,
                        label: 'Add',
                        isLoading: false,
                        useRootLoadingOverlay: false,
                        onPressed:
                            _canSubmit
                                ? () => Navigator.of(context).pop((
                                  _selectedProduct!.name!,
                                  int.parse(_boxesController.text),
                                ))
                                : null,
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
