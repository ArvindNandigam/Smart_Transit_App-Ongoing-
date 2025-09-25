import 'package:flutter/material.dart';
import 'package:lucide_flutter/lucide_flutter.dart';
import 'package:smart_transit/components/button.dart';
import 'package:smart_transit/components/card.dart';
import 'package:smart_transit/components/tabs.dart';

// --- Data Models (No changes needed) ---
enum TransactionType { debit, credit }

class Transaction {
  final String id;
  final TransactionType type;
  final String amount;
  final String? route;
  final String date;
  final String time;
  final String description;

  Transaction({
    required this.id,
    required this.type,
    required this.amount,
    this.route,
    required this.date,
    required this.time,
    required this.description,
  });
}

// --- Main Screen Widget ---
class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  // Mock data - in a real app, this would come from a state manager or API
  final String _balance = '\$24.75';
  bool _showQR = false;

  final List<Transaction> _transactions = [
    Transaction(
        id: '1',
        type: TransactionType.debit,
        amount: '\$2.75',
        route: '5C',
        date: 'Today',
        time: '2:45 PM',
        description: 'Broadway & 42nd St → Union Square'),
    Transaction(
        id: '2',
        type: TransactionType.debit,
        amount: '\$2.75',
        route: '101',
        date: 'Today',
        time: '9:30 AM',
        description: 'Times Square → Central Park'),
    Transaction(
        id: '3',
        type: TransactionType.credit,
        amount: '\$25.00',
        date: 'Yesterday',
        time: '6:20 PM',
        description: 'Wallet Top-up'),
    Transaction(
        id: '4',
        type: TransactionType.debit,
        amount: '\$3.25',
        route: 'B46',
        date: 'Yesterday',
        time: '4:15 PM',
        description: 'Brooklyn Bridge → Atlantic Terminal'),
    Transaction(
        id: '5',
        type: TransactionType.debit,
        amount: '\$2.75',
        route: 'M15',
        date: 'Sep 10',
        time: '11:00 AM',
        description: '14th St & 3rd Ave → Houston St'),
  ];

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? const Color(0xFF0F172A) : Colors.grey[50],
      body: Column(
        children: [
          _WalletHeader(
            balance: _balance,
            onToggleQR: () => setState(() => _showQR = !_showQR),
          ),
          if (_showQR) _QrCodeDisplay(),
          _TransactionsHeader(),
          Expanded(child: _TransactionList(transactions: _transactions)),
          _QuickActions(),
        ],
      ),
    );
  }
}

// --- Smaller, Reusable Widgets ---

class _WalletHeader extends StatelessWidget {
  final String balance;
  final VoidCallback onToggleQR;

  const _WalletHeader({required this.balance, required this.onToggleQR});

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
          Text(
            'My Wallet',
            style: Theme.of(context)
                .textTheme
                .headlineSmall
                ?.copyWith(color: Colors.white),
          ),
          const SizedBox(height: 24),
          _BalanceCard(balance: balance),
          const SizedBox(height: 24),
          _HeaderActions(onToggleQR: onToggleQR),
        ],
      ),
    );
  }
}

class _BalanceCard extends StatelessWidget {
  final String balance;
  const _BalanceCard({required this.balance});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: const LinearGradient(
              colors: [Color(0xFF28A745), Color(0xFF20C997)]),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Current Balance',
                    style: TextStyle(color: Colors.white70)),
                Text(
                  balance,
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const Icon(LucideIcons.creditCard, color: Colors.white70, size: 32),
          ],
        ),
      ),
    );
  }
}

class _HeaderActions extends StatelessWidget {
  final VoidCallback onToggleQR;
  const _HeaderActions({required this.onToggleQR});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: AppButton(
            onPressed: () {},
            icon: LucideIcons.plus,
            label: 'Add Money',
            variant:
                ButtonVariant.secondary, // Uses our theme's secondary style
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: AppButton(
            onPressed: onToggleQR,
            icon: LucideIcons.qrCode,
            label: 'QR Code',
            variant: ButtonVariant.outline, // Uses our theme's outline style
          ),
        ),
      ],
    );
  }
}

class _QrCodeDisplay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(24),
      color: isDarkMode ? Colors.black26 : Colors.grey[200],
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            // In a real app, you would use a QR code generator package here
            child:
                const Icon(LucideIcons.qrCode, size: 80, color: Colors.black),
          ),
          const SizedBox(height: 12),
          const Text(
            'Show this QR code to the bus driver',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

class _TransactionsHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 8, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Recent Transactions',
              style: Theme.of(context).textTheme.titleLarge),
          TextButton.icon(
            onPressed: () {},
            icon: const Icon(LucideIcons.history, size: 16),
            label: const Text('View All'),
            style: TextButton.styleFrom(foregroundColor: Colors.green),
          ),
        ],
      ),
    );
  }
}

class _TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  const _TransactionList({required this.transactions});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: transactions.length,
      itemBuilder: (context, index) {
        final tx = transactions[index];
        final isDebit = tx.type == TransactionType.debit;
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: isDebit
                ? (isDarkMode
                    ? Colors.red.withOpacity(0.2)
                    : Colors.red.shade100)
                : (isDarkMode
                    ? Colors.green.withOpacity(0.2)
                    : Colors.green.shade100),
            child: Icon(
              isDebit ? LucideIcons.arrowUpRight : LucideIcons.arrowDownLeft,
              color: isDebit ? Colors.red.shade400 : Colors.green.shade400,
              size: 20,
            ),
          ),
          title: Text(tx.description),
          subtitle: Text('${tx.date} • ${tx.time}'),
          trailing: Text(
            '${isDebit ? '-' : '+'}${tx.amount}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isDebit ? Colors.red.shade400 : Colors.green.shade400,
              fontSize: 16,
            ),
          ),
        );
      },
    );
  }
}

class _QuickActions extends StatefulWidget {
  const _QuickActions();
  @override
  State<_QuickActions> createState() => _QuickActionsState();
}

class _QuickActionsState extends State<_QuickActions>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          border: Border(
              top: BorderSide(
                  color: Theme.of(context).dividerColor.withOpacity(0.5))),
        ),
        child: AppTabs(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Auto Top-up'),
            Tab(text: 'Payment History'),
            Tab(text: 'Help & Support'),
          ],
          // The `tabViews` property is removed because it's not needed when `isTabBarOnly` is true.
          isTabBarOnly: true,
        ),
      ),
    );
  }
}
