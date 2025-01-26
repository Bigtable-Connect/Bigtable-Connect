class ChatModel{
  late String senderId;
  late String participantId;

  ChatModel(this.senderId, this.participantId);

  Map<dynamic, dynamic> toJson() => <dynamic, dynamic> {
    'SenderId': senderId,
    'ParticipantId': participantId
  };
}