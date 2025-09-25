import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const BusApp());
}

class BusApp extends StatelessWidget {
  const BusApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Bus> _buses = [];
  Bus? _selectedBus;

  @override
  void initState() {
    super.initState();
    _fetchBusData();
  }

  Future<void> _fetchBusData() async {
    final response = await http.get(
      Uri.parse('https://mocki.io/v1/64f74e0c-5c60-4f73-8b2a-bb4d08c32ad0'),
    );
    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      setState(() {
        _buses = data.map<Bus>((json) => Bus.fromJson(json)).toList();
      });
    }
  }

  void _handleScanQR() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Scan QR pressed")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _FlutterBusMapAndMarkers(
            buses: _buses,
            onBusSelected: (bus) => setState(() => _selectedBus = bus),
          ),
          const _OccupancyLegendOverlay(),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: _selectedBus != null
                ? _BusDetailsSheet(
                    bus: _selectedBus!,
                    onClose: () => setState(() => _selectedBus = null),
                  )
                : const SizedBox.shrink(),
          ),
          _ActionButtonsOverlay(onScanQR: _handleScanQR),
        ],
      ),
    );
  }
}

class Bus {
  final String id;
  final double lat;
  final double lng;
  final String occupancy;

  Bus({
    required this.id,
    required this.lat,
    required this.lng,
    required this.occupancy,
  });

  factory Bus.fromJson(Map<String, dynamic> json) {
    return Bus(
      id: json['id'],
      lat: json['lat'],
      lng: json['lng'],
      occupancy: json['occupancy'],
    );
  }
}

class _FlutterBusMapAndMarkers extends StatelessWidget {
  final List<Bus> buses;
  final ValueChanged<Bus> onBusSelected;

  const _FlutterBusMapAndMarkers({
    required this.buses,
    required this.onBusSelected,
  });

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      options: const MapOptions(
        initialCenter: LatLng(13.0827, 80.2707), // Chennai center
        initialZoom: 12,
      ),
      children: [
        TileLayer(
          urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
          userAgentPackageName: 'com.example.app',
        ),
        MarkerLayer(
          markers: buses
              .map(
                (bus) => Marker(
                  point: LatLng(bus.lat, bus.lng),
                  width: 40,
                  height: 40,
                  child: GestureDetector(
                    // ✅ fixed here
                    onTap: () => onBusSelected(bus),
                    child: const Icon(
                      Icons.directions_bus,
                      color: Colors.blue,
                      size: 30,
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}

class _OccupancyLegendOverlay extends StatelessWidget {
  const _OccupancyLegendOverlay();

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 40,
      right: 16,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: const [
              Text("🟢 Low occupancy"),
              Text("🟡 Medium occupancy"),
              Text("🔴 High occupancy"),
            ],
          ),
        ),
      ),
    );
  }
}

class _BusDetailsSheet extends StatelessWidget {
  final Bus bus;
  final VoidCallback onClose;

  const _BusDetailsSheet({required this.bus, required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Material(
        elevation: 20,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        child: Container(
          padding: const EdgeInsets.all(16),
          height: 140,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Bus ${bus.id}",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(onPressed: onClose, icon: const Icon(Icons.close)),
                ],
              ),
              Text("Occupancy: ${bus.occupancy}"),
              Text("Location: (${bus.lat}, ${bus.lng})"),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionButtonsOverlay extends StatelessWidget {
  final VoidCallback onScanQR;
  const _ActionButtonsOverlay({required this.onScanQR});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 160, // keeps it above the sheet
      left: 0,
      right: 0,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.navigation),
                label: const Text('Change start point'),
              ),
              const SizedBox(width: 16),
              ElevatedButton.icon(
                onPressed: onScanQR,
                icon: const Icon(Icons.qr_code),
                label: const Text('Scan QR'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
