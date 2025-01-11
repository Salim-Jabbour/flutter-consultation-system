import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';

import '../../../../config/theme/color_manager.dart';
import '../../../../core/resource/const_manager.dart';
import '../../../../core/resource/string_manager.dart';
import '../../../../core/utils/dbg_print.dart';
import '../../../../core/utils/global_snackbar.dart';
import '../../../../core/utils/services/api_service.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../model/supervision_model.dart';
import '../bloc/floating_button/floating_bloc.dart';
import 'add_supervision_request_button.dart';
import 'user_list_tile_widget.dart';

void showBottomSheetFunc(BuildContext context) {
  List<UserLessResponseModel>? users;

  showModalBottomSheet(
    backgroundColor: const Color.fromRGBO(242, 243, 242, 1),
    context: context,
    elevation: 2,
    isScrollControlled: true,
    builder: (context) => BlocProvider(
      create: (context) => GetIt.I.get<FloatingBloc>(),
      child: BlocConsumer<FloatingBloc, FloatingState>(
        listener: (context, state) {
          if (state is SupervisionRandomTenSuccess) {
            users = state.userLessResponseModelList.usersList;
          }
          if (state is SupervisionSearchedTenSuccess) {
            users = state.userLessResponseModelList.usersList;
          }
        },
        builder: (context, state) {
          if (state is FloatingInitial) {
            context.read<FloatingBloc>().add(RandomTenEvent(
                context.read<AuthBloc>().token ??
                    ApiService.token ??
                    '454545'));
          }
          return Stack(
            children: [
              Container(
                height: 500.h,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: ColorManager.grey.withOpacity(0.1),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.r),
                    topRight: Radius.circular(30.r),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 20.h,
                    // horizontal: 20.w,
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 5.h,
                          horizontal: 20.w,
                        ),
                        child: TextFormField(
                          // controller: searchInputs,
                          keyboardType: TextInputType.name,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.r),
                              borderSide: const BorderSide(color: Colors.grey),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 12.0),
                            hintText: StringManager.search.tr(),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.r),
                              borderSide:
                                  const BorderSide(color: ColorManager.c1),
                            ),
                            prefixIcon: Icon(
                              Icons.search,
                              color: ColorManager.foregroundL,
                              size: 25.sp,
                            ),
                          ),
                          onFieldSubmitted: (inputs) {
                            dbg("im in button");
                            String search =
                                inputs.replaceAll(RegExp(r'^\s+'), '');

                            // add search event
                            if (search != '') {
                              context
                                  .read<FloatingBloc>()
                                  .add(SearchedUsersEvent(
                                    token: context.read<AuthBloc>().token ??
                                        ApiService.token ??
                                        '',
                                    keyword: search,
                                  ));
                            }
                          },
                          textInputAction: TextInputAction.search,
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: users?.length ?? 1,
                          itemBuilder: (context, index) {
                            return UserListTileWidget(
                              model: users?[index] ?? ConstManager.userModel,
                              widget: AddSupervisionRequestButton(
                                onTapFunction: () {
                                  // showAlertDialog(context);
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return BlocProvider(
                                        create: (context) =>
                                            GetIt.I.get<FloatingBloc>(),
                                        child: BlocConsumer<FloatingBloc,
                                            FloatingState>(
                                          listener: (context, state) {
                                            // two state for sending request
                                            if (state
                                                is SupervisionRequestSuccess) {
                                              gShowSuccessSnackBar(
                                                  context: context,
                                                  message: state.msg);
                                            }
                                            if (state
                                                is SupervisionRequestFailure) {
                                              gShowErrorSnackBar(
                                                  context: context,
                                                  message:
                                                      state.failure.message);
                                            }
                                          },
                                          builder: (context, state) {
                                            return Stack(
                                              children: [
                                                AlertDialog(
                                                  title: Text(StringManager
                                                      .addSupervisionRequest
                                                      .tr()),
                                                  content: Text(StringManager
                                                      .addSupervisionRequestDetails
                                                      .tr()),
                                                  actions: [
                                                    ElevatedButton(
                                                      onPressed: () {
                                                        context
                                                            .read<
                                                                FloatingBloc>()
                                                            .add(
                                                                SendSupervisionRequestEvent(
                                                              supervisedId: users?[
                                                                          index]
                                                                      .id
                                                                      .toString() ??
                                                                  '0',
                                                              token: context
                                                                      .read<
                                                                          AuthBloc>()
                                                                      .token ??
                                                                  ApiService
                                                                      .token ??
                                                                  '454545',
                                                            ));

                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child: Text(StringManager
                                                          .yes
                                                          .tr()),
                                                    ),
                                                    ElevatedButton(
                                                      child: Text(StringManager
                                                          .no
                                                          .tr()),
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                    )
                                                  ],
                                                ),
                                                if (state is FloatingLoading)
                                                  Center(
                                                    child: SizedBox(
                                                      height: 200.h,
                                                      child:
                                                          const LoadingWidget(
                                                        fullScreen: false,
                                                      ),
                                                    ),
                                                  ),
                                              ],
                                            );
                                          },
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (state is FloatingLoading)
                SizedBox(
                  height: 495.h,
                  child: const LoadingWidget(
                      // fullScreen: true,
                      ),
                ),
              // if(state is SupervisionRandomTenSuccess && users!.isEmpty)
              //  SizedBox(
              //   height: 495.h,
              //   child: const EmptyWidget()
              // ),
            ],
          );
        },
      ),
    ),
  );
}
