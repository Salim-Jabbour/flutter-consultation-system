import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/theme/color_manager.dart';
import '../../../../core/resource/string_manager.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../supervision/presentation/widget/removing_supervisor_icon_widget.dart';
import '../../model/medical_record_model.dart';

class AdditionalInfoWidget extends StatefulWidget {
  const AdditionalInfoWidget({
    super.key,
    required this.isGet,
    required this.list,
    required this.title,
    required this.type,
    this.suggestionList = const [],
    this.getListFunc,
  });
  final bool isGet;
  final String title;
  final List<AdditionalRecordInfoResponse> list;
  final AdditionalInfoType type;
  final void Function(List<AdditionalRecordInfoResponse>)? getListFunc;
  final List<String> suggestionList;

  @override
  State<AdditionalInfoWidget> createState() => _AdditionalInfoWidgetState();
}

class _AdditionalInfoWidgetState extends State<AdditionalInfoWidget> {
  List<AdditionalRecordInfoResponse> localList = [];

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController titleController;
  late TextEditingController descriptionController;

  @override
  void initState() {
    localList.addAll(widget.list);
    titleController = TextEditingController();
    descriptionController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "${widget.title}:",
            textAlign: TextAlign.start,
            style: TextStyle(
              color: ColorManager.c1,
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              Container(
                height: 150.h,
                width: widget.isGet ? 0.8.sw : 0.77.sw,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(18.r)),
                  color: Colors.white,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: SingleChildScrollView(
                    child: Wrap(
                      spacing: 2.0,
                      runSpacing: 2.0,
                      children: localList.map((item) {
                        return GestureDetector(
                          onLongPress: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  backgroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.r),
                                  ),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 10),
                                      Row(
                                        children: [
                                          Text(
                                            item.name,
                                            style: TextStyle(
                                              fontSize: 18.sp,
                                              color: ColorManager.c1,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            textAlign: TextAlign.start,
                                          ),
                                          const Spacer(),
                                          widget.isGet
                                              ? const SizedBox.shrink()
                                              : RemovingSupervisorIconButton(
                                                  headline: StringManager
                                                      .deleteConfirmation
                                                      .tr(),
                                                  headlineDetails: StringManager
                                                      .deleteConfirmationDetails
                                                      .tr(),
                                                  onTapFunction: () {
                                                    setState(() {
                                                      localList.remove(item);
                                                      widget.getListFunc!(
                                                          localList);
                                                    });
                                                    Navigator.of(context).pop();
                                                  },
                                                )
                                        ],
                                      ),
                                      const SizedBox(height: 20),
                                      Text(
                                        item.description,
                                        style: TextStyle(
                                            fontSize: 16.sp,
                                            color: ColorManager.c1),
                                        textAlign: TextAlign.start,
                                      ),
                                      const SizedBox(height: 30),
                                      Center(
                                        child: ElevatedButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor: ColorManager.c3),
                                          child: Text(
                                            'Close',
                                            style: TextStyle(
                                                fontSize: 12.sp,
                                                color: ColorManager.c1),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                          child: SizedBox(
                            width: 100.w,
                            child: Center(
                              child: ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: ColorManager.c3),
                                child: Text(
                                  item.name.length > 8
                                      ? "${item.name.substring(0, 6)}..."
                                      : item.name,
                                  style: TextStyle(
                                      fontSize: 14.sp, color: ColorManager.c1),
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
              widget.isGet
                  ? const SizedBox.shrink()
                  : SizedBox.fromSize(
                      size: Size.fromRadius(30.sp),
                      child: IconButton(
                        onPressed: () {
                          addListDialog(
                            titleController,
                            descriptionController,
                            widget.suggestionList,
                          );
                        },
                        icon: const Icon(
                          Icons.add_rounded,
                          color: ColorManager.c1,
                        ),
                      ),
                    ),
            ],
          ),
        ],
      ),
    );
  }

  void addListDialog(TextEditingController title,
      TextEditingController description, List<String> dropdownItems) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String? _selectedItem;
        return Form(
          key: _formKey,
          child: AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.r),
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 50),
                  CustomTextField(
                    // height: 50,
                    textEditingController: titleController,
                    hintText: StringManager.title.tr(),
                    icon: Icons.view_headline_rounded,
                    textFieldColor: ColorManager.c3,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return StringManager.emptyFieldError.tr();
                      }
                      return null;
                    },
                    suffixIconWidget: DropdownButton<String>(
                      padding: const EdgeInsets.all(8.0),
                      iconEnabledColor: ColorManager.c2,
                      // isDense: true,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: ColorManager.c1,
                      ),
                      value: _selectedItem,
                      icon: const Icon(Icons.arrow_drop_down),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedItem = newValue;
                          title.text = newValue!;
                        });
                      },
                      items: dropdownItems
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    height: 100,
                    textEditingController: descriptionController,
                    hintText: StringManager.description.tr(),
                    icon: Icons.description_rounded,
                    textFieldColor: ColorManager.c3,
                    // validator: (value) {
                    //   if (value == null || value.isEmpty) {
                    //     return StringManager.emptyFieldError.tr();
                    //   }
                    //   return null;
                    // },
                  ),
                  const SizedBox(height: 30),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          AdditionalRecordInfoResponse newRecord =
                              AdditionalRecordInfoResponse(
                            id: localList.isEmpty ? 1 : localList.last.id + 1,
                            name: title.text,
                            description: description.text.isEmpty
                                ? StringManager.noData.tr()
                                : description.text,
                            type: widget.type,
                          );
                          setState(() {
                            localList.add(newRecord);
                            widget.getListFunc!(localList);
                          });
                          Navigator.of(context).pop();
                          titleController.clear();
                          descriptionController.clear();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: ColorManager.c3),
                      child: Text(
                        StringManager.add.tr(),
                        style:
                            TextStyle(fontSize: 12.sp, color: ColorManager.c1),
                      ),
                    ),
                  ),
                  const SizedBox(height: 50),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
