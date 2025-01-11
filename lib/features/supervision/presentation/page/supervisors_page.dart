//second tab
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';

import '../../../../core/resource/const_manager.dart';
import '../../../../core/resource/string_manager.dart';
import '../../../../core/utils/global_snackbar.dart';
import '../../../../core/utils/services/api_service.dart';
import '../../../../core/widgets/empty_widget.dart';
import '../../../../core/widgets/failure_widget.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../model/supervision_model.dart';
import '../bloc/second_page_bloc/second_page_bloc.dart';
import '../widget/removing_supervisor_icon_widget.dart';
import '../widget/user_list_tile_widget.dart';

class SupervisorsPage extends StatefulWidget {
  const SupervisorsPage({super.key});

  @override
  State<SupervisorsPage> createState() => _SupervisorsPageState();
}

// second tab page
class _SupervisorsPageState extends State<SupervisorsPage> {
  // I'm being supervised by these supervisors 
  List<SupervisionDataModel>? supervisor;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetIt.I.get<SecondPageBloc>(),
      child: BlocConsumer<SecondPageBloc, SecondPageState>(
        listener: (context, state) {
          if (state is SupervisionSecondTabSuccess) {
            supervisor = state.supervisionModel.supervisonDataModel;
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
          if (state is SecondPageInitial) {
            context.read<SecondPageBloc>().add(SecondTabEvent(
                  ApiService.token ?? "5555ss",
                ));
          }
          if (state is SupervisionSecondTabFailure) {
            return FailureWidget(
              errorMessage: state.failure.message,
              onPressed: () {},
            );
          }
          return Stack(
            children: [
              Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: supervisor?.length ?? 0,
                      itemBuilder: (context, index) {
                        return UserListTileWidget(
                          model: supervisor?[index].supervisor ??
                              ConstManager.userModel,
                          widget: RemovingSupervisorIconButton(
                            headline: StringManager.deleteSupervisor.tr(),
                            headlineDetails:
                                StringManager.deleteSupervisorDetails.tr(),
                            onTapFunction: () {
                              context.read<SecondPageBloc>().add(
                                  DeleteSupervisionEvent(
                                      supervisionId:
                                          supervisor?[index].id.toString() ??
                                              "10000",
                                      token: ApiService.token ?? '454545'));
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
              if (state is SecondPageLoading)
                const LoadingWidget(
                  fullScreen: true,
                )
              else if (state is SupervisionSecondTabSuccess &&
                  supervisor!.isEmpty)
                EmptyWidget(height: 0.7.sh),
            ],
          );
        },
      ),
    );
  }
}
