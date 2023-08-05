import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/controllers/task_controller.dart';
import 'package:todo_app/models/task.dart';
import 'package:todo_app/services/notification_services.dart';
import 'package:todo_app/services/theme_services.dart';
import 'package:todo_app/ui/pages/add_task_page.dart';
import 'package:todo_app/ui/size_config.dart';
import 'package:todo_app/ui/theme.dart';
import 'package:todo_app/ui/widgets/app_bar.dart';
import 'package:todo_app/ui/widgets/button.dart';
import 'package:todo_app/ui/widgets/task_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TaskController _taskController = Get.put(TaskController());
  late NotifyHelper notifyHelper;
  @override
  void initState() {
    notifyHelper = NotifyHelper();
    notifyHelper.initializeNotification();
    notifyHelper.requestIOSPermissions();
    _taskController.getTasks();
    super.initState();
  }

  DateTime _dateTime = DateTime.now();

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
      backgroundColor: Theme.of(context).dialogBackgroundColor,
      appBar: appBar(
        context,
        IconButton(
          onPressed: () => setState(
            () {
              ThemeServices().switchTheme();
            },
          ),
          icon: Icon(
            Get.isDarkMode ? Icons.sunny : Icons.nightlight,
          ),
        ),
        IconButton(
          onPressed: () async {
            await notifyHelper.cancelAllNotification();
            setState(
              () {
                _taskController.deleteAllData();
              },
            );
          },
          icon: const Icon(
            Icons.delete,
          ),
        ),
      ),
      body: Column(
        children: [
          _addTaskBar(),
          const SizedBox(
            height: 20,
          ),
          _addDateBar(),
          const SizedBox(
            height: 20,
          ),
          _showTasks(),
        ],
      ),
    );
  }

  Widget _addTaskBar() {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 10, top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DateFormat.yMMMMd().format(DateTime.now()),
                style: Themes().subHeadingStyle,
              ),
              Text(
                'Today',
                style: Themes().headingStyle,
              )
            ],
          ),
          MyButton(
            label: '+ Add Task',
            onTap: () async {
              await Get.to(const AddTaskPage());
            },
          )
        ],
      ),
    );
  }

  Widget _addDateBar() {
    return Container(
      margin: const EdgeInsets.only(top: 6, left: 20),
      child: DatePicker(
        DateTime.now(),
        height: 100,
        selectedTextColor: Colors.white,
        selectionColor: primaryClr,
        initialSelectedDate: DateTime.now(),
        onDateChange: (newDate) {
          setState(() {
            _dateTime = newDate;
          });
        },
        dateTextStyle: Themes().datePickerTextStyle(Colors.grey, 20),
        dayTextStyle: Themes().datePickerTextStyle(Colors.grey, 16),
        monthTextStyle: Themes().datePickerTextStyle(Colors.grey, 12),
      ),
    );
  }

  _showTasks() {
    return Expanded(
      child: Obx(
        () {
          if (_taskController.taskList.isEmpty) {
            return _noTaskMsg();
          } else {
            return _listOfTasks();
          }
        },
      ),
    );
  }

  ListView _listOfTasks() {
    return ListView.builder(
      scrollDirection: SizeConfig.orientation == Orientation.landscape
          ? Axis.horizontal
          : Axis.vertical,
      itemCount: _taskController.taskList.length,
      itemBuilder: (BuildContext context, int index) {
        var task = _taskController.taskList[index];

        if ((DateFormat.yMd().format(_dateTime) == task.date ||
                task.repeat == 'Daily') ||
            (task.repeat == 'Weekly' &&
                _dateTime
                            .difference(
                              DateFormat.yMd().parse(task.date!),
                            )
                            .inDays %
                        7 ==
                    0) ||
            (task.repeat == 'Monthly' &&
                DateFormat.yMd().parse(task.date!).day == _dateTime.day)) {
          var hour = task.startTime.toString().split(':')[0];
          var minutes = task.startTime.toString().split(':')[0];

          notifyHelper.scheduledNotification(
            int.parse(hour),
            int.parse(minutes),
            task,
          );

          notifyHelper.displayNotification(
            title: task.title!,
            body: task.note!,
            task: Task(
              title: task.title,
              note: task.note,
              date: task.date,
            ),
          );

          // notifyHelper.goToNotificationScreen(
          //     payLoad: '${task.title}|${task.note}|${task.date}');

          return AnimationConfiguration.staggeredList(
            position: index,
            duration: const Duration(milliseconds: 1370),
            child: SlideAnimation(
              horizontalOffset: 300,
              child: FadeInAnimation(
                child: InkWell(
                  onTap: () {
                    _showBottomSheet(context, task);
                  },
                  child: TaskTile(taskName: task),
                ),
              ),
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }

  _noTaskMsg() {
    return Stack(
      children: [
        AnimatedPositioned(
          curve: Curves.bounceIn,
          duration: const Duration(milliseconds: 2000),
          child: SingleChildScrollView(
            child: Wrap(
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              direction: SizeConfig.orientation == Orientation.landscape
                  ? Axis.horizontal
                  : Axis.vertical,
              children: [
                SizeConfig.orientation == Orientation.landscape
                    ? const SizedBox(
                        height: 6,
                      )
                    : const SizedBox(
                        height: 220,
                      ),
                SvgPicture.asset(
                  'assets/images/task.svg',
                  height: 90,
                  semanticsLabel: 'Task',
                  colorFilter:
                      const ColorFilter.mode(primaryClr, BlendMode.srcIn),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  margin: const EdgeInsets.only(left: 15, right: 15),
                  child: Text(
                    "You don't have any tasks yet!\nAdd new tasks to make your days productive",
                    textAlign: TextAlign.center,
                    style: Themes().datePickerTextStyle(
                      Get.isDarkMode ? Colors.white : Colors.black,
                      18,
                    ),
                  ),
                )
              ],
            ),
          ),
        )
      ],
    );
  }

  _notFoundTaskToDay() {
    return Stack(
      children: [
        AnimatedPositioned(
          curve: Curves.bounceIn,
          duration: const Duration(milliseconds: 2000),
          child: SingleChildScrollView(
            child: Wrap(
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              direction: SizeConfig.orientation == Orientation.landscape
                  ? Axis.horizontal
                  : Axis.vertical,
              children: [
                SizeConfig.orientation == Orientation.landscape
                    ? const SizedBox(
                        height: 6,
                      )
                    : const SizedBox(
                        height: 220,
                      ),
                SvgPicture.asset(
                  'assets/images/task.svg',
                  height: 90,
                  semanticsLabel: 'Task',
                  colorFilter: const ColorFilter.mode(pinkClr, BlendMode.srcIn),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  margin: const EdgeInsets.only(left: 15, right: 15),
                  child: Text(
                    "you don't have any tasks for today!\nAdd new tasks to make your days productive",
                    textAlign: TextAlign.center,
                    style: Themes().datePickerTextStyle(
                      Get.isDarkMode ? Colors.white : Colors.black,
                      18,
                    ),
                  ),
                )
              ],
            ),
          ),
        )
      ],
    );
  }

  _buildBottomSheet({
    required String label,
    required Function() onTap,
    required Color clr,
    bool isClose = false,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        height: 65,
        width: SizeConfig.screenWidth * 0.9,
        decoration: BoxDecoration(
            border: Border.all(
              width: 2,
              color: isClose
                  ? Get.isDarkMode
                      ? Colors.grey[600]!
                      : Colors.grey[300]!
                  : clr,
            ),
            borderRadius: BorderRadius.circular(20),
            color: isClose ? Colors.transparent : clr),
        child: Center(
          child: Text(
            label,
            style: isClose
                ? Themes().titleStyle
                : Themes().datePickerTextStyle(
                    Colors.white,
                  ),
          ),
        ),
      ),
    );
  }

  _showBottomSheet(BuildContext context, Task task) {
    Get.bottomSheet(
      SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.only(top: 4),
          width: SizeConfig.screenWidth,
          height: (SizeConfig.orientation == Orientation.landscape)
              ? (task.isCompleted == 1
                  ? SizeConfig.screenHeight * 0.6
                  : SizeConfig.screenHeight * 0.8)
              : (task.isCompleted == 1
                  ? SizeConfig.screenHeight * 0.30
                  : SizeConfig.screenHeight * 0.39),
          color: Get.isDarkMode ? darkHeaderClr : Colors.white,
          child: Column(
            children: [
              Flexible(
                child: Container(
                  height: 6,
                  width: 120,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color:
                          Get.isDarkMode ? Colors.grey[600] : Colors.grey[300]),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              task.isCompleted == 1
                  ? Container()
                  : _buildBottomSheet(
                      label: 'Task Completed',
                      onTap: () async {
                        notifyHelper.cancelNotification(task);
                        _taskController.markTaskCompleted(task.id!);

                        Get.back();
                      },
                      clr: primaryClr,
                    ),
              _buildBottomSheet(
                label: 'Delete Task',
                onTap: () async {
                  await notifyHelper.cancelNotification(task);

                  _taskController.deleteTask(task);
                  Get.back();
                },
                clr: pinkClr,
              ),
              Divider(
                color: Get.isDarkMode ? Colors.grey : darkGreyClr,
              ),
              _buildBottomSheet(
                label: 'Cancel',
                onTap: () {
                  Get.back();
                },
                clr: primaryClr,
              ),
              const SizedBox(
                height: 10,
              )
            ],
          ),
        ),
      ),
    );
  }
}
