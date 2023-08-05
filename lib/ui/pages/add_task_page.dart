import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/controllers/task_controller.dart';
import 'package:todo_app/models/task.dart';
import 'package:todo_app/ui/theme.dart';
import 'package:todo_app/ui/widgets/app_bar.dart';
import 'package:todo_app/ui/widgets/button.dart';
import 'package:todo_app/ui/widgets/input_field.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({Key? key}) : super(key: key);

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final TaskController _taskController = Get.put(TaskController());

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  DateTime selectedDate = DateTime.now();
  String _startTime = DateFormat('hh:mm a').format(DateTime.now()).toString();
  String _endTime = DateFormat('hh:mm a')
      .format(
        DateTime.now().add(
          const Duration(minutes: 15),
        ),
      )
      .toString();

  int _selectedRemind = 5;
  List<int> reminderList = [5, 10, 15, 20];
  String _selectedRepeat = 'None';
  List<String> repeatList = ['None', 'Daily', 'Weekly', 'Monthly'];

  int _selectedColor = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).dialogBackgroundColor,
      appBar: appBar(
        context,
        IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(
            Icons.arrow_back,
          ),
        ),
        Container(),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                'Add Task',
                style: Themes().headingStyle,
              ),
              InputField(
                title: 'Title',
                hint: 'Enter title here',
                controller: _titleController,
              ),
              const SizedBox(
                height: 15,
              ),
              InputField(
                title: 'Note',
                hint: 'Enter Description here',
                controller: _noteController,
              ),
              const SizedBox(
                height: 15,
              ),
              InputField(
                title: 'Date',
                hint: DateFormat.yMd().format(selectedDate),
                widget: IconButton(
                  icon: const Icon(
                    Icons.calendar_month,
                    color: Colors.grey,
                  ),
                  onPressed: () => _getDateFromUser(),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                children: [
                  Expanded(
                    child: InputField(
                      title: 'Start Time',
                      hint: _startTime,
                      widget: IconButton(
                        icon: const Icon(
                          Icons.access_time_rounded,
                          color: Colors.grey,
                        ),
                        onPressed: () => _getTimeFromUser(isStartTime: true),
                      ),
                    ),
                  ),
                  Expanded(
                    child: InputField(
                      title: 'End Time',
                      hint: _endTime,
                      widget: IconButton(
                        icon: const Icon(
                          Icons.access_time_rounded,
                          color: Colors.grey,
                        ),
                        onPressed: () => _getTimeFromUser(isStartTime: false),
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              InputField(
                title: 'Remind',
                hint: '$_selectedRemind minutes early',
                widget: DropdownButton<int>(
                  borderRadius: BorderRadius.circular(15),
                  onChanged: (newValue) {
                    setState(() {
                      _selectedRemind = newValue!;
                    });
                  },
                  icon: const Icon(
                    Icons.arrow_drop_down,
                    size: 32,
                  ),
                  items: reminderList
                      .map(
                        (value) => DropdownMenuItem<int>(
                          value: value,
                          child: Text('$value'),
                          onTap: () {},
                        ),
                      )
                      .toList(),
                  underline: const SizedBox(
                    height: 0,
                    width: 0,
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              InputField(
                title: 'Repeat',
                hint: '$_selectedRepeat minutes early',
                widget: DropdownButton<String>(
                  borderRadius: BorderRadius.circular(15),
                  onChanged: (newValue) {
                    setState(() {
                      _selectedRepeat = newValue!;
                    });
                  },
                  icon: const Icon(
                    Icons.arrow_drop_down,
                    size: 32,
                  ),
                  items: repeatList
                      .map(
                        (String value) => DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                          onTap: () {},
                        ),
                      )
                      .toList(),
                  underline: const SizedBox(
                    height: 0,
                    width: 0,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _colorPalit(),
                    MyButton(
                        label: 'Create Task',
                        onTap: () {
                          setState(() {
                            _validateDate();
                            Get.back();
                            _taskController.getTasks();
                          });
                        })
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  _validateDate() {
    if (_titleController.text.isNotEmpty && _noteController.text.isNotEmpty) {
      _addTasksToDb();
      Get.back();
    } else {
      Get.snackbar(
        'required',
        'All fields are required!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.white,
        colorText: pinkClr,
        icon: const Icon(
          Icons.warning_amber_rounded,
          color: Colors.red,
        ),
      );
    }
  }

  _addTasksToDb() async {
    int value = await _taskController.addTask(
      task: Task(
        title: _titleController.text,
        note: _noteController.text,
        isCompleted: 0,
        date: DateFormat.yMd().format(selectedDate),
        startTime: _startTime,
        endTime: _endTime,
        color: _selectedColor,
        remind: _selectedRemind,
        repeat: _selectedRepeat,
      ),
    );
    print('id $value');
  }

  Column _colorPalit() {
    return Column(
      children: [
        const Text('Color'),
        Wrap(
          children: List.generate(
            3,
            (index) {
              return InkWell(
                onTap: () {
                  setState(() {
                    _selectedColor = index;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: CircleAvatar(
                    child: index == _selectedColor
                        ? const Icon(
                            Icons.done,
                            color: Colors.white,
                          )
                        : null,
                    backgroundColor: index == 0
                        ? primaryClr
                        : index == 1
                            ? pinkClr
                            : orangeClr,
                  ),
                ),
              );
            },
          ),
        )
      ],
    );
  }

  _getDateFromUser() async {
    DateTime? _picktDate = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015),
        lastDate: DateTime(2030));
    if (_picktDate != null) {
      setState(() {
        selectedDate = _picktDate;
      });
    } else {
      setState(() {
        selectedDate = selectedDate;
      });
    }
  }

  _getTimeFromUser({required bool isStartTime}) async {
    TimeOfDay? _pickedDate = await showTimePicker(
      context: context,
      initialTime: isStartTime
          ? TimeOfDay.now()
          : TimeOfDay.fromDateTime(
              DateTime.now().add(
                const Duration(minutes: 15),
              ),
            ),
    );

    String _formatedTime = _pickedDate!.format(context);

    if (isStartTime) {
      setState(() {
        _startTime = _formatedTime;
      });
    } else if (!isStartTime) {
      setState(() {
        _endTime = _formatedTime;
      });
    } else {}
  }
}
