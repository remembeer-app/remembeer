import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

void showNotification(
  String message, {
  ToastificationType type = ToastificationType.info,
}) {
  toastification.show(
    title: Text(message),
    type: type,
    autoCloseDuration: const Duration(seconds: 2),
  );
}

void showSuccessNotification(String message) {
  showNotification(message, type: ToastificationType.success);
}

void showInfoNotification(String message) {
  showNotification(message, type: ToastificationType.info);
}
