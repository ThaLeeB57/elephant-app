class Task {
  String? id;
  late String content;
  late bool completed;
  String? title;

  Task(
      {required this.id,
      required this.content,
      required this.completed,
      this.title});

  Task.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    content = json['content'] ?? "";
    completed = json['completed'] ?? false;
    title = json['title'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['content'] = this.content;
    data['completed'] = this.completed;
    data['title'] = this.title;
    return data;
  }

  @override
  String toString() {
    return 'Task{id: $id, content: $content, completed: $completed, title: $title}';
  }
}
