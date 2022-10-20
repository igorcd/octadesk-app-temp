import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:octadesk_app/resources/index.dart';

class OctaListButton extends StatelessWidget {
  const OctaListButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSizes.s12,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          child: Row(
            children: [
              Expanded(
                child: Text("1'23"),
              ),
              Image.asset(AppIcons.angleLeft),
            ],
          ),
        ),
      ),
    );
  }
}
