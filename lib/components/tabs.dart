import 'package:flutter/material.dart';

class AppTabs extends StatefulWidget {
  final List<Tab> tabs;
  final List<Widget>? tabViews;
  final TabController? controller;
  final bool isTabBarOnly;
  final ValueChanged<int>? onTap;

  const AppTabs({
    super.key,
    required this.tabs,
    this.tabViews,
    this.controller,
    this.isTabBarOnly = false,
    this.onTap,
  }) : assert(isTabBarOnly || tabViews != null,
            'tabViews must be provided if isTabBarOnly is false');

  @override
  State<AppTabs> createState() => _AppTabsState();
}

class _AppTabsState extends State<AppTabs> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    // Use the provided controller or create a new one.
    _tabController = widget.controller ??
        TabController(length: widget.tabs.length, vsync: this);

    // Add a listener to call the onTap callback.
    if (widget.onTap != null) {
      _tabController.addListener(() {
        if (!_tabController.indexIsChanging) {
          widget.onTap!(_tabController.index);
        }
      });
    }
  }

  @override
  void didUpdateWidget(covariant AppTabs oldWidget) {
    super.didUpdateWidget(oldWidget);
    // If the controller provided by the parent changes, update our internal controller.
    if (widget.controller != null && widget.controller != _tabController) {
      _tabController = widget.controller!;
    }
  }

  @override
  void dispose() {
    // Only dispose the controller if it was created internally by this widget.
    if (widget.controller == null) {
      _tabController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final tabBar = TabBar(
      controller: _tabController,
      tabs: widget.tabs,
      isScrollable: true,
      tabAlignment: TabAlignment.center,
      indicator: _CustomTabIndicator(
        color: isDarkMode ? Theme.of(context).cardColor : Colors.white,
      ),
      labelColor: Theme.of(context).colorScheme.onSurface,
      unselectedLabelColor: Theme.of(context).hintColor,
      splashFactory: NoSplash.splashFactory,
      overlayColor: WidgetStateProperty.all(Colors.transparent),
    );

    // If it's just the bar, return it directly.
    if (widget.isTabBarOnly) {
      return tabBar;
    }

    // Otherwise, build the full tab layout.
    return Column(
      children: [
        Container(
          height: 40,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200,
            borderRadius: BorderRadius.circular(12),
          ),
          child: tabBar,
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: widget.tabViews!,
          ),
        ),
      ],
    );
  }
}

class _CustomTabIndicator extends Decoration {
  final Color color;
  const _CustomTabIndicator({required this.color});

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _CustomPainter(this, onChanged, color: color);
  }
}

class _CustomPainter extends BoxPainter {
  final _CustomTabIndicator decoration;
  final Color color;

  _CustomPainter(this.decoration, VoidCallback? onChanged,
      {required this.color})
      : super(onChanged);

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    final Rect baseRect = offset & configuration.size!;
    final Rect rect = baseRect.deflate(4.0); // Inset by 4 pixels on all sides
    final Paint paint = Paint();
    paint.color = color;
    paint.style = PaintingStyle.fill;
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(8.0)),
      paint,
    );
  }
}
