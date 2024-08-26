import 'package:flutter/material.dart';

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

  static List<Widget> toWidgetList(BuildContext context, int value) {
    MomoPaymentStatus status = fromInt(value);
    switch (status) {
      case MomoPaymentStatus.success:
        return [
          const Icon(Icons.check_circle, size: 70, color: Colors.green),
          const SizedBox(height: 15),
          Text("Payment Success", style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 7),
          Text("Your payment was successful. You can now close this page.",
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontFamily: 'Merriweather'),
              textAlign: TextAlign.center,
              maxLines: 2,)
        ];
      case MomoPaymentStatus.timeout:
        return [
          Icon(Icons.timer, size: 70, color: Colors.yellow[700]),
          const SizedBox(height: 15),
          Text("Request Timeout", style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 7),
          Text("Your payment was not completed in time. Please try again.",
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontFamily: 'Merriweather'),
              textAlign: TextAlign.center,
              maxLines: 2,)
        ];
      case MomoPaymentStatus.cancel:
        return [
          const Icon(Icons.cancel, size: 70, color: Colors.blueGrey),
          const SizedBox(height: 15),
          Text("Payment Cancelled", style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 7),
          Text("Your payment was cancelled. Please try again.",
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontFamily: 'Merriweather'),
              textAlign: TextAlign.center,
              maxLines: 2,)
        ];
      case MomoPaymentStatus.error:
        return [
          Icon(Icons.error, size: 70, color: Colors.deepOrange[700]),
          const SizedBox(height: 15),
          Text("Payment Error", style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 7),
          Text("An error occurred while processing your payment. Please try again.",
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontFamily: 'Merriweather'),
              textAlign: TextAlign.center,
              maxLines: 2,)
        ];
      default:
        return [
          Icon(Icons.error, size: 70, color: Colors.deepOrange[700]),
          const SizedBox(height: 15),
          Text("Payment Error", style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 7),
          Text("An error occurred while processing your payment. Please try again.",
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontFamily: 'Merriweather'),
              textAlign: TextAlign.center,
              maxLines: 2,)
        ];
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
