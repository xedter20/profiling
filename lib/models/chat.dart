class ChatMessage {
  String? message;
  String? senderName;
  DateTime? dateTime;
  bool? isAdmin;

  ChatMessage({
    required this.message,
    required this.senderName,
    required this.dateTime,
    required this.isAdmin,
  });

  ChatMessage.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    senderName = json['senderName'];
    dateTime = json['dateTime'].toDate();
    isAdmin = json['isAdmin'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    data['senderName'] = senderName;
    data['dateTime'] = dateTime;
    data['isAdmin'] = isAdmin;

    return data;
  }
}
