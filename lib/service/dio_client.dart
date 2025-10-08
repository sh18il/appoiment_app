import 'package:dio/dio.dart';

final dio = Dio(
  BaseOptions(
    receiveTimeout: Duration(seconds: 30),
  ),
);
