import 'package:elhanbly/core/consts/images.dart';
import 'package:elhanbly/feature/auth/login/cubit/login_cubit.dart';
import 'package:elhanbly/feature/auth/login/login_imports.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../core/network/repository/repository_imports.dart';
import '../../../core/navigator/named_navigator_impl.dart';
import '../../../core/services/di.dart';
import '../../../core/theme/colors/app_colors.dart';
import '../../../core/theme/theme.dart';
import '../../../core/util/validator/order_validators.dart';
import '../../../core/util/validator/validator.dart';
import '../../../core/widgets/app_buttons/custom_button.dart';
import '../../../core/widgets/app_texts/app_text.dart';
import '../../../core/widgets/loader/app_loader.dart';
import '../../../core/widgets/text_field/master_text_field.dart';
import '../../../core/widgets/ui_helpers/app_dropdown.dart';
import '../../../core/widgets/ui_helpers/alert_message.dart';
import '../../../core/widgets/ui_helpers/extensions.dart';
import 'cubit/register_cubit.dart';

part 'register_screen.dart';
