import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:kaseapp_ui/configs/themes/app_theme.dart';

enum MessageTypesEnum { preOrder, accept, reject, confirm }

extension MessageTypesEnumExtension on MessageTypesEnum {
  static MessageTypesEnum fromString(String value) {
    switch (value) {
      case 'pre_order':
        return MessageTypesEnum.preOrder;
      case 'accept':
        return MessageTypesEnum.accept;
      case 'reject':
        return MessageTypesEnum.reject;
      case 'confirm':
        return MessageTypesEnum.confirm;
      default:
        return MessageTypesEnum.preOrder; // default fallback
    }
  }
  
  IconData _getNotificationTypeIcon(MessageTypesEnum type) {
    switch (type) {
      case MessageTypesEnum.preOrder:
        return Icons.shopping_cart_outlined;
      case MessageTypesEnum.accept:
        return Icons.inventory_2_outlined;
      case MessageTypesEnum.confirm:
        return Icons.local_offer_outlined;
      case MessageTypesEnum.reject:
        return Icons.local_shipping_outlined;
        
    }
  }

  Color _getNotificationTypeColor(MessageTypesEnum type) {
    switch (type) {
      case MessageTypesEnum.preOrder:
        return Colors.blue;
      case MessageTypesEnum.accept:
        return Colors.green;
      case MessageTypesEnum.confirm:
        return Colors.orange;
      case MessageTypesEnum.reject:
        return Colors.purple;
    }
  }

}

