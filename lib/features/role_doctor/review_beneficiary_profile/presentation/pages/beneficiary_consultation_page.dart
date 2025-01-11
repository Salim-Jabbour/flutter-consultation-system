import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';

import '../../../../../config/theme/color_manager.dart';
import '../../../../../core/resource/string_manager.dart';
import '../../../../../core/utils/services/api_service.dart';
import '../../../../../core/widgets/custom_app_bar.dart';
import '../../../../../core/widgets/empty_widget.dart';
import '../../../../../core/widgets/failure_widget.dart';
import '../../../../../core/widgets/skeletonizer_consultation_widget.dart';
import '../../../../auth/presentation/bloc/auth_bloc.dart';
import '../../models/beneficiary_consultation_model.dart';
import '../manager/consultation_bloc/beneficiary_consultation_bloc.dart';
import '../widgets/consultation_card_widget.dart';
import 'beneficiary_consultation_details_page.dart';

class BeneficiaryConsultationPage extends StatefulWidget {
  const BeneficiaryConsultationPage({super.key, required this.userId});

  final String userId;
  @override
  State<BeneficiaryConsultationPage> createState() =>
      _BeneficiaryConsultationPageState();
}

class _BeneficiaryConsultationPageState
    extends State<BeneficiaryConsultationPage> {
  List<BeneficiaryConsultationDetails>? consultationList = [];

  int page = 0;

  late BeneficiaryConsultationBloc _bloc;

  final ScrollController _scrollController = ScrollController();
  bool isLoadingMore = false;

// this variable is to make sure that we dont need more data
  bool moreDataNeeded = true;

  @override
  void initState() {
    _scrollController.addListener(_onScroll);
    _bloc = BeneficiaryConsultationBloc(GetIt.I.get());
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.extentAfter < 100 &&
        !isLoadingMore &&
        moreDataNeeded) {
      setState(() {
        isLoadingMore = true;
      });
      _bloc.add(BeneficiaryGetConsultationEvent(
          token: context.read<AuthBloc>().token ?? ApiService.token ?? '',
          userId: widget.userId,
          page: page,
          isInitial: false));
    }
  }

  bool checkIfMoreIsNeeded(List<BeneficiaryConsultationDetails> consultations) {
    if (consultations.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _bloc,
      child: Scaffold(
        backgroundColor: ColorManager.c3,
        appBar: CustomAppBar(
          title: StringManager.consultation.tr(),
        ),
        body: BlocConsumer<BeneficiaryConsultationBloc,
            BeneficiaryConsultationState>(
          listener: (context, state) {
            if (state is BeneficiaryConsultationSuccess) {
              setState(() {
                consultationList!.addAll(state.model.data);
                page++;
                moreDataNeeded = checkIfMoreIsNeeded(state.model.data);
                isLoadingMore = false;
                // print("ENTERREEEEEEEEEEED HERRRE");
              });
            }

            if (state is BeneficiaryConsultationFailure) {
              setState(() {
                isLoadingMore = false;
              });
            }
          },
          builder: (context, state) {
            if (state is BeneficiaryConsultationInitial) {
              _bloc.add(BeneficiaryGetConsultationEvent(
                token: context.read<AuthBloc>().token ?? ApiService.token ?? '',
                userId: widget.userId,
                page: page,
                isInitial: true,
              ));
            }

            if (state is BeneficiaryConsultationFailure) {
              return FailureWidget(
                errorMessage: state.failure.message,
                onPressed: () {
                  _bloc.add(BeneficiaryGetConsultationEvent(
                    token: context.read<AuthBloc>().token ??
                        ApiService.token ??
                        '',
                    userId: widget.userId,
                    page: page,
                    isInitial: true,
                  ));
                },
              );
            }

            return Stack(
              children: [
                Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        controller: _scrollController,
                        itemCount:
                            consultationList!.length + (isLoadingMore ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index == consultationList!.length) {
                            return const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Center(
                                child: CircularProgressIndicator(
                                    color: ColorManager.c2),
                              ),
                            );
                          }
                          return ConsultationCardWidget(
                            details: consultationList![index],
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      BeneficiaryConsultationDetailsPage(
                                          consultationModel:
                                              consultationList![index]),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
                if (state is BeneficiaryConsultationLoading)
                  const SkeletonizerConsultationWidget(),
                if (state is BeneficiaryConsultationSuccess &&
                    consultationList!.isEmpty)
                  EmptyWidget(height: 0.7.sh)
              ],
            );
          },
        ),
      ),
    );
  }
}
