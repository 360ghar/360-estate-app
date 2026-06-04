import 'package:estate_app/core/presentation/design_system/app_colors.dart';
import 'package:estate_app/core/presentation/design_system/app_radii.dart';
import 'package:estate_app/core/presentation/design_system/app_shadows.dart';
import 'package:estate_app/core/presentation/design_system/app_spacing.dart';
import 'package:estate_app/core/presentation/widgets/app_scaffold.dart';
import 'package:flutter/material.dart';

/// Calendar event model
class CalendarEvent {
  const CalendarEvent({
    required this.id,
    required this.title,
    required this.date,
    required this.type,
    this.propertyName,
    this.tenantName,
    this.time,
    this.notes,
  });

  final String id;
  final String title;
  final DateTime date;
  final CalendarEventType type;
  final String? propertyName;
  final String? tenantName;
  final String? time;
  final String? notes;
}

/// Event types with design-system-aligned colors:
/// red for rent due, green for payments, blue for inspections, amber for maintenance.
enum CalendarEventType {
  leaseStart('Lease Start', Icons.login_rounded, Color(0xFF059669)),
  leaseEnd('Lease End', Icons.logout_rounded, Color(0xFFDC2626)),
  rentDue('Rent Due', Icons.payments_rounded, Color(0xFFDC2626)),
  maintenance('Maintenance', Icons.build_rounded, Color(0xFFF59E0B)),
  inspection('Inspection', Icons.fact_check_rounded, Color(0xFF3B82F6)),
  moveIn('Move-In', Icons.arrow_forward_rounded, Color(0xFF14B8A6)),
  moveOut('Move-Out', Icons.arrow_back_rounded, Color(0xFFEF4444)),
  payment('Payment Received', Icons.check_circle_rounded, Color(0xFF059669));

  const CalendarEventType(this.label, this.icon, this.color);
  final String label;
  final IconData icon;
  final Color color;
}

/// Calendar page showing events.
///
/// Events will be fetched from the API when the calendar endpoints are available.
class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  late DateTime _selectedMonth;
  DateTime? _selectedDay;
  CalendarEventType? _selectedFilter;

  // No mock events - will be populated from API when available
  List<CalendarEvent> get _eventsForSelectedDay => const [];

  List<CalendarEvent> get _eventsForMonth => const [];

  @override
  void initState() {
    super.initState();
    _selectedMonth = DateTime.now();
    _selectedDay = DateTime.now();
  }

  void _previousMonth() {
    setState(() {
      _selectedMonth =
          DateTime(_selectedMonth.year, _selectedMonth.month - 1);
    });
  }

  void _nextMonth() {
    setState(() {
      _selectedMonth =
          DateTime(_selectedMonth.year, _selectedMonth.month + 1);
    });
  }

  void _goToToday() {
    setState(() {
      _selectedMonth = DateTime.now();
      _selectedDay = DateTime.now();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppBar(
        title: const Text('Calendar'),
        actions: [
          TextButton.icon(
            onPressed: _goToToday,
            icon: const Icon(Icons.today_rounded, size: 18),
            label: const Text('Today'),
          ),
        ],
      ),
      body: Column(
        children: [
          // Month navigation
          _MonthHeader(
            selectedMonth: _selectedMonth,
            onPrevious: _previousMonth,
            onNext: _nextMonth,
          ),

          // Filter chips
          _FilterRow(
            selectedFilter: _selectedFilter,
            onFilterChanged: (filter) {
              setState(() => _selectedFilter = filter);
            },
          ),

          const SizedBox(height: AppSpacing.sm),

          // Calendar grid
          _CalendarGrid(
            selectedMonth: _selectedMonth,
            selectedDay: _selectedDay,
            monthEvents: _eventsForMonth,
            onDaySelected: (day) {
              setState(() => _selectedDay = day);
            },
          ),

          const SizedBox(height: AppSpacing.md),

          // Legend
          const _Legend(),

          const SizedBox(height: AppSpacing.md),

          // Events for selected day
          Expanded(
            child: _EventsList(
              events: _eventsForSelectedDay,
              selectedDay: _selectedDay,
            ),
          ),
        ],
      ),
    );
  }
}

/// Month header with clean navigation arrows and centered month/year text.
class _MonthHeader extends StatelessWidget {
  const _MonthHeader({
    required this.selectedMonth,
    required this.onPrevious,
    required this.onNext,
  });

  final DateTime selectedMonth;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  String get _monthYear {
    return '${_monthNames[selectedMonth.month - 1]} ${selectedMonth.year}';
  }

  static const _monthNames = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.sm,
      ),
      child: Row(
        children: [
          _NavButton(
            icon: Icons.chevron_left_rounded,
            onTap: onPrevious,
          ),
          Expanded(
            child: Text(
              _monthYear,
              style: textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          _NavButton(
            icon: Icons.chevron_right_rounded,
            onTap: onNext,
          ),
        ],
      ),
    );
  }
}

/// Compact navigation button with subtle background.
class _NavButton extends StatelessWidget {
  const _NavButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Material(
      color: isDark
          ? AppColors.darkSurfaceSecondary
          : AppColors.surfaceSecondary,
      borderRadius: AppRadii.md,
      child: InkWell(
        borderRadius: AppRadii.md,
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.sm),
          child: Icon(
            icon,
            size: 22,
            color: scheme.onSurface,
          ),
        ),
      ),
    );
  }
}

/// Horizontal scrollable filter chips.
class _FilterRow extends StatelessWidget {
  const _FilterRow({
    required this.selectedFilter,
    required this.onFilterChanged,
  });

  final CalendarEventType? selectedFilter;
  final ValueChanged<CalendarEventType?> onFilterChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.xs,
        ),
        itemCount: CalendarEventType.values.length + 1,
        separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.sm),
        itemBuilder: (context, index) {
          if (index == 0) {
            return FilterChip(
              label: const Text('All'),
              selected: selectedFilter == null,
              onSelected: (_) => onFilterChanged(null),
            );
          }
          final type = CalendarEventType.values[index - 1];
          return FilterChip(
            label: Text(type.label),
            selected: selectedFilter == type,
            onSelected: (_) => onFilterChanged(
              selectedFilter == type ? null : type,
            ),
            selectedColor: type.color.withValues(alpha: 0.15),
            checkmarkColor: type.color,
            avatar: selectedFilter == type
                ? Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: type.color,
                      shape: BoxShape.circle,
                    ),
                  )
                : null,
          );
        },
      ),
    );
  }
}

/// Calendar grid with improved day cell styling.
class _CalendarGrid extends StatelessWidget {
  const _CalendarGrid({
    required this.selectedMonth,
    required this.selectedDay,
    required this.monthEvents,
    required this.onDaySelected,
  });

  final DateTime selectedMonth;
  final DateTime? selectedDay;
  final List<CalendarEvent> monthEvents;
  final ValueChanged<DateTime> onDaySelected;

  int get _daysInMonth {
    return DateTime(selectedMonth.year, selectedMonth.month + 1, 0).day;
  }

  int get _firstWeekday {
    return DateTime(selectedMonth.year, selectedMonth.month).weekday;
  }

  List<CalendarEvent> _getEventsForDay(int day) {
    return monthEvents.where((event) {
      return event.date.year == selectedMonth.year &&
          event.date.month == selectedMonth.month &&
          event.date.day == day;
    }).toList();
  }

  bool _isToday(int day) {
    final now = DateTime.now();
    return day == now.day &&
        selectedMonth.month == now.month &&
        selectedMonth.year == now.year;
  }

  bool _isSelected(int day) {
    return selectedDay != null &&
        day == selectedDay!.day &&
        selectedMonth.month == selectedDay!.month &&
        selectedMonth.year == selectedDay!.year;
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Table(
        children: [
          // Weekday headers
          TableRow(
            children: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']
                .map((day) => Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                      child: Center(
                        child: Text(
                          day,
                          style: textTheme.labelSmall?.copyWith(
                            color: AppColors.textTertiary,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ))
                .toList(),
          ),
          // Calendar days
          ..._buildCalendarRows(),
        ],
      ),
    );
  }

  List<TableRow> _buildCalendarRows() {
    final rows = <TableRow>[];
    final days = <Widget>[];

    // Add empty cells for days before the first day of month
    for (int i = 1; i < _firstWeekday; i++) {
      days.add(const SizedBox(height: 52));
    }

    // Add days of the month
    for (int day = 1; day <= _daysInMonth; day++) {
      final events = _getEventsForDay(day);
      final isToday = _isToday(day);
      final isSelected = _isSelected(day);

      days.add(
        GestureDetector(
          onTap: () => onDaySelected(
              DateTime(selectedMonth.year, selectedMonth.month, day)),
          child: _DayCell(
            day: day,
            isToday: isToday,
            isSelected: isSelected,
            events: events,
          ),
        ),
      );

      // Start a new row every 7 days
      if (days.length == 7) {
        rows.add(TableRow(children: List.of(days)));
        days.clear();
      }
    }

    // Add remaining cells
    while (days.length < 7) {
      days.add(const SizedBox(height: 52));
    }
    if (days.isNotEmpty) {
      rows.add(TableRow(children: List.of(days)));
    }

    return rows;
  }
}

/// Day cell with selected = filled primary circle, today = outlined primary circle.
class _DayCell extends StatelessWidget {
  const _DayCell({
    required this.day,
    required this.isToday,
    required this.isSelected,
    required this.events,
  });

  final int day;
  final bool isToday;
  final bool isSelected;
  final List<CalendarEvent> events;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return SizedBox(
      height: 52,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Day number inside a circle
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected ? scheme.primary : null,
              border: isToday && !isSelected
                  ? Border.all(color: scheme.primary, width: 1.5)
                  : null,
            ),
            alignment: Alignment.center,
            child: Text(
              '$day',
              style: textTheme.bodyMedium?.copyWith(
                fontWeight:
                    isSelected || isToday ? FontWeight.w700 : FontWeight.w400,
                color: isSelected
                    ? scheme.onPrimary
                    : isToday
                        ? scheme.primary
                        : null,
              ),
            ),
          ),

          // Event dots below the date number
          const SizedBox(height: 2),
          SizedBox(
            height: 8,
            child: events.isEmpty
                ? null
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: events.take(3).map((event) {
                      return Padding(
                        padding:
                            const EdgeInsets.symmetric(horizontal: 1),
                        child: Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: event.type.color,
                            shape: BoxShape.circle,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
          ),
        ],
      ),
    );
  }
}

/// Legend row showing colored pills with labels.
class _Legend extends StatelessWidget {
  const _Legend();

  static const _legendItems = [
    (label: 'Rent Due', color: Color(0xFFDC2626)),
    (label: 'Payment', color: Color(0xFF059669)),
    (label: 'Inspection', color: Color(0xFF3B82F6)),
    (label: 'Maintenance', color: Color(0xFFF59E0B)),
  ];

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: _legendItems.map((item) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: item.color,
                    borderRadius: AppRadii.pill,
                  ),
                ),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  item.label,
                  style: textTheme.labelSmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

/// Events list for selected day.
class _EventsList extends StatelessWidget {
  const _EventsList({
    required this.events,
    required this.selectedDay,
  });

  final List<CalendarEvent> events;
  final DateTime? selectedDay;

  String get _formattedDate {
    if (selectedDay == null) return 'Select a day';
    final d = selectedDay!;
    return '${d.day} ${_monthNames[d.month - 1]} ${d.year}';
  }

  static const _monthNames = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.darkSurfaceSecondary
            : AppColors.surfaceSecondary,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(AppRadii.xlValue),
          topRight: Radius.circular(AppRadii.xlValue),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.lg,
              AppSpacing.lg,
              AppSpacing.sm,
            ),
            child: Text(
              _formattedDate,
              style: textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          Expanded(
            child: events.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.event_available_rounded,
                          size: 40,
                          color: AppColors.textDisabled,
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          'No events scheduled',
                          style: textTheme.bodyMedium?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          'Events will appear here once connected to the API',
                          style: textTheme.bodySmall?.copyWith(
                            color: AppColors.textTertiary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg,
                      vertical: AppSpacing.sm,
                    ),
                    itemCount: events.length,
                    separatorBuilder: (_, _) =>
                        const SizedBox(height: AppSpacing.sm),
                    itemBuilder: (context, index) {
                      final event = events[index];
                      return Container(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        decoration: BoxDecoration(
                          color: scheme.surface,
                          borderRadius: AppRadii.lg,
                          border: Border.all(
                            color: isDark
                                ? AppColors.darkCardBorder
                                : AppColors.cardBorder,
                            width: 0.5,
                          ),
                          boxShadow: AppShadows.cardResting,
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: event.type.color
                                    .withValues(alpha: isDark ? 0.15 : 0.1),
                                borderRadius: AppRadii.md,
                              ),
                              child: Icon(
                                event.type.icon,
                                size: 20,
                                color: event.type.color,
                              ),
                            ),
                            const SizedBox(width: AppSpacing.md),
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    event.title,
                                    style: textTheme.titleSmall,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  if (event.propertyName != null ||
                                      event.time != null)
                                    Text(
                                      [
                                        if (event.time != null) event.time,
                                        if (event.propertyName != null)
                                          event.propertyName,
                                      ].join(' \u2022 '),
                                      style:
                                          textTheme.bodySmall?.copyWith(
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
