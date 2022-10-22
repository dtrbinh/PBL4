import 'package:flutter/material.dart';

void logWarning(String warning) {
  debugPrint('\x1B[33m$warning\x1B[0m');
}

void logError(String error) {
  debugPrint('\x1B[31m$error\x1B[0m');
}

// Black:   \x1B[30m
// Red:     \x1B[31m
// Green:   \x1B[32m
// Yellow:  \x1B[33m
// Blue:    \x1B[34m
// Magenta: \x1B[35m
// Cyan:    \x1B[36m
// White:   \x1B[37m
// Reset:   \x1B[0m