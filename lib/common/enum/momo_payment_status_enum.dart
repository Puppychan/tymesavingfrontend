enum MomoPaymentStatus {
  success(0),
  timeout(5),
  cancel(6),
  error(7);

  const MomoPaymentStatus(this.value);

  final int value;

  @override
  String toString() {
    switch (this) {
      case MomoPaymentStatus.success:
        return "Success";
      case MomoPaymentStatus.timeout:
        return "Timeout";
      case MomoPaymentStatus.cancel:
        return "Cancel";
      case MomoPaymentStatus.error:
        return "Error";
      default:
        return "Unknown";
    }
  }

  static MomoPaymentStatus fromInt(int value) {
    // get the payment status from the value
    for (var status in MomoPaymentStatus.values) {
      if (status.value == value) {
        return status;
      }
    }
    // default to error
    return MomoPaymentStatus.error;
  }

  static List<String> get list {
    return MomoPaymentStatus.values.map((e) => e.toString()).toList();
  }
}
