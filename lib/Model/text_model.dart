class TextModel{
  late String textContent;
  late String classId;
  late String senderId;
  late String dateTime;

  TextModel(this.textContent, this.classId, this.senderId, this.dateTime);

  Map<dynamic, dynamic> toJson() => <dynamic, dynamic>{
    'TextContent': textContent,
    'Class_or_ChatId': classId,
    'SenderId': senderId,
    'DateTimeOfMessage': dateTime
  };
}