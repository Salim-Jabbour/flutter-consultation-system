import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class SkeletonizerConsultationWidget extends StatelessWidget {
  const SkeletonizerConsultationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      child: ListView.builder(
          itemCount: 10,
          padding: const EdgeInsets.all(12.0),
          itemBuilder: (context, index) {
            return const Card(
              child: ListTile(
                leading: Skeleton.leaf(
                  child: CircleAvatar(
                    child: Text("0"),
                  ),
                ),
                title: Text("0000000000000"),
                subtitle: Text("0000000000000000000000000000000"),
              ),
            );
          }),
    );
  }
}
