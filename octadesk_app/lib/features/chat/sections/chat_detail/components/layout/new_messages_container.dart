import 'package:flutter/material.dart';
import 'package:octadesk_app/resources/index.dart';

class NewMassagesContainer extends StatelessWidget {
  final int messagesLength;
  final void Function() onTap;
  const NewMassagesContainer(this.messagesLength, {required this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.s04, vertical: AppSizes.s01),
      margin: const EdgeInsets.all(AppSizes.s05),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(AppSizes.s10),
        boxShadow: const [
          BoxShadow(blurRadius: 10, offset: Offset(0, 5), color: Colors.black12),
        ],
      ),
      clipBehavior: Clip.hardEdge,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: Text(
            messagesLength == 0 ? "Últimas mensagens" : "Você possui $messagesLength nova${messagesLength == 1 ? '' : 's'} mensage${messagesLength == 1 ? 'm' : 'ns'}",
            style: const TextStyle(fontFamily: "Poppins", color: Colors.white, fontSize: AppSizes.s03_5, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}
