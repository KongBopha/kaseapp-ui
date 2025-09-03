import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kaseapp_ui/controllers/pre_order_controller.dart';
import 'package:kaseapp_ui/models/pre_order_model.dart';
import 'package:kaseapp_ui/models/product.dart';
import 'package:kaseapp_ui/utils/pre_order_enum.dart';

class SupplyForm extends StatefulWidget {
  const SupplyForm({super.key});

  @override
  _SupplyFormState createState() => _SupplyFormState();
}

class _SupplyFormState extends State<SupplyForm> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
  // final PreOrderController _controller =
  //     Get.put(PreOrderController(apiService: ApiService()));

  // final _formKey = GlobalKey<FormState>();
  // final _quantityController = TextEditingController();
  // final _locationController = TextEditingController();
  // final _noteController = TextEditingController();
  // final _deliveryDateController = TextEditingController();
  // final _recurringController = TextEditingController();

  // int? _selectedProductId;

  // @override
  // void dispose() {
  //   _quantityController.dispose();
  //   _locationController.dispose();
  //   _noteController.dispose();
  //   _deliveryDateController.dispose();
  //   _recurringController.dispose();
  //   super.dispose();
  // }

  // void _submitForm() {
  //   if (!_formKey.currentState!.validate()) return;

  //   try {
  //     final selectedProduct = _controller.products
  //         .firstWhere((p) => p['id'] == _selectedProductId);
  //     final preOrder = PreOrder(
  //       id: 0,
  //       userId: 1,
  //     productId: _selectedProductId!,
  //     qty: double.parse(_quantityController.text),
  //     location: _locationController.text,
  //     noteText: _noteController.text,
  //     deliveryDate: DateTime.parse(_deliveryDateController.text),
  //     recurringSchedule: _recurringController.text,
  //     status: PreOrderStatus.pending,
  //     product: Product.fromJson(selectedProduct),
  //   );

  //   _controller.createPreOrder(preOrder);
  //     _clearForm();
  //   } catch (e) {
  //     Get.snackbar('Error', 'Please select a valid product');
  //   }
  // }

  // void _clearForm() {
  //   _selectedProductId = null;
  //   _quantityController.clear();
  //   _locationController.clear();
  //   _noteController.clear();
  //   _deliveryDateController.clear();
  //   _recurringController.clear();
  //   setState(() {});
  // }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(title: const Text('Create Pre-Order')),
  //     body: Obx(() {
  //       if (_controller.isLoading.value) {
  //         return const Center(child: CircularProgressIndicator());
  //       }

  //       return SingleChildScrollView(
  //         padding: const EdgeInsets.all(16),
  //         child: Form(
  //           key: _formKey,
  //           child: Column(
  //             children: [
  //               _buildProductDropdown(),
  //               _buildTextField(_quantityController, 'Quantity',
  //                   keyboardType: TextInputType.number),
  //               _buildTextField(_deliveryDateController,
  //                   'Delivery Date (YYYY-MM-DD)',
  //                   keyboardType: TextInputType.datetime),
  //               _buildTextField(_locationController, 'Location'),
  //               _buildTextField(_recurringController, 'Recurring Schedule',
  //                   hintText: 'e.g., weekly, monthly'),
  //               _buildTextField(_noteController, 'Note',
  //                   maxLines: 3, hintText: 'Additional notes'),
  //               const SizedBox(height: 24),
  //               SizedBox(
  //                 width: double.infinity,
  //                 child: ElevatedButton(
  //                   onPressed: _submitForm,
  //                   style: ElevatedButton.styleFrom(
  //                     backgroundColor: const Color(0xFF06BC00),
  //                     padding: const EdgeInsets.symmetric(vertical: 16),
  //                     shape: RoundedRectangleBorder(
  //                         borderRadius: BorderRadius.circular(12)),
  //                   ),
  //                   child: const Text('Submit Pre-Order'),
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       );
  //     }),
  //   );
  }

//   Widget _buildProductDropdown() {
//     return Obx(() {
//       return DropdownButtonFormField<int>(
//         value: _selectedProductId,
//         items: _controller.products
//             .map((p) => DropdownMenuItem<int>(
//                   value: p['id'],
//                   child: Text(p['name']),
//                 ))
//             .toList(),
//         onChanged: (val) => setState(() => _selectedProductId = val),
//         validator: (value) =>
//             value == null ? 'Please select a product' : null,
//         decoration: InputDecoration(
//           labelText: 'Select Product',
//           border:
//               OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//         ),
//       );
//     });
//   }

//   Widget _buildTextField(TextEditingController controller, String label,
//       {String? hintText,
//       TextInputType? keyboardType,
//       int maxLines = 1,
//       String? Function(String?)? validator}) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8),
//       child: TextFormField(
//         controller: controller,
//         keyboardType: keyboardType,
//         maxLines: maxLines,
//         validator: validator ??
//             (value) {
//               if (value == null || value.isEmpty) return 'Enter $label';
//               return null;
//             },
//         decoration: InputDecoration(
//           labelText: label,
//           hintText: hintText,
//           border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(12)),
//         ),
//       ),
//     );
//   }
// }
