import 'package:flutter/material.dart';

void main() => runApp(const AirTrackApp());

class AirTrackApp extends StatelessWidget {
  const AirTrackApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AirTrack',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.teal,
        brightness: Brightness.light,
      ),
      home: const HomeShell(),
    );
  }
}

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});
  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _index = 0;

  static const _titles = <String>[
    'Dashboard',
    'Use Now',
    'History',
    'Alerts',
    'Settings',
  ];

  final _pages = const <Widget>[
    _DashboardPage(),
    _UseNowPage(),
    _HistoryPage(),
    _AlertsPage(),
    _SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_index]),
      ),
      body: SafeArea(
        // IndexedStack keeps each tab’s state when switching
        child: IndexedStack(
          index: _index,
          children: _pages,
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          NavigationDestination(
            icon: Icon(Icons.medication_outlined),
            selectedIcon: Icon(Icons.medication),
            label: 'Use Now',
          ),
          NavigationDestination(
            icon: Icon(Icons.history),
            selectedIcon: Icon(Icons.history_toggle_off),
            label: 'History',
          ),
          NavigationDestination(
            icon: Icon(Icons.notifications_none),
            selectedIcon: Icon(Icons.notifications),
            label: 'Alerts',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}

/// ---------- Pages (placeholders you can extend) ----------

//class _DashboardPage extends StatelessWidget {
  //const _DashboardPage();

  //@override
  //Widget build(BuildContext context) {
   // return const Center(
      //child: Text(
        //'Dashboard — summary cards will go here',
        //textAlign: TextAlign.center,
      //),
    //);
  //}
//}

// ===================== Dashboard =====================
// ===================== Dashboard =====================
class _DashboardPage extends StatelessWidget {
  const _DashboardPage();

  // Helper: switch bottom-nav tab from a child page
  void _switchTab(BuildContext context, int index) {
    final home = context.findAncestorStateOfType<_HomeShellState>();
    if (home != null) {
      home.setState(() => home._index = index); // index: 0=Dashboard,1=UseNow,2=History,3=Alerts,4=Settings
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    // Mock data (swap with real)
    const String userName = 'Naimisha';
    const String nextDose = 'Today • 8:00 PM';
    const String lastSession = 'Yesterday • Good technique';
    const double adherence = 0.72; // 72%

    String motivationText() {
      if (adherence >= 0.9) return 'Great job staying consistent! Keep it up 💪';
      if (adherence >= 0.7) return 'Doing well! A few more doses to reach 100%.';
      if (adherence >= 0.5) return 'You’re halfway there — stay on track today!';
      return 'Let’s get back on routine. You’ve got this!';
    }

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
        children: [
          // Greeting
          Text(
            'Hi $userName 👋',
            style: Theme.of(context)
                .textTheme
                .headlineSmall
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            'How are you feeling today?',
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: cs.onSurfaceVariant),
          ),
          const SizedBox(height: 20),

          // Summary header
          Text('Today’s Summary', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),

          // Summary cards
          _DashCard(
            icon: Icons.alarm,
            title: 'Next Dose',
            subtitle: nextDose,
            onTap: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Opening next dose details...')),
            ),
          ),
          _DashCard(
            icon: Icons.fact_check,
            title: 'Last Session',
            subtitle: lastSession,
            onTap: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Viewing last session summary...')),
            ),
          ),

          // Adherence card with progress bar (tap → History tab)
          Card(
            elevation: 0,
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () => _switchTab(context, 2), // → History
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: cs.primaryContainer,
                      child: Icon(Icons.show_chart, color: cs.onPrimaryContainer),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Adherence This Week',
                              style: TextStyle(fontWeight: FontWeight.w600)),
                          const SizedBox(height: 6),
                          LinearProgressIndicator(
                            value: adherence,
                            color: cs.primary,
                            backgroundColor: cs.surfaceVariant,
                          ),
                          const SizedBox(height: 6),
                          Text('${(adherence * 100).round()}% • 5 of 7 doses taken'),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 10),

          // Quick actions row
          Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  icon: const Icon(Icons.play_circle_fill),
                  label: const Text('Use Inhaler'),
                  onPressed: () => _switchTab(context, 1), // → Use Now tab
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.add_alert),
                  label: const Text('Set Reminder'),
                  onPressed: () => _switchTab(context, 3), // → Alerts tab
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Daily Tips
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    Icon(Icons.lightbulb, color: cs.primary),
                    const SizedBox(width: 8),
                    const Text('Daily Tips',
                        style: TextStyle(fontWeight: FontWeight.w600)),
                  ]),
                  const SizedBox(height: 10),
                  const _TipTile(text: 'Rinse your mouth after inhaler use to prevent side effects.'),
                  const _TipTile(text: 'Keep the inhaler upright when pressing the canister.'),
                  const _TipTile(text: 'Aim for the same time each day for better adherence.'),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Motivation / wellness banner
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: cs.primaryContainer.withOpacity(0.3),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                const Icon(Icons.favorite, color: Colors.teal),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(motivationText(),
                      style: Theme.of(context).textTheme.bodyMedium),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Reusable dashboard card with arrow + ripple
class _DashCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  const _DashCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: cs.primaryContainer,
              child: Icon(icon, color: cs.onPrimaryContainer),
            ),
            title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
            subtitle: Text(subtitle),
            trailing: const Icon(Icons.chevron_right),
          ),
        ),
      ),
    );
  }
}

class _TipTile extends StatelessWidget {
  const _TipTile({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      contentPadding: EdgeInsets.zero,
      leading: const Icon(Icons.check_circle, size: 20),
      title: Text(text),
    );
    }
}



//end of dashboard page


//class _UseNowPage extends StatelessWidget {
  //const _UseNowPage();

  //@override
  //Widget build(BuildContext context) {
    //return const Center(
      //child: Text(
       // 'Use Now — start a guided inhaler session',
       // textAlign: TextAlign.center,
      //),
    //);
  //}
//}

class _UseNowPage extends StatelessWidget {
  const _UseNowPage();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
        children: [
          Text(
            'Guided Inhaler Session',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),

          // Step 1
          const _StepCard(
            step: 1,
            title: 'Prepare Inhaler',
            instruction: 'Shake inhaler and remove the cap.',
            icon: Icons.medical_services_outlined,
          ),

          // Step 2
          const _StepCard(
            step: 2,
            title: 'Breathe Out Fully',
            instruction: 'Exhale completely before using your inhaler.',
            icon: Icons.air_outlined,
          ),

          // Step 3
          const _StepCard(
            step: 3,
            title: 'Inhale Slowly',
            instruction: 'Press inhaler and breathe in deeply for 5 seconds.',
            icon: Icons.play_circle_outline,
          ),

          // Step 4
          const _StepCard(
            step: 4,
            title: 'Hold Your Breath',
            instruction: 'Hold for 10 seconds before exhaling.',
            icon: Icons.timer_outlined,
          ),

          const SizedBox(height: 24),

          // Start session button
          FilledButton.icon(
            icon: const Icon(Icons.play_arrow),
            label: const Text('Start Session'),
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              textStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Starting guided inhaler session...'),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _StepCard extends StatelessWidget {
  final int step;
  final String title;
  final String instruction;
  final IconData icon;

  const _StepCard({
    required this.step,
    required this.title,
    required this.instruction,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: cs.surfaceVariant.withOpacity(0.4),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: cs.primaryContainer,
          child: Icon(icon, color: cs.onPrimaryContainer),
        ),
        title: Text(
          'Step $step: $title',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(instruction),
      ),
    );
  }
}

// end of Use now page

//class _HistoryPage extends StatelessWidget {
  //const _HistoryPage();

  //@override
  //Widget build(BuildContext context) {
   // return const Center(
      //child: Text(
       // 'History — logs and adherence timeline',
       // textAlign: TextAlign.center,
    //  ),
   // );
 // }
//}

// ---------- History Page (List + Calendar + Weekly Chart) ----------
class _HistoryPage extends StatefulWidget {
  const _HistoryPage();

  @override
  State<_HistoryPage> createState() => _HistoryPageState();
}

enum _Quality { excellent, good, poor, missed }

class _Session {
  final DateTime at;
  final _Quality quality;
  const _Session(this.at, this.quality);
}

class _HistoryPageState extends State<_HistoryPage> {
  bool _showCalendar = false;

  // Mock data — replace later with DB/BLE sync
  final List<_Session> _sessions = [
    _Session(DateTime.now().subtract(const Duration(hours: 2)), _Quality.excellent),
    _Session(DateTime.now().subtract(const Duration(days: 1, hours: 15)), _Quality.good),
    _Session(DateTime.now().subtract(const Duration(days: 2, hours: 9)), _Quality.missed),
    _Session(DateTime.now().subtract(const Duration(days: 3, hours: 12)), _Quality.excellent),
    _Session(DateTime.now().subtract(const Duration(days: 4, hours: 20)), _Quality.good),
    _Session(DateTime.now().subtract(const Duration(days: 5, hours: 21)), _Quality.poor),
    _Session(DateTime.now().subtract(const Duration(days: 6, hours: 8)), _Quality.excellent),
    _Session(DateTime.now().subtract(const Duration(days: 7, hours: 9)), _Quality.good),
    _Session(DateTime.now().subtract(const Duration(days: 10, hours: 7)), _Quality.excellent),
  ];

  // For calendar: month being viewed
  DateTime _visibleMonth = DateTime(DateTime.now().year, DateTime.now().month);

  // ----- helpers -----
  String _qualityLabel(_Quality q) => switch (q) {
        _Quality.excellent => 'Excellent',
        _Quality.good => 'Good',
        _Quality.poor => 'Poor',
        _Quality.missed => 'Missed',
      };

  Color _qualityColor(_Quality q) => switch (q) {
        _Quality.excellent => Colors.green,
        _Quality.good => Colors.teal,
        _Quality.poor => Colors.orange,
        _Quality.missed => Colors.redAccent,
      };

  /// Return counts for the last 7 days (Sun..Sat style order based on now.weekday)
  List<int> _weeklyTakenCounts() {
    // 1 dose max per day in this mock; adapt if you have multiple
    final now = DateTime.now();
    return List<int>.generate(7, (i) {
      final day = DateTime(now.year, now.month, now.day).subtract(Duration(days: 6 - i));
      final hasDose = _sessions.any((s) =>
          s.at.year == day.year && s.at.month == day.month && s.at.day == day.day && s.quality != _Quality.missed);
      return hasDose ? 1 : 0;
    });
  }

  (int taken, int total) _adherenceThisWeek() {
    final counts = _weeklyTakenCounts();
    final taken = counts.fold(0, (a, b) => a + b);
    return (taken, 7);
  }

  List<_Session> _sessionsForDay(DateTime day) {
    return _sessions.where((s) =>
        s.at.year == day.year && s.at.month == day.month && s.at.day == day.day).toList()
      ..sort((a, b) => b.at.compareTo(a.at));
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final (taken, total) = _adherenceThisWeek();
    final progress = total == 0 ? 0.0 : taken / total;

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
        children: [
          // Header + toggle
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('History', style: Theme.of(context).textTheme.titleLarge),
              SegmentedButton<bool>(
                segments: const [
                  ButtonSegment(value: false, label: Text('List'), icon: Icon(Icons.view_list)),
                  ButtonSegment(value: true, label: Text('Calendar'), icon: Icon(Icons.calendar_today)),
                ],
                selected: <bool>{_showCalendar},
                onSelectionChanged: (s) => setState(() => _showCalendar = s.first),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // ----- Weekly adherence chart card -----
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            margin: const EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Adherence This Week', style: TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 10),
                  LinearProgressIndicator(value: progress, color: cs.primary, backgroundColor: cs.surfaceVariant),
                  const SizedBox(height: 8),
                  Text('$taken of $total doses taken', style: Theme.of(context).textTheme.bodyMedium),
                  const SizedBox(height: 12),
                  _MiniBarChart(values: _weeklyTakenCounts()),
                ],
              ),
            ),
          ),

          // ----- Body: List OR Calendar -----
          if (!_showCalendar) ..._buildListBody(context) else ..._buildCalendarBody(context),
        ],
      ),
    );
  }

  // ---------- LIST BODY ----------
  List<Widget> _buildListBody(BuildContext context) {
    // group by day (Today, Yesterday, date)
    final now = DateTime.now();
    String dayLabel(DateTime d) {
      final base = DateTime(now.year, now.month, now.day);
      final target = DateTime(d.year, d.month, d.day);
      final diff = base.difference(target).inDays;
      if (diff == 0) return 'Today';
      if (diff == 1) return 'Yesterday';
      return '${_monthName(d.month)} ${d.day}';
    }

    final sorted = [..._sessions]..sort((a, b) => b.at.compareTo(a.at));

    return [
      Text('Dose History', style: Theme.of(context).textTheme.titleLarge),
      const SizedBox(height: 12),
      ...sorted.map((s) {
        final statusColor = _qualityColor(s.quality);
        final timeStr = TimeOfDay.fromDateTime(s.at).format(context);
        return Card(
          elevation: 0,
          margin: const EdgeInsets.only(bottom: 10),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.25),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: statusColor.withOpacity(0.15),
              child: Icon(
                switch (s.quality) {
                  _Quality.excellent => Icons.check_circle,
                  _Quality.good => Icons.thumb_up,
                  _Quality.poor => Icons.warning_amber_rounded,
                  _Quality.missed => Icons.cancel,
                },
                color: statusColor,
              ),
            ),
            title: Text('${dayLabel(s.at)} • $timeStr'),
            subtitle: Text('Inhalation: ${_qualityLabel(s.quality)}'),
          ),
        );
      }),
    ];
  }

  // ---------- CALENDAR BODY ----------
  List<Widget> _buildCalendarBody(BuildContext context) {
    final year = _visibleMonth.year;
    final month = _visibleMonth.month;
    final firstOfMonth = DateTime(year, month, 1);
    final daysInMonth = DateTime(year, month + 1, 0).day;
    final startWeekday = firstOfMonth.weekday; // 1=Mon..7=Sun
    final int leadingBlanks = (startWeekday % 7); // make 0 for Sun

    // Build list of day cells including blanks
    final totalCells = leadingBlanks + daysInMonth;
    final rows = (totalCells / 7).ceil();

    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            tooltip: 'Previous month',
            onPressed: () => setState(() =>
                _visibleMonth = DateTime(year, month - 1)),
            icon: const Icon(Icons.chevron_left),
          ),
          Text('${_monthName(month)} $year',
              style: Theme.of(context).textTheme.titleMedium),
          IconButton(
            tooltip: 'Next month',
            onPressed: () => setState(() =>
                _visibleMonth = DateTime(year, month + 1)),
            icon: const Icon(Icons.chevron_right),
          ),
        ],
      ),
      const SizedBox(height: 8),
      // Weekday headers
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: const [
          _Weekday('Mon'), _Weekday('Tue'), _Weekday('Wed'), _Weekday('Thu'),
          _Weekday('Fri'), _Weekday('Sat'), _Weekday('Sun'),
        ],
      ),
      const SizedBox(height: 4),

      // Calendar grid
      GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: rows * 7,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 7,
          mainAxisExtent: 44,
        ),
        itemBuilder: (ctx, idx) {
          final dayNum = idx - leadingBlanks + 1;
          if (dayNum < 1 || dayNum > daysInMonth) {
            return const SizedBox.shrink();
          }
          final day = DateTime(year, month, dayNum);
          final sessionsToday = _sessionsForDay(day);
          final hasAny = sessionsToday.isNotEmpty;
          final missed = sessionsToday.any((s) => s.quality == _Quality.missed);
          final goodish = sessionsToday.any((s) => s.quality == _Quality.excellent || s.quality == _Quality.good);

          Color? dotColor;
          if (missed) {
            dotColor = Colors.redAccent;
          } else if (goodish) {
            dotColor = Colors.teal;
          }

          return InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: () {
              if (!hasAny) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('No sessions on ${_monthName(month)} $dayNum')),
                );
                return;
              }
              showModalBottomSheet(
                context: context,
                showDragHandle: true,
                builder: (ctx) => Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${_monthName(month)} $dayNum, $year',
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 12),
                      ...sessionsToday.map((s) => ListTile(
                            leading: Icon(
                              switch (s.quality) {
                                _Quality.excellent => Icons.check_circle,
                                _Quality.good => Icons.thumb_up,
                                _Quality.poor => Icons.warning_amber_rounded,
                                _Quality.missed => Icons.cancel,
                              },
                              color: _qualityColor(s.quality),
                            ),
                            title: Text(TimeOfDay.fromDateTime(s.at).format(context)),
                            subtitle: Text('Inhalation: ${_qualityLabel(s.quality)}'),
                          )),
                    ],
                  ),
                ),
              );
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('$dayNum'),
                const SizedBox(height: 2),
                if (dotColor != null)
                  Container(width: 6, height: 6, decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle)),
              ],
            ),
          );
        },
      ),
      const SizedBox(height: 16),
    ];
  }

  String _monthName(int m) => const [
        'Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'
      ][m - 1];
}

class _Weekday extends StatelessWidget {
  const _Weekday(this.label);
  final String label;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 40,
      child: Text(label, textAlign: TextAlign.center, style: Theme.of(context).textTheme.labelSmall),
    );
  }
}

/// Tiny bar chart (7 bars) without external packages.
class _MiniBarChart extends StatelessWidget {
  const _MiniBarChart({required this.values});
  final List<int> values; // e.g., [0|1, ...] length 7

  @override
  Widget build(BuildContext context) {
    final maxVal = (values.isEmpty ? 1 : values.reduce((a, b) => a > b ? a : b)).clamp(1, 10);
    final cs = Theme.of(context).colorScheme;

    return SizedBox(
      height: 54,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(values.length, (i) {
          final v = values[i];
          final h = (v / maxVal) * 44 + (v > 0 ? 6 : 2); // keep a small visible base
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3),
              child: Container(
                height: h,
                decoration: BoxDecoration(
                  color: v > 0 ? cs.primary : cs.surfaceVariant,
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}



//class _AlertsPage extends StatelessWidget {
  //const _AlertsPage();

  //@override
  //Widget build(BuildContext context) {
    //return const Center(
      //child: Text(
       // 'Alerts — reminders and notifications',
        //textAlign: TextAlign.center,
      //),
    //);
  //}
//}

// ---------- Alerts Page ----------
class _AlertsPage extends StatefulWidget {
  const _AlertsPage();

  @override
  State<_AlertsPage> createState() => _AlertsPageState();
}

class _AlertsPageState extends State<_AlertsPage> {
  final List<_Reminder> _reminders = <_Reminder>[
    _Reminder(label: 'Morning Dose', time: const TimeOfDay(hour: 8, minute: 0)),
    _Reminder(label: 'Evening Dose', time: const TimeOfDay(hour: 20, minute: 0)),
  ];

  final List<_Alert> _alerts = <_Alert>[
    _Alert(
      title: 'Missed Dose',
      subtitle: 'You missed last night’s dose at 9:00 PM.',
      level: _AlertLevel.warning,
      icon: Icons.schedule,
      time: DateTime.now().subtract(const Duration(hours: 12)),
    ),
    _Alert(
      title: 'Battery Low',
      subtitle: 'AirTrack clip battery at 18%. Please charge soon.',
      level: _AlertLevel.critical,
      icon: Icons.battery_alert,
      time: DateTime.now().subtract(const Duration(days: 1, hours: 2)),
    ),
    _Alert(
      title: 'Sync Complete',
      subtitle: 'New inhaler session synced from device.',
      level: _AlertLevel.info,
      icon: Icons.sync,
      time: DateTime.now().subtract(const Duration(days: 2, hours: 3)),
    ),
  ];

  Future<void> _addReminder() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 21, minute: 0),
      builder: (context, child) => Theme(data: Theme.of(context), child: child!),
    );
    if (picked != null) {
      setState(() {
        _reminders.add(_Reminder(label: 'Custom Reminder', time: picked));
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Reminder set for ${picked.format(context)}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
        children: [
          // Header + Add button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Reminders', style: Theme.of(context).textTheme.titleLarge),
              FilledButton.icon(
                icon: const Icon(Icons.add),
                label: const Text('Add'),
                onPressed: _addReminder,
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Reminder cards (with switches)
          ..._reminders.map((r) => Card(
                elevation: 0,
                margin: const EdgeInsets.only(bottom: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: SwitchListTile(
                  dense: false,
                  secondary: CircleAvatar(
                    backgroundColor: cs.primaryContainer,
                    child: Icon(Icons.alarm, color: cs.onPrimaryContainer),
                  ),
                  title: Text(r.label,
                      style: const TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: Text(r.time.format(context)),
                  value: r.enabled,
                  onChanged: (v) {
                    setState(() => r.enabled = v);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(v
                            ? 'Enabled ${r.label}'
                            : 'Disabled ${r.label}'),
                      ),
                    );
                  },
                ),
              )),

          const SizedBox(height: 20),
          Text('Recent Alerts', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),

          // Alerts list
          ..._alerts.map((a) => _AlertCard(alert: a)),
        ],
      ),
    );
  }
}

// ---------- Models & widgets used by Alerts ----------

class _Reminder {
  _Reminder({required this.label, required this.time, this.enabled = true});
  final String label;
  final TimeOfDay time;
  bool enabled; 
}

enum _AlertLevel { info, warning, critical }

class _Alert {
  _Alert({
    required this.title,
    required this.subtitle,
    required this.level,
    required this.icon,
    required this.time,
  });

  final String title;
  final String subtitle;
  final _AlertLevel level;
  final IconData icon;
  final DateTime time;
}

class _AlertCard extends StatelessWidget {
  const _AlertCard({required this.alert});

  final _Alert alert;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final colors = switch (alert.level) {
      _AlertLevel.info => (bg: cs.surfaceVariant.withOpacity(0.4), fg: cs.primary),
      _AlertLevel.warning => (bg: Colors.amber.withOpacity(0.25), fg: Colors.amber[900]!),
      _AlertLevel.critical => (bg: Colors.redAccent.withOpacity(0.22), fg: Colors.redAccent),
    };

    String timeLabel;
    final diff = DateTime.now().difference(alert.time);
    if (diff.inMinutes < 60) {
      timeLabel = '${diff.inMinutes} min ago';
    } else if (diff.inHours < 24) {
      timeLabel = '${diff.inHours} hr ago';
    } else {
      timeLabel = '${diff.inDays} day${diff.inDays == 1 ? '' : 's'} ago';
    }

    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: colors.bg,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.transparent,
          child: Icon(alert.icon, color: colors.fg),
        ),
        title: Text(alert.title,
            style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text('${alert.subtitle}\n$timeLabel'),
        isThreeLine: true,
        trailing: Icon(Icons.chevron_right, color: colors.fg),
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(alert.title)),
          );
        },
      ),
    );
  }
}

// ---------- Settings Page ----------
class _SettingsPage extends StatefulWidget {
  const _SettingsPage();

  @override
  State<_SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<_SettingsPage> {
  // ---- Mock BLE state (replace with real BLE plugin later) ----
  bool _bleConnected = false;
  String _bleName = 'AirTrack Clip';
  int _batteryPct = 78;
  bool _isScanning = false;

  // ---- Profile (simple local state for now) ----
  String _name = 'Naimisha K.';
  int _age = 23;
  String _condition = 'Asthma';

  // ---- Preferences ----
  bool _notifications = true;
  ThemeMode _themeMode = ThemeMode.light; // NOTE: app-wide wiring tip below

  Future<void> _scanForDevices() async {
    setState(() => _isScanning = true);
    await Future.delayed(const Duration(seconds: 2));
    setState(() => _isScanning = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Found 1 device: AirTrack Clip')),
    );
  }

  Future<void> _connectBle() async {
    await Future.delayed(const Duration(milliseconds: 600));
    setState(() {
      _bleConnected = true;
      _batteryPct = 78;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Connected to AirTrack Clip')),
    );
  }

  Future<void> _disconnectBle() async {
    await Future.delayed(const Duration(milliseconds: 300));
    setState(() => _bleConnected = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Disconnected')),
    );
  }

  Future<void> _editText({
    required String title,
    required String initial,
    required void Function(String) onSave,
    TextInputType keyboardType = TextInputType.text,
  }) async {
    final controller = TextEditingController(text: initial);
    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: TextField(
          controller: controller,
          keyboardType: keyboardType,
          autofocus: true,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          FilledButton(
            onPressed: () {
              onSave(controller.text.trim());
              Navigator.pop(ctx);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
    setState(() {});
  }

  Future<void> _pickTheme() async {
    final picked = await showModalBottomSheet<ThemeMode>(
      context: context,
      showDragHandle: true,
      builder: (ctx) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          RadioListTile<ThemeMode>(
            value: ThemeMode.light,
            groupValue: _themeMode,
            title: const Text('Light'),
            onChanged: (v) => Navigator.pop(ctx, v),
          ),
          RadioListTile<ThemeMode>(
            value: ThemeMode.dark,
            groupValue: _themeMode,
            title: const Text('Dark'),
            onChanged: (v) => Navigator.pop(ctx, v),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
    if (picked != null) {
      setState(() => _themeMode = picked);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Theme set to ${picked == ThemeMode.dark ? 'Dark' : 'Light'}')),
      );
      // To apply app-wide, lift ThemeMode state to AirTrackApp and rebuild MaterialApp.
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
        children: [
          // -------- BLE Device Section --------
          Text('Device', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: CircleAvatar(
                      backgroundColor: cs.primaryContainer,
                      child: Icon(
                        _bleConnected ? Icons.bluetooth_connected : Icons.bluetooth,
                        color: cs.onPrimaryContainer,
                      ),
                    ),
                    title: Text(_bleConnected ? '$_bleName • Battery $_batteryPct%' : 'No device connected'),
                    subtitle: Text(_bleConnected ? 'Tap disconnect or scan for a new device' : 'Scan to find your AirTrack clip'),
                    trailing: _bleConnected
                        ? FilledButton.tonal(
                            onPressed: _disconnectBle,
                            child: const Text('Disconnect'),
                          )
                        : FilledButton(
                            onPressed: _connectBle,
                            child: const Text('Connect'),
                          ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          icon: _isScanning
                              ? const SizedBox(
                                  width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                              : const Icon(Icons.search),
                          label: Text(_isScanning ? 'Scanning…' : 'Scan for Devices'),
                          onPressed: _isScanning ? null : _scanForDevices,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          icon: const Icon(Icons.info_outline),
                          label: const Text('Device Help'),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Ensure Bluetooth is ON and device is charged.')),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // -------- Profile Section --------
          Text('Profile', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.person_outline),
                  title: const Text('Name'),
                  subtitle: Text(_name),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _editText(
                    title: 'Edit Name',
                    initial: _name,
                    onSave: (v) => _name = v.isEmpty ? _name : v,
                  ),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.cake_outlined),
                  title: const Text('Age'),
                  subtitle: Text('$_age'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _editText(
                    title: 'Edit Age',
                    initial: '$_age',
                    keyboardType: TextInputType.number,
                    onSave: (v) {
                      final n = int.tryParse(v);
                      if (n != null && n > 0) _age = n;
                    },
                  ),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.monitor_heart_outlined),
                  title: const Text('Condition'),
                  subtitle: Text(_condition),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _editText(
                    title: 'Edit Condition',
                    initial: _condition,
                    onSave: (v) => _condition = v.isEmpty ? _condition : v,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // -------- Preferences Section --------
          Text('Preferences', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Column(
              children: [
                SwitchListTile(
                  secondary: const Icon(Icons.notifications_active_outlined),
                  title: const Text('Notifications'),
                  subtitle: const Text('Dose reminders, device alerts'),
                  value: _notifications,
                  onChanged: (v) {
                    setState(() => _notifications = v);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(v ? 'Notifications enabled' : 'Notifications disabled')),
                    );
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.brightness_6_outlined),
                  title: const Text('Theme'),
                  subtitle: Text(_themeMode == ThemeMode.dark ? 'Dark' : 'Light'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: _pickTheme,
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.support_agent_outlined),
                  title: const Text('Help & Support'),
                  subtitle: const Text('FAQs, Contact, Troubleshooting'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      showDragHandle: true,
                      builder: (ctx) => Padding(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text('Help & Support', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                            SizedBox(height: 12),
                            Text('• Make sure Bluetooth is enabled on your phone.'),
                            Text('• Charge the AirTrack clip to at least 20%.'),
                            Text('• Hold the power button on the clip for 3 seconds to pair.'),
                            SizedBox(height: 8),
                            Text('For assistance: support@airtrack.app'),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


//class _SettingsPage extends StatelessWidget {
  //const _SettingsPage();

  //@override
  //Widget build(BuildContext context) {
    //return const Center(
      //child: Text(
       // 'Settings — profile, BLE, preferences',
       // textAlign: TextAlign.center,
      //),
   // );
 // }
//}
