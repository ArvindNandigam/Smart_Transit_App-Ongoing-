// lib/components/table.dart
import 'package:flutter/material.dart';

/// A styled, responsive table for displaying data.
class AppTable extends StatelessWidget {
  final List<DataColumn> columns;
  final List<DataRow> rows;

  const AppTable({super.key, required this.columns, required this.rows});

  @override
  Widget build(BuildContext context) {
    // The DataTable is wrapped in a container for styling and a SingleChildScrollView
    // to allow for horizontal scrolling on small screens.
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).dividerColor),
        borderRadius: BorderRadius.circular(12),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          // --- Styling to match the .tsx component ---
          headingTextStyle: Theme.of(
            context,
          ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.bold),
          dataRowColor: WidgetStateProperty.resolveWith<Color?>((
            Set<WidgetState> states,
          ) {
            // Add a hover effect, similar to "hover:bg-muted/50"
            if (states.contains(WidgetState.hovered)) {
              return Theme.of(context).hoverColor;
            }
            return null; // Use default transparent background
          }),
          columns: columns,
          rows: rows,
        ),
      ),
    );
  }
}

/// A styled caption for displaying below a table.
class AppTableCaption extends StatelessWidget {
  final String text;
  const AppTableCaption(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Text(
        text,
        style: Theme.of(
          context,
        ).textTheme.bodySmall?.copyWith(color: Theme.of(context).hintColor),
      ),
    );
  }
}
