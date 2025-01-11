// first tab

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';

import '../../../../config/theme/color_manager.dart';
import '../../../../core/resource/const_manager.dart';
import '../../../../core/resource/string_manager.dart';
import '../../../../core/utils/global_snackbar.dart';
import '../../../../core/utils/services/api_service.dart';
import '../../../../core/widgets/empty_widget.dart';
import '../../../../core/widgets/failure_widget.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../model/supervision_model.dart';
import '../bloc/first_page_bloc/first_page_bloc.dart';
import '../widget/floating_action_button_function.dart';
import '../widget/removing_supervisor_icon_widget.dart';
import '../widget/user_list_tile_widget.dart';
import 'supervised_todays_medicine_page.dart';

class SupervisedPage extends StatefulWidget {
  const SupervisedPage({super.key});

  @override
  State<SupervisedPage> createState() => _SupervisedPageState();
}

// first tab
class _SupervisedPageState extends State<SupervisedPage> {
  final TextEditingController searchInputs = TextEditingController();
// I am superviror and those are supervised
  List<SupervisionDataModel>? supervised;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetIt.I.get<FirstPageBlocBloc>(),
      child: BlocConsumer<FirstPageBlocBloc, FirstPageBlocState>(
        listener: (context, state) {
          // state for success initial data
          if (state is FirstPageSuccess) {
            supervised = state.supervisionModel.supervisonDataModel;
          }
          // two state for deleting
          if (state is SupervisionDeleteSuccess) {
            gShowSuccessSnackBar(context: context, message: state.msg);
          }
          if (state is SupervisionDeleteFailure) {
            gShowErrorSnackBar(
                context: context, message: state.failure.message);
          }
        },
        builder: (context, state) {
          if (state is FirstPageBlocInitial) {
            context.read<FirstPageBlocBloc>().add(FirstTabEvent(
                  context.read<AuthBloc>().token ?? ApiService.token ?? '',
                ));
          }
          if (state is FirstPageFailure) {
            return FailureWidget(
              errorMessage: state.failure.message,
              onPressed: () {
                context.read<FirstPageBlocBloc>().add(FirstTabEvent(
                      context.read<AuthBloc>().token ?? ApiService.token ?? '',
                    ));
              },
            );
          }
          return Scaffold(
            floatingActionButton: Container(
              height: 80.r,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: ColorManager.c2,
              ),
              child: IconButton(
                onPressed: () {
                  showBottomSheetFunc(context);
                },
                icon: Icon(
                  Icons.add_rounded,
                  size: 30.sp,
                  color: ColorManager.c3,
                ),
              ),
            ),
            body: Stack(
              children: [
                Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: supervised?.length ?? 0,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          SupervisedTodaysMedicinePage(
                                            supervisedId: supervised![index]
                                                .supervised
                                                .id
                                                .toString(),
                                            supervisedName: supervised![index]
                                                .supervised
                                                .name,
                                          )));
                            },
                            child: UserListTileWidget(
                              model: supervised?[index].supervised ??
                                  ConstManager.userModel,
                              widget: RemovingSupervisorIconButton(
                                headline: StringManager.deleteSupervised.tr(),
                                headlineDetails:
                                    StringManager.deleteSupervisedDetails.tr(),
                                onTapFunction: () {
                                  context.read<FirstPageBlocBloc>().add(
                                      DeleteSupervisionEvent(
                                          supervisionId: supervised?[index]
                                                  .id
                                                  .toString() ??
                                              "0",
                                          token:
                                              context.read<AuthBloc>().token ??
                                                  ApiService.token ??
                                                  '454545'));
                                },
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                if (state is FirstPageLoading)
                  const LoadingWidget(
                    fullScreen: true,
                  )
                else if (state is FirstPageSuccess && supervised!.isEmpty)
                  EmptyWidget(height: 0.7.sh)
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    searchInputs.dispose();
    super.dispose();
  }
}
