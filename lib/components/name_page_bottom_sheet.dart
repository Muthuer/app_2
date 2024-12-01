import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class NamePage extends StatelessWidget {
  const NamePage(
      {super.key,
      required this.nameController,
      required this.validateName,
      required this.pageComplected,
      required this.hintText,
      required this.title});
  final TextEditingController nameController;
  final void Function(String) validateName;
  final bool pageComplected;
  final String hintText;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          // style: Theme.of(context).textTheme.titleLarge,
          style: TextStyle(
            fontSize: 16.sp,
            color: Colors.grey.shade600,
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        TextField(
          cursorColor: Colors.pink[200],
          controller: nameController,
          autofocus: true,
          maxLength: 20,
          onChanged: validateName,
          decoration: InputDecoration(
            suffixIcon: pageComplected
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: const Icon(
                          Icons.check,
                          size: 15,
                        )),
                  )
                : null,
            filled: true,
            fillColor: Colors
                .pink[50], // Optional: Background color for the text field
            hintText: hintText,
            hintStyle: TextStyle(fontSize: 13.5),
            errorText:
                nameController.text.length > 2 || nameController.text.isEmpty
                    ? null
                    : "Invalid Name",
            border: OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(15.0), // Adjust the radius here
              borderSide: BorderSide.none, // Remove the border
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.0),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.0),
              borderSide: BorderSide.none,
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.0),
              borderSide:
                  BorderSide(color: Colors.red), // Optional: Error border
            ),
          ),
        ),
      ],
    );
  }
}
