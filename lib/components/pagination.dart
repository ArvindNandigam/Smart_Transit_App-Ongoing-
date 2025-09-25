// lib/components/pagination.dart
import 'package:flutter/material.dart';
import 'package:smart_transit/components/button.dart';

class AppPagination extends StatefulWidget {
  final int totalPages;
  final int initialPage;
  final ValueChanged<int> onPageChanged;

  const AppPagination({
    super.key,
    required this.totalPages,
    this.initialPage = 1,
    required this.onPageChanged,
  });

  @override
  State<AppPagination> createState() => _AppPaginationState();
}

class _AppPaginationState extends State<AppPagination> {
  late int _currentPage;

  @override
  void initState() {
    super.initState();
    _currentPage = widget.initialPage;
  }

  // Update current page if the parent widget changes it
  @override
  void didUpdateWidget(covariant AppPagination oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialPage != oldWidget.initialPage) {
      _currentPage = widget.initialPage;
    }
  }

  void _onPageSelected(int page) {
    if (page >= 1 && page <= widget.totalPages) {
      setState(() {
        _currentPage = page;
      });
      widget.onPageChanged(page);
    }
  }

  // --- The core logic to build the page number items ---
  List<Widget> _buildPageItems() {
    final List<Widget> items = [];
    const int pageWindow = 1; // How many pages to show around the current one

    // If there are only a few pages, show all of them
    if (widget.totalPages <= 5) {
      for (int i = 1; i <= widget.totalPages; i++) {
        items.add(_buildPageButton(i));
      }
      return items;
    }

    // --- Logic for many pages with ellipses ---
    // Add first page
    items.add(_buildPageButton(1));

    // Add left ellipsis if needed
    if (_currentPage > pageWindow + 2) {
      items.add(_buildEllipsis());
    }

    // Add pages around the current page
    for (
      int i = _currentPage - pageWindow;
      i <= _currentPage + pageWindow;
      i++
    ) {
      if (i > 1 && i < widget.totalPages) {
        items.add(_buildPageButton(i));
      }
    }

    // Add right ellipsis if needed
    if (_currentPage < widget.totalPages - pageWindow - 1) {
      items.add(_buildEllipsis());
    }

    // Add last page
    if (widget.totalPages > 1) {
      items.add(_buildPageButton(widget.totalPages));
    }

    return items;
  }

  Widget _buildPageButton(int pageNumber) {
    bool isActive = _currentPage == pageNumber;
    return AppButton(
      onPressed: () => _onPageSelected(pageNumber),
      label: '$pageNumber',
      size: ButtonSize.icon,
      variant: isActive ? ButtonVariant.outline : ButtonVariant.ghost,
    );
  }

  Widget _buildEllipsis() {
    return const SizedBox(width: 36, height: 36, child: Icon(Icons.more_horiz));
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // --- Previous Button ---
        AppButton(
          onPressed: _currentPage > 1
              ? () => _onPageSelected(_currentPage - 1)
              : null,
          icon: Icons.chevron_left,
          label: 'Previous',
          variant: ButtonVariant.ghost,
        ),
        const SizedBox(width: 8),

        // --- Page Number Buttons ---
        ..._buildPageItems(),

        const SizedBox(width: 8),
        // --- Next Button ---
        AppButton(
          onPressed: _currentPage < widget.totalPages
              ? () => _onPageSelected(_currentPage + 1)
              : null,
          icon: Icons.chevron_right,
          label: 'Next',
          variant: ButtonVariant.ghost,
        ),
      ],
    );
  }
}
