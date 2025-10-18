import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  final Map<String, dynamic>? preFilledData;
  const PreOrderRequestView({Key? key, this.preFilledData}) : super(key: key);

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
  Map<String, dynamic>? selectedProduct;
  DateTime selectedDeliveryDate = DateTime.now();
  
  // For keyboard navigation
  List<Map<String, dynamic>> _currentSuggestions = [];
  int _highlightedIndex = -1;
  bool _showSuggestions = false;

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

    if (widget.preFilledData != null) {
      final data = widget.preFilledData!;
      setState(() {
        selectedProductId = data['product_id']?.toString();
        selectedProduct = {
          'id': data['product_id']?.toString(),
          'name': data['product_name'] ?? '',
          'image': data['product_image'] ?? '',
        };
        _quantityController.text = data['available_qty']?.toString() ?? '';
      });
    }
  }

  void _selectProduct(Map<String, dynamic> suggestion) {
    setState(() {
      selectedProductId = suggestion['id'];
      selectedProduct = suggestion;
      _searchController.text = suggestion['name'];
      _showSuggestions = false;
      _highlightedIndex = -1;
      _currentSuggestions = [];
    });
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
                
                // Enhanced Autocomplete with Keyboard Support
                _buildKeyboardFriendlyAutocomplete(),
                
                const SizedBox(height: 20),
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

  Widget _buildKeyboardFriendlyAutocomplete() {
    return Obx(() => Stack(
          children: [
            Focus(
              onKeyEvent: (node, event) {
                if (event is KeyDownEvent && _showSuggestions && _currentSuggestions.isNotEmpty) {
                  // Arrow Down
                  if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
                    setState(() {
                      _highlightedIndex = (_highlightedIndex + 1) % _currentSuggestions.length;
                    });
                    return KeyEventResult.handled;
                  }
                  // Arrow Up
                  else if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
                    setState(() {
                      _highlightedIndex = _highlightedIndex <= 0
                          ? _currentSuggestions.length - 1
                          : _highlightedIndex - 1;
                    });
                    return KeyEventResult.handled;
                  }
                  // Enter or Tab - Select highlighted item
                  else if (event.logicalKey == LogicalKeyboardKey.enter ||
                      event.logicalKey == LogicalKeyboardKey.tab) {
                    if (_highlightedIndex >= 0 && _highlightedIndex < _currentSuggestions.length) {
                      _selectProduct(_currentSuggestions[_highlightedIndex]);
                      return KeyEventResult.handled;
                    }
                  }
                  // Escape - Close suggestions
                  else if (event.logicalKey == LogicalKeyboardKey.escape) {
                    setState(() {
                      _showSuggestions = false;
                      _highlightedIndex = -1;
                    });
                    return KeyEventResult.handled;
                  }
                }
                return KeyEventResult.ignored;
              },
              child: TypeAheadField<Map<String, dynamic>>(
                controller: _searchController,
                builder: (context, controller, focusNode) {
                  return TextField(
                    controller: controller,
                    focusNode: focusNode,
                    decoration: InputDecoration(
                      labelText: 'Search Product',
                      hintText: 'Type to search products',
                      helperText: 'Use ↑↓ arrows, Tab or Enter to select',
                      helperStyle: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                setState(() {
                                  _searchController.clear();
                                  selectedProduct = null;
                                  selectedProductId = null;
                                  _showSuggestions = false;
                                  _highlightedIndex = -1;
                                  _currentSuggestions = [];
                                });
                              },
                            )
                          : null,
                    ),
                    onChanged: (value) {
                      if (value.isEmpty) {
                        setState(() {
                          _showSuggestions = false;
                          _currentSuggestions = [];
                          _highlightedIndex = -1;
                        });
                      } else {
                        setState(() {
                          _showSuggestions = true;
                          _highlightedIndex = -1;
                        });
                      }
                    },
                  );
                },
                suggestionsCallback: (pattern) async {
                  if (pattern.isEmpty) {
                    setState(() {
                      _currentSuggestions = [];
                      _highlightedIndex = -1;
                    });
                    return [];
                  }
                  
                  await _productController.fetchProductsByQuery(pattern);
                  
                  final suggestions = _productController.products
                      .map((p) => {
                            'id': p.id.toString(),
                            'name': p.name,
                            'image': p.image != null ? getProductImageUrl(p.image) : null,
                          })
                      .toList();
                  
                  setState(() {
                    _currentSuggestions = suggestions;
                    if (suggestions.isNotEmpty && _highlightedIndex == -1) {
                      _highlightedIndex = 0; // Auto-highlight first item
                    }
                  });
                  
                  return suggestions;
                },
                itemBuilder: (context, suggestion) {
                  final index = _currentSuggestions.indexOf(suggestion);
                  final isHighlighted = index == _highlightedIndex;
                  
                  return Container(
                    color: isHighlighted ? AppTheme.btnNormalColor.withOpacity(0.1) : null,
                    child: ListTile(
                      leading: suggestion['image'] != null
                          ? Image.network(
                              suggestion['image'],
                              width: 50,
                              height: 50,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(Icons.image),
                            )
                          : const Icon(Icons.image),
                      title: Text(
                        suggestion['name'],
                        style: TextStyle(
                          fontWeight: isHighlighted ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                      trailing: isHighlighted
                          ? Icon(Icons.keyboard_return, 
                              color: AppTheme.btnNormalColor, 
                              size: 20)
                          : null,
                    ),
                  );
                },
                onSelected: (suggestion) {
                  _selectProduct(suggestion);
                },
                emptyBuilder: (context) => const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('No products found'),
                ),
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
        ));
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppTheme.appbarBackgroundColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.appbarBackgroundColor.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline_rounded, color: AppTheme.btnNormalColor, size: 20),
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
        border: Border.all(color: AppTheme.btnNormalColor, width: 2.0),
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
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
          Icon(Icons.check_circle, color: AppTheme.btnNormalColor, size: 24),
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
            colorScheme: ColorScheme.light(primary: AppTheme.btnNormalColor),
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
    if (!_formKey.currentState!.validate()) return;

    if (widget.preFilledData != null) {
      final data = {
        "farm_id": widget.preFilledData!['farm_id'],
        "product_id": widget.preFilledData!['product_id'],
        "quantity": double.parse(_quantityController.text),
        "unit": widget.preFilledData!['unit'],
        "market_supply_id": widget.preFilledData!['market_supply_id'],
        "delivery_date": selectedDeliveryDate,
        if (_notesController.text.isNotEmpty) "note": _notesController.text,
      };

      final success = await _preOrderController.createPreOrderFromSurplus(data);

      if (success) {
        Get.snackbar(
          "Success",
          "Pre-order request sent successfully",
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        Navigator.pop(context);
      } else {
        Get.snackbar(
          "Error",
          "Failed to send pre-order request",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } else {
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

      final success = await _preOrderController.createPreOrder(model: preOrderModel);

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Pre-order created successfully'),
            backgroundColor: Colors.green,
          ),
        );
        _resetForm();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to create pre-order'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _resetForm() {
    _formKey.currentState!.reset();
    _quantityController.clear();
    _notesController.clear();
    _recurringScheduleController.clear();
    _searchController.clear();
    setState(() {
      selectedProduct = null;
      selectedProductId = null;
      _showSuggestions = false;
      _highlightedIndex = -1;
      _currentSuggestions = [];
    });
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