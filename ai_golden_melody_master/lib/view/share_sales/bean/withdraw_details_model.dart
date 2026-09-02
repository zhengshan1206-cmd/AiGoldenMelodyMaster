class WithdrawDetailsApiResponse {
  final int status;
  final String message;
  final DataWrapper data;

  const WithdrawDetailsApiResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory WithdrawDetailsApiResponse.fromJson(Map<String, dynamic> json) {
    return WithdrawDetailsApiResponse(
      status: json['status'] as int,
      message: json['message'] as String,
      data: DataWrapper.fromJson(json['data'] as Map<String, dynamic>),
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

class DataWrapper {
  final int total;
  final int perPage;
  final int currentPage;
  final int lastPage;
  final List<WithdrawDetailsItem> data;

  const DataWrapper({
    required this.total,
    required this.perPage,
    required this.currentPage,
    required this.lastPage,
    required this.data,
  });

  factory DataWrapper.fromJson(Map<String, dynamic> json) {
    final List<dynamic> dataList = json['data'] as List<dynamic>;
    final List<WithdrawDetailsItem> items = dataList
        .map((dynamic item) => WithdrawDetailsItem.fromJson(item as Map<String, dynamic>))
        .toList();

    return DataWrapper(
      total: json['total'] as int,
      perPage: json['per_page'] as int,
      currentPage: json['current_page'] as int,
      lastPage: json['last_page'] as int,
      data: items,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total': total,
      'per_page': perPage,
      'current_page': currentPage,
      'last_page': lastPage,
      'data': data.map((item) => item.toJson()).toList(),
    };
  }
}

class WithdrawDetailsItem {
  final int id;
  final int status;
  final int type;
  final String amount;
  final String createdAt;

  const WithdrawDetailsItem({
    required this.id,
    required this.status,
    required this.type,
    required this.amount,
    required this.createdAt,
  });

  factory WithdrawDetailsItem.fromJson(Map<String, dynamic> json) {
    return WithdrawDetailsItem(
      id: json['id'] as int,
      status: json['status'] as int,
      type: json['type'] as int,
      amount: json['amount'] ,
      createdAt: json['created_at'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'status': status,
      'type': type,
      'amount': amount,
      'created_at': createdAt,
    };
  }
}
    