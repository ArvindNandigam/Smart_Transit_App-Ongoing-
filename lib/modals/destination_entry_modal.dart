import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:lucide_flutter/lucide_flutter.dart';
import 'package:smart_transit/components/button.dart';
import 'package:smart_transit/components/card.dart';
import 'package:smart_transit/components/input.dart';
import 'package:smart_transit/models/app_models.dart'; // Correctly imports BusInfo

class DestinationEntryModal extends StatefulWidget {
  final BusInfo busInfo;
  final Function(String) onDestinationSelect;

  const DestinationEntryModal({
    super.key,
    required this.busInfo,
    required this.onDestinationSelect,
  });

  @override
  State<DestinationEntryModal> createState() => _DestinationEntryModalState();
}

class _DestinationEntryModalState extends State<DestinationEntryModal> {
  final _searchController = TextEditingController();
  String _selectedStop = '';

  // Mock data for route stops
  final List<String> _routeStops = [
    'Central Station',
    'Market Square',
    'University Campus',
    'Hospital Junction',
    'Shopping Mall',
    'Business District',
    'Airport Terminal',
    'Sports Complex',
  ];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<String> get _filteredStops {
    final query = _searchController.text.toLowerCase();
    final stops =
        _routeStops.where((s) => s != widget.busInfo.currentStop).toList();
    if (query.isEmpty) return stops;
    return stops.where((s) => s.toLowerCase().contains(query)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            constraints: const BoxConstraints(maxHeight: 600),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor.withOpacity(0.85),
              border:
                  Border(top: BorderSide(color: Colors.grey.withOpacity(0.2))),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _Header(
                    busInfo: widget.busInfo,
                    onClose: () => Navigator.of(context).pop()),
                const SizedBox(height: 16),
                _CurrentStopCard(busInfo: widget.busInfo),
                const SizedBox(height: 16),
                AppInput(
                    controller: _searchController,
                    hintText: 'Search destination stops...'),
                const SizedBox(height: 16),
                Expanded(
                    child: _StopsList(
                  stops: _filteredStops,
                  selectedStop: _selectedStop,
                  onStopSelected: (stop) {
                    setState(() {
                      _selectedStop = stop;
                      _searchController.text = stop;
                      FocusScope.of(context).unfocus(); // Hide keyboard
                    });
                  },
                )),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: AppButton(
                    onPressed: _selectedStop.isNotEmpty
                        ? () => widget.onDestinationSelect(_selectedStop)
                        : null,
                    label: 'Calculate Fare',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// --- Smaller, Self-Contained Widgets ---

class _Header extends StatelessWidget {
  final BusInfo busInfo;
  final VoidCallback onClose;
  const _Header({required this.busInfo, required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("You've boarded Bus No. ${busInfo.number}",
                  style: Theme.of(context).textTheme.titleLarge),
              const Text('Please enter your destination stop',
                  style: TextStyle(color: Colors.grey)),
            ],
          ),
        ),
        IconButton(onPressed: onClose, icon: const Icon(LucideIcons.x)),
      ],
    );
  }
}

class _CurrentStopCard extends StatelessWidget {
  final BusInfo busInfo;
  const _CurrentStopCard({required this.busInfo});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            const Icon(LucideIcons.mapPin, color: Colors.green),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Current Stop',
                    style: TextStyle(color: Colors.grey)),
                Text(busInfo.currentStop,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StopsList extends StatelessWidget {
  final List<String> stops;
  final String selectedStop;
  final ValueChanged<String> onStopSelected;

  const _StopsList(
      {required this.stops,
      required this.selectedStop,
      required this.onStopSelected});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: stops.length,
      itemBuilder: (context, index) {
        final stop = stops[index];
        final isSelected = selectedStop == stop;
        return ListTile(
          leading: const Icon(LucideIcons.mapPin),
          title: Text(stop),
          selected: isSelected,
          selectedTileColor: Theme.of(context).primaryColor.withOpacity(0.1),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          onTap: () => onStopSelected(stop),
        );
      },
    );
  }
}
