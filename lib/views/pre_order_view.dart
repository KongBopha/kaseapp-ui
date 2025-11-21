import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:kaseapp_ui/configs/themes/app_theme.dart';
import 'package:kaseapp_ui/controllers/pre_order_controller.dart';
import 'package:kaseapp_ui/controllers/product_controller.dart';
import 'package:kaseapp_ui/models/pre_order_model.dart';
import 'package:kaseapp_ui/utils/constants/app_image.dart';
import 'package:kaseapp_ui/utils/constants/base_api.dart';
import 'package:kaseapp_ui/utils/pre_order_enum.dart';
import 'package:kaseapp_ui/widgets/app_bar/my_app_bar.dart';
import 'package:kaseapp_ui/widgets/locationpicker.dart';

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
  final TextEditingController _locationController = TextEditingController();

  final PreOrderController _preOrderController = Get.find<PreOrderController>();
  late final ProductController _productController;

  String? selectedProductId;
  Map<String, dynamic>? selectedProduct;
  DateTime selectedDeliveryDate = DateTime.now();
  Position? _currentPosition;
  bool _isLoadingLocation = false;
  double? _selectedLat;
  double? _selectedLng;
  String? _selectedRecurringSchedule;
  
  List<Map<String, dynamic>> _currentSuggestions = [];
  int _highlightedIndex = -1;
  bool _showSuggestions = false;

  // Crop growing periods (in days) - min and max days from planting to harvest
  final Map<String, Map<String, int>> productGrowingPeriods = {
    'Cherry Tomatoes': {'min': 55, 'max': 65},
    'Cucumber': {'min': 40, 'max': 55},
    'Eggplant': {'min': 75, 'max': 85},
    'Carrot': {'min': 70, 'max': 80},
    'Fresh Corn': {'min': 80, 'max': 90},
    'Tomatoes': {'min': 65, 'max': 75},
  };

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
      
      // Clear dependent fields when product changes
      _deliveryDateController.clear();
      selectedDeliveryDate = DateTime.now();
    });
  }

  // Check if product is selected
  bool get isProductSelected => selectedProduct != null;

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Location services are disabled. Please enable them.'),
          backgroundColor: Colors.orange,
        ),
      );
      return false;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Location permissions are denied'),
            backgroundColor: Colors.red,
          ),
        );
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Location permissions are permanently denied. Please enable them in settings.'),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }

    return true;
  }

  Future<void> _getCurrentLocation() async {
    final hasPermission = await _handleLocationPermission();
    if (!hasPermission) return;

    setState(() {
      _isLoadingLocation = true;
    });

    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _currentPosition = position;
      });

      await _getAddressFromCoordinates(position.latitude, position.longitude);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error getting location: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoadingLocation = false;
      });
    }
  }

  Future<void> _getAddressFromCoordinates(double latitude, double longitude) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        String address = '';
        if (place.street != null && place.street!.isNotEmpty) address += '${place.street}, ';
        if (place.locality != null && place.locality!.isNotEmpty) address += '${place.locality}, ';
        if (place.administrativeArea != null && place.administrativeArea!.isNotEmpty) address += '${place.administrativeArea}, ';
        if (place.country != null && place.country!.isNotEmpty) address += place.country!;
        setState(() {
          _locationController.text = address.isNotEmpty ? address : 'Lat: $latitude, Long: $longitude';
        });
      }
    } catch (e) {
      setState(() {
        _locationController.text = 'Lat: $latitude, Long: $longitude';
      });
    }
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
                Text('Product Details', style: TextStyle(color: AppTheme.pageTitleColor, fontSize: 18, fontWeight: FontWeight.w600)),
                const SizedBox(height: 16),
                _buildKeyboardFriendlyAutocomplete(),
                const SizedBox(height: 20),
                if (selectedProduct != null) _buildSelectedProductCard(selectedProduct!),
                const SizedBox(height: 20),
                // Quantity - Disabled until product is selected
                Opacity(
                  opacity: isProductSelected ? 1.0 : 0.5,
                  child: TextFormField(
                    controller: _quantityController,
                    enabled: isProductSelected,
                    decoration: InputDecoration(
                      labelText: 'Quantity',
                      hintText: isProductSelected ? 'Enter quantity in kg' : 'Select product first',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      suffixText: 'kg',
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Please enter quantity';
                      if (double.tryParse(value) == null) return 'Please enter a valid number';
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 20),
                // Location - Disabled until product is selected
                Opacity(
                  opacity: isProductSelected ? 1.0 : 0.5,
                  child: TextFormField(
                    controller: _locationController,
                    enabled: isProductSelected,
                    decoration: InputDecoration(
                      labelText: 'Delivery Location',
                      hintText: isProductSelected ? 'Enter location or use GPS' : 'Select product first',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      suffixIcon: !isProductSelected ? null : _isLoadingLocation
                          ? const Padding(
                              padding: EdgeInsets.all(12.0),
                              child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)),
                            )
                          : ElevatedButton.icon(
                              icon: const Icon(Icons.map_outlined),
                              label: const Text('Select on Map'),
                              onPressed: () async {
                                final LatLng? pickedLocation = await Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const VendorLocationPicker()),
                                );

                                if (pickedLocation != null) {
                                  setState(() {
                                    _selectedLat = pickedLocation.latitude;
                                    _selectedLng = pickedLocation.longitude;
                                  });
                                  await _getAddressFromCoordinates(_selectedLat!, _selectedLng!);
                                }
                              },
                            ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Please enter or select location';
                      return null;
                    },
                    maxLines: 2,
                    minLines: 1,
                  ),
                ),
                const SizedBox(height: 20),
                // Delivery Date - Disabled until product is selected
                Opacity(
                  opacity: isProductSelected ? 1.0 : 0.5,
                  child: TextFormField(
                    controller: _deliveryDateController,
                    readOnly: true,
                    enabled: isProductSelected,
                    decoration: InputDecoration(
                      labelText: 'Delivery Date',
                      hintText: isProductSelected ? 'Select delivery date' : 'Select product first',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.calendar_today),
                        onPressed: isProductSelected ? () => _selectDeliveryDate(context) : null,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Please select delivery date';
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 20),
                // Recurring Schedule - Disabled until product is selected
                Opacity(
                  opacity: isProductSelected ? 1.0 : 0.5,
                  child: TextFormField(
                    controller: _recurringScheduleController,
                    readOnly: true,
                    enabled: isProductSelected,
                    decoration: InputDecoration(
                      labelText: 'Recurring Schedule (Optional)',
                      hintText: isProductSelected ? 'Tap to select schedule' : 'Select product first',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.schedule),
                        onPressed: isProductSelected ? () => _showRecurringScheduleDialog() : null,
                      ),
                    ),
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
                // Submit
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _submitForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.btnNormalColor,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: Text('Create Pre-order', style: TextStyle(color: AppTheme.btnTextNormalColor, fontSize: 16, fontWeight: FontWeight.w600)),
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

  Widget _buildKeyboardFriendlyAutocomplete() {
    return Obx(() => Stack(
          children: [
            Focus(
              onKeyEvent: (node, event) {
                if (event is KeyDownEvent && _showSuggestions && _currentSuggestions.isNotEmpty) {
                  if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
                    setState(() {
                      _highlightedIndex = (_highlightedIndex + 1) % _currentSuggestions.length;
                    });
                    return KeyEventResult.handled;
                  } else if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
                    setState(() {
                      _highlightedIndex = _highlightedIndex <= 0
                          ? _currentSuggestions.length - 1
                          : _highlightedIndex - 1;
                    });
                    return KeyEventResult.handled;
                  } else if (event.logicalKey == LogicalKeyboardKey.enter ||
                      event.logicalKey == LogicalKeyboardKey.tab) {
                    if (_highlightedIndex >= 0 && _highlightedIndex < _currentSuggestions.length) {
                      _selectProduct(_currentSuggestions[_highlightedIndex]);
                      return KeyEventResult.handled;
                    }
                  } else if (event.logicalKey == LogicalKeyboardKey.escape) {
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
                      _highlightedIndex = 0;
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
                              errorBuilder: (context, error, stackTrace) => const Icon(Icons.image),
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
                              color: AppTheme.btnNormalColor, size: 20)
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

  Future<void> _selectDeliveryDate(BuildContext context) async {
    if (!isProductSelected) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a product first'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // Get growing period for selected product
    final productName = selectedProduct!['name'];
    final growingPeriod = productGrowingPeriods[productName];
    
    DateTime recommendedMinDate = DateTime.now();
    DateTime recommendedMaxDate = DateTime.now();
    
    if (growingPeriod != null) {
      recommendedMinDate = DateTime.now().add(Duration(days: growingPeriod['min']!));
      recommendedMaxDate = DateTime.now().add(Duration(days: growingPeriod['max']!));
    }

    DateTime tempSelectedDate = recommendedMinDate;

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Select Delivery Date",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.pageTitleColor,
                ),
              ),
              if (growingPeriod != null) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.btnNormalColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, color: AppTheme.btnNormalColor, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Recommended delivery: ${growingPeriod['min']} to ${growingPeriod['max']} days from today',
                          style: TextStyle(
                            fontSize: 13,
                            color: AppTheme.pageTitleColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 16),
              CalendarDatePicker(
                initialDate: recommendedMinDate,
                firstDate: DateTime.now(),
                lastDate: DateTime(DateTime.now().year + 2),
                onDateChanged: (date) {
                  tempSelectedDate = date;
                },
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(ctx),
                    child: Text(
                      'Cancel',
                      style: TextStyle(color: AppTheme.date_Color),
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.date_Color,
                    ),
                    onPressed: () {
                      setState(() {
                        selectedDeliveryDate = tempSelectedDate;
                        _deliveryDateController.text =
                            "${tempSelectedDate.day.toString().padLeft(2, '0')}/"
                            "${tempSelectedDate.month.toString().padLeft(2, '0')}/"
                            "${tempSelectedDate.year}";
                      });
                      Navigator.pop(ctx);
                    },
                    child: const Text('Confirm', style: TextStyle(color: Colors.black)),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  Future<void> _showRecurringScheduleDialog() async {
    if (!isProductSelected) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a product first'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final selectedSchedule = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Select Recurring Schedule'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.calendar_today),
                title: const Text('Daily'),
                onTap: () => Navigator.pop(context, 'Daily'),
              ),
              ListTile(
                leading: const Icon(Icons.view_week),
                title: const Text('Weekly'),
                onTap: () => Navigator.pop(context, 'Weekly'),
              ),
              ListTile(
                leading: const Icon(Icons.calendar_month),
                title: const Text('Monthly'),
                onTap: () => Navigator.pop(context, 'Monthly'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );

    if (selectedSchedule != null) {
      setState(() {
        _selectedRecurringSchedule = selectedSchedule;
        _recurringScheduleController.text = selectedSchedule;
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
        "location": _locationController.text,
        if (_currentPosition != null) "latitude": _currentPosition!.latitude,
        if (_currentPosition != null) "longitude": _currentPosition!.longitude,
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
        location: _locationController.text,
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
    _locationController.clear();
    _deliveryDateController.clear();
    setState(() {
      selectedProduct = null;
      selectedProductId = null;
      _currentPosition = null;
      _showSuggestions = false;
      _highlightedIndex = -1;
      _currentSuggestions = [];
      _selectedRecurringSchedule = null;
    });
  }

  @override
  void dispose() {
    _quantityController.dispose();
    _deliveryDateController.dispose();
    _notesController.dispose();
    _recurringScheduleController.dispose();
    _searchController.dispose();
    _locationController.dispose();
    super.dispose();
  }
}