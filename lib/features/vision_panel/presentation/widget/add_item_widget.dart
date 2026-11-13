import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shakti_hormann/features/vision_panel/model/product_type.dart';
import 'package:shakti_hormann/features/vision_panel/presentation/bloc/bloc_provider.dart';
import 'package:shakti_hormann/features/vision_panel/presentation/widget/vision_select_fields.dart';
import 'package:shakti_hormann/styles/app_color.dart';
import 'package:shakti_hormann/widgets/dailogs/app_popup_card.dart';

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
    return StatefulBuilder(
      builder: (context, setDialogState) {
        return AppFormDialogShell(
          title: 'Add Item',
          subtitle: 'Select a product type and enter the number of boxes.',
          icon: Icons.add_box_outlined,
          iconBackground: const Color(0xFFE8F0FE),
          iconColor: AppColors.darkBlue,
          onClose: () => Navigator.of(context).pop(),
          cancelText: 'Cancel',
          onCancel: () => Navigator.of(context).pop(),
          confirmText: 'Add',
          confirmIcon: Icons.check_rounded,
          confirmColor: AppColors.darkBlue,
          onConfirm: _canSubmit
              ? () => Navigator.of(context).pop((
                    _selectedProduct!.name!,
                    int.parse(_boxesController.text),
                  ))
              : null,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              BlocBuilder<ProductCubit, ProductState>(
                builder: (_, productState) {
                  final products = productState.maybeWhen(
                    orElse: () => <ProductType>[],
                    success: (data) => data,
                  );
                  return VisionProductTypeSelect(
                    products: products,
                    selected: _selectedProduct,
                    isLoading: productState.isLoading,
                    onSelected: (p) =>
                        setDialogState(() => _selectedProduct = p),
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
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                ),
                onChanged: (_) => setDialogState(() {}),
              ),
            ],
          ),
        );
      },
    );
  }
}
