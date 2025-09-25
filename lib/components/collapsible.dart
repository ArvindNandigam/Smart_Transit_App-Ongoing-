// lib/components/collapsible.dart
import 'package:flutter/material.dart';

class AppCollapsible extends StatefulWidget {
  final Widget trigger;
  final Widget content;
  final bool initiallyExpanded;
  final Duration animationDuration;

  const AppCollapsible({
    super.key,
    required this.trigger,
    required this.content,
    this.initiallyExpanded = false,
    this.animationDuration = const Duration(milliseconds: 300),
  });

  @override
  State<AppCollapsible> createState() => _AppCollapsibleState();
}

class _AppCollapsibleState extends State<AppCollapsible> {
  late bool _isExpanded;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.initiallyExpanded;
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // CollapsibleTrigger
        InkWell(onTap: _toggleExpanded, child: widget.trigger),
        // CollapsibleContent with smooth animation
        AnimatedSize(
          duration: widget.animationDuration,
          curve: Curves.easeInOut,
          child: _isExpanded ? widget.content : const SizedBox.shrink(),
        ),
      ],
    );
  }
}
