import 'package:flutter/material.dart';
import 'package:lucide_flutter/lucide_flutter.dart';
import 'package:smart_transit/components/button.dart';
import 'package:smart_transit/components/card.dart';
import 'package:smart_transit/components/input.dart';

// --- Data Models (should be in their own files in a real app) ---
enum RouteType { fastest, comfortable, ac, electric, all }

class RouteOption {
  final String id;
  final String duration;
  final int transfers;
  final List<String> routes;
  final String fare;
  final RouteType type;
  final String walkTime;

  RouteOption({
    required this.id,
    required this.duration,
    required this.transfers,
    required this.routes,
    required this.fare,
    required this.type,
    required this.walkTime,
  });
}

// --- Main Widget ---
class RoutesScreen extends StatefulWidget {
  const RoutesScreen({super.key});

  @override
  State<RoutesScreen> createState() => _RoutesScreenState();
}

class _RoutesScreenState extends State<RoutesScreen> {
  final _sourceController = TextEditingController();
  final _destinationController = TextEditingController();
  RouteType _activeFilter = RouteType.all;
  bool _showResults = false;

  // Mock Data
  final List<RouteOption> _allRoutes = [
    RouteOption(
        id: '1',
        duration: '28 min',
        transfers: 1,
        routes: ['5C', 'M15'],
        fare: '\$2.75',
        type: RouteType.fastest,
        walkTime: '5 min'),
    RouteOption(
        id: '2',
        duration: '35 min',
        transfers: 0,
        routes: ['101'],
        fare: '\$2.75',
        type: RouteType.comfortable,
        walkTime: '3 min'),
    RouteOption(
        id: '3',
        duration: '32 min',
        transfers: 1,
        routes: ['B46', 'Q32'],
        fare: '\$3.25',
        type: RouteType.ac,
        walkTime: '7 min'),
    RouteOption(
        id: '4',
        duration: '40 min',
        transfers: 2,
        routes: ['E1', 'E7', 'E12'],
        fare: '\$2.50',
        type: RouteType.electric,
        walkTime: '4 min'),
  ];

  List<RouteOption> get _filteredRoutes {
    if (_activeFilter == RouteType.all) return _allRoutes;
    return _allRoutes.where((route) => route.type == _activeFilter).toList();
  }

  void _handleSearch() {
    if (_sourceController.text.isNotEmpty &&
        _destinationController.text.isNotEmpty) {
      setState(() => _showResults = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDarkMode ? const Color(0xFF0F172A) : Colors.grey[50],
      body: Column(
        children: [
          _RoutesHeader(
            sourceController: _sourceController,
            destinationController: _destinationController,
            onSearch: _handleSearch,
          ),
          Expanded(
            child: _showResults
                ? _ResultsView(
                    filteredRoutes: _filteredRoutes,
                    activeFilter: _activeFilter,
                    onFilterChanged: (newFilter) =>
                        setState(() => _activeFilter = newFilter),
                  )
                : const _EmptyState(),
          ),
        ],
      ),
    );
  }
}

// --- Smaller, Reusable Widgets ---

class _RoutesHeader extends StatelessWidget {
  final TextEditingController sourceController;
  final TextEditingController destinationController;
  final VoidCallback onSearch;

  const _RoutesHeader({
    required this.sourceController,
    required this.destinationController,
    required this.onSearch,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 48, 16, 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDarkMode
              ? [const Color(0xFF1E293B), const Color(0xFF111827)]
              : [const Color(0xFF003366), const Color(0xFF004080)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Plan Your Journey',
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(color: Colors.white)),
          const SizedBox(height: 16),
          // Using our custom AppInput component
          AppInput(controller: sourceController, hintText: 'Enter Source'),
          const SizedBox(height: 12),
          AppInput(
              controller: destinationController, hintText: 'Enter Destination'),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: AppButton(
              // Using our custom AppButton component
              onPressed: onSearch,
              icon: LucideIcons.search,
              label: 'Find Routes',
            ),
          ),
        ],
      ),
    );
  }
}

class _ResultsView extends StatelessWidget {
  final List<RouteOption> filteredRoutes;
  final RouteType activeFilter;
  final ValueChanged<RouteType> onFilterChanged;

  const _ResultsView(
      {required this.filteredRoutes,
      required this.activeFilter,
      required this.onFilterChanged});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _FilterChips(
            activeFilter: activeFilter, onFilterChanged: onFilterChanged),
        Expanded(
          child: filteredRoutes.isEmpty
              ? const Center(child: Text("No routes found for this filter."))
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: filteredRoutes.length,
                  itemBuilder: (context, index) =>
                      _RouteResultCard(route: filteredRoutes[index]),
                ),
        ),
      ],
    );
  }
}

class _FilterChips extends StatelessWidget {
  final RouteType activeFilter;
  final ValueChanged<RouteType> onFilterChanged;

  const _FilterChips(
      {required this.activeFilter, required this.onFilterChanged});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final filters = [
      {'id': RouteType.all, 'label': 'All Routes', 'icon': null},
      {'id': RouteType.fastest, 'label': 'Fastest', 'icon': LucideIcons.zap},
      {'id': RouteType.comfortable, 'label': 'Comfortable', 'icon': null},
      {'id': RouteType.ac, 'label': 'AC Only', 'icon': LucideIcons.snowflake},
      {'id': RouteType.electric, 'label': 'Electric', 'icon': LucideIcons.zap},
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.all(16),
      child: Row(
        children: filters.map((filter) {
          final type = filter['id'] as RouteType;
          final isActive = activeFilter == type;
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: FilterChip(
              label: Text(filter['label'] as String),
              avatar: filter['icon'] != null
                  ? Icon(filter['icon'] as IconData, size: 16)
                  : null,
              selected: isActive,
              onSelected: (_) => onFilterChanged(type),
              backgroundColor: isDarkMode ? Colors.grey[800] : Colors.grey[200],
              selectedColor: Colors.green.shade600,
              checkmarkColor: Colors.white,
              labelStyle: TextStyle(color: isActive ? Colors.white : null),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _RouteResultCard extends StatelessWidget {
  final RouteOption route;
  const _RouteResultCard({required this.route});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return AppCard(
      // Using our custom AppCard component
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(children: [
                  const Icon(LucideIcons.clock, size: 16),
                  const SizedBox(width: 8),
                  Text(route.duration,
                      style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(width: 8),
                  _getRouteTypeIcon(route.type),
                ]),
                Text(route.fare,
                    style: const TextStyle(
                        fontSize: 18,
                        color: Colors.green,
                        fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 12),
            Row(
                children: route.routes
                    .map((r) => Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Chip(
                            label: Text(r),
                            backgroundColor: isDarkMode
                                ? Colors.indigo.shade700
                                : const Color(0xFF003366),
                            labelStyle: const TextStyle(color: Colors.white),
                          ),
                        ))
                    .toList()),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                    route.transfers == 0
                        ? 'Direct'
                        : '${route.transfers} transfer(s)',
                    style: const TextStyle(color: Colors.grey)),
                Text('${route.walkTime} walk',
                    style: const TextStyle(color: Colors.grey)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _getRouteTypeIcon(RouteType type) {
    switch (type) {
      case RouteType.fastest:
        return const Icon(LucideIcons.zap, size: 16, color: Colors.amber);
      case RouteType.ac:
        return const Icon(LucideIcons.snowflake, size: 16, color: Colors.blue);
      case RouteType.electric:
        return const Icon(LucideIcons.zap, size: 16, color: Colors.green);
      default:
        return const SizedBox.shrink();
    }
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();
  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(LucideIcons.search,
              size: 64,
              color: isDarkMode ? Colors.grey[700] : Colors.grey[300]),
          const SizedBox(height: 16),
          Text('Plan Your Trip',
              style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 8),
          Text('Enter your source and destination to find routes.',
              style: TextStyle(color: Colors.grey[600]),
              textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
