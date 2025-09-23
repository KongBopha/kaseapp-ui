import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:kaseapp_ui/configs/themes/app_theme.dart';
import 'package:kaseapp_ui/controllers/pre_order_controller.dart';
import 'package:kaseapp_ui/controllers/product_controller.dart';
import 'package:kaseapp_ui/controllers/user_controller.dart';
import 'package:kaseapp_ui/models/pre_order_model.dart';
import 'package:kaseapp_ui/utils/constants/app_image.dart';
import 'package:kaseapp_ui/utils/constants/base_api.dart';
import 'package:kaseapp_ui/utils/pre_order_enum.dart';
import 'package:kaseapp_ui/widgets/app_bar/my_app_bar.dart';

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
  final TextEditingController _searchController = TextEditingController();

  final PreOrderController _preOrderController = Get.find<PreOrderController>();
  late final ProductController _productController;

  String? selectedProductId;
  Map<String, dynamic>? selectedProduct; // Store display details (id, name, image)

  DateTime selectedDeliveryDate = DateTime.now();

  // Helper to get correct product image URL
  String getProductImageUrl(String? productImageUrl) {
    if (productImageUrl == null || productImageUrl.isEmpty) return AppImage.orderIcon;

    if (productImageUrl.startsWith("http")) return productImageUrl;
    final cleanPath = productImageUrl.replaceAll(RegExp(r'^/storage/product_images/'), '');
    return '${Constants.mainUrl}/storage/product_images/$cleanPath';
  }

  @override
  void initState() {
    super.initState();
    _productController = Get.find<ProductController>();
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

                Text(
                  'Product Details',
                  style: TextStyle(
                    color: AppTheme.pageTitleColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),

                // Autocomplete Search
                  Obx(() => Stack(
                    children: [
                      TypeAheadField<Map<String, dynamic>>(
                         builder: (context, controller, focusNode) {
                          return TextField(
                            controller: controller,
                            focusNode: focusNode,
                            decoration: InputDecoration(
                              labelText: 'Search Product',
                              hintText: 'Type to search products',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          );
                        },
                        suggestionsCallback: (pattern) async {
                          if (pattern.isEmpty) return [];
                          await _productController.fetchProductsByQuery(pattern);
                          return _productController.products.map((p) => {
                                'id': p.id.toString(),
                                'name': p.name,
                                'image': p.image != null ? getProductImageUrl(p.image) : null,
                              }).toList();
                        },
                        itemBuilder: (context, suggestion) {
                          return ListTile(
                            leading: suggestion['image'] != null
                                ? Image.network(
                                    suggestion['image'],
                                    width: 50,
                                    height: 50,
                                    errorBuilder: (context, error, stackTrace) =>
                                        const Icon(Icons.image),
                                  )
                                : const Icon(Icons.image),
                            title: Text(suggestion['name']),
                          );
                        },
                        onSelected: (suggestion) {
                          setState(() {
                            selectedProductId = suggestion['id'];
                            selectedProduct = suggestion;
                            _searchController.text = suggestion['name'];
                          });
                        },
                        emptyBuilder: (context) => const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('No products found'),
                        ),
                      ),
                      if (_productController.isLoading.value)
                        const Positioned(
                          right: 10,
                          top: 15,
                          child: SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        ),
                    ],
                  )),


                const SizedBox(height: 20),

                // Selected Product Card
                if (selectedProduct != null) _buildSelectedProductCard(selectedProduct!),

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
                const SizedBox(height: 20),
                TextFormField(
                  
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
        // ignore: deprecated_member_use
        color: AppTheme.appbarBackgroundColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          // ignore: deprecated_member_use
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

  Widget _buildSelectedProductCard(Map<String, dynamic> product) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        border: Border.all(
          color: AppTheme.btnNormalColor,
          width: 2.0,
        ),
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          product['image'] != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    product['image'],
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Icon(Icons.image, size: 60),
                  ),
                )
              : Icon(Icons.image, size: 60),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              product['name'],
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppTheme.pageTitleColor,
              ),
            ),
          ),
          Icon(
            Icons.check_circle,
            color: AppTheme.btnNormalColor,
            size: 24,
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
      if (selectedProductId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select a product'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      final preOrderModel = PreOrder(
        id: null,
        userId: _preOrderController.userController.user.id!,
        productId: int.parse(selectedProductId!),
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

      await _preOrderController.createPreOrder(model: preOrderModel);
    }
  }

  @override
  void dispose() {
    _quantityController.dispose();
    _deliveryDateController.dispose();
    _notesController.dispose();
    _recurringScheduleController.dispose();
    _searchController.dispose();
    super.dispose();
  }
}