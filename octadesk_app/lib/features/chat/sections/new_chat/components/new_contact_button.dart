import 'package:flutter/material.dart';
import 'package:octadesk_app/resources/index.dart';

class NewContactButton extends StatelessWidget {
  final void Function() onPressed;
  const NewContactButton({required this.onPressed, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSizes.s18,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.s06),
            child: Row(
              children: [
                Container(
                  width: AppSizes.s12,
                  height: AppSizes.s12,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppSizes.s02_5),
                    color: AppColors.blue.shade400,
                  ),
                  child: Image.asset(AppIcons.addUser, width: AppSizes.s06),
                ),
                const SizedBox(width: AppSizes.s04),
                Expanded(
                  child: Text(
                    "Adicionar novo contato",
                    style: TextStyle(
                      color: AppColors.blue.shade400,
                      fontSize: AppSizes.s04,
                      fontWeight: FontWeight.w500,
                      fontFamily: "Poppins",
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
