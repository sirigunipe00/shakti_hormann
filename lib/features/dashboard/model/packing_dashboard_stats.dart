/// Aggregated Scanning & Packaging KPIs built from live packing doctypes.
class PackingDashboardStats {
  const PackingDashboardStats({
    required this.modules,
    required this.daywise,
  });

  factory PackingDashboardStats.empty() => const PackingDashboardStats(
        modules: [],
        daywise: [],
      );

  final List<PackingModuleStat> modules;
  final List<PackingDayPoint> daywise;

  int get totalDocs =>
      modules.fold<int>(0, (sum, m) => sum + m.total);

  int get totalDraft =>
      modules.fold<int>(0, (sum, m) => sum + m.draft);

  int get totalSubmitted =>
      modules.fold<int>(0, (sum, m) => sum + m.submitted);

  int get totalCancelled =>
      modules.fold<int>(0, (sum, m) => sum + m.cancelled);
}

class PackingModuleStat {
  const PackingModuleStat({
    required this.key,
    required this.label,
    required this.doctype,
    required this.draft,
    required this.submitted,
    required this.cancelled,
    required this.color,
  });

  final String key;
  final String label;
  final String doctype;
  final int draft;
  final int submitted;
  final int cancelled;
  final int color; // ARGB

  int get total => draft + submitted + cancelled;
}

class PackingDayPoint {
  const PackingDayPoint({
    required this.day,
    required this.created,
    required this.submitted,
  });

  final String day; // yyyy-MM-dd
  final int created;
  final int submitted;
}
