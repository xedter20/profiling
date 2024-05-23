class Announcement {
  String? title;
  String? content;
  DateTime? datePosted;
  String? postedBy;
  String? id;

  Announcement({
    required this.title,
    required this.content,
    required this.datePosted,
    required this.postedBy,
    this.id,
  });

  Announcement.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    content = json['content'];
    datePosted = json['datePosted'].toDate();
    postedBy = json['postedBy'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['content'] = content;
    data['datePosted'] = datePosted;
    data['postedBy'] = postedBy;
    return data;
  }
}
