import 'package:octadesk_core/dtos/index.dart';

class ContactDetailDTO {
  String id;
  bool isEnabled;
  String name;
  String email;
  String thumbUrl;
  List<ContactPhoneDTO> phoneContacts;
  String organizationsName;
  List<OrganizationDTO> organizations;
  String idContactStatus;
  int permissionView;

  dynamic number;
  dynamic dateCreation;
  dynamic type;
  dynamic roleType;
  dynamic permissionType;
  dynamic participantPermission;
  dynamic contactStatusEvents;
  dynamic hasPassword;
  dynamic othersEmail;
  dynamic documentCode;
  dynamic othersDocumentCode;
  dynamic documentCodeType;
  dynamic documentIdentificationCode;
  dynamic customerCode;
  dynamic phone;
  dynamic othersPhone;
  dynamic thumbUrlEncrypted;
  dynamic avatarName;
  dynamic isEmailValidated;
  dynamic isResetPassword;
  dynamic invitePasswordSent;
  dynamic idGroup;
  dynamic idsGroups;
  dynamic myApps;
  dynamic customField;
  dynamic products;
  dynamic productsMembersJoin;
  dynamic organization;
  dynamic groups;
  dynamic groupsMembersJoin;
  dynamic groupsIds;
  dynamic externalIds;
  dynamic facebookId;
  dynamic facebookUserName;
  dynamic homePage;
  dynamic lastLoginId;
  dynamic checkUniqueBy;
  dynamic subDomain;
  dynamic emailSignature;
  dynamic isSSOAuthorization;
  dynamic remoteLogoutUrl;
  dynamic metadataAttributes;
  dynamic favoriteResponseTab;
  dynamic phoneContactsDescribed;
  dynamic accessRestriction;
  dynamic accessNewList;
  dynamic ticketListOrderConfig;
  dynamic deviceTokens;
  dynamic apps;
  dynamic newOcta;

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

  ContactDetailDTO clone() {
    return ContactDetailDTO(
      id: id,
      isEnabled: isEnabled,
      name: name,
      email: email,
      thumbUrl: thumbUrl,
      phoneContacts: phoneContacts.map((e) => e.clone()).toList(),
      number: number,
      dateCreation: dateCreation,
      type: type,
      roleType: roleType,
      permissionType: permissionType,
      participantPermission: participantPermission,
      contactStatusEvents: contactStatusEvents,
      hasPassword: hasPassword,
      othersEmail: othersEmail,
      documentCode: documentCode,
      othersDocumentCode: othersDocumentCode,
      documentCodeType: documentCodeType,
      documentIdentificationCode: documentIdentificationCode,
      customerCode: customerCode,
      phone: phone,
      othersPhone: othersPhone,
      thumbUrlEncrypted: thumbUrlEncrypted,
      avatarName: avatarName,
      isEmailValidated: isEmailValidated,
      isResetPassword: isResetPassword,
      invitePasswordSent: invitePasswordSent,
      idGroup: idGroup,
      idsGroups: idsGroups,
      myApps: myApps,
      customField: customField,
      products: products,
      productsMembersJoin: productsMembersJoin,
      groups: groups,
      groupsMembersJoin: groupsMembersJoin,
      groupsIds: groupsIds,
      organization: null,
      organizations: organizations.map((e) => e.clone()).toList(),
      organizationsName: organizationsName,
      externalIds: externalIds,
      facebookId: facebookId,
      facebookUserName: facebookUserName,
      homePage: homePage,
      lastLoginId: lastLoginId,
      checkUniqueBy: checkUniqueBy,
      permissionView: permissionView,
      subDomain: subDomain,
      emailSignature: emailSignature,
      isSSOAuthorization: isSSOAuthorization,
      remoteLogoutUrl: remoteLogoutUrl,
      metadataAttributes: metadataAttributes,
      favoriteResponseTab: favoriteResponseTab,
      phoneContactsDescribed: phoneContactsDescribed,
      accessRestriction: accessRestriction,
      accessNewList: accessNewList,
      ticketListOrderConfig: ticketListOrderConfig,
      deviceTokens: deviceTokens,
      apps: apps,
      newOcta: newOcta,
      idContactStatus: idContactStatus,
    );
  }

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

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "isEnabled": isEnabled,
      "name": name,
      "email": email,
      "thumbUrl": thumbUrl,
      "phoneContacts": phoneContacts.map((e) => e.toMap()).toList(),
      "organizationsName": organizationsName,
      "organizations": organizations.map((e) => e.toMap()).toList(),
      "permissionView": permissionView,
      "number": number,
      "dateCreation": dateCreation,
      "type": type,
      "roleType": roleType,
      "permissionType": permissionType,
      "participantPermission": participantPermission,
      "contactStatusEvents": contactStatusEvents,
      "hasPassword": hasPassword,
      "othersEmail": othersEmail,
      "documentCode": documentCode,
      "othersDocumentCode": othersDocumentCode,
      "documentCodeType": documentCodeType,
      "documentIdentificationCode": documentIdentificationCode,
      "customerCode": customerCode,
      "phone": phone,
      "othersPhone": othersPhone,
      "thumbUrlEncrypted": thumbUrlEncrypted,
      "avatarName": avatarName,
      "isEmailValidated": isEmailValidated,
      "isResetPassword": isResetPassword,
      "invitePasswordSent": invitePasswordSent,
      "idGroup": idGroup,
      "idsGroups": idsGroups,
      "myApps": myApps,
      "customField": customField,
      "products": products,
      "productsMembersJoin": productsMembersJoin,
      "organization": organization,
      "groups": groups,
      "groupsMembersJoin": groupsMembersJoin,
      "groupsIds": groupsIds,
      "externalIds": externalIds,
      "facebookId": facebookId,
      "facebookUserName": facebookUserName,
      "homePage": homePage,
      "lastLoginId": lastLoginId,
      "checkUniqueBy": checkUniqueBy,
      "subDomain": subDomain,
      "emailSignature": emailSignature,
      "isSSOAuthorization": isSSOAuthorization,
      "remoteLogoutUrl": remoteLogoutUrl,
      "metadataAttributes": metadataAttributes,
      "favoriteResponseTab": favoriteResponseTab,
      "phoneContactsDescribed": phoneContactsDescribed,
      "accessRestriction": accessRestriction,
      "accessNewList": accessNewList,
      "ticketListOrderConfig": ticketListOrderConfig,
      "deviceTokens": deviceTokens,
      "apps": apps,
      "newOcta": newOcta,
    };
  }
}
