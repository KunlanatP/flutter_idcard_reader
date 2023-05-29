import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'people_repository.g.dart';

@RestApi()
abstract class PeopleRepository {
  factory PeopleRepository(Dio dio) = _PeopleRepository;
}
