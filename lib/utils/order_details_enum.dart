enum OrderDetailsEnum {
  pending,
  accepted,
  confirmed,
  rejected,
}
// Extension for conversion to convert enum to string, string to enum
extension OrderDetailStatusExtension on OrderDetailsEnum {
  String get value {
    switch (this) {
      case OrderDetailsEnum.pending:
        return 'pending';
      case OrderDetailsEnum.accepted:
        return 'partially_fulfilled';
      case OrderDetailsEnum.confirmed:
        return 'fulfilled';
      case OrderDetailsEnum.rejected:
        return 'cancelled';
    }
  }

  static OrderDetailsEnum fromString(String status) {
    switch (status) {
      case 'pending':
        return OrderDetailsEnum.pending;
      case 'accepted':
        return OrderDetailsEnum.accepted;
      case 'confirmed':
        return OrderDetailsEnum.confirmed;
      case 'rejected':
        return OrderDetailsEnum.rejected;
      default:
        return OrderDetailsEnum.pending; // fallback
    }
  }
}
