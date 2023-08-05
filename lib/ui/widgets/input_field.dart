import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app/ui/size_config.dart';
import 'package:todo_app/ui/theme.dart';

class InputField extends StatelessWidget {
  const InputField(
      {Key? key,
      required this.title,
      required this.hint,
      this.controller,
      this.widget})
      : super(key: key);

  final String title;
  final String hint;
  final TextEditingController? controller;
  final Widget? widget;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Themes().titleStyle,
          ),
          Container(
            padding: const EdgeInsets.only(
              left: 15,
            ),
            margin: const EdgeInsets.only(top: 8),
            width: SizeConfig.screenWidth,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.grey,
              ),
            ),
            height: 52,
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: controller,
                    readOnly: widget != null ? true : false,
                    autofocus: false,
                    cursorColor:
                        Get.isDarkMode ? Colors.grey[100] : Colors.grey[700],
                    decoration: InputDecoration(
                      hintText: hint,
                      hintStyle: Themes().subTitleStyle,
                      enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(
                          width: 0,
                        ),
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(
                          width: 0,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 15),
                  child: widget ?? Container(),
                  
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
