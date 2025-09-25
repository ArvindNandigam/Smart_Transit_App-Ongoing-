import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:lucide_flutter/lucide_flutter.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:smart_transit/components/button.dart';
import 'package:smart_transit/components/card.dart';
import 'package:smart_transit/models/app_models.dart'; // Import the new models file

class DigitalTicketScreen extends StatelessWidget {
  final TripDetails tripDetails;
  final VoidCallback onClose;

  const DigitalTicketScreen({
    super.key,
    required this.tripDetails,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.5),
      body: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
        child: Center(
          child: AppCard(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _Header(onClose: onClose),
                    const SizedBox(height: 24),
                    _TicketCard(tripDetails: tripDetails),
                    const SizedBox(height: 24),
                    _ActionButtons(tripDetails: tripDetails),
                    const SizedBox(height: 12),
                    AppButton(
                      label: 'Done',
                      onPressed: onClose,
                      variant: ButtonVariant.secondary,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'This ticket has been automatically saved to your "Previous Tickets"',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// --- Smaller, Self-Contained Widgets ---

class _Header extends StatelessWidget {
  final VoidCallback onClose;
  const _Header({required this.onClose});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isDarkMode
                ? Colors.green.withOpacity(0.3)
                : Colors.green.shade100,
          ),
          child: Icon(LucideIcons.circleCheck, color: Colors.green.shade600),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Ticket Confirmed',
                style: Theme.of(context).textTheme.titleLarge),
            Text('Payment successful',
                style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
        const Spacer(),
        IconButton(
          onPressed: onClose,
          icon: const Icon(LucideIcons.x),
          style: IconButton.styleFrom(
            backgroundColor: isDarkMode ? Colors.grey[800] : Colors.grey[200],
          ),
        ),
      ],
    );
  }
}

class _TicketCard extends StatelessWidget {
  final TripDetails tripDetails;
  const _TicketCard({required this.tripDetails});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return AppCard(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
              gradient: LinearGradient(
                colors: isDarkMode
                    ? [Colors.indigo.shade800, Colors.blue.shade800]
                    : [const Color(0xFF003366), const Color(0xFF004080)],
              ),
            ),
            child: const Center(
              child: Text('Digital Bus Ticket',
                  style: TextStyle(color: Colors.white, fontSize: 18)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                // --- REAL QR CODE ---
                QrImageView(
                  data: tripDetails.ticketId,
                  version: QrVersions.auto,
                  size: 120.0,
                  backgroundColor: Colors.white,
                ),
                const SizedBox(height: 16),
                Chip(label: Text('Ticket ID: ${tripDetails.ticketId}')),
                const SizedBox(height: 24),
                _ticketDetailsRow('Passenger Name', tripDetails.userName,
                    'Bus Route', tripDetails.busNumber),
                const SizedBox(height: 16),
                _ticketDetailsRow('From', tripDetails.startStop, 'To',
                    tripDetails.destinationStop),
                const SizedBox(height: 16),
                _fareDetailsRow(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _ticketDetailsRow(
      String label1, String value1, String label2, String value2) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(child: _detailItem(label1, value1)),
        Expanded(
            child: _detailItem(label2, value2, align: CrossAxisAlignment.end)),
      ],
    );
  }

  Widget _fareDetailsRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
            child: _detailItem(
                'Fare Paid', '\$${tripDetails.fare.toStringAsFixed(2)}',
                valueColor: Colors.green)),
        Expanded(
            child: _detailItem('Date & Time',
                DateFormat('MMM d, h:mm a').format(tripDetails.purchaseTime),
                align: CrossAxisAlignment.end)),
      ],
    );
  }

  Widget _detailItem(String label, String value,
      {CrossAxisAlignment align = CrossAxisAlignment.start,
      Color? valueColor}) {
    return Column(
      crossAxisAlignment: align,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        Text(value,
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.w500, color: valueColor)),
      ],
    );
  }
}

class _ActionButtons extends StatelessWidget {
  final TripDetails tripDetails;
  const _ActionButtons({required this.tripDetails});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: AppButton(
            onPressed: () => print('Sharing ticket: ${tripDetails.ticketId}'),
            icon: LucideIcons.share2,
            label: 'Share',
            variant: ButtonVariant.outline,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: AppButton(
            onPressed: () =>
                print('Downloading ticket: ${tripDetails.ticketId}'),
            icon: LucideIcons.download,
            label: 'Download',
            variant: ButtonVariant.outline,
          ),
        ),
      ],
    );
  }
}
