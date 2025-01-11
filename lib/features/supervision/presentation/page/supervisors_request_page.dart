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
import '../../../../core/widgets/empty_widget.dart';
import '../../../../core/widgets/failure_widget.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../model/supervision_model.dart';
import '../bloc/bell_bloc/bell_bloc.dart';
import '../widget/approve_or_reject_request_widget.dart';
import '../widget/user_list_tile_widget.dart';

class SupervisorsRequestPage extends StatefulWidget {
  const SupervisorsRequestPage({super.key});

  @override
  State<SupervisorsRequestPage> createState() => _SupervisorsRequestPageState();
}

class _SupervisorsRequestPageState extends State<SupervisorsRequestPage> {
  List<SupervisionDataModel>? requests;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorManager.c3,
        centerTitle: true,
        title: Text(
          StringManager.supervisionRequest.tr(),
          style: const TextStyle(
            color: ColorManager.c1,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: BlocProvider(
        create: (context) => GetIt.I.get<BellBloc>(),
        child: BlocConsumer<BellBloc, BellState>(
          listener: (context, state) {
            if (state is SupervisionInsideBellSuccess) {
              requests = state.supervisionModel.supervisonDataModel;
            }
            // two state for deleting
            if (state is SupervisionDeleteSuccess) {
              gShowSuccessSnackBar(context: context, message: state.msg);
            }
            if (state is SupervisionDeleteFailure) {
              gShowErrorSnackBar(
                  context: context, message: state.failure.message);
            }

            // two state for approving
            if (state is SupervisionApproveSuccess) {
              gShowSuccessSnackBar(context: context, message: state.msg);
            }
            if (state is SupervisionApproveFailure) {
              gShowErrorSnackBar(
                  context: context, message: state.failure.message);
            }
          },
          builder: (context, state) {
            if (state is BellInitial) {
              context.read<BellBloc>().add(InsideBellEvent(
                    ApiService.token ?? "",
                  ));
            }
            if (state is SupervisionInsideBellFailure) {
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
                        itemCount: requests?.length ?? 0,
                        itemBuilder: (context, index) {
                          return UserListTileWidget(
                            model: requests?[index].supervisor ??
                                ConstManager.userModel,
                            widget: ApproveOrRejectRequestWidget(
                              approveFunction: () {
                                dbg("approve");
                                context.read<BellBloc>().add(
                                    ApproveSupervisionEvent(
                                        supervisionId:
                                            requests?[index].id.toString() ??
                                                "10000",
                                        token: ApiService.token ?? '454545'));
                              },
                              refuseFunction: () {
                                dbg("refuse");
                                context.read<BellBloc>().add(
                                    DeleteSupervisionEvent(
                                        supervisionId:
                                            requests?[index].id.toString() ??
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
                if (state is BellLoading)
                  const LoadingWidget(
                    fullScreen: true,
                  )
                else if (state is SupervisionInsideBellSuccess &&
                    requests!.isEmpty)
                  EmptyWidget(height: 0.7.sh)
              ],
            );
          },
        ),
      ),
    );
  }
}
