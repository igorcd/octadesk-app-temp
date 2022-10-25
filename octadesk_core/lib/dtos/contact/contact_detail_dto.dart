import 'package:octadesk_core/dtos/index.dart';

class ContactDetailDTO {
  final String id;
  final bool isEnabled;
  final String name;
  final String email;
  final String thumbUrl;
  final List<ContactPhoneDTO> phoneContacts;
  final String organizationsName;
  final List<OrganizationDTO> organizations;
  final String idContactStatus;
  final int permissionView;

  final dynamic number;
  final dynamic dateCreation;
  final dynamic type;
  final dynamic roleType;
  final dynamic permissionType;
  final dynamic participantPermission;
  final dynamic contactStatusEvents;
  final dynamic hasPassword;
  final dynamic othersEmail;
  final dynamic documentCode;
  final dynamic othersDocumentCode;
  final dynamic documentCodeType;
  final dynamic documentIdentificationCode;
  final dynamic customerCode;
  final dynamic phone;
  final dynamic othersPhone;
  final dynamic thumbUrlEncrypted;
  final dynamic avatarName;
  final dynamic isEmailValidated;
  final dynamic isResetPassword;
  final dynamic invitePasswordSent;
  final dynamic idGroup;
  final dynamic idsGroups;
  final dynamic myApps;
  final dynamic customField;
  final dynamic products;
  final dynamic productsMembersJoin;
  final dynamic organization;
  final dynamic groups;
  final dynamic groupsMembersJoin;
  final dynamic groupsIds;
  final dynamic externalIds;
  final dynamic facebookId;
  final dynamic facebookUserName;
  final dynamic homePage;
  final dynamic lastLoginId;
  final dynamic checkUniqueBy;
  final dynamic subDomain;
  final dynamic emailSignature;
  final dynamic isSSOAuthorization;
  final dynamic remoteLogoutUrl;
  final dynamic metadataAttributes;
  final dynamic favoriteResponseTab;
  final dynamic phoneContactsDescribed;
  final dynamic accessRestriction;
  final dynamic accessNewList;
  final dynamic ticketListOrderConfig;
  final dynamic deviceTokens;
  final dynamic apps;
  final dynamic newOcta;

  ContactDetailDTO({
    required this.id,
    required this.isEnabled,
    required this.name,
    required this.email,
    required this.thumbUrl,
    required this.phoneContacts,
    required this.number,
    required this.dateCreation,
    required this.type,
    required this.roleType,
    required this.permissionType,
    required this.participantPermission,
    required this.contactStatusEvents,
    required this.hasPassword,
    required this.othersEmail,
    required this.documentCode,
    required this.othersDocumentCode,
    required this.documentCodeType,
    required this.documentIdentificationCode,
    required this.customerCode,
    required this.phone,
    required this.othersPhone,
    required this.thumbUrlEncrypted,
    required this.avatarName,
    required this.isEmailValidated,
    required this.isResetPassword,
    required this.invitePasswordSent,
    required this.idGroup,
    required this.idsGroups,
    required this.myApps,
    required this.customField,
    required this.products,
    required this.productsMembersJoin,
    required this.groups,
    required this.groupsMembersJoin,
    required this.groupsIds,
    required this.organization,
    required this.organizations,
    required this.organizationsName,
    required this.externalIds,
    required this.facebookId,
    required this.facebookUserName,
    required this.homePage,
    required this.lastLoginId,
    required this.checkUniqueBy,
    required this.permissionView,
    required this.subDomain,
    required this.emailSignature,
    required this.isSSOAuthorization,
    required this.remoteLogoutUrl,
    required this.metadataAttributes,
    required this.favoriteResponseTab,
    required this.phoneContactsDescribed,
    required this.accessRestriction,
    required this.accessNewList,
    required this.ticketListOrderConfig,
    required this.deviceTokens,
    required this.apps,
    required this.newOcta,
    required this.idContactStatus,
  });

  factory ContactDetailDTO.fromMap(Map<String, dynamic> data) {
    return ContactDetailDTO(
      id: data["id"] ?? "",
      isEnabled: data["isEnabled"] ?? false,
      name: data["name"] ?? "",
      email: data["email"] ?? "",
      thumbUrl: data["thumbUrl"] ?? "",
      phoneContacts: List.from(data["phoneContacts"] ?? []).map((e) => ContactPhoneDTO.fromMap(e)).toList(),
      organizationsName: data["organizationsName"] ?? "",
      organizations: List.from(data["organizations"] ?? []).map((e) => OrganizationDTO.fromMap(e)).toList(),
      idContactStatus: data["idContactStatus"],
      permissionView: data["permissionView"],

      // Ignorar daqui pra baixo
      number: data["number"],
      dateCreation: data["dateCreation"],
      type: data["type"],
      roleType: data["roleType"],
      permissionType: data["permissionType"],
      participantPermission: data["participantPermission"],
      contactStatusEvents: data["contactStatusEvents"],
      hasPassword: data["hasPassword"],
      othersEmail: data["othersEmail"],
      documentCode: data["documentCode"],
      othersDocumentCode: data["othersDocumentCode"],
      documentCodeType: data["documentCodeType"],
      documentIdentificationCode: data["documentIdentificationCode"],
      customerCode: data["customerCode"],
      phone: data["phone"],
      othersPhone: data["othersPhone"],
      thumbUrlEncrypted: data["thumbUrlEncrypted"],
      avatarName: data["avatarName"],
      isEmailValidated: data["isEmailValidated"],
      isResetPassword: data["isResetPassword"],
      invitePasswordSent: data["invitePasswordSent"],
      idGroup: data["idGroup"],
      idsGroups: data["idsGroups"],
      myApps: data["myApps"],
      customField: data["customField"],
      products: data["products"],
      productsMembersJoin: data["productsMembersJoin"],
      groups: data["groups"],
      groupsMembersJoin: data["groupsMembersJoin"],
      groupsIds: data["groupsIds"],
      organization: data["organization"],
      externalIds: data["externalIds"],
      facebookId: data["facebookId"],
      facebookUserName: data["facebookUserName"],
      homePage: data["homePage"],
      lastLoginId: data["lastLoginId"],
      checkUniqueBy: data["checkUniqueBy"],
      subDomain: data["subDomain"],
      emailSignature: data["emailSignature"],
      isSSOAuthorization: data["isSSOAuthorization"],
      remoteLogoutUrl: data["remoteLogoutUrl"],
      metadataAttributes: data["metadataAttributes"],
      favoriteResponseTab: data["favoriteResponseTab"],
      phoneContactsDescribed: data["phoneContactsDescribed"],
      accessRestriction: data["accessRestriction"],
      accessNewList: data["accessNewList"],
      ticketListOrderConfig: data["ticketListOrderConfig"],
      deviceTokens: data["deviceTokens"],
      apps: data["apps"],
      newOcta: data["newOcta"],
    );
  }
}
