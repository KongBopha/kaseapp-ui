import 'package:flutter/material.dart';
import 'package:kaseapp_ui/models/receiveorder_model.dart';
import 'package:kaseapp_ui/configs/themes/app_theme.dart';

class ReceiveOrderCard extends StatelessWidget {
  final ReceiveorderModel preOrder;

  const ReceiveOrderCard({super.key, required this.preOrder});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),  
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(preOrder.productName,
                style: TextStyle(
                    color: AppTheme.itemTitleColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text('From ${preOrder.vendorName}', style: TextStyle(color: AppTheme.itemSubTitleColor)),
            const SizedBox(height: 8),
            Text('Quantity: ${preOrder.fulfilledQty}kg',
                style: TextStyle(color: Colors.green, fontWeight: FontWeight.w600)),
            const SizedBox(height: 4),
            Text('Delivery: ${_formatDate(preOrder.deliveryDate)}',
                style: TextStyle(color: AppTheme.itemTitleColor)),
            const SizedBox(height: 4),
            Text('Location: ${preOrder.location}', style: TextStyle(color: AppTheme.itemSubTitleColor)),
            if (preOrder.note.isNotEmpty && preOrder.note != "No notes") ...[
              const SizedBox(height: 8),
              Text('Note: ${preOrder.note}', style: TextStyle(color: AppTheme.itemTitleColor)),
            ],
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: _getStatusColor(preOrder.offerStatus),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(preOrder.offerStatus.toLowerCase(),
                  style: const TextStyle(color: Colors.white, fontSize: 12)),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'accepted':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return '${date.day.toString().padLeft(2,'0')}-${date.month.toString().padLeft(2,'0')}-${date.year}';
    } catch (_) {
      return dateString;
    }
  }
}
