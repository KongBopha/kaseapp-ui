enum PreOrderStatus {
  pending,
  partiallyFulfilled,
  fulfilled,
  cancelled,
}

// Extension for conversion to convert enum to string, string to enum
extension PreOrderStatusExtension on PreOrderStatus {
  String get value {
    switch (this) {
      case PreOrderStatus.pending:
        return 'pending';
      case PreOrderStatus.partiallyFulfilled:
        return 'partially_fulfilled';
      case PreOrderStatus.fulfilled:
        return 'fulfilled';
      case PreOrderStatus.cancelled:
        return 'cancelled';
    }
  }

  static PreOrderStatus fromString(String status) {
    switch (status) {
      case 'pending':
        return PreOrderStatus.pending;
      case 'partially_fulfilled':
        return PreOrderStatus.partiallyFulfilled;
      case 'fulfilled':
        return PreOrderStatus.fulfilled;
      case 'cancelled':
        return PreOrderStatus.cancelled;
      default:
        return PreOrderStatus.pending;  
    }
  }
    String get label {
    switch (this) {
      case PreOrderStatus.pending:
        return 'Pending';
      case PreOrderStatus.partiallyFulfilled:
        return 'Partially Fulfilled';
      case PreOrderStatus.fulfilled:
        return 'Fulfilled';
      case PreOrderStatus.cancelled:
        return 'Cancelled';
    }
  }
}

