import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:lucide_flutter/lucide_flutter.dart';
import 'package:smart_transit/components/button.dart';
import 'package:smart_transit/components/card.dart';
import 'package:smart_transit/screens/digital_ticket_screen.dart';
import 'package:smart_transit/models/app_models.dart'; // Import the new models file

// --- Main Screen Widget ---
class FareConfirmationScreen extends StatefulWidget {
  final TripDetails tripDetails;

  const FareConfirmationScreen({
    super.key,
    required this.tripDetails,
  });

  @override
  State<FareConfirmationScreen> createState() => _FareConfirmationScreenState();
}

class _FareConfirmationScreenState extends State<FareConfirmationScreen> {
  PaymentMethod _selectedPaymentMethod = PaymentMethod.wallet;
  final double _walletBalance = 24.75; // Mock wallet balance

  void _confirmPayment() {
    print('Payment Confirmed!');
    Navigator.of(context).pop(); // Close this fare screen

    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        pageBuilder: (context, _, __) {
          return DigitalTicketScreen(
            tripDetails: widget.tripDetails,
            onClose: () => Navigator.of(context).pop(),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final canPay = _selectedPaymentMethod == PaymentMethod.wallet
        ? _walletBalance >= widget.tripDetails.fare
        : true;

    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.5),
      body: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
        child: Center(
          child: AppCard(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _Header(onBack: () => Navigator.of(context).pop()),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      children: [
                        _TripSummaryCard(tripDetails: widget.tripDetails),
                        const SizedBox(height: 20),
                        _FareDisplayCard(fare: widget.tripDetails.fare),
                        const SizedBox(height: 20),
                        _PaymentMethods(
                          selectedMethod: _selectedPaymentMethod,
                          walletBalance: _walletBalance,
                          tripFare: widget.tripDetails.fare,
                          onMethodChanged: (method) {
                            if (method != null) {
                              setState(() => _selectedPaymentMethod = method);
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  _ConfirmButton(
                    canPay: canPay,
                    fare: widget.tripDetails.fare,
                    onConfirm: _confirmPayment,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// --- Smaller, Self-Contained Widgets (No changes below) ---

class _Header extends StatelessWidget {
  final VoidCallback onBack;
  const _Header({required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 16, 16, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
              onPressed: onBack, icon: const Icon(LucideIcons.arrowLeft)),
          Text('Confirm & Pay', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(width: 48),
        ],
      ),
    );
  }
}

class _TripSummaryCard extends StatelessWidget {
  final TripDetails tripDetails;
  const _TripSummaryCard({required this.tripDetails});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Trip Summary',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 16),
            _summaryRow('Start', tripDetails.startStop, LucideIcons.mapPin,
                Colors.green),
            const SizedBox(height: 12),
            _summaryRow('Destination', tripDetails.destinationStop,
                LucideIcons.mapPin, Colors.red),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Bus No.', style: TextStyle(color: Colors.grey)),
                Chip(
                  label: Text(tripDetails.busNumber,
                      style: const TextStyle(color: Colors.white)),
                  backgroundColor: const Color(0xFF003366),
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _summaryRow(
      String label, String value, IconData icon, Color iconColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey)),
        Row(children: [
          Icon(icon, color: iconColor, size: 16),
          const SizedBox(width: 8),
          Text(value),
        ]),
      ],
    );
  }
}

class _FareDisplayCard extends StatelessWidget {
  final double fare;
  const _FareDisplayCard({required this.fare});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return AppCard(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: isDarkMode
                ? [
                    Colors.green.shade900.withOpacity(0.4),
                    Colors.green.shade800.withOpacity(0.6)
                  ]
                : [Colors.green.shade50, Colors.green.shade100],
          ),
          border: Border.all(
            color: isDarkMode
                ? Colors.green.shade700.withOpacity(0.5)
                : Colors.green.shade200,
          ),
        ),
        child: Column(
          children: [
            const Text('Total Fare', style: TextStyle(color: Colors.green)),
            Text(
              '\$${fare.toStringAsFixed(2)}',
              style: Theme.of(context)
                  .textTheme
                  .displaySmall
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

class _PaymentMethods extends StatelessWidget {
  final PaymentMethod selectedMethod;
  final double walletBalance;
  final double tripFare;
  final ValueChanged<PaymentMethod?> onMethodChanged;

  const _PaymentMethods({
    required this.selectedMethod,
    required this.walletBalance,
    required this.tripFare,
    required this.onMethodChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isWalletInsufficient = walletBalance < tripFare;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Payment Method', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 12),
        RadioListTile<PaymentMethod>(
          title: Text('Wallet Balance',
              style:
                  TextStyle(color: isWalletInsufficient ? Colors.red : null)),
          subtitle: Text(
            isWalletInsufficient
                ? 'Insufficient balance'
                : '\$${walletBalance.toStringAsFixed(2)} available',
            style: TextStyle(
                fontSize: 12,
                color:
                    isWalletInsufficient ? Colors.red.shade400 : Colors.grey),
          ),
          value: PaymentMethod.wallet,
          groupValue: selectedMethod,
          onChanged: isWalletInsufficient ? null : onMethodChanged,
          secondary: Icon(LucideIcons.wallet,
              color: isWalletInsufficient ? Colors.red : null),
        ),
        RadioListTile<PaymentMethod>(
          title: const Text('Other Payment Methods'),
          subtitle: const Text('UPI, Cards, Net Banking'),
          value: PaymentMethod.other,
          groupValue: selectedMethod,
          onChanged: onMethodChanged,
          secondary: const Icon(LucideIcons.creditCard),
        ),
      ],
    );
  }
}

class _ConfirmButton extends StatelessWidget {
  final bool canPay;
  final double fare;
  final VoidCallback onConfirm;

  const _ConfirmButton(
      {required this.canPay, required this.fare, required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SizedBox(
        width: double.infinity,
        child: AppButton(
          onPressed: canPay ? onConfirm : null,
          label: 'Confirm & Pay \$${fare.toStringAsFixed(2)}',
        ),
      ),
    );
  }
}
