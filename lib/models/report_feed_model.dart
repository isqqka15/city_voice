// Model only: no Flutter material widgets required here.

/// Report model for the social feed
class Report {
  final String id;
  final String userId;
  final String userName;
  final String userAvatar;
  final String content;
  final String? imageUrl;
  final DateTime createdAt;
  final int likes;
  final int comments;
  final bool isLiked;
  final ReportType type;
  final bool isNew;

  Report({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userAvatar,
    required this.content,
    this.imageUrl,
    required this.createdAt,
    required this.likes,
    required this.comments,
    required this.isLiked,
    required this.type,
    this.isNew = false,
  });

  /// Create a copy with modifications
  Report copyWith({
    bool? isLiked,
    int? likes,
    int? comments,
  }) {
    return Report(
      id: id,
      userId: userId,
      userName: userName,
      userAvatar: userAvatar,
      content: content,
      imageUrl: imageUrl,
      createdAt: createdAt,
      likes: likes ?? this.likes,
      comments: comments ?? this.comments,
      isLiked: isLiked ?? this.isLiked,
      type: type,
      isNew: isNew,
    );
  }
}

/// Enum for different report types
enum ReportType {
  text,
  image,
  link,
}

/// Sample data for testing
class ReportFeedSampleData {
  static List<Report> getSampleReports() {
    return [
      Report(
        id: '1',
        userId: 'user1',
        userName: 'John Doe',
        userAvatar: 'assets/avatars/avatar1.png',
        content: 'The streetlight on Main Street is broken. It hasn\'t been working for weeks. This is a safety hazard for pedestrians at night. Needs urgent repair.',
        imageUrl: null,
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        likes: 24,
        comments: 8,
        isLiked: false,
        type: ReportType.text,
        isNew: true,
      ),
      Report(
        id: '2',
        userId: 'user2',
        userName: 'Sarah Smith',
        userAvatar: 'assets/avatars/avatar2.png',
        content: 'Pothole damage on 5th Avenue near the intersection. Very dangerous for cyclists and motorcycles.',
        imageUrl: null,
        createdAt: DateTime.now().subtract(const Duration(hours: 4)),
        likes: 45,
        comments: 12,
        isLiked: true,
        type: ReportType.image,
      ),
      Report(
        id: '3',
        userId: 'user3',
        userName: 'Mike Johnson',
        userAvatar: 'assets/avatars/avatar3.png',
        content: 'Garbage overflow at the corner waste bin. The street smells bad and looks dirty.',
        imageUrl: null,
        createdAt: DateTime.now().subtract(const Duration(hours: 6)),
        likes: 18,
        comments: 5,
        isLiked: false,
        type: ReportType.text,
      ),
      Report(
        id: '4',
        userId: 'user4',
        userName: 'Emily Brown',
        userAvatar: 'assets/avatars/avatar4.png',
        content: 'Water leak from underground pipe causing flooding on Roosevelt Street. Vehicles are getting stuck.',
        imageUrl: null,
        createdAt: DateTime.now().subtract(const Duration(hours: 8)),
        likes: 67,
        comments: 23,
        isLiked: true,
        type: ReportType.image,
        isNew: true,
      ),
      Report(
        id: '5',
        userId: 'user5',
        userName: 'Alex Wilson',
        userAvatar: 'assets/avatars/avatar5.png',
        content: 'Suggestion: Add more benches for elderly citizens in the park area. Current seating is insufficient.',
        imageUrl: null,
        createdAt: DateTime.now().subtract(const Duration(hours: 12)),
        likes: 32,
        comments: 9,
        isLiked: false,
        type: ReportType.text,
      ),
    ];
  }
}
