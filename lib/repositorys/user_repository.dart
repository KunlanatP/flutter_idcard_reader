import 'package:dio/dio.dart';
import 'package:flutter_idcard_reader/models/login_model.dart';
import 'package:flutter_idcard_reader/models/pageable_with_search.dart';
import 'package:flutter_idcard_reader/models/user_model.dart';
import 'package:retrofit/retrofit.dart';

part 'user_repository.g.dart';

@RestApi()
abstract class UserRepository {
  factory UserRepository(Dio dio) = _UserRepository;

  @GET('/users')
  Future<Pagination<List<UserModel>>?> getAllUsers(
    @Queries() PageableWithSearch search,
  );

  @GET('/users/login')
  Future<UserModel?> userLogin(@Queries() LoginModel login);
}
