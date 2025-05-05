class InfectionInfo {
  final String reason;
  final String solution;

  InfectionInfo({required this.reason, required this.solution});

  factory InfectionInfo.fromJson(Map<String, dynamic> json) {
    return InfectionInfo(
      reason: json['reason'] ?? 'No reason provided.',
      solution: json['solution'] ?? 'No solution provided.',
    );
  }
}