class AiMusicCoverResponseModel {
  final int status;
  final String message;
  final DataModel data;

  AiMusicCoverResponseModel(
      {required this.status, required this.message, required this.data});

  factory AiMusicCoverResponseModel.fromJson(Map<String, dynamic> json) {
    return AiMusicCoverResponseModel(
      status: json['status'] as int,
      message: json['message'] as String,
      data: DataModel.fromJson(json['data'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data.toJson(),
    };
  }
}

class DataModel {
  final int total;
  final int perPage;
  final int currentPage;
  final int lastPage;
  final List<DataDetailModel> data;

  DataModel({
    required this.total,
    required this.perPage,
    required this.currentPage,
    required this.lastPage,
    required this.data,
  });

  factory DataModel.fromJson(Map<String, dynamic> json) {
    List<DataDetailModel> data = [];
    dynamic jsonData = json["data"];
    if (jsonData != null) {
      jsonData = jsonData as List;
      if (jsonData.isNotEmpty) {
        for (var e in jsonData) {
          data.add(DataDetailModel.fromJson(e));
        }
      }
    }
    return DataModel(
      total: json['total'] as int,
      perPage: json['per_page'] as int,
      currentPage: json['current_page'] as int,
      lastPage: json['last_page'] as int,
      // data: List<DataDetailModel>.from(
      //   json['data'] as List,
      //   map: (item) => DataDetailModel.fromJson(item as Map<String, dynamic>),
      // ),
      data: data,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total': total,
      'per_page': perPage,
      'current_page': currentPage,
      'last_page': lastPage,
      'data': data.map((e) => e.toJson()).toList(),
    };
  }
}

class DataDetailModel {
  final int id;
  final int status;
  final int audit;
  final String coverUrl;
  final String taskId;

  DataDetailModel({
    required this.id,
    required this.status,
    required this.audit,
    required this.coverUrl,
    required this.taskId,
  });

  factory DataDetailModel.fromJson(Map<String, dynamic> json) {
    return DataDetailModel(
      id: json['id'] as int,
      status: json['status'] as int,
      audit: json['audit'] as int,
      coverUrl: json['cover_url'] as String,
      taskId: json["task_id"]??"",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'status': status,
      'audit': audit,
      'cover_url': coverUrl,
      "task_id":taskId,
    };
  }
}

class AiMusicCoverTaskModel {
  String taskId;
  int dataId;
  AiMusicCoverTaskModel({
    required this.dataId,
    required this.taskId,
  });

  factory AiMusicCoverTaskModel.fromJson(
      {required String taskId, required int dataId}) {
    return AiMusicCoverTaskModel(dataId: dataId, taskId: taskId);
  }
}
