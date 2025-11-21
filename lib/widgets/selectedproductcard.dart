import 'package:flutter/material.dart';
import 'package:kaseapp_ui/configs/themes/app_theme.dart';

class SelectedProductCard extends StatelessWidget {
  final Map<String, dynamic> product;
  const SelectedProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: AppTheme.btnNormalColor, width: 2),
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.2), spreadRadius: 1, blurRadius: 5, offset: Offset(0, 2))],
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
                    errorBuilder: (_, __, ___) => Icon(Icons.image, size: 60),
                  ),
                )
              : Icon(Icons.image, size: 60),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              product['name'],
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: AppTheme.pageTitleColor),
            ),
          ),
          Icon(Icons.check_circle, color: AppTheme.btnNormalColor, size: 24),
        ],
      ),
    );
  }
}
