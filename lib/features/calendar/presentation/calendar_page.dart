import 'package:estate_app/core/presentation/design_system/app_spacing.dart';
import 'package:estate_app/core/presentation/widgets/app_scaffold.dart';
import 'package:estate_app/core/presentation/widgets/section_header.dart';
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

/// Event types
enum CalendarEventType {
  leaseStart('Lease Start', Icons.login, Colors.green),
  leaseEnd('Lease End', Icons.logout, Colors.red),
  rentDue('Rent Due', Icons.payments, Colors.orange),
  maintenance('Maintenance', Icons.build, Colors.blue),
  inspection('Inspection', Icons.fact_check, Colors.purple),
  moveIn('Move-In', Icons.arrow_forward, Colors.teal),
  moveOut('Move-Out', Icons.arrow_back, Colors.deepOrange),
  payment('Payment Received', Icons.check_circle, Color(0xFF2E7D32));

  const CalendarEventType(this.label, this.icon, this.color);
  final String label;
  final IconData icon;
  final Color color;
}

/// Calendar page showing events
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
      _selectedMonth = DateTime(_selectedMonth.year, _selectedMonth.month - 1);
    });
  }

  void _nextMonth() {
    setState(() {
      _selectedMonth = DateTime(_selectedMonth.year, _selectedMonth.month + 1);
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
          IconButton(
            onPressed: _goToToday,
            icon: const Icon(Icons.today),
            tooltip: 'Go to today',
          ),
        ],
      ),
      body: Column(
        children: [
          // Month selector and filters
          _MonthHeader(
            selectedMonth: _selectedMonth,
            onPrevious: _previousMonth,
            onNext: _nextMonth,
            selectedFilter: _selectedFilter,
            onFilterChanged: (filter) {
              setState(() => _selectedFilter = filter);
            },
          ),

          // Calendar grid
          _CalendarGrid(
            selectedMonth: _selectedMonth,
            selectedDay: _selectedDay,
            monthEvents: _eventsForMonth,
            onDaySelected: (day) {
              setState(() => _selectedDay = day);
            },
          ),

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

/// Month header with navigation and filters
class _MonthHeader extends StatelessWidget {
  const _MonthHeader({
    required this.selectedMonth,
    required this.onPrevious,
    required this.onNext,
    required this.selectedFilter,
    required this.onFilterChanged,
  });

  final DateTime selectedMonth;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final CalendarEventType? selectedFilter;
  final ValueChanged<CalendarEventType?> onFilterChanged;

  String get _monthYear {
    return '${_monthNames[selectedMonth.month - 1]} ${selectedMonth.year}';
  }

  static const _monthNames = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December'
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        children: [
          // Month navigation
          Row(
            children: [
              IconButton(
                onPressed: onPrevious,
                icon: const Icon(Icons.chevron_left),
              ),
              Expanded(
                child: Text(
                  _monthYear,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                  textAlign: TextAlign.center,
                ),
              ),
              IconButton(
                onPressed: onNext,
                icon: const Icon(Icons.chevron_right),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.md),

          // Filter chips
          SizedBox(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _FilterChip(
                  label: 'All',
                  isSelected: selectedFilter == null,
                  onTap: () => onFilterChanged(null),
                ),
                ...CalendarEventType.values.map((type) {
                  return _FilterChip(
                    label: type.label,
                    isSelected: selectedFilter == type,
                    color: type.color,
                    onTap: () => onFilterChanged(
                      selectedFilter == type ? null : type,
                    ),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Filter chip widget
class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.isSelected,
    this.color,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final Color? color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: AppSpacing.sm),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (_) => onTap(),
        selectedColor: color?.withOpacity(0.2) ?? null,
        checkmarkColor: color,
        avatar: isSelected && color != null
            ? Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
              )
            : null,
      ),
    );
  }
}

/// Calendar grid widget
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
    return DateTime(selectedMonth.year, selectedMonth.month, 1).weekday;
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
    return Table(
      children: [
        // Weekday headers
        TableRow(
          children: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']
              .map((day) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                    child: Center(
                      child: Text(
                        day,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ),
                  ))
              .toList(),
        ),
        // Calendar days
        ..._buildCalendarRows(),
      ],
    );
  }

  List<TableRow> _buildCalendarRows() {
    final rows = <TableRow>[];
    final days = <Widget>[];

    // Add empty cells for days before the first day of month
    for (int i = 1; i < _firstWeekday; i++) {
      days.add(const SizedBox());
    }

    // Add days of the month
    for (int day = 1; day <= _daysInMonth; day++) {
      final events = _getEventsForDay(day);
      final isToday = _isToday(day);
      final isSelected = _isSelected(day);

      days.add(
        GestureDetector(
          onTap: () => onDaySelected(DateTime(selectedMonth.year, selectedMonth.month, day)),
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
        rows.add(TableRow(children: days));
        days.clear();
      }
    }

    // Add remaining cells
    while (days.length < 7) {
      days.add(const SizedBox());
    }
    if (days.isNotEmpty) {
      rows.add(TableRow(children: days));
    }

    return rows;
  }
}

/// Day cell widget
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
    return Container(
      margin: const EdgeInsets.all(2),
      height: 60,
      decoration: BoxDecoration(
        color: isSelected
            ? Theme.of(context).colorScheme.primaryContainer
            : isToday
                ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
                : null,
        borderRadius: BorderRadius.circular(8),
        border: isSelected
            ? Border.all(color: Theme.of(context).colorScheme.primary)
            : null,
      ),
      child: Stack(
        children: [
          // Day number
          Positioned(
            top: 4,
            left: 4,
            child: Text(
              '$day',
              style: TextStyle(
                fontWeight: isSelected || isToday ? FontWeight.bold : FontWeight.normal,
                color: isSelected
                    ? Theme.of(context).colorScheme.onPrimaryContainer
                    : null,
              ),
            ),
          ),
          // Event indicators
          if (events.isNotEmpty)
            Positioned(
              bottom: 4,
              left: 4,
              right: 4,
              child: Wrap(
                spacing: 2,
                runSpacing: 2,
                children: events.take(3).map((event) {
                  return Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: event.type.color,
                      shape: BoxShape.circle,
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

/// Events list for selected day
class _EventsList extends StatelessWidget {
  const _EventsList({
    required this.events,
    required this.selectedDay,
  });

  final List<CalendarEvent> events;
  final DateTime? selectedDay;

  String get _formattedDate {
    if (selectedDay == null) return 'Select a day';
    return '${selectedDay!.day}/${selectedDay!.month}/${selectedDay!.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(
            title: 'Events for $_formattedDate',
          ),
          const SizedBox(height: AppSpacing.md),
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.event_available,
                    size: 48,
                    color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    'No events scheduled',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'Calendar events will appear here once connected to the API',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
