class ClassModel{
  late String className;
  late String classOwner;
  late DateTime date;
  late int total;

  ClassModel(this.className, this.classOwner, this.date, this.total);

  Map<dynamic, dynamic> toJson() => <dynamic, dynamic>{
    'ClassName': className,
    'ClassOwner': classOwner,
    'DateTimeOfCreation': date,
    'TotalCandidates': total,
  };
}