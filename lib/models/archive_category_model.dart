class ArchiveCategory {
  final String id;
  final String userId;
  final String name;
  final DateTime createdAt;

  ArchiveCategory({
    required this.id,
    required this.userId,
    required this.name,
    required this.createdAt,
  });
  factory ArchiveCategory.fromMap(
    Map<String, dynamic>? data,
    String documentId,
  ) {
    data = data ?? {};

    return ArchiveCategory(
      id: documentId,
      userId: data['userId']?.toString() ?? '',
      name: data['name']?.toString() ?? '',
      createdAt: data['createdAt'] != null
          ? (data['createdAt'] is DateTime
                ? data['createdAt']
                : DateTime.parse(data['createdAt'].toString()))
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {'userId': userId, 'name': name, 'createdAt': createdAt};
  }
}
