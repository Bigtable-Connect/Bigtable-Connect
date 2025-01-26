class NotificationModel {
  late String classId;
  late String senderId;
  late String textId;
  late String mediaId;

  NotificationModel(this.classId, this.senderId, this.textId, this.mediaId);

  Map<dynamic, dynamic> toJson() => <dynamic, dynamic> {
    'Class/ChatId': classId,
    'SenderId': senderId,
    'TextId': textId,
    'MediaId': mediaId
  };
}