// lib/components/chart_config.dart
import 'package:flutter/material.dart';

// Defines the style for a single data series in the chart
class ChartSeriesConfig {
  final String label;
  final Color color;
  final IconData? icon;

  const ChartSeriesConfig({
    required this.label,
    required this.color,
    this.icon,
  });
}

// A map that holds the configuration for all series in a chart
typedef AppChartConfig = Map<String, ChartSeriesConfig>;
