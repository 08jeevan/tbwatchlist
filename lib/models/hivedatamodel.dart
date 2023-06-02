import 'package:hive/hive.dart';

part 'hivedatamodel.g.dart';

@HiveType(typeId: 0)
class HiveDataModel extends HiveObject {
  @HiveField(0)
  late String stockId;

  @HiveField(1)
  late String stockName;
}
