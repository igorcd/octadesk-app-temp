import 'package:flutter/material.dart';
import 'package:octadesk_app/components/index.dart';
import 'package:octadesk_app/components/octa_chip.dart';
import 'package:octadesk_app/components/octa_select.dart';
import 'package:octadesk_app/components/responsive/responsive_widgets.dart';
import 'package:octadesk_app/features/contacts/sections/contact_detail/components/contact_organization_input.dart';
import 'package:octadesk_app/features/contacts/sections/contact_detail/components/contact_phone_input.dart';
import 'package:octadesk_app/features/contacts/sections/contact_detail/components/contact_text_input.dart';
import 'package:octadesk_app/components/octa_toogle_button.dart';
import 'package:octadesk_app/features/contacts/providers/contact_detail_provider.dart';
import 'package:octadesk_app/features/contacts/store/contacts_store.dart';
import 'package:octadesk_app/resources/app_colors.dart';
import 'package:octadesk_app/resources/app_icons.dart';
import 'package:octadesk_app/resources/app_sizes.dart';
import 'package:octadesk_app/resources/app_validators.dart';
import 'package:octadesk_conversation/octadesk_conversation.dart';
import 'package:provider/provider.dart';

class ContactDetail extends StatelessWidget {
  const ContactDetail({super.key});

  @override
  Widget build(BuildContext context) {
    ContactsStore contactsStore = Provider.of(context);
    var colorScheme = Theme.of(context).colorScheme;
    var screenSize = MediaQuery.of(context).size.width;

    return Consumer<ContactDetailProvider>(
      builder: (context, value, child) {
        return Form(
          key: value.form,
          autovalidateMode: value.autovalidateForm ? AutovalidateMode.onUserInteraction : AutovalidateMode.disabled,
          child: SingleChildScrollView(
            padding: screenSize < ScreenSize.sm
                ? const EdgeInsets.symmetric(vertical: AppSizes.s04, horizontal: AppSizes.s04)
                : const EdgeInsets.symmetric(vertical: AppSizes.s16, horizontal: AppSizes.s06),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 500),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (screenSize < ScreenSize.sm)
                      Row(
                        children: [
                          OctaIconButton(
                            onPressed: () => contactsStore.closeContact(),
                            icon: AppIcons.angleLeft,
                            color: colorScheme.onSurface,
                          ),
                        ],
                      ),
                    //
                    // Avatar do usuário
                    Center(
                      child: OctaAvatar(
                        size: AppSizes.s40,
                        fontSize: AppSizes.s06,
                        name: value.contact.name,
                        source: value.contact.thumbUrl,
                      ),
                    ),

                    // Nome do usuário
                    const SizedBox(height: AppSizes.s06),
                    OctaText.displaySmall(value.contact.name, textAlign: TextAlign.center),

                    // Email do usuário
                    const SizedBox(height: AppSizes.s01),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        OctaText.bodySmall(
                          value.contact.organizationsName,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(width: AppSizes.s02),
                        const OctaChip(color: AppColors.lime, text: "Lead"),
                      ],
                    ),

                    // Telefone
                    if (value.contact.phoneContacts.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: AppSizes.s00_5),
                        child: OctaText.bodySmall(
                          value.contact.phoneContacts[0].phoneNumber,
                          textAlign: TextAlign.center,
                        ),
                      ),

                    // E-mail
                    const SizedBox(height: AppSizes.s00_5),
                    OctaText.bodySmall(
                      value.contact.email,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSizes.s07),

                    // Contato ativo
                    Center(
                      child: OctaToogleButton(
                        active: value.contactActive,
                        onChange: (active) => value.contactActive = active,
                      ),
                    ),
                    const SizedBox(height: AppSizes.s07),

                    // // Histório de conversas
                    // OctaListButton(
                    //   onTap: () {},
                    //   text: "Histórico de conversas",
                    // ),
                    // const Divider(),

                    // // Histórico de tickets
                    // OctaListButton(
                    //   onTap: () {},
                    //   text: "Histórico de tickets",
                    // ),
                    // const Divider(),
                    // const SizedBox(height: AppSizes.s06),

                    // Nome do contato
                    OctaText.labelLarge("Name"),
                    ContactTextInput(
                      placeholder: "Insira o nome do contato",
                      controller: value.nameController,
                      validators: const [AppValidators.notEmpty],
                    ),

                    const Divider(height: AppSizes.s06),

                    // Email do contato
                    OctaText.labelLarge("E-mail"),
                    ContactTextInput(
                      placeholder: "Insira o e-mail",
                      controller: value.emailController,
                      validators: const [AppValidators.notEmpty],
                    ),

                    if (value.phones.isNotEmpty) const Divider(height: AppSizes.s06),

                    // Lista de telefones
                    ListView.separated(
                      shrinkWrap: true,
                      itemCount: value.phones.length,
                      separatorBuilder: (c, i) => const Divider(height: AppSizes.s06),
                      itemBuilder: (c, i) {
                        var phone = value.phones[i];

                        return ContactPhoneInput(
                          isMainPhone: i == 0,
                          phone: phone,
                          onRemove: () => value.removePhone(i),
                        );
                      },
                    ),
                    const Divider(height: AppSizes.s06),

                    // Novo contato
                    ContactPhoneInput(
                      inputKey: value.newContactPhoneKey,
                      contryCodeKey: value.newContactContryKey,
                      isMainPhone: false,
                      phone: value.newContactPhone,
                      onAdd: () => value.addPhoneNumber(),
                    ),

                    if (value.organizations.isNotEmpty) const Divider(height: AppSizes.s06),

                    // Organizações
                    ListView.separated(
                      shrinkWrap: true,
                      itemCount: value.organizations.length,
                      separatorBuilder: (c, i) => const Divider(height: AppSizes.s06),
                      itemBuilder: (context, index) {
                        return ContactOrganizationInput(
                          value: value.organizations[index].name ?? "",
                          onRemove: () => value.removeOrganization(index),
                        );
                      },
                    ),

                    const Divider(height: AppSizes.s06),

                    // Novas organizações
                    ContactOrganizationInput(
                      value: "Nome",
                      onAdd: () => value.addOrganization(context),
                    ),

                    const Divider(height: AppSizes.s06),

                    // Status do funil de vendas
                    OctaText.labelLarge("Status do funil de vendas"),
                    OctaSelect<String>(
                      values: OctadeskConversation.instance.contactTypes.map((e) {
                        return OctaSelectItem(text: e.name, value: e.id);
                      }).toList(),
                      value: value.salesFunnelStatus,
                      onChanged: (newValue) => value.salesFunnelStatus = newValue!,
                      hint: "Selecione o tipo de contato",
                    ),

                    const Divider(height: AppSizes.s06),

                    // Tickets visualizados
                    OctaText.labelLarge("Tickets visualizados na central"),
                    OctaSelect<TicketsVisualizationMode>(
                      values: [
                        OctaSelectItem(value: TicketsVisualizationMode.requested, text: "Solicitados pela pessoa"),
                        OctaSelectItem(value: TicketsVisualizationMode.all, text: "Todos em sua organização"),
                      ],
                      value: value.ticketsVisualizationMode,
                      onChanged: (newValue) => value.ticketsVisualizationMode = newValue,
                      hint: "Selecione",
                    ),

                    const SizedBox(height: AppSizes.s10),

                    Row(
                      children: [
                        Expanded(
                          child: OctaButton(
                            text: "Limpar",
                            onTap: () => value.clear(),
                            disabled: value.loading,
                            outline: true,
                          ),
                        ),
                        const SizedBox(width: AppSizes.s04),
                        Expanded(
                          child: OctaButton(
                            text: "Submeter",
                            onTap: () => value.submit(context),
                            loading: value.loading,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
