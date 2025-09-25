// resizable.dart
import 'package:flutter/material.dart';

/// A group of resizable panels laid out horizontally or vertically,
/// with draggable handles between them.
class ResizablePanelGroup extends StatefulWidget {
  const ResizablePanelGroup({
    super.key,
    required this.panels,
    this.direction = Axis.horizontal,
    this.handleThickness = 1.0,
    this.withHandle = true,
    this.handleHitAreaExtent = 12.0,
    this.handleColor,
    this.onSizesChanged,
    this.handleBuilder,
  });

  /// The list of panels to render and resize.
  final List<ResizablePanel> panels;

  /// Layout direction: horizontal (default) or vertical.
  final Axis direction;

  /// Visual thickness of the divider line (in logical pixels).
  final double handleThickness;

  /// Whether to render a grip handle in the divider.
  final bool withHandle;

  /// Extra hit area for drag (beyond the visible line).
  final double handleHitAreaExtent;

  /// Divider color. Defaults to Theme.dividerColor if null.
  final Color? handleColor;

  /// Callback fired when the fractional sizes change.
  /// Fractions sum to 1.0.
  final ValueChanged<List<double>>? onSizesChanged;

  /// Optional custom handle builder.
  /// index is the handle index between panel[index] and panel[index+1].
  final Widget Function(
    BuildContext context,
    Axis axis,
    bool isDragging,
    int index,
  )?
  handleBuilder;

  @override
  State<ResizablePanelGroup> createState() => _ResizablePanelGroupState();
}

class _ResizablePanelGroupState extends State<ResizablePanelGroup> {
  late List<double> _fractions;
  late List<double> _minFractions;
  late List<double> _maxFractions;

  // Drag state
  int? _dragIndex;
  bool _isDragging = false;

  @override
  void initState() {
    super.initState();
    _initFractions();
  }

  @override
  void didUpdateWidget(covariant ResizablePanelGroup oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.panels.length != widget.panels.length) {
      _initFractions();
    } else {
      // If constraints change in panels, ensure current fractions are still valid.
      _minFractions = widget.panels
          .map((p) => p.minFraction.clamp(0.0, 1.0))
          .toList(growable: false);
      _maxFractions = widget.panels
          .map((p) => p.maxFraction.clamp(0.0, 1.0))
          .toList(growable: false);
      _normalizeToBounds();
    }
  }

  void _initFractions() {
    final n = widget.panels.length;
    if (n == 0) {
      _fractions = const [];
      _minFractions = const [];
      _maxFractions = const [];
      return;
    }

    _minFractions = widget.panels
        .map((p) => p.minFraction.clamp(0.0, 1.0))
        .toList(growable: false);
    _maxFractions = widget.panels
        .map((p) => p.maxFraction.clamp(0.0, 1.0))
        .toList(growable: false);

    // Start with provided defaults or equal split.
    final provided = widget.panels.map((p) => p.defaultFraction).toList();
    if (provided.any((f) => f != null)) {
      _fractions = List<double>.generate(
        n,
        (i) => (provided[i] ?? (1.0 / n)).clamp(0.0, 1.0),
        growable: false,
      );
    } else {
      _fractions = List<double>.filled(n, 1.0 / n, growable: false);
    }

    _normalizeToBounds();
  }

  void _normalizeToBounds() {
    // Ensure fractions sum to 1 and each within [min, max].
    final n = _fractions.length;
    if (n == 0) return;

    // First clamp to min/max.
    for (int i = 0; i < n; i++) {
      _fractions[i] = _fractions[i].clamp(_minFractions[i], _maxFractions[i]);
    }

    // Normalize sum to 1.0 while respecting min/max:
    double sum = _fractions.fold(0.0, (a, b) => a + b);
    if (sum == 0) {
      // Degenerate; distribute min, then fill remaining evenly.
      final minSum = _minFractions.fold(0.0, (a, b) => a + b);
      final remaining = (1.0 - minSum).clamp(0.0, 1.0);
      final room = List<double>.generate(
        n,
        (i) => _maxFractions[i] - _minFractions[i],
      );
      final roomSum = room.fold(0.0, (a, b) => a + b);
      for (int i = 0; i < n; i++) {
        final add = roomSum > 0 ? remaining * (room[i] / roomSum) : 0.0;
        _fractions[i] = _minFractions[i] + add;
      }
      return;
    }

    // Scale to 1.0 while not breaking min/max.
    // Two-pass approach: scale, then clip, then redistribute leftover.
    final scale = 1.0 / sum;
    for (int i = 0; i < n; i++) {
      _fractions[i] = (_fractions[i] * scale).clamp(
        _minFractions[i],
        _maxFractions[i],
      );
    }

    // After scaling and clamping, re-balance to sum exactly 1.0.
    double current = _fractions.fold(0.0, (a, b) => a + b);
    double diff = 1.0 - current;
    if (diff.abs() < 1e-6) return;

    // Distribute diff proportionally to available headroom.
    for (int iter = 0; iter < 3 && diff.abs() >= 1e-6; iter++) {
      if (diff > 0) {
        // Need to add to panels with available max headroom.
        final headroom = List<double>.generate(
          n,
          (i) => _maxFractions[i] - _fractions[i],
        );
        final total = headroom.fold(0.0, (a, b) => a + b);
        if (total <= 1e-9) break;
        for (int i = 0; i < n; i++) {
          final add = diff * (headroom[i] / total);
          _fractions[i] = (_fractions[i] + add).clamp(
            _minFractions[i],
            _maxFractions[i],
          );
        }
      } else {
        // Need to subtract from panels with available min headroom.
        final room = List<double>.generate(
          n,
          (i) => _fractions[i] - _minFractions[i],
        );
        final total = room.fold(0.0, (a, b) => a + b);
        if (total <= 1e-9) break;
        for (int i = 0; i < n; i++) {
          final sub = (-diff) * (room[i] / total);
          _fractions[i] = (_fractions[i] - sub).clamp(
            _minFractions[i],
            _maxFractions[i],
          );
        }
      }
      current = _fractions.fold(0.0, (a, b) => a + b);
      diff = 1.0 - current;
    }
  }

  void _applyDeltaToAdjacent(int leftIndex, double deltaFraction) {
    final rightIndex = leftIndex + 1;
    if (leftIndex < 0 || rightIndex >= _fractions.length) return;

    final left = _fractions[leftIndex];
    final right = _fractions[rightIndex];

    // First, try to apply delta to left (increase) and right (decrease).
    double newLeft = (left + deltaFraction).clamp(
      _minFractions[leftIndex],
      _maxFractions[leftIndex],
    );
    double actualDelta = newLeft - left;

    double newRight = (right - actualDelta).clamp(
      _minFractions[rightIndex],
      _maxFractions[rightIndex],
    );
    double actualRightDelta = right - newRight;

    // If right clamped prevented the full delta, adjust left accordingly.
    if ((actualRightDelta - actualDelta).abs() > 1e-9) {
      newLeft = (left + actualRightDelta).clamp(
        _minFractions[leftIndex],
        _maxFractions[leftIndex],
      );
    }

    _fractions[leftIndex] = newLeft;
    _fractions[rightIndex] = newRight;

    widget.onSizesChanged?.call(List<double>.from(_fractions));
  }

  @override
  Widget build(BuildContext context) {
    final axis = widget.direction;
    final dividerColor = widget.handleColor ?? Theme.of(context).dividerColor;

    if (widget.panels.isEmpty) {
      return const SizedBox.shrink();
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final totalExtent = axis == Axis.horizontal
            ? constraints.maxWidth
            : constraints.maxHeight;
        final children = <Widget>[];

        for (int i = 0; i < widget.panels.length; i++) {
          final panel = widget.panels[i];
          final flex = (_fractions[i] * 100000).round().clamp(1, 1000000000);

          children.add(
            Flexible(
              flex: flex,
              child: ClipRect(child: panel.child),
            ),
          );

          if (i < widget.panels.length - 1) {
            children.add(
              _buildHandle(
                index: i,
                axis: axis,
                dividerColor: dividerColor,
                totalExtent: totalExtent,
              ),
            );
          }
        }

        return Flex(direction: axis, children: children);
      },
    );
  }

  Widget _buildHandle({
    required int index,
    required Axis axis,
    required Color dividerColor,
    required double totalExtent,
  }) {
    final thickness = widget.handleThickness;
    final hit = widget.handleHitAreaExtent;

    final handleVisual = Container(
      width: axis == Axis.horizontal ? thickness : double.infinity,
      height: axis == Axis.vertical ? thickness : double.infinity,
      color: dividerColor,
      alignment: Alignment.center,
      child: widget.withHandle
          ? ResizableHandle(axis: axis, withHandle: true)
          : null,
    );

    final handleContent = widget.handleBuilder != null
        ? StatefulBuilder(
            builder: (context, setSB) {
              return Listener(
                onPointerDown: (_) => setState(() {
                  _dragIndex = index;
                  _isDragging = true;
                }),
                onPointerUp: (_) => setState(() {
                  _dragIndex = null;
                  _isDragging = false;
                }),
                child: widget.handleBuilder!(
                  context,
                  axis,
                  _isDragging && _dragIndex == index,
                  index,
                ),
              );
            },
          )
        : handleVisual;

    final gestureChild = MouseRegion(
      cursor: axis == Axis.horizontal
          ? SystemMouseCursors.resizeColumn
          : SystemMouseCursors.resizeRow,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onHorizontalDragStart: axis == Axis.horizontal
            ? (_) => setState(() {
                _dragIndex = index;
                _isDragging = true;
              })
            : null,
        onHorizontalDragUpdate: axis == Axis.horizontal
            ? (details) {
                final deltaFraction = (details.delta.dx / totalExtent);
                setState(() {
                  _applyDeltaToAdjacent(index, deltaFraction);
                });
              }
            : null,
        onHorizontalDragEnd: axis == Axis.horizontal
            ? (_) => setState(() {
                _dragIndex = null;
                _isDragging = false;
              })
            : null,
        onVerticalDragStart: axis == Axis.vertical
            ? (_) => setState(() {
                _dragIndex = index;
                _isDragging = true;
              })
            : null,
        onVerticalDragUpdate: axis == Axis.vertical
            ? (details) {
                final deltaFraction = (details.delta.dy / totalExtent);
                setState(() {
                  _applyDeltaToAdjacent(index, deltaFraction);
                });
              }
            : null,
        onVerticalDragEnd: axis == Axis.vertical
            ? (_) => setState(() {
                _dragIndex = null;
                _isDragging = false;
              })
            : null,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: axis == Axis.horizontal ? hit : 0,
            minHeight: axis == Axis.vertical ? hit : 0,
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Center the thin divider line
              Align(
                alignment: Alignment.center,
                child: SizedBox(
                  width: axis == Axis.horizontal
                      ? widget.handleThickness
                      : double.infinity,
                  height: axis == Axis.vertical
                      ? widget.handleThickness
                      : double.infinity,
                  child: DecoratedBox(
                    decoration: BoxDecoration(color: dividerColor),
                  ),
                ),
              ),
              if (widget.withHandle) handleContent,
            ],
          ),
        ),
      ),
    );

    return SizedBox(
      width: axis == Axis.horizontal ? widget.handleHitAreaExtent : null,
      height: axis == Axis.vertical ? widget.handleHitAreaExtent : null,
      child: gestureChild,
    );
  }
}

/// A single resizable panel within a [ResizablePanelGroup].
/// You can set min/max/default fractional sizes. Fractions are relative to the group and sum to 1.0.
class ResizablePanel extends StatelessWidget {
  const ResizablePanel({
    super.key,
    required this.child,
    this.minFraction = 0.05,
    this.maxFraction = 0.95,
    this.defaultFraction,
  }) : assert(
         minFraction >= 0 && maxFraction <= 1 && minFraction <= maxFraction,
       );

  /// The content widget for this panel.
  final Widget child;

  /// Minimum fraction of the total group extent this panel should occupy.
  final double minFraction;

  /// Maximum fraction of the total group extent this panel should occupy.
  final double maxFraction;

  /// Preferred initial fraction; if null, the group distributes space evenly.
  final double? defaultFraction;

  @override
  Widget build(BuildContext context) {
    // This widget acts mostly as a data holder; rendering is managed by the group.
    return child;
  }
}

/// Visual handle used inside the divider. Optional and purely decorative.
/// The actual drag behavior is handled by the group’s gesture detector.
class ResizableHandle extends StatelessWidget {
  const ResizableHandle({
    super.key,
    required this.axis,
    this.withHandle = true,
    this.knobSize = const Size(12, 16),
    this.borderRadius = const BorderRadius.all(Radius.circular(4)),
    this.borderColor,
    this.backgroundColor,
    this.iconColor,
  });

  final Axis axis;
  final bool withHandle;
  final Size knobSize;
  final BorderRadius borderRadius;
  final Color? borderColor;
  final Color? backgroundColor;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    if (!withHandle) return const SizedBox.shrink();

    final theme = Theme.of(context);
    final bg = backgroundColor ?? theme.colorScheme.surface;
    final border = borderColor ?? theme.dividerColor.withOpacity(0.9);
    final iconC = iconColor ?? theme.iconTheme.color;

    final knob = Container(
      width: knobSize.width,
      height: knobSize.height,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: borderRadius,
        border: Border.all(color: border),
      ),
      alignment: Alignment.center,
      child: RotatedBox(
        quarterTurns: axis == Axis.vertical ? 1 : 0,
        child: Icon(Icons.drag_indicator, size: 12, color: iconC),
      ),
    );

    return Material(
      type: MaterialType.transparency,
      child: Padding(padding: const EdgeInsets.all(2.0), child: knob),
    );
  }
}
