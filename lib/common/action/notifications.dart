import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

void showNotification(
  String message, {
  ToastificationType type = ToastificationType.info,
}) {
  toastification.show(
    title: Text(message),
    type: type,
    autoCloseDuration: const Duration(seconds: 4),
    // TODO(ohtenkay): adapt colors based on theme, currently requires passing in context, which is annoying
    backgroundColor: const Color(0xFFFFF8F2),
    foregroundColor: const Color(0xFF1F1B13),
  );
}

void showSuccessNotification(String message) {
  showNotification(message, type: ToastificationType.success);
}
