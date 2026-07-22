import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:elhanbly/models/Session/get_session_info_response.dart';
import 'package:elhanbly/models/Session/show_video_response.dart';
import 'package:elhanbly/models/home_entities/courses/get_course_data_response_model.dart';
import 'package:elhanbly/models/home_entities/courses/get_my_courses.dart';
import 'package:elhanbly/models/home_entities/home/get_home.dart';
import 'package:elhanbly/models/profile/wallet/wallet_history.dart';
import 'package:elhanbly/models/profile/wallet/store_products.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../models/general/general_response.dart';
import '../../../models/general/general_selectable_entity.dart';
import '../../../models/general/register_stage_model.dart';
import '../../../models/general/settings_response.dart';
import '../../../models/guest/guest_courses_response.dart';

import '../../../models/user_response/login_response.dart';
import '../../../models/user_response/user_data.dart';
import '../../local/cache_helper.dart';
import '../../services/di.dart';
import '../dio/dio_helper.dart';
import '../remote/api_endpoints.dart';

part 'repository.dart';
part 'repository_extension.dart';
part 'repository_impl.dart';
