class MediaModel{
  late String mediaName;
  late String mediaType;
  late String classId;
  late String uploaderId;
  late DateTime dateTime;

  MediaModel(this.mediaName, this.mediaType, this.classId, this.uploaderId,
      this.dateTime);

  Map<dynamic, dynamic> toJson()=> <dynamic, dynamic>{
    'MediaName': mediaName,
    'MediaType': mediaType,
    'Class_or_ChatId': classId,
    'UploaderId': uploaderId,
    'DateTimeOfUploading': dateTime
  };
}