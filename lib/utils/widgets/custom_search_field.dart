
import 'package:flutter/material.dart';

class CustomSearchField extends StatelessWidget {
  final String hintText;
  final Function(String)? onSubmitted;
  final TextEditingController textEditingController;
  const CustomSearchField({
    super.key,
    required this.hintText,
    required this.textEditingController,
    this.onSubmitted
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: const Color(0xffF0F0F0),
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: const Color(0xffE1E1E1))
      ),
      child:  Row(
        children: [
          // Search Icon
          const Padding(
            padding: EdgeInsets.only(
                left: 8.0),
            child: Icon(Icons.search,color: Color(0xff979797),)
          ),
          const SizedBox(
              width: 12), 
          // TextField
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 0.0),
                child: TextField(
                  onSubmitted: onSubmitted,
                  controller: textEditingController,
                  style: const TextStyle(color: Colors.black,fontSize: 15,fontWeight: FontWeight.w500),
                  cursorColor: Colors.white,
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 10),
                    hintText: hintText,
                    hintStyle: const TextStyle(
                      color: Color(0xff979797),
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
