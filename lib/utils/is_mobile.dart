// lib/utils/is_mobile.dart
import 'package:flutter/material.dart';

const double _mobileBreakpoint = 768.0;

/// A utility function that returns true if the screen is considered mobile size.
bool isMobile(BuildContext context) {
  return MediaQuery.of(context).size.width < _mobileBreakpoint;
}
