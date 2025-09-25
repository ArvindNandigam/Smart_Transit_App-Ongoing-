// lib/components/calendar.dart
import 'package:flutter/material.dart';
import 'package:smart_transit/theme/app_colors.dart';
import 'package:table_calendar/table_calendar.dart';

class AppCalendar extends StatefulWidget {
  final DateTime? initialDate;
  final Function(DateTime selectedDate) onDateSelected;

  const AppCalendar({
    super.key,
    this.initialDate,
    required this.onDateSelected,
  });

  @override
  State<AppCalendar> createState() => _AppCalendarState();
}

class _AppCalendarState extends State<AppCalendar> {
  late DateTime _focusedDay;
  late DateTime _selectedDay;

  @override
  void initState() {
    super.initState();
    _focusedDay = widget.initialDate ?? DateTime.now();
    _selectedDay = widget.initialDate ?? DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final defaultTextColor = isDarkMode
        ? AppColorsDark.foreground
        : AppColorsLight.foreground;
    final mutedTextColor = isDarkMode
        ? AppColorsDark.mutedForeground
        : AppColorsLight.mutedForeground;
    final primaryColor = isDarkMode
        ? AppColorsDark.primary
        : AppColorsLight.primary;
    final onPrimaryColor = isDarkMode
        ? AppColorsDark.primaryForeground
        : AppColorsLight.primaryForeground;
    final accentColor = isDarkMode
        ? AppColorsDark.accent
        : AppColorsLight.accent;
    final accentTextColor = isDarkMode
        ? AppColorsDark.accentForeground
        : AppColorsLight.accentForeground;

    return TableCalendar(
      firstDay: DateTime.utc(2010, 1, 1),
      lastDay: DateTime.utc(2040, 12, 31),
      focusedDay: _focusedDay,
      selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
      onDaySelected: (selectedDay, focusedDay) {
        setState(() {
          _selectedDay = selectedDay;
          _focusedDay = focusedDay;
        });
        widget.onDateSelected(selectedDay);
      },
      onPageChanged: (focusedDay) {
        _focusedDay = focusedDay;
      },
      // --- STYLING ---
      headerStyle: HeaderStyle(
        formatButtonVisible: false, // Hides the "2 weeks" button
        titleCentered: true,
        titleTextStyle: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 16,
          color: defaultTextColor,
        ),
        leftChevronIcon: Icon(
          Icons.chevron_left,
          color: defaultTextColor.withOpacity(0.6),
        ),
        rightChevronIcon: Icon(
          Icons.chevron_right,
          color: defaultTextColor.withOpacity(0.6),
        ),
      ),
      daysOfWeekStyle: DaysOfWeekStyle(
        weekdayStyle: TextStyle(color: mutedTextColor, fontSize: 13),
        weekendStyle: TextStyle(color: mutedTextColor, fontSize: 13),
      ),
      calendarStyle: CalendarStyle(
        // Default day
        defaultTextStyle: TextStyle(color: defaultTextColor),
        weekendTextStyle: TextStyle(color: defaultTextColor),
        // Day outside the current month
        outsideTextStyle: TextStyle(color: mutedTextColor.withOpacity(0.8)),
      ),
      calendarBuilders: CalendarBuilders(
        // --- Today's Date Marker ---
        todayBuilder: (context, day, focusedDay) {
          return Center(
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: accentColor,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  '${day.day}',
                  style: TextStyle(color: accentTextColor),
                ),
              ),
            ),
          );
        },
        // --- Selected Date Marker ---
        selectedBuilder: (context, day, focusedDay) {
          return Center(
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: primaryColor,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  '${day.day}',
                  style: TextStyle(color: onPrimaryColor),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
