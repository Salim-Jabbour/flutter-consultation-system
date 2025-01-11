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
import '../../../review_beneficiary_profile/models/beneficiary_consultation_model.dart';
import '../../../review_beneficiary_profile/presentation/widgets/consultation_card_widget.dart';
import '../manager/doctor_consultation/doctor_consultations_bloc.dart';
import 'doctor_consultation_details_page.dart';

class DoctorConsultationPage extends StatefulWidget {
  const DoctorConsultationPage({super.key});

  @override
  State<DoctorConsultationPage> createState() => _DoctorConsultationPageState();
}

class _DoctorConsultationPageState extends State<DoctorConsultationPage> {
  List<BeneficiaryConsultationDetails>? consultationList = [];

  int page = 0;

  late DoctorConsultationsBloc _bloc;

  final ScrollController _scrollController = ScrollController();

  bool isLoadingMore = false;

// this variable is to make sure that we dont need more data
  bool moreDataNeeded = true;

  @override
  void initState() {
    _scrollController.addListener(_onScroll);
    _bloc = DoctorConsultationsBloc(GetIt.I.get());
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
      _bloc.add(
        DoctorGetConsultationsEvent(
          context.read<AuthBloc>().token ?? ApiService.token ?? '',
          page,
          false,
        ),
      );
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
          title: StringManager.consultations.tr(),
        ),
        body: BlocConsumer<DoctorConsultationsBloc, DoctorConsultationsState>(
          listener: (context, state) {
            if (state is DoctorGetConsultationsSuccess) {
              setState(() {
                consultationList!.addAll(state.model.data);
                page++;
                moreDataNeeded = checkIfMoreIsNeeded(state.model.data);
                isLoadingMore = false;
              });
            }

            if (state is DoctorGetConsultationsFailure) {
              setState(() {
                isLoadingMore = false;
              });
            }
          },
          builder: (context, state) {
            if (state is DoctorConsultationsInitial) {
              _bloc.add(
                DoctorGetConsultationsEvent(
                  context.read<AuthBloc>().token ?? ApiService.token ?? '',
                  page,
                  true,
                ),
              );
            }

            if (state is DoctorGetConsultationsFailure) {
              return FailureWidget(
                errorMessage: state.failure.message,
                onPressed: () {
                  _bloc.add(
                    DoctorGetConsultationsEvent(
                      context.read<AuthBloc>().token ?? ApiService.token ?? '',
                      page,
                      true,
                    ),
                  );
                },
              );
            }

            return Stack(
              children: [
                RefreshIndicator(
                  onRefresh: () async {
                    setState(() {
                      consultationList = [];
                      page = 0;
                    });
                    _bloc.add(
                      DoctorGetConsultationsEvent(
                        context.read<AuthBloc>().token ??
                            ApiService.token ??
                            '',
                        page,
                        true,
                      ),
                    );
                  },
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          controller: _scrollController,
                          itemCount: consultationList!.length +
                              (isLoadingMore ? 1 : 0),
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
                                            DoctorConsultationDetailsPage(
                                              consultationModel:
                                                  consultationList![index],
                                              bloc: _bloc,
                                            )));
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                if (state is DoctorConsultationsLoading)
                  const SkeletonizerConsultationWidget(),
                if (state is DoctorGetConsultationsSuccess &&
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
