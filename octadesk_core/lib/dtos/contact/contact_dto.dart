class ContactDTO {
  final bool accessNewList;
  final dynamic accessRestriction;
  final List<dynamic> apps;
  final String avatarName;
  final dynamic checkUniqueBy;
  final String? contactStatus;
  final dynamic contactStatusEvents;
  final dynamic customField;
  final dynamic customerCode;
  final String dateCreation;
  final List<dynamic> deviceTokens;
  final dynamic documentCode;
  final dynamic documentCodeType;
  final dynamic documentIdentificationCode;
  final String email;
  final dynamic emailSignature;
  final List<dynamic> externalIds;
  final dynamic facebookId;
  final dynamic facebookUserName;
  final int favoriteResponseTab;
  final List<dynamic> groups;
  final List<dynamic> groupsIds;
  final String groupsMembersJoin;
  final bool hasPassword;
  final dynamic homePage;
  final String id;
  String idContactStatus;
  final dynamic idGroup;
  final List<dynamic> idsGroups;
  final bool invitePasswordSent;
  final bool isEmailValidated;
  final bool isEnabled;
  final bool isResetPassword;
  final dynamic isSSOAuthorization;
  final dynamic lastLoginId;
  final List<dynamic> metadataAttributes;
  final List<dynamic> myApps;
  final String name;
  final int number;
  final dynamic organization;
  final List<dynamic> organizations;
  final String organizationsName;
  final dynamic othersCustomerCode;
  final dynamic othersDocumentCode;
  final List<dynamic> othersEmail;
  final dynamic othersPhone;
  final int participantPermission;
  final int permissionType;
  final int permissionView;
  final dynamic phone;
  final List<dynamic> phoneContacts;
  final String phoneContactsDescribed;
  final List<dynamic> products;
  final String productsMembersJoin;
  final dynamic remoteLogoutUrl;
  final dynamic responsible;
  final int roleType;
  final dynamic subDomain;
  final String? thumbUrl;
  final String? thumbUrlEncrypted;
  final List<dynamic> ticketListOrderConfig;
  final int type;

  ContactDTO({
    required this.accessNewList,
    required this.accessRestriction,
    required this.apps,
    required this.avatarName,
    required this.checkUniqueBy,
    required this.contactStatus,
    required this.contactStatusEvents,
    required this.customField,
    required this.customerCode,
    required this.dateCreation,
    required this.deviceTokens,
    required this.documentCode,
    required this.documentCodeType,
    required this.documentIdentificationCode,
    required this.email,
    required this.emailSignature,
    required this.externalIds,
    required this.facebookId,
    required this.facebookUserName,
    required this.favoriteResponseTab,
    required this.groups,
    required this.groupsIds,
    required this.groupsMembersJoin,
    required this.hasPassword,
    required this.homePage,
    required this.id,
    required this.idContactStatus,
    required this.idGroup,
    required this.idsGroups,
    required this.invitePasswordSent,
    required this.isEmailValidated,
    required this.isEnabled,
    required this.isResetPassword,
    required this.isSSOAuthorization,
    required this.lastLoginId,
    required this.metadataAttributes,
    required this.myApps,
    required this.name,
    required this.number,
    required this.organization,
    required this.organizations,
    required this.organizationsName,
    required this.othersCustomerCode,
    required this.othersDocumentCode,
    required this.othersEmail,
    required this.othersPhone,
    required this.participantPermission,
    required this.permissionType,
    required this.permissionView,
    required this.phone,
    required this.phoneContacts,
    required this.phoneContactsDescribed,
    required this.products,
    required this.productsMembersJoin,
    required this.remoteLogoutUrl,
    required this.responsible,
    required this.roleType,
    required this.subDomain,
    required this.thumbUrl,
    required this.thumbUrlEncrypted,
    required this.ticketListOrderConfig,
    required this.type,
  });

  factory ContactDTO.fromMap(Map<String, dynamic> data) {
    return ContactDTO(
      accessNewList: data["accessNewList"],
      accessRestriction: data["accessRestriction"],
      apps: List.from(data["apps"]),
      avatarName: data["avatarName"],
      checkUniqueBy: data["checkUniqueBy"],
      contactStatus: data["contactStatus"],
      contactStatusEvents: data["contactStatusEvents"],
      customField: data["customField"],
      customerCode: data["customerCode"],
      dateCreation: data["dateCreation"],
      deviceTokens: List.from(data["deviceTokens"]),
      documentCode: data["documentCode"],
      documentCodeType: data["documentCodeType"],
      documentIdentificationCode: data["documentIdentificationCode"],
      email: data["email"],
      emailSignature: data["emailSignature"],
      externalIds: List.from(data["externalIds"]),
      facebookId: data["facebookId"],
      facebookUserName: data["facebookUserName"],
      favoriteResponseTab: data["favoriteResponseTab"],
      groups: List.from(data["groups"]),
      groupsIds: List.from(data["groupsIds"]),
      groupsMembersJoin: data["groupsMembersJoin"],
      hasPassword: data["hasPassword"],
      homePage: data["homePage"],
      id: data["id"],
      idContactStatus: data["idContactStatus"],
      idGroup: data["idGroup"],
      idsGroups: List.from(data["idsGroups"]),
      invitePasswordSent: data["invitePasswordSent"],
      isEmailValidated: data["isEmailValidated"],
      isEnabled: data["isEnabled"],
      isResetPassword: data["isResetPassword"],
      isSSOAuthorization: data["isSSOAuthorization"],
      lastLoginId: data["lastLoginId"],
      metadataAttributes: List.from(data["metadataAttributes"]),
      myApps: List.from(data["myApps"]),
      name: data["name"],
      number: data["number"],
      organization: data["organization"],
      organizations: List.from(data["organizations"]),
      organizationsName: data["organizationsName"],
      othersCustomerCode: data["othersCustomerCode"],
      othersDocumentCode: data["othersDocumentCode"],
      othersEmail: List.from(data["othersEmail"]),
      othersPhone: data["othersPhone"],
      participantPermission: data["participantPermission"],
      permissionType: data["permissionType"],
      permissionView: data["permissionView"],
      phone: data["phone"],
      phoneContacts: List.from(data["phoneContacts"]),
      phoneContactsDescribed: data["phoneContactsDescribed"],
      products: List.from(data["products"]),
      productsMembersJoin: data["productsMembersJoin"],
      remoteLogoutUrl: data["remoteLogoutUrl"],
      responsible: data["responsible"],
      roleType: data["roleType"],
      subDomain: data["subDomain"],
      thumbUrl: data["thumbUrl"],
      thumbUrlEncrypted: data["thumbUrlEncrypted"],
      ticketListOrderConfig: List.from(data["ticketListOrderConfig"]),
      type: data["type"],
    );
  }
}
