import 'dart:async';

import 'package:akemha/config/theme/color_manager.dart';
import 'package:akemha/core/utils/global_snackbar.dart';
import 'package:akemha/features/consultation/models/Consultation.dart';
import 'package:akemha/features/consultation/presentation/bloc/consultation_search_cubit.dart';
import 'package:akemha/features/consultation/presentation/widgets/consultation_card.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../core/resource/string_manager.dart';

class ConsultationSearchPage extends StatefulWidget {
  const ConsultationSearchPage({super.key});

  @override
  State<ConsultationSearchPage> createState() => _ConsultationSearchPageState();
}

class _ConsultationSearchPageState extends State<ConsultationSearchPage> {
  ConsultationSearchCubit cubit = GetIt.I.get<ConsultationSearchCubit>();
  final TextEditingController _searchController = TextEditingController();
  Timer? timer;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => cubit,
      child: BlocConsumer<ConsultationSearchCubit, ConsultationSearchState>(
        listener: (context, state) {
          if (state is ConsultationSearchFailure) {
            gShowErrorSnackBar(context: context, message: state.errMessage);
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              leading: context.canPop()
                  ? IconButton(
                      onPressed: () {
                        context.pop();
                      },
                      icon: const Icon(Icons.arrow_back_ios_new),
                    )
                  : const SizedBox.shrink(),
              backgroundColor: ColorManager.c3,
              iconTheme: const IconThemeData(
                color: ColorManager.c1,
              ),
              title: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: StringManager.searchConsultations.tr(),
                  border: InputBorder.none,
                  hintStyle: const TextStyle(color: ColorManager.c1),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                            cubit.clearSearch();
                          },
                        )
                      : null,
                ),
                style: const TextStyle(color: ColorManager.c1),
                onChanged: (query) {
                  if (timer?.isActive ?? false) {
                    timer?.cancel();
                  }
                  timer = Timer(const Duration(seconds: 1), () {
                    cubit.searchConsultations(
                        searchText: _searchController.text);
                  });
                },
              ),
              centerTitle: true,
            ),
            body: RefreshIndicator(
              onRefresh: () async {
                if (_searchController.text.isNotEmpty) {
                  await cubit.searchConsultations(
                      searchText: _searchController.text);
                }
              },
              child: ListView.builder(
                  itemCount: cubit.consultation.length +
                      ((state is ConsultationSearchLoaded)
                          ? 2
                          : ((state is ConsultationSearchLoading &&
                                  cubit.consultation.isEmpty)
                              ? 10
                              : 0)),
                  itemBuilder: (context, index) {
                    if (index < cubit.consultation.length) {
                      return ConsultationCard(
                          consultationModel: cubit.consultation[index]);
                    } else {
                      if (state is ConsultationSearchLoaded &&
                          _searchController.text.isNotEmpty) {
                        cubit.searchConsultations(
                            searchText: _searchController.text,
                            page: state.page);
                      }
                      return Skeletonizer(
                        child: ConsultationCard(
                            consultationModel: loadingConsultation),
                      );
                    }
                  }),
            ),
          );
        },
      ),
    );
  }
}
