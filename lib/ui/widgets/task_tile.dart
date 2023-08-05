// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:todo_app/models/task.dart';
import 'package:todo_app/ui/size_config.dart';
import 'package:todo_app/ui/theme.dart';

class TaskTile extends StatelessWidget {
  final Task taskName;

  const TaskTile({
    Key? key,
    required this.taskName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(
        getProportionateScreenWidth(
            SizeConfig.orientation == Orientation.landscape ? 8 : 8),
      ),
      width: SizeConfig.orientation == Orientation.landscape
          ? SizeConfig.screenWidth / 2
          : SizeConfig.screenWidth,
      margin: EdgeInsets.only(bottom: getProportionateScreenHeight(2)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: _getBGClr(taskName.color),
        ),
        child: Row(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top:10,left: 10),
                      child: Text(
                        taskName.title!,
                        style: Themes().datePickerTextStyle(
                          Colors.grey[100],
                          20,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.access_time_rounded,
                          color: Colors.grey[200],
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          '${taskName.startTime} - ${taskName.endTime}',
                          style: Themes().datePickerTextStyle(
                            Colors.grey[100],
                            13,
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom:10,left: 10),
                      child: Text(
                        taskName.note!,
                        style: Themes().datePickerTextStyle(
                          Colors.grey[100],
                          16,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Container(
              height: taskName.isCompleted==0?50:80,
              width: 2,
              color: Colors.grey[200]!.withOpacity(0.9),
            ),
            RotatedBox(
              quarterTurns: 3,
              child: Text(
                taskName.isCompleted == 0 ? 'TODO' : 'Completed',
                style: Themes().datePickerTextStyle(taskName.isCompleted==0?const Color.fromARGB(255, 114, 8, 0):Colors.white  , 15),
              ),
            )
          ],
        ),
      ),
    );
  }

  _getBGClr(int? color) {
    switch (color) {
      case 0:
        return bluishClr;
      case 1:
        return pinkClr;
      case 2:
        return orangeClr;
      default:
        return bluishClr;
    }
  }
}
