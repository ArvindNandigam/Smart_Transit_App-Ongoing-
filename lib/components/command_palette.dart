// lib/components/command_palette.dart
import 'package:flutter/material.dart';
import 'package:smart_transit/theme/app_colors.dart';

/// Data class to represent a single executable command.
class CommandItem {
  final IconData icon;
  final String title;
  final String group;
  final VoidCallback onSelected;

  CommandItem({
    required this.icon,
    required this.title,
    required this.group,
    required this.onSelected,
  });
}

/// Displays the command palette dialog.
Future<void> showAppCommandPalette({
  required BuildContext context,
  required List<CommandItem> commands,
}) {
  return showDialog(
    context: context,
    builder: (_) => Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(16),
      child: _CommandPalette(commands: commands),
    ),
  );
}

// The internal stateful widget that powers the command palette
class _CommandPalette extends StatefulWidget {
  final List<CommandItem> commands;
  const _CommandPalette({required this.commands});

  @override
  State<_CommandPalette> createState() => _CommandPaletteState();
}

class _CommandPaletteState extends State<_CommandPalette> {
  final _textController = TextEditingController();
  late Map<String, List<CommandItem>> _groupedCommands;

  @override
  void initState() {
    super.initState();
    _filterCommands('');
    _textController.addListener(() => _filterCommands(_textController.text));
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _filterCommands(String query) {
    final filtered = query.isEmpty
        ? widget.commands
        : widget.commands
              .where(
                (cmd) => cmd.title.toLowerCase().contains(query.toLowerCase()),
              )
              .toList();

    final newGroupedCommands = <String, List<CommandItem>>{};
    for (var cmd in filtered) {
      (newGroupedCommands[cmd.group] ??= []).add(cmd);
    }
    setState(() => _groupedCommands = newGroupedCommands);
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final popoverColor = isDarkMode
        ? AppColorsDark.popover
        : AppColorsLight.popover;
    final mutedColor = isDarkMode
        ? AppColorsDark.mutedForeground
        : AppColorsLight.mutedForeground;

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 400,
        decoration: BoxDecoration(
          color: popoverColor,
          border: Border.all(color: Theme.of(context).dividerColor),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            // --- CommandInput ---
            Container(
              height: 48,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Theme.of(context).dividerColor),
                ),
              ),
              child: Row(
                children: [
                  Icon(Icons.search, color: mutedColor, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _textController,
                      autofocus: true,
                      decoration: InputDecoration(
                        hintText: 'Search commands...',
                        border: InputBorder.none,
                        hintStyle: TextStyle(color: mutedColor),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // --- CommandList ---
            Expanded(
              child: _groupedCommands.isEmpty
                  ? const Center(
                      child: Text('No results found.'),
                    ) // CommandEmpty
                  : ListView.builder(
                      padding: const EdgeInsets.all(8.0),
                      itemCount: _groupedCommands.length,
                      itemBuilder: (context, index) {
                        final groupName = _groupedCommands.keys.elementAt(
                          index,
                        );
                        final items = _groupedCommands[groupName]!;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // CommandGroup Heading
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8.0,
                                vertical: 12.0,
                              ),
                              child: Text(
                                groupName,
                                style: TextStyle(
                                  color: mutedColor,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                            // CommandItems
                            ...items.map(
                              (item) => ListTile(
                                leading: Icon(
                                  item.icon,
                                  size: 20,
                                  color: mutedColor,
                                ),
                                title: Text(item.title),
                                onTap: () {
                                  Navigator.of(
                                    context,
                                  ).pop(); // Close the dialog
                                  item.onSelected(); // Execute the command
                                },
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
