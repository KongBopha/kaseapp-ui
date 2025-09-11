import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kaseapp_ui/configs/themes/app_theme.dart';
import 'package:kaseapp_ui/controllers/pre_order_controller.dart';
import 'package:kaseapp_ui/controllers/product_controller.dart';
import 'package:kaseapp_ui/models/pre_order_model.dart';
import 'package:kaseapp_ui/utils/pre_order_enum.dart';
import 'package:kaseapp_ui/widgets/app_bar/my_app_bar.dart';
import 'package:kaseapp_ui/widgets/custom_drop_down_button.dart';
class PreOrderRequestView extends StatefulWidget {
  const PreOrderRequestView({super.key});

  @override
  State<PreOrderRequestView> createState() => _PreOrderRequestViewState();
}

class _PreOrderRequestViewState extends State<PreOrderRequestView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _deliveryDateController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  final TextEditingController _recurringScheduleController = TextEditingController();

  final PreOrderController _preOrderController = Get.find<PreOrderController>();
  
  
  late final ProductController _productController;


  String? selectedProduct;
  DateTime selectedDeliveryDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    
    _productController = Get.find<ProductController>();
    _productController.fetchProductbyname();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: 'Create Pre-order'),
      backgroundColor: AppTheme.pageBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 24),

                Text('Product Details', style: TextStyle(
                  color: AppTheme.pageTitleColor,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                )),
                const SizedBox(height: 16),

                // Reactive Dropdown
                Obx(() {
                  final products = _productController.products;
                  if (products.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  return CustomDropDownButtonFormField<String>(
                    hintText: 'Select Product',
                    value: selectedProduct,
                    items: [
                      for (var product in products)
                        DropdownMenuItem(
                          value: product.id.toString(),
                          child: Text(product.name),
                        ),
                    ],
                    onChanged: (value) => setState(() => selectedProduct = value),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select a product';
                      }
                      return null;
                    },
                  );
                }),

                const SizedBox(height: 20),

                // Quantity Input
                TextFormField(
                  controller: _quantityController,
                  decoration: InputDecoration(
                    labelText: 'Quantity',
                    hintText: 'Enter quantity in kg',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    suffixText: 'kg',
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Please enter quantity';
                    if (double.tryParse(value) == null) return 'Please enter a valid number';
                    return null;
                  },
                ),

                const SizedBox(height: 20),

                // Delivery Date
                TextFormField(
                  controller: _deliveryDateController,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'Delivery Date',
                    hintText: 'Select delivery date',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.calendar_today),
                      onPressed: () => _selectDeliveryDate(context),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Please select delivery date';
                    return null;
                  },
                ),
                // Recurring Schedule
                TextFormField(
                  controller: _recurringScheduleController,
                  decoration: InputDecoration(
                    labelText: 'Recurring Schedule (Optional)',
                    hintText: 'Enter recurring schedule',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),

                const SizedBox(height: 20),

                // Notes
                TextFormField(
                  controller: _notesController,
                  decoration: InputDecoration(
                    labelText: 'Additional Notes (Optional)',
                    hintText: 'Any special instructions or requirements',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  maxLines: 3,
                  textInputAction: TextInputAction.done,
                ),

                const SizedBox(height: 32),

                // Submit Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _submitForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.btnNormalColor,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      'Create Pre-order',
                      style: TextStyle(
                        color: AppTheme.btnTextNormalColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

Widget _buildHeader() {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppTheme.appbarBackgroundColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.appbarBackgroundColor.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline_rounded,
                color: AppTheme.btnNormalColor,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Create New Pre-order',
                style: TextStyle(
                  color: AppTheme.pageTitleColor,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Fill in the details below to create a new pre-order request. Farmers will be able to view and submit offers for your request.',
            style: TextStyle(
              color: AppTheme.itemSubTitleColor,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
  
  Future<void> _selectDeliveryDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 7)),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 1),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: AppTheme.btnNormalColor,
            ),
          ),
          child: child!,
        );
      },
    );
    
    if (picked != null && picked != selectedDeliveryDate) {
      setState(() {
        selectedDeliveryDate = picked;
        _deliveryDateController.text = 
          "${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}";
      });
    }
  }
  
void _submitForm() async {
  if (_formKey.currentState!.validate()) {
    if (_preOrderController.products.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Products are still loading, please wait...'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    if (selectedProduct == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a product'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final product = _preOrderController.products.firstWhere(
      (p) => p.id.toString() == selectedProduct,
      orElse: () => throw Exception('Product not found'),
    );

    final preOrderModel = PreOrder(
      id: null,
      userId: _preOrderController.userController.user.id!,
      productId: product.id,
      qty: double.parse(_quantityController.text),
      location: "Default Location",
      deliveryDate: selectedDeliveryDate,
      noteText: _notesController.text.isNotEmpty ? _notesController.text : null,
      status: PreOrderStatus.pending,
      cropId: null,
      recurringSchedule: _recurringScheduleController.text.isNotEmpty
          ? _recurringScheduleController.text
          : null,
    );

    final result = await _preOrderController.preOrderRepo.createPreOrder(
      model: preOrderModel,
      userId: _preOrderController.userController.user.id!,
      product: product,
    );

    result.fold(
      (failure) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${failure.message}'),
            backgroundColor: Colors.red,
          ),
        );
      },
      (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Pre-order created successfully!'),
            backgroundColor: Colors.green,
          ),
        );

        // Navigate back
        Future.delayed(const Duration(seconds: 1), () {
          Navigator.pop(context);
        });
      },
    );
  }
}

  
  @override
  void dispose() {
    _quantityController.dispose();
    _deliveryDateController.dispose();
    _notesController.dispose();
    super.dispose();
  }
}

