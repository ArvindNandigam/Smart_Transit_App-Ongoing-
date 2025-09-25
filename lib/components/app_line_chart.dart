// lib/components/app_line_chart.dart
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:smart_transit/components/chart_config.dart';
import 'package:smart_transit/theme/app_colors.dart';

class AppLineChart extends StatelessWidget {
  final List<FlSpot> spots;
  final AppChartConfig chartConfig;
  final String seriesKey; // The key for the data series being displayed

  const AppLineChart({
    super.key,
    required this.spots,
    required this.chartConfig,
    required this.seriesKey,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final seriesStyle = chartConfig[seriesKey]!;
    final mutedTextColor = isDarkMode
        ? AppColorsDark.mutedForeground
        : AppColorsLight.mutedForeground;

    return Column(
      children: [
        AspectRatio(
          aspectRatio: 16 / 9,
          child: LineChart(
            LineChartData(
              // --- Styling the Chart Elements ---
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                getDrawingHorizontalLine: (value) => FlLine(
                  color: Theme.of(context).dividerColor.withOpacity(0.5),
                  strokeWidth: 1,
                ),
              ),
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                topTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 30,
                    getTitlesWidget: (value, meta) => Text(
                      '${value.toInt()}', // Example: show integer labels
                      style: TextStyle(color: mutedTextColor, fontSize: 12),
                    ),
                  ),
                ),
              ),
              borderData: FlBorderData(show: false),
              // --- Custom Tooltip ---
              lineTouchData: LineTouchData(
                handleBuiltInTouches: true,
                touchTooltipData: LineTouchTooltipData(
                  getTooltipColor: (spot) => Theme.of(context).cardColor,
                  getTooltipItems: (touchedSpots) {
                    return touchedSpots.map((spot) {
                      return LineTooltipItem(
                        '${spot.y.toStringAsFixed(0)} ${seriesStyle.label}',
                        TextStyle(
                          color: seriesStyle.color,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    }).toList();
                  },
                ),
              ),
              // --- Line Data ---
              lineBarsData: [
                LineChartBarData(
                  spots: spots,
                  isCurved: true,
                  color: seriesStyle.color,
                  barWidth: 3,
                  isStrokeCapRound: true,
                  dotData: const FlDotData(show: false),
                  belowBarData: BarAreaData(
                    show: true,
                    gradient: LinearGradient(
                      colors: [
                        seriesStyle.color.withOpacity(0.3),
                        Colors.transparent,
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        // --- Custom Legend ---
        _ChartLegend(chartConfig: chartConfig),
      ],
    );
  }
}

// The legend widget for the chart
class _ChartLegend extends StatelessWidget {
  final AppChartConfig chartConfig;
  const _ChartLegend({required this.chartConfig});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 24,
      runSpacing: 8,
      children: chartConfig.entries.map((entry) {
        final config = entry.value;
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: config.color,
              ),
            ),
            const SizedBox(width: 8),
            Text(config.label),
          ],
        );
      }).toList(),
    );
  }
}
