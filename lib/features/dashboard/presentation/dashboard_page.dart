import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shakti_hormann/core/core.dart';
import 'package:shakti_hormann/features/dashboard/data/dashboardrepo.dart';
import 'package:shakti_hormann/features/dashboard/model/gate_dashboard_response.dart';
import 'package:shakti_hormann/features/dashboard/model/packing_dashboard_stats.dart';
import 'package:shakti_hormann/features/dashboard/presentation/bloc_provider.dart';
import 'package:shakti_hormann/styles/app_color.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

/// Hörmann operations dashboard — gate KPIs + Scanning & Packaging analytics.
class AppDashboardPage extends StatefulWidget {
  const AppDashboardPage({super.key});

  @override
  State<AppDashboardPage> createState() => _AppDashboardPageState();
}

class _AppDashboardPageState extends State<AppDashboardPage> {
  late final DashBoardList dashboardCubit;
  _PlantFilter _filter = _PlantFilter.all;
  PackingDashboardStats _packing = PackingDashboardStats.empty();
  bool _packingLoading = true;

  static const _bg = Color(0xFFF7F8FA);
  static const _ink = Color(0xFF0E1446);
  static const _muted = Color(0xFF5B6178);
  static const _accent = Color(0xFFF2A93E);
  static const _entry = Color(0xFF1A7A5C);
  static const _exit = Color(0xFFC45C3E);
  static const _jaipur = Color(0xFF163A6B);
  static const _medchal = Color(0xFF2F6FED);

  @override
  void initState() {
    super.initState();
    dashboardCubit = DashBoardBlocProvider.get().getDash();
    dashboardCubit.request(null);
    _loadPacking();
  }

  Future<void> _reload() async {
    await Future.wait([
      dashboardCubit.request(null),
      _loadPacking(),
    ]);
  }

  Future<void> _loadPacking() async {
    setState(() => _packingLoading = true);
    final result = await $sl<Dashboardrepo>().getPackingStats();
    if (!mounted) return;
    result.fold(
      (_) => setState(() {
        _packing = PackingDashboardStats.empty();
        _packingLoading = false;
      }),
      (stats) => setState(() {
        _packing = stats;
        _packingLoading = false;
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        bottom: false,
        child: BlocBuilder<DashBoardList, DashBoardState>(
          bloc: dashboardCubit,
          builder: (context, state) {
            return state.when(
              loading: () => _DashboardShell(
                onRefresh: _reload,
                child: const _DashboardSkeleton(),
              ),
              initial: () => _DashboardShell(
                onRefresh: _reload,
                child: const _DashboardSkeleton(),
              ),
              failure: (err) => _DashboardShell(
                onRefresh: _reload,
                child: _DashboardStatus(
                  icon: Icons.cloud_off_outlined,
                  title: 'Could not load dashboard',
                  message: err.error.isNotEmpty
                      ? err.error
                      : 'Check your connection and try again.',
                  actionLabel: 'Try again',
                  onAction: _reload,
                ),
              ),
              success: (data) {
                final plants = data.message.data;
                final jaipur = _plantOf(
                  plants,
                  'Shakti Hormann Private Limited Jaipur',
                );
                final medchal = _plantOf(
                  plants,
                  'Shakti Hormann Private Limited Medchal',
                );
                return _DashboardShell(
                  onRefresh: _reload,
                  child: RefreshIndicator(
                    color: AppColors.darkBlue,
                    onRefresh: _reload,
                    child: _DashboardBody(
                      jaipur: jaipur,
                      medchal: medchal,
                      hasPlantData: plants.isNotEmpty,
                      filter: _filter,
                      onFilterChanged: (f) => setState(() => _filter = f),
                      packing: _packing,
                      packingLoading: _packingLoading,
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  PlantDashboard _plantOf(Map<String, PlantDashboard> plants, String key) {
    return plants[key] ?? PlantDashboardExtension.empty();
  }
}

enum _PlantFilter { all, jaipur, medchal }

extension on _PlantFilter {
  String get label => switch (this) {
        _PlantFilter.all => 'All plants',
        _PlantFilter.jaipur => 'Jaipur',
        _PlantFilter.medchal => 'Medchal',
      };
}

// ─── Shell / chrome ─────────────────────────────────────────────────────────

class _DashboardShell extends StatelessWidget {
  const _DashboardShell({required this.onRefresh, required this.child});

  final Future<void> Function() onRefresh;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final pad = Responsive.pagePadding(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(pad.left, 8, pad.right, 4),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Operations',
                      style: TextStyle(
                        fontFamily: 'Urbanist',
                        fontSize: Responsive.isTablet(context) ? 26 : 22,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.4,
                        color: _AppDashboardPageState._ink,
                        height: 1.1,
                      ),
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      'Gate flow · Jaipur & Medchal',
                      style: TextStyle(
                        fontFamily: 'Urbanist',
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: _AppDashboardPageState._muted,
                      ),
                    ),
                  ],
                ),
              ),
              Material(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                child: InkWell(
                  onTap: onRefresh,
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    width: 44,
                    height: 44,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFE8ECF4)),
                    ),
                    child: const Icon(
                      Icons.refresh_rounded,
                      color: AppColors.darkBlue,
                      size: 22,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(child: child),
      ],
    );
  }
}

// ─── Body ───────────────────────────────────────────────────────────────────

class _DashboardBody extends StatelessWidget {
  const _DashboardBody({
    required this.jaipur,
    required this.medchal,
    required this.hasPlantData,
    required this.filter,
    required this.onFilterChanged,
    required this.packing,
    required this.packingLoading,
  });

  final PlantDashboard jaipur;
  final PlantDashboard medchal;
  final bool hasPlantData;
  final _PlantFilter filter;
  final ValueChanged<_PlantFilter> onFilterChanged;
  final PackingDashboardStats packing;
  final bool packingLoading;

  PlantDashboard get _active {
    return switch (filter) {
      _PlantFilter.jaipur => jaipur,
      _PlantFilter.medchal => medchal,
      _PlantFilter.all => PlantDashboard(
          gateEntries: jaipur.gateEntries + medchal.gateEntries,
          gateExits: jaipur.gateExits + medchal.gateExits,
          daywise: _mergeDaywise(jaipur.daywise, medchal.daywise),
        ),
    };
  }

  static List<Daywise> _mergeDaywise(List<Daywise> a, List<Daywise> b) {
    final map = <String, Daywise>{};
    for (final d in [...a, ...b]) {
      final prev = map[d.day];
      if (prev == null) {
        map[d.day] = d;
      } else {
        map[d.day] = Daywise(
          day: d.day,
          entries: prev.entries + d.entries,
          exits: prev.exits + d.exits,
        );
      }
    }
    final keys = map.keys.toList()..sort();
    return [for (final k in keys) map[k]!];
  }

  @override
  Widget build(BuildContext context) {
    final pad = Responsive.pagePadding(context);
    final active = _active;
    final metrics = _GateMetrics.from(active);
    final isTablet = Responsive.isTablet(context);
    final bottomClearance = Responsive.homeBottomClearance(context);

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(
        parent: ClampingScrollPhysics(),
      ),
      padding: EdgeInsets.fromLTRB(pad.left, 8, pad.right, bottomClearance),
      children: [
        if (!hasPlantData) const _EmptyBanner(),
        _HeroSummary(metrics: metrics, filter: filter),
        const SizedBox(height: 14),
        _PlantFilterBar(value: filter, onChanged: onFilterChanged),
        const SizedBox(height: 16),
        _KpiGrid(metrics: metrics),
        const SizedBox(height: 18),
        if (isTablet)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: _DaywiseChartCard(
                  title: '${filter.label} · daily gate traffic',
                  data: active.daywise,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: _RatioCard(metrics: metrics),
              ),
            ],
          )
        else ...[
          _DaywiseChartCard(
            title: '${filter.label} · daily gate traffic',
            data: active.daywise,
          ),
          const SizedBox(height: 12),
          _RatioCard(metrics: metrics),
        ],
        if (filter == _PlantFilter.all) ...[
          const SizedBox(height: 18),
          _PlantCompareCard(jaipur: jaipur, medchal: medchal),
        ],
        const SizedBox(height: 18),
        _InsightRow(metrics: metrics),
        const SizedBox(height: 22),
        const _SectionLabel(
          title: 'Logistics pipeline',
          subtitle: 'From gate-in to proof of delivery',
        ),
        const SizedBox(height: 10),
        const _LogisticsPipeline(),
        const SizedBox(height: 22),
        const _SectionLabel(
          title: 'Scanning & packaging',
          subtitle: 'Live shop-floor document counts & trends',
        ),
        const SizedBox(height: 10),
        if (packingLoading)
          const _PackingSkeleton()
        else
          _PackingAnalytics(stats: packing),
      ],
    );
  }
}

// ─── Metrics ────────────────────────────────────────────────────────────────

class _GateMetrics {
  const _GateMetrics({
    required this.entries,
    required this.exits,
    required this.net,
    required this.avgEntries,
    required this.avgExits,
    required this.busiestDay,
    required this.quietestDay,
    required this.entryShare,
    required this.trendEntries,
    required this.daysTracked,
  });

  factory _GateMetrics.from(PlantDashboard p) {
    final days = p.daywise;
    final n = days.isEmpty ? 1 : days.length;
    Daywise? busy;
    Daywise? quiet;
    for (final d in days) {
      final total = d.entries + d.exits;
      if (total == 0) continue;
      if (busy == null || total > (busy.entries + busy.exits)) busy = d;
      if (quiet == null || total < (quiet.entries + quiet.exits)) quiet = d;
    }
    final total = p.gateEntries + p.gateExits;
    final share = total == 0 ? 0.5 : p.gateEntries / total;

    var trend = 0;
    if (days.length >= 2) {
      final last = days.last.entries;
      final prev = days[days.length - 2].entries;
      trend = last - prev;
    }

    return _GateMetrics(
      entries: p.gateEntries,
      exits: p.gateExits,
      net: p.gateEntries - p.gateExits,
      avgEntries: p.gateEntries / n,
      avgExits: p.gateExits / n,
      busiestDay: busy,
      quietestDay: quiet,
      entryShare: share,
      trendEntries: trend,
      daysTracked: days.length,
    );
  }

  final int entries;
  final int exits;
  final int net;
  final double avgEntries;
  final double avgExits;
  final Daywise? busiestDay;
  final Daywise? quietestDay;
  final double entryShare;
  final int trendEntries;
  final int daysTracked;
}

String _shortDay(String day) {
  if (day.length >= 10) return day.substring(8); // DD from YYYY-MM-DD
  if (day.length >= 8) return day.substring(day.length - 2);
  return day;
}

String _prettyDay(String day) {
  if (day.length >= 10) {
    return '${day.substring(8, 10)}/${day.substring(5, 7)}';
  }
  return day;
}

// ─── Widgets ────────────────────────────────────────────────────────────────

class _EmptyBanner extends StatelessWidget {
  const _EmptyBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF6E5),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _AppDashboardPageState._accent),
      ),
      child: const Row(
        children: [
          Icon(Icons.info_outline_rounded, color: Color(0xFF9A6A12), size: 20),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'No plant activity yet. Showing an empty gate summary for Jaipur and Medchal.',
              style: TextStyle(
                fontFamily: 'Urbanist',
                fontSize: 13,
                height: 1.3,
                color: _AppDashboardPageState._ink,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroSummary extends StatelessWidget {
  const _HeroSummary({required this.metrics, required this.filter});

  final _GateMetrics metrics;
  final _PlantFilter filter;

  @override
  Widget build(BuildContext context) {
    final totalMoves = metrics.entries + metrics.exits;
    final trendUp = metrics.trendEntries >= 0;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0E1446), Color(0xFF163A6B), Color(0xFF1F4F8C)],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0E1446).withValues(alpha: 0.22),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  filter.label.toUpperCase(),
                  style: const TextStyle(
                    fontFamily: 'Urbanist',
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.6,
                    color: Colors.white,
                  ),
                ),
              ),
              const Spacer(),
              Icon(
                trendUp ? Icons.trending_up_rounded : Icons.trending_down_rounded,
                color: trendUp
                    ? const Color(0xFF6EEFCF)
                    : const Color(0xFFFFAE9A),
                size: 20,
              ),
              const SizedBox(width: 4),
              Text(
                '${trendUp ? '+' : ''}${metrics.trendEntries} vs prior day',
                style: TextStyle(
                  fontFamily: 'Urbanist',
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.white.withValues(alpha: 0.85),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            '$totalMoves',
            style: TextStyle(
              fontFamily: 'Urbanist',
              fontSize: Responsive.isTablet(context) ? 44 : 38,
              fontWeight: FontWeight.w800,
              height: 1,
              letterSpacing: -1,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'total gate movements · ${metrics.daysTracked} day window',
            style: TextStyle(
              fontFamily: 'Urbanist',
              fontSize: 13,
              color: Colors.white.withValues(alpha: 0.72),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _HeroChip(
                label: 'Entries',
                value: '${metrics.entries}',
                color: const Color(0xFF6EEFCF),
              ),
              const SizedBox(width: 8),
              _HeroChip(
                label: 'Exits',
                value: '${metrics.exits}',
                color: const Color(0xFFFFAE9A),
              ),
              const SizedBox(width: 8),
              _HeroChip(
                label: 'Net on yard',
                value: metrics.net >= 0 ? '+${metrics.net}' : '${metrics.net}',
                color: _AppDashboardPageState._accent,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeroChip extends StatelessWidget {
  const _HeroChip({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Urbanist',
                fontSize: 11,
                color: Colors.white.withValues(alpha: 0.65),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: TextStyle(
                fontFamily: 'Urbanist',
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PlantFilterBar extends StatelessWidget {
  const _PlantFilterBar({required this.value, required this.onChanged});

  final _PlantFilter value;
  final ValueChanged<_PlantFilter> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE8ECF4)),
      ),
      child: Row(
        children: [
          for (final f in _PlantFilter.values)
            Expanded(
              child: GestureDetector(
                onTap: () => onChanged(f),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  curve: Curves.easeOut,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: value == f
                        ? AppColors.darkBlue
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    f.label,
                    style: TextStyle(
                      fontFamily: 'Urbanist',
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: value == f
                          ? Colors.white
                          : _AppDashboardPageState._muted,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _KpiGrid extends StatelessWidget {
  const _KpiGrid({required this.metrics});

  final _GateMetrics metrics;

  @override
  Widget build(BuildContext context) {
    final cols = Responsive.isTablet(context) ? 4 : 2;
    final items = [
      _KpiData(
        'Gate entries',
        '${metrics.entries}',
        Icons.login_rounded,
        _AppDashboardPageState._entry,
        'Avg ${metrics.avgEntries.toStringAsFixed(1)}/day',
      ),
      _KpiData(
        'Gate exits',
        '${metrics.exits}',
        Icons.logout_rounded,
        _AppDashboardPageState._exit,
        'Avg ${metrics.avgExits.toStringAsFixed(1)}/day',
      ),
      _KpiData(
        'Net on site',
        metrics.net >= 0 ? '+${metrics.net}' : '${metrics.net}',
        Icons.swap_vert_rounded,
        AppColors.darkBlue,
        metrics.net >= 0 ? 'More in than out' : 'More out than in',
      ),
      _KpiData(
        'Entry share',
        '${(metrics.entryShare * 100).round()}%',
        Icons.pie_chart_outline_rounded,
        _AppDashboardPageState._accent,
        'Of all movements',
      ),
    ];

    return LayoutBuilder(
      builder: (context, c) {
        final gap = 10.0;
        final w = (c.maxWidth - gap * (cols - 1)) / cols;
        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: [
            for (final item in items)
              SizedBox(
                width: w,
                child: _KpiTile(data: item),
              ),
          ],
        );
      },
    );
  }
}

class _KpiData {
  const _KpiData(this.title, this.value, this.icon, this.color, this.caption);
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final String caption;
}

class _KpiTile extends StatelessWidget {
  const _KpiTile({required this.data});
  final _KpiData data;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE8ECF4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: data.color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(data.icon, color: data.color, size: 18),
          ),
          const SizedBox(height: 12),
          Text(
            data.title,
            style: const TextStyle(
              fontFamily: 'Urbanist',
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: _AppDashboardPageState._muted,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            data.value,
            style: TextStyle(
              fontFamily: 'Urbanist',
              fontSize: 24,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
              color: data.color,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            data.caption,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontFamily: 'Urbanist',
              fontSize: 11,
              color: Color(0xFF8A90A2),
            ),
          ),
        ],
      ),
    );
  }
}

class _DaywiseChartCard extends StatelessWidget {
  const _DaywiseChartCard({required this.title, required this.data});

  final String title;
  final List<Daywise> data;

  @override
  Widget build(BuildContext context) {
    final maxY = _maxY(data);
    final interval = maxY <= 5 ? 1.0 : (maxY / 5).ceilToDouble();

    return Container(
      height: Responsive.isTablet(context) ? 300 : 280,
      padding: const EdgeInsets.fromLTRB(12, 14, 12, 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE8ECF4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              title,
              style: const TextStyle(
                fontFamily: 'Urbanist',
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: _AppDashboardPageState._ink,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Expanded(
            child: data.every((d) => d.entries == 0 && d.exits == 0)
                ? const _ChartEmpty()
                : SfCartesianChart(
                    margin: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                    plotAreaBorderWidth: 0,
                    primaryXAxis: CategoryAxis(
                      majorGridLines: const MajorGridLines(width: 0),
                      axisLine: const AxisLine(width: 0),
                      labelStyle: const TextStyle(
                        fontFamily: 'Urbanist',
                        fontSize: 11,
                        color: _AppDashboardPageState._muted,
                      ),
                    ),
                    primaryYAxis: NumericAxis(
                      majorGridLines: MajorGridLines(
                        width: 0.6,
                        color: Colors.black.withValues(alpha: 0.06),
                      ),
                      axisLine: const AxisLine(width: 0),
                      minimum: 0,
                      maximum: maxY,
                      interval: interval,
                      labelStyle: const TextStyle(
                        fontFamily: 'Urbanist',
                        fontSize: 11,
                        color: _AppDashboardPageState._muted,
                      ),
                    ),
                    legend: const Legend(
                      isVisible: true,
                      position: LegendPosition.top,
                      overflowMode: LegendItemOverflowMode.wrap,
                      textStyle: TextStyle(
                        fontFamily: 'Urbanist',
                        fontSize: 12,
                      ),
                    ),
                    tooltipBehavior: TooltipBehavior(enable: true),
                    series: <CartesianSeries<Daywise, String>>[
                      ColumnSeries<Daywise, String>(
                        name: 'Entries',
                        color: _AppDashboardPageState._entry,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(5),
                        ),
                        width: 0.4,
                        spacing: 0.15,
                        dataSource: data,
                        xValueMapper: (d, _) => _shortDay(d.day),
                        yValueMapper: (d, _) => d.entries,
                      ),
                      ColumnSeries<Daywise, String>(
                        name: 'Exits',
                        color: _AppDashboardPageState._exit,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(5),
                        ),
                        width: 0.4,
                        spacing: 0.15,
                        dataSource: data,
                        xValueMapper: (d, _) => _shortDay(d.day),
                        yValueMapper: (d, _) => d.exits,
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  double _maxY(List<Daywise> data) {
    if (data.isEmpty) return 5;
    var maxValue = 0;
    for (final d in data) {
      maxValue = math.max(maxValue, math.max(d.entries, d.exits));
    }
    if (maxValue == 0) return 5;
    return maxValue + (maxValue * 0.25);
  }
}

class _ChartEmpty extends StatelessWidget {
  const _ChartEmpty({this.message = 'No movements in this window yet'});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontFamily: 'Urbanist',
            fontSize: 13,
            color: _AppDashboardPageState._muted,
          ),
        ),
      ),
    );
  }
}

class _RatioCard extends StatelessWidget {
  const _RatioCard({required this.metrics});
  final _GateMetrics metrics;

  @override
  Widget build(BuildContext context) {
    final total = metrics.entries + metrics.exits;
    return Container(
      height: Responsive.isTablet(context) ? 300 : 220,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE8ECF4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Entry vs exit mix',
            style: TextStyle(
              fontFamily: 'Urbanist',
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: _AppDashboardPageState._ink,
            ),
          ),
          const SizedBox(height: 4),
          Expanded(
            child: total == 0
                ? const _ChartEmpty()
                : SfCircularChart(
                    margin: EdgeInsets.zero,
                    legend: const Legend(
                      isVisible: true,
                      position: LegendPosition.bottom,
                      textStyle: TextStyle(
                        fontFamily: 'Urbanist',
                        fontSize: 12,
                      ),
                    ),
                    series: <CircularSeries<_Slice, String>>[
                      DoughnutSeries<_Slice, String>(
                        dataSource: [
                          _Slice('Entries', metrics.entries,
                              _AppDashboardPageState._entry),
                          _Slice('Exits', metrics.exits,
                              _AppDashboardPageState._exit),
                        ],
                        xValueMapper: (s, _) => s.label,
                        yValueMapper: (s, _) => s.value,
                        pointColorMapper: (s, _) => s.color,
                        innerRadius: '62%',
                        radius: '88%',
                        dataLabelSettings: const DataLabelSettings(
                          isVisible: false,
                        ),
                      ),
                    ],
                    annotations: <CircularChartAnnotation>[
                      CircularChartAnnotation(
                        widget: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '$total',
                              style: const TextStyle(
                                fontFamily: 'Urbanist',
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                                color: _AppDashboardPageState._ink,
                              ),
                            ),
                            const Text(
                              'moves',
                              style: TextStyle(
                                fontFamily: 'Urbanist',
                                fontSize: 11,
                                color: _AppDashboardPageState._muted,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}

class _Slice {
  const _Slice(this.label, this.value, this.color);
  final String label;
  final int value;
  final Color color;
}

class _PlantCompareCard extends StatelessWidget {
  const _PlantCompareCard({required this.jaipur, required this.medchal});

  final PlantDashboard jaipur;
  final PlantDashboard medchal;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE8ECF4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Plant comparison',
            style: TextStyle(
              fontFamily: 'Urbanist',
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: _AppDashboardPageState._ink,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Side-by-side gate volume for the two Hörmann plants',
            style: TextStyle(
              fontFamily: 'Urbanist',
              fontSize: 12,
              color: _AppDashboardPageState._muted,
            ),
          ),
          const SizedBox(height: 14),
          _CompareBar(
            label: 'Jaipur',
            entries: jaipur.gateEntries,
            exits: jaipur.gateExits,
            color: _AppDashboardPageState._jaipur,
            maxTotal: math.max(
              jaipur.gateEntries + jaipur.gateExits,
              medchal.gateEntries + medchal.gateExits,
            ),
          ),
          const SizedBox(height: 12),
          _CompareBar(
            label: 'Medchal',
            entries: medchal.gateEntries,
            exits: medchal.gateExits,
            color: _AppDashboardPageState._medchal,
            maxTotal: math.max(
              jaipur.gateEntries + jaipur.gateExits,
              medchal.gateEntries + medchal.gateExits,
            ),
          ),
        ],
      ),
    );
  }
}

class _CompareBar extends StatelessWidget {
  const _CompareBar({
    required this.label,
    required this.entries,
    required this.exits,
    required this.color,
    required this.maxTotal,
  });

  final String label;
  final int entries;
  final int exits;
  final Color color;
  final int maxTotal;

  @override
  Widget build(BuildContext context) {
    final total = entries + exits;
    final frac = maxTotal == 0 ? 0.0 : total / maxTotal;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: const TextStyle(
                fontFamily: 'Urbanist',
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: _AppDashboardPageState._ink,
              ),
            ),
            const Spacer(),
            Text(
              '$entries in · $exits out',
              style: const TextStyle(
                fontFamily: 'Urbanist',
                fontSize: 12,
                color: _AppDashboardPageState._muted,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: SizedBox(
            height: 10,
            child: Stack(
              children: [
                Container(color: const Color(0xFFEEF1F6)),
                FractionallySizedBox(
                  widthFactor: frac.clamp(0.0, 1.0),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          color,
                          color.withValues(alpha: 0.7),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _InsightRow extends StatelessWidget {
  const _InsightRow({required this.metrics});
  final _GateMetrics metrics;

  @override
  Widget build(BuildContext context) {
    final busy = metrics.busiestDay;
    final quiet = metrics.quietestDay;
    return Row(
      children: [
        Expanded(
          child: _InsightTile(
            icon: Icons.local_fire_department_outlined,
            title: 'Busiest day',
            value: busy == null
                ? '—'
                : _prettyDay(busy.day),
            caption: busy == null
                ? 'No data'
                : '${busy.entries + busy.exits} movements',
            tint: const Color(0xFFFFF1E0),
            iconColor: const Color(0xFFC47A1A),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _InsightTile(
            icon: Icons.nightlight_outlined,
            title: 'Quietest day',
            value: quiet == null
                ? '—'
                : _prettyDay(quiet.day),
            caption: quiet == null
                ? 'No data'
                : '${quiet.entries + quiet.exits} movements',
            tint: const Color(0xFFEAF2FF),
            iconColor: AppColors.darkBlue,
          ),
        ),
      ],
    );
  }
}

class _InsightTile extends StatelessWidget {
  const _InsightTile({
    required this.icon,
    required this.title,
    required this.value,
    required this.caption,
    required this.tint,
    required this.iconColor,
  });

  final IconData icon;
  final String title;
  final String value;
  final String caption;
  final Color tint;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: tint,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor, size: 20),
          const SizedBox(height: 10),
          Text(
            title,
            style: TextStyle(
              fontFamily: 'Urbanist',
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: iconColor.withValues(alpha: 0.8),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontFamily: 'Urbanist',
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: iconColor,
            ),
          ),
          Text(
            caption,
            style: TextStyle(
              fontFamily: 'Urbanist',
              fontSize: 11,
              color: iconColor.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.title, required this.subtitle});
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontFamily: 'Urbanist',
            fontSize: Responsive.isTablet(context) ? 18 : 16,
            fontWeight: FontWeight.w800,
            color: _AppDashboardPageState._ink,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          subtitle,
          style: const TextStyle(
            fontFamily: 'Urbanist',
            fontSize: 12,
            color: _AppDashboardPageState._muted,
          ),
        ),
      ],
    );
  }
}

class _LogisticsPipeline extends StatelessWidget {
  const _LogisticsPipeline();

  static const _steps = [
    (Icons.login_rounded, 'Gate Entry'),
    (Icons.local_shipping_outlined, 'Vehicle'),
    (Icons.inventory_2_outlined, 'Loading'),
    (Icons.logout_rounded, 'Gate Exit'),
    (Icons.fact_check_outlined, 'POD'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE8ECF4)),
      ),
      child: Row(
        children: [
          for (var i = 0; i < _steps.length; i++) ...[
            if (i > 0)
              Expanded(
                child: Container(
                  height: 2,
                  margin: const EdgeInsets.only(bottom: 18),
                  color: const Color(0xFFE8ECF4),
                ),
              ),
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: AppColors.darkBlue.withValues(alpha: 0.08),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _steps[i].$1,
                      size: 18,
                      color: AppColors.darkBlue,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _steps[i].$2,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    style: const TextStyle(
                      fontFamily: 'Urbanist',
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      height: 1.15,
                      color: _AppDashboardPageState._ink,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _PackingSkeleton extends StatelessWidget {
  const _PackingSkeleton();

  @override
  Widget build(BuildContext context) {
    Widget box({double h = 110}) => Container(
          height: h,
          decoration: BoxDecoration(
            color: const Color(0xFFE8ECF4),
            borderRadius: BorderRadius.circular(16),
          ),
        );
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: box()),
            const SizedBox(width: 10),
            Expanded(child: box()),
          ],
        ),
        const SizedBox(height: 10),
        box(h: 220),
        const SizedBox(height: 10),
        box(h: 240),
      ],
    );
  }
}

class _PackingAnalytics extends StatelessWidget {
  const _PackingAnalytics({required this.stats});

  final PackingDashboardStats stats;

  @override
  Widget build(BuildContext context) {
    final isTablet = Responsive.isTablet(context);
    if (stats.modules.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE8ECF4)),
        ),
        child: const Text(
          'No packaging documents found yet.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Urbanist',
            fontSize: 13,
            color: _AppDashboardPageState._muted,
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _PackingSummaryStrip(stats: stats),
        const SizedBox(height: 12),
        _PackingModuleGrid(modules: stats.modules),
        const SizedBox(height: 12),
        if (isTablet)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _PackingStatusPie(stats: stats)),
              const SizedBox(width: 12),
              Expanded(child: _PackingModuleBar(modules: stats.modules)),
            ],
          )
        else ...[
          _PackingStatusPie(stats: stats),
          const SizedBox(height: 12),
          _PackingModuleBar(modules: stats.modules),
        ],
        const SizedBox(height: 12),
        _PackingTrendLine(daywise: stats.daywise),
        const SizedBox(height: 12),
        _PackingDraftAlert(modules: stats.modules),
      ],
    );
  }
}

class _PackingSummaryStrip extends StatelessWidget {
  const _PackingSummaryStrip({required this.stats});
  final PackingDashboardStats stats;

  @override
  Widget build(BuildContext context) {
    final tiles = [
      (
        'Total docs',
        '${stats.totalDocs}',
        Icons.inventory_2_outlined,
        AppColors.darkBlue,
      ),
      (
        'Draft',
        '${stats.totalDraft}',
        Icons.edit_note_rounded,
        _AppDashboardPageState._accent,
      ),
      (
        'Submitted',
        '${stats.totalSubmitted}',
        Icons.verified_outlined,
        _AppDashboardPageState._entry,
      ),
      (
        'Cancelled',
        '${stats.totalCancelled}',
        Icons.cancel_outlined,
        _AppDashboardPageState._exit,
      ),
    ];

    return LayoutBuilder(
      builder: (context, c) {
        final cols = Responsive.isTablet(context) ? 4 : 2;
        final gap = 10.0;
        final w = (c.maxWidth - gap * (cols - 1)) / cols;
        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: [
            for (final t in tiles)
              SizedBox(
                width: w,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(12, 12, 12, 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFE8ECF4)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 34,
                        height: 34,
                        decoration: BoxDecoration(
                          color: t.$4.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(t.$3, size: 18, color: t.$4),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              t.$1,
                              style: const TextStyle(
                                fontFamily: 'Urbanist',
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: _AppDashboardPageState._muted,
                              ),
                            ),
                            Text(
                              t.$2,
                              style: TextStyle(
                                fontFamily: 'Urbanist',
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                                color: t.$4,
                                height: 1.1,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _PackingModuleGrid extends StatelessWidget {
  const _PackingModuleGrid({required this.modules});
  final List<PackingModuleStat> modules;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, c) {
        final cols = Responsive.isLargeTablet(context)
            ? 4
            : Responsive.isTablet(context)
                ? 3
                : 2;
        final gap = 10.0;
        final w = (c.maxWidth - gap * (cols - 1)) / cols;
        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: [
            for (final m in modules)
              SizedBox(
                width: w,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFE8ECF4)),
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
                              color: Color(m.color),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              m.label,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontFamily: 'Urbanist',
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: _AppDashboardPageState._ink,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${m.total}',
                        style: TextStyle(
                          fontFamily: 'Urbanist',
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                          color: Color(m.color),
                          height: 1,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '${m.draft} draft · ${m.submitted} done',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontFamily: 'Urbanist',
                          fontSize: 11,
                          color: _AppDashboardPageState._muted,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _PackingStatusPie extends StatelessWidget {
  const _PackingStatusPie({required this.stats});
  final PackingDashboardStats stats;

  @override
  Widget build(BuildContext context) {
    final slices = <_Slice>[
      if (stats.totalDraft > 0)
        _Slice('Draft', stats.totalDraft, _AppDashboardPageState._accent),
      if (stats.totalSubmitted > 0)
        _Slice(
          'Submitted',
          stats.totalSubmitted,
          _AppDashboardPageState._entry,
        ),
      if (stats.totalCancelled > 0)
        _Slice(
          'Cancelled',
          stats.totalCancelled,
          _AppDashboardPageState._exit,
        ),
    ];

    return Container(
      height: 240,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE8ECF4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Status mix',
            style: TextStyle(
              fontFamily: 'Urbanist',
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: _AppDashboardPageState._ink,
            ),
          ),
          Expanded(
            child: slices.isEmpty
                ? const _ChartEmpty(message: 'No packing status data')
                : SfCircularChart(
                    margin: EdgeInsets.zero,
                    legend: const Legend(
                      isVisible: true,
                      position: LegendPosition.bottom,
                      textStyle: TextStyle(fontFamily: 'Urbanist', fontSize: 11),
                    ),
                    series: <CircularSeries<_Slice, String>>[
                      PieSeries<_Slice, String>(
                        dataSource: slices,
                        xValueMapper: (s, _) => s.label,
                        yValueMapper: (s, _) => s.value,
                        pointColorMapper: (s, _) => s.color,
                        explode: true,
                        explodeIndex: 0,
                        dataLabelSettings: const DataLabelSettings(
                          isVisible: true,
                          textStyle: TextStyle(
                            fontFamily: 'Urbanist',
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}

class _PackingModuleBar extends StatelessWidget {
  const _PackingModuleBar({required this.modules});
  final List<PackingModuleStat> modules;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 240,
      padding: const EdgeInsets.fromLTRB(10, 14, 10, 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE8ECF4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              'Volume by module',
              style: TextStyle(
                fontFamily: 'Urbanist',
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: _AppDashboardPageState._ink,
              ),
            ),
          ),
          Expanded(
            child: modules.every((m) => m.total == 0)
                ? const _ChartEmpty(message: 'No module volume yet')
                : SfCartesianChart(
                    margin: const EdgeInsets.only(top: 8),
                    plotAreaBorderWidth: 0,
                    primaryXAxis: CategoryAxis(
                      majorGridLines: const MajorGridLines(width: 0),
                      labelStyle: const TextStyle(
                        fontFamily: 'Urbanist',
                        fontSize: 10,
                        color: _AppDashboardPageState._muted,
                      ),
                    ),
                    primaryYAxis: NumericAxis(
                      majorGridLines: MajorGridLines(
                        width: 0.5,
                        color: Colors.black.withValues(alpha: 0.06),
                      ),
                      axisLine: const AxisLine(width: 0),
                      labelStyle: const TextStyle(
                        fontFamily: 'Urbanist',
                        fontSize: 10,
                        color: _AppDashboardPageState._muted,
                      ),
                    ),
                    tooltipBehavior: TooltipBehavior(enable: true),
                    series: <CartesianSeries<PackingModuleStat, String>>[
                      ColumnSeries<PackingModuleStat, String>(
                        name: 'Draft',
                        dataSource: modules,
                        xValueMapper: (m, _) => m.label,
                        yValueMapper: (m, _) => m.draft,
                        color: _AppDashboardPageState._accent,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(4),
                        ),
                      ),
                      ColumnSeries<PackingModuleStat, String>(
                        name: 'Submitted',
                        dataSource: modules,
                        xValueMapper: (m, _) => m.label,
                        yValueMapper: (m, _) => m.submitted,
                        color: _AppDashboardPageState._entry,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(4),
                        ),
                      ),
                    ],
                    legend: const Legend(
                      isVisible: true,
                      position: LegendPosition.bottom,
                      textStyle: TextStyle(fontFamily: 'Urbanist', fontSize: 11),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class _PackingTrendLine extends StatelessWidget {
  const _PackingTrendLine({required this.daywise});
  final List<PackingDayPoint> daywise;

  @override
  Widget build(BuildContext context) {
    final hasData = daywise.any((d) => d.created > 0 || d.submitted > 0);
    return Container(
      height: 260,
      padding: const EdgeInsets.fromLTRB(10, 14, 10, 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE8ECF4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              '30-day packing activity',
              style: TextStyle(
                fontFamily: 'Urbanist',
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: _AppDashboardPageState._ink,
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
            child: Text(
              'Documents created vs submitted (recent records)',
              style: TextStyle(
                fontFamily: 'Urbanist',
                fontSize: 11,
                color: _AppDashboardPageState._muted,
              ),
            ),
          ),
          Expanded(
            child: !hasData
                ? const _ChartEmpty(
                    message: 'No packing activity in the last 30 days',
                  )
                : SfCartesianChart(
                    margin: const EdgeInsets.only(top: 8),
                    plotAreaBorderWidth: 0,
                    primaryXAxis: CategoryAxis(
                      majorGridLines: const MajorGridLines(width: 0),
                      labelRotation: -45,
                      interval: 5,
                      labelStyle: const TextStyle(
                        fontFamily: 'Urbanist',
                        fontSize: 9,
                        color: _AppDashboardPageState._muted,
                      ),
                    ),
                    primaryYAxis: NumericAxis(
                      majorGridLines: MajorGridLines(
                        width: 0.5,
                        color: Colors.black.withValues(alpha: 0.06),
                      ),
                      axisLine: const AxisLine(width: 0),
                      labelStyle: const TextStyle(
                        fontFamily: 'Urbanist',
                        fontSize: 10,
                        color: _AppDashboardPageState._muted,
                      ),
                    ),
                    legend: const Legend(
                      isVisible: true,
                      position: LegendPosition.bottom,
                      textStyle: TextStyle(fontFamily: 'Urbanist', fontSize: 11),
                    ),
                    tooltipBehavior: TooltipBehavior(enable: true),
                    series: <CartesianSeries<PackingDayPoint, String>>[
                      SplineAreaSeries<PackingDayPoint, String>(
                        name: 'Created',
                        dataSource: daywise,
                        xValueMapper: (d, _) =>
                            d.day.length >= 10 ? d.day.substring(5) : d.day,
                        yValueMapper: (d, _) => d.created,
                        color: AppColors.darkBlue.withValues(alpha: 0.15),
                        borderColor: AppColors.darkBlue,
                        borderWidth: 2,
                      ),
                      SplineSeries<PackingDayPoint, String>(
                        name: 'Submitted',
                        dataSource: daywise,
                        xValueMapper: (d, _) =>
                            d.day.length >= 10 ? d.day.substring(5) : d.day,
                        yValueMapper: (d, _) => d.submitted,
                        color: _AppDashboardPageState._entry,
                        width: 2.5,
                        markerSettings: const MarkerSettings(
                          isVisible: true,
                          height: 4,
                          width: 4,
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}

class _PackingDraftAlert extends StatelessWidget {
  const _PackingDraftAlert({required this.modules});
  final List<PackingModuleStat> modules;

  @override
  Widget build(BuildContext context) {
    final top = [...modules]..sort((a, b) => b.draft.compareTo(a.draft));
    final focus = top.where((m) => m.draft > 0).take(3).toList();
    if (focus.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF6E5),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _AppDashboardPageState._accent),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Drafts needing attention',
            style: TextStyle(
              fontFamily: 'Urbanist',
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: _AppDashboardPageState._ink,
            ),
          ),
          const SizedBox(height: 8),
          for (final m in focus) ...[
            Row(
              children: [
                Expanded(
                  child: Text(
                    m.label,
                    style: const TextStyle(
                      fontFamily: 'Urbanist',
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: _AppDashboardPageState._ink,
                    ),
                  ),
                ),
                Text(
                  '${m.draft} open',
                  style: const TextStyle(
                    fontFamily: 'Urbanist',
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF9A6A12),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: m.total == 0 ? 0 : m.draft / m.total,
                minHeight: 6,
                backgroundColor: Colors.white,
                color: _AppDashboardPageState._accent,
              ),
            ),
            const SizedBox(height: 10),
          ],
        ],
      ),
    );
  }
}

class _DashboardStatus extends StatelessWidget {
  const _DashboardStatus({
    required this.icon,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
  });

  final IconData icon;
  final String title;
  final String message;
  final String? actionLabel;
  final Future<void> Function()? onAction;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 52, color: AppColors.darkBlue.withValues(alpha: 0.7)),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'Urbanist',
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.darkBlue,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'Urbanist',
                fontSize: 14,
                color: _AppDashboardPageState._muted,
              ),
            ),
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () => onAction!.call(),
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.darkBlue,
                ),
                child: Text(actionLabel!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _DashboardSkeleton extends StatelessWidget {
  const _DashboardSkeleton();

  @override
  Widget build(BuildContext context) {
    final pad = Responsive.pagePadding(context);
    Widget box({double h = 16, double? w, double r = 12}) => Container(
          height: h,
          width: w,
          decoration: BoxDecoration(
            color: const Color(0xFFE8ECF4),
            borderRadius: BorderRadius.circular(r),
          ),
        );

    return ListView(
      padding: EdgeInsets.fromLTRB(pad.left, 8, pad.right, 96),
      children: [
        box(h: 150, r: 20),
        const SizedBox(height: 14),
        box(h: 44, r: 14),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(child: box(h: 110, r: 16)),
            const SizedBox(width: 10),
            Expanded(child: box(h: 110, r: 16)),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(child: box(h: 110, r: 16)),
            const SizedBox(width: 10),
            Expanded(child: box(h: 110, r: 16)),
          ],
        ),
        const SizedBox(height: 16),
        box(h: 260, r: 18),
      ],
    );
  }
}
