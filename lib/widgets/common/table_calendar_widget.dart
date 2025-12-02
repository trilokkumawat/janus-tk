import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:janus/core/extensions/state_extensions.dart';
import 'package:janus/core/theme/app_theme.dart';
import 'package:janus/core/constants/app_text_style.dart';
import 'package:intl/intl.dart';

class TableCalendarWidget extends StatefulWidget {
  final Function(DateTime)? onDaySelected;
  final Function(DateTime, DateTime)? onRangeSelected;
  final Map<DateTime, List<dynamic>>? events;
  final bool rangeSelectionEnabled;
  final DateTime? initialSelectedDate;
  final RangeSelection? initialRange;
  final Widget Function(DateTime date, List<dynamic> events)?
  eventMarkerBuilder;
  final Widget Function(
    DateTime date,
    bool isSelected,
    bool isToday,
    bool isSameMonth,
  )?
  dayBuilder;
  final CalendarFormat initialCalendarFormat;
  final bool showTodayButton;
  final bool showFormatToggle;

  const TableCalendarWidget({
    super.key,
    this.onDaySelected,
    this.onRangeSelected,
    this.events,
    this.rangeSelectionEnabled = false,
    this.initialSelectedDate,
    this.initialRange,
    this.eventMarkerBuilder,
    this.dayBuilder,
    this.initialCalendarFormat = CalendarFormat.month,
    this.showTodayButton = true,
    this.showFormatToggle = true,
  });

  @override
  State<TableCalendarWidget> createState() => _TableCalendarWidgetState();
}

class _TableCalendarWidgetState extends State<TableCalendarWidget>
    with SafeStateMixin {
  late DateTime _focusedDay;
  late DateTime _selectedDay;
  RangeSelection? _selectedRange;
  CalendarFormat _calendarFormat = CalendarFormat.month;

  @override
  void initState() {
    super.initState();
    _focusedDay = widget.initialSelectedDate ?? DateTime.now();
    _selectedDay = widget.initialSelectedDate ?? DateTime.now();
    _selectedRange = widget.initialRange;
    _calendarFormat = widget.initialCalendarFormat;
  }

  List<dynamic> _getEventsForDay(DateTime day) {
    final normalizedDate = DateTime(day.year, day.month, day.day);
    return widget.events?[normalizedDate] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? AppColors.darkCard : AppColors.lightCard;
    final textColor = isDark ? AppColors.lightText : AppColors.darkText;
    final secondaryTextColor = AppColors.secondaryText;

    return Card(
      color: cardColor,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(context, textColor, secondaryTextColor),
            const SizedBox(height: 16),
            TableCalendar<dynamic>(
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) {
                if (widget.rangeSelectionEnabled) return false;
                return isSameDay(_selectedDay, day);
              },
              rangeStartDay:
                  widget.rangeSelectionEnabled && _selectedRange?.start != null
                  ? _selectedRange!.start!
                  : null,
              rangeEndDay:
                  widget.rangeSelectionEnabled && _selectedRange?.end != null
                  ? _selectedRange!.end!
                  : null,
              rangeSelectionMode: widget.rangeSelectionEnabled
                  ? RangeSelectionMode.enforced
                  : RangeSelectionMode.disabled,
              calendarFormat: _calendarFormat,
              eventLoader: _getEventsForDay,
              startingDayOfWeek: StartingDayOfWeek.monday,
              calendarStyle: CalendarStyle(
                todayDecoration: BoxDecoration(
                  color: AppColors.purple.withOpacity(0.3),
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.purple, width: 2),
                ),
                todayTextStyle: AppTextStyle.bodyMedium.copyWith(
                  color: AppColors.purple,
                  fontWeight: FontWeight.bold,
                ),
                selectedDecoration: BoxDecoration(
                  color: AppColors.purple,
                  shape: BoxShape.circle,
                ),
                selectedTextStyle: AppTextStyle.bodyMedium.copyWith(
                  color: AppColors.lightText,
                  fontWeight: FontWeight.bold,
                ),
                rangeStartDecoration: BoxDecoration(
                  color: AppColors.purple,
                  shape: BoxShape.circle,
                ),
                rangeEndDecoration: BoxDecoration(
                  color: AppColors.purple,
                  shape: BoxShape.circle,
                ),
                defaultTextStyle: AppTextStyle.bodyMedium.copyWith(
                  color: textColor,
                ),
                weekendTextStyle: AppTextStyle.bodyMedium.copyWith(
                  color: textColor,
                ),
                outsideDaysVisible: false,
                outsideTextStyle: AppTextStyle.bodySmall.copyWith(
                  color: secondaryTextColor.withOpacity(0.5),
                ),
                outsideDecoration: BoxDecoration(shape: BoxShape.circle),
                weekendDecoration: BoxDecoration(shape: BoxShape.circle),
                defaultDecoration: BoxDecoration(shape: BoxShape.circle),
                markerDecoration: BoxDecoration(
                  color: AppColors.coral,
                  shape: BoxShape.circle,
                ),
                markerSize: 6,
                markersMaxCount: 3,
                markerMargin: const EdgeInsets.symmetric(horizontal: 0.5),
              ),
              headerStyle: HeaderStyle(
                formatButtonVisible: widget.showFormatToggle,
                formatButtonShowsNext: false,
                formatButtonDecoration: BoxDecoration(
                  color: AppColors.purple.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.purple.withOpacity(0.3)),
                ),
                formatButtonTextStyle: AppTextStyle.bodySmall.copyWith(
                  color: AppColors.purple,
                  fontWeight: FontWeight.w600,
                ),
                leftChevronIcon: Icon(
                  Icons.chevron_left,
                  color: AppColors.purple,
                ),
                rightChevronIcon: Icon(
                  Icons.chevron_right,
                  color: AppColors.purple,
                ),
                titleTextStyle: AppTextStyle.h5.copyWith(
                  color: textColor,
                  fontWeight: FontWeight.bold,
                ),
                titleCentered: true,
              ),
              daysOfWeekStyle: DaysOfWeekStyle(
                weekdayStyle: AppTextStyle.bodySmall.copyWith(
                  color: secondaryTextColor,
                  fontWeight: FontWeight.w600,
                ),
                weekendStyle: AppTextStyle.bodySmall.copyWith(
                  color: secondaryTextColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
              onDaySelected: (selectedDay, focusedDay) {
                if (!isSameDay(_selectedDay, selectedDay)) {
                  safeSetState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                  widget.onDaySelected?.call(selectedDay);
                }
              },
              onRangeSelected: widget.rangeSelectionEnabled
                  ? (start, end, focusedDay) {
                      safeSetState(() {
                        _selectedRange = RangeSelection(start: start, end: end);
                        _focusedDay = focusedDay;
                      });
                      if (start != null && end != null) {
                        widget.onRangeSelected?.call(start, end);
                      }
                    }
                  : null,
              onFormatChanged: (format) {
                safeSetState(() {
                  _calendarFormat = format;
                });
              },
              onPageChanged: (focusedDay) {
                safeSetState(() {
                  _focusedDay = focusedDay;
                });
              },
              calendarBuilders: widget.dayBuilder != null
                  ? CalendarBuilders(
                      defaultBuilder: (context, date, focusedDay) {
                        final isSelected = isSameDay(_selectedDay, date);
                        final isToday = isSameDay(DateTime.now(), date);
                        final isSameMonth = date.month == _focusedDay.month;
                        return widget.dayBuilder!(
                          date,
                          isSelected,
                          isToday,
                          isSameMonth,
                        );
                      },
                    )
                  : const CalendarBuilders(),
            ),
            if (widget.events != null && widget.events!.isNotEmpty) ...[
              const SizedBox(height: 16),
              _buildEventMarkersInfo(context, textColor, secondaryTextColor),
            ],
            if (widget.showTodayButton) ...[
              const SizedBox(height: 12),
              _buildTodayButton(context),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context,
    Color textColor,
    Color secondaryTextColor,
  ) {
    final monthYear = DateFormat('MMMM yyyy').format(_focusedDay);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          monthYear,
          style: AppTextStyle.h4.copyWith(
            color: textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        Row(
          children: [
            IconButton(
              icon: Icon(Icons.chevron_left, color: AppColors.purple),
              onPressed: () {
                safeSetState(() {
                  if (_calendarFormat == CalendarFormat.month) {
                    _focusedDay = DateTime(
                      _focusedDay.year,
                      _focusedDay.month - 1,
                    );
                  } else {
                    _focusedDay = _focusedDay.subtract(const Duration(days: 7));
                  }
                });
              },
              tooltip: 'Previous',
            ),
            IconButton(
              icon: Icon(Icons.chevron_right, color: AppColors.purple),
              onPressed: () {
                safeSetState(() {
                  if (_calendarFormat == CalendarFormat.month) {
                    _focusedDay = DateTime(
                      _focusedDay.year,
                      _focusedDay.month + 1,
                    );
                  } else {
                    _focusedDay = _focusedDay.add(const Duration(days: 7));
                  }
                });
              },
              tooltip: 'Next',
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildEventMarkersInfo(
    BuildContext context,
    Color textColor,
    Color secondaryTextColor,
  ) {
    final todayEvents = _getEventsForDay(DateTime.now());
    final selectedEvents = _getEventsForDay(_selectedDay);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? AppColors.darkCard : AppColors.lightCard;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.purple.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: AppColors.coral,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Event markers',
                style: AppTextStyle.bodySmall.copyWith(
                  color: secondaryTextColor,
                ),
              ),
            ],
          ),
          if (selectedEvents.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              'Selected day (${DateFormat('MMM dd, yyyy').format(_selectedDay)}):',
              style: AppTextStyle.bodySmall.copyWith(
                color: textColor,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            ...selectedEvents.map((event) {
              final eventTitle = _getEventTitle(event);
              final eventType = _getEventType(event);
              return Container(
                margin: const EdgeInsets.only(bottom: 6),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppColors.purple.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: _getEventTypeColor(eventType),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        eventTitle,
                        style: AppTextStyle.bodyMedium.copyWith(
                          color: textColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    if (eventType != null) ...[
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: _getEventTypeColor(eventType).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          eventType,
                          style: AppTextStyle.bodySmall.copyWith(
                            color: _getEventTypeColor(eventType),
                            fontWeight: FontWeight.w600,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              );
            }).toList(),
          ],
          if (selectedEvents.isEmpty) ...[
            const SizedBox(height: 8),
            Text(
              'No events for selected day',
              style: AppTextStyle.bodySmall.copyWith(
                color: secondaryTextColor,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
          if (todayEvents.isNotEmpty &&
              !isSameDay(_selectedDay, DateTime.now())) ...[
            const SizedBox(height: 12),
            const Divider(),
            const SizedBox(height: 8),
            Text(
              'Today (${DateFormat('MMM dd').format(DateTime.now())}):',
              style: AppTextStyle.bodySmall.copyWith(
                color: textColor,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            ...todayEvents.take(3).map((event) {
              final eventTitle = _getEventTitle(event);
              return Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  children: [
                    Container(
                      width: 4,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppColors.coral,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        eventTitle,
                        style: AppTextStyle.bodySmall.copyWith(
                          color: secondaryTextColor,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
            if (todayEvents.length > 3) ...[
              Text(
                'and ${todayEvents.length - 3} more...',
                style: AppTextStyle.bodySmall.copyWith(
                  color: secondaryTextColor,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ],
        ],
      ),
    );
  }

  String _getEventTitle(dynamic event) {
    if (event is Map) {
      return event['title']?.toString() ??
          event['name']?.toString() ??
          'Untitled Event';
    } else if (event is String) {
      return event;
    } else {
      return event.toString();
    }
  }

  String? _getEventType(dynamic event) {
    if (event is Map) {
      return event['type']?.toString();
    }
    return null;
  }

  Color _getEventTypeColor(String? type) {
    switch (type?.toLowerCase()) {
      case 'work':
        return AppColors.blue;
      case 'personal':
        return AppColors.green;
      case 'urgent':
      case 'high':
        return AppColors.highPriority;
      case 'medium':
        return AppColors.mediumPriority;
      case 'low':
        return AppColors.lowPriority;
      default:
        return AppColors.purple;
    }
  }

  Widget _buildTodayButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () {
          safeSetState(() {
            _focusedDay = DateTime.now();
            _selectedDay = DateTime.now();
            if (widget.rangeSelectionEnabled) {
              _selectedRange = null;
            }
          });
          widget.onDaySelected?.call(DateTime.now());
        },
        icon: const Icon(Icons.today, size: 18),
        label: const Text('Go to Today'),
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.purple,
          side: const BorderSide(color: AppColors.purple),
        ),
      ),
    );
  }
}

class RangeSelection {
  final DateTime? start;
  final DateTime? end;

  RangeSelection({this.start, this.end});
}
