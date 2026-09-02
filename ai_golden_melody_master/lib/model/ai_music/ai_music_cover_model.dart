class AiMusicCoverModel {
  final String coverUrl;
  final int id;
   int audit;
   int status;

   AiMusicCoverModel({
    required this.coverUrl,
    required this.id,
    required this.audit,
     required this.status,
  });

  factory AiMusicCoverModel.fromJson({required Map<String, dynamic> json}) {
    return AiMusicCoverModel(
      coverUrl: json["cover_url"],
      id: json["id"],
      audit: json["audit"],
      status: json['status'],
    );
  }
}
