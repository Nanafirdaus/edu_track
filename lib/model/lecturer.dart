import 'package:hive/hive.dart';
part 'lecturer.g.dart';

@HiveType(typeId: 1)
class Lecturer {
  @HiveField(0)
  final String lecturerId; 

  @HiveField(1)
  final String lecturerName;

  @HiveField(2)
  final int lecturerContact;

  Lecturer({
    required this.lecturerId,
    required this.lecturerContact,
    required this.lecturerName,
  });
}
