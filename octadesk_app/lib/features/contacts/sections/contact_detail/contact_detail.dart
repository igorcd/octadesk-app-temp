import 'package:flutter/material.dart';
import 'package:octadesk_app/components/octa_avatar.dart';
import 'package:octadesk_app/components/octa_chip.dart';
import 'package:octadesk_app/components/octa_list_button.dart';
import 'package:octadesk_app/components/octa_text.dart';
import 'package:octadesk_app/components/octa_toogle_button.dart';
import 'package:octadesk_app/resources/app_colors.dart';
import 'package:octadesk_app/resources/app_sizes.dart';

class ContactDetail extends StatelessWidget {
  const ContactDetail({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 450),
      child: ListView(
        padding: const EdgeInsets.symmetric(vertical: AppSizes.s14),
        children: [
          // Avatar do usuário
          const Center(
            child: OctaAvatar(
              size: AppSizes.s40,
              fontSize: AppSizes.s06,
              name: "Fulana",
            ),
          ),

          // Nome do usuário
          const SizedBox(height: AppSizes.s06),
          OctaText.displaySmall("Camila Fernandes", textAlign: TextAlign.center),

          // Email do usuário
          const SizedBox(height: AppSizes.s01),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              OctaText.bodySmall(
                "Acme Inc",
                textAlign: TextAlign.center,
              ),
              const SizedBox(width: AppSizes.s02),
              const OctaChip(color: AppColors.lime, text: "Lead"),
            ],
          ),

          // E-mail
          const SizedBox(height: AppSizes.s00_5),
          OctaText.bodySmall(
            "camila.fernandes@acmeinc.com",
            textAlign: TextAlign.center,
          ),

          // Telefone
          const SizedBox(height: AppSizes.s00_5),
          OctaText.bodySmall(
            "+55 11 997 5859",
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: AppSizes.s07),
          Center(
            child: OctaToogleButton(
              active: true,
              onChange: (value) {},
            ),
          ),
          const SizedBox(height: AppSizes.s07),
          OctaListButton(),
          Divider(),
          OctaListButton(),
          Divider(),
        ],
      ),
    );
  }
}
