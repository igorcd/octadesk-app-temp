import 'package:octadesk_core/dtos/index.dart';

class ContactListDTO {
  final String id;
  final String email;
  final String name;
  final List<ContactPhoneDTO> phoneContacts;
  final String? thumbUrl;
  final OrganizationDTO? organization;
  final String contactStatus;

  final dynamic apps;
  final dynamic dateCreation;
  final dynamic deviceTokens;
  final dynamic groups;
  final dynamic isEnabled;
  final dynamic isLocked;
  final dynamic loginTries;
  final dynamic myApps;
  final dynamic myTicketViews;
  final dynamic organizations;
  final dynamic othersEmail;
  final dynamic participantPermission;
  final dynamic permissionType;
  final dynamic permissionView;
  final dynamic products;
  final dynamic roleType;
  final dynamic type;
  final dynamic webPushSubscriptions;

  ContactListDTO({
    required this.email,
    required this.id,
    required this.isEnabled,
    required this.name,
    required this.phoneContacts,
    required this.thumbUrl,
    required this.apps,
    required this.dateCreation,
    required this.deviceTokens,
    required this.groups,
    required this.isLocked,
    required this.loginTries,
    required this.myApps,
    required this.myTicketViews,
    required this.organization,
    required this.organizations,
    required this.othersEmail,
    required this.participantPermission,
    required this.permissionType,
    required this.permissionView,
    required this.products,
    required this.roleType,
    required this.type,
    required this.webPushSubscriptions,
    required this.contactStatus,
  });

  factory ContactListDTO.fromMap(Map<String, dynamic> map) {
    return ContactListDTO(
        email: map["email"],
        id: map["id"],
        isEnabled: map["isEnabled"],
        name: map["name"],
        phoneContacts: List.from(map["phoneContacts"]).map((e) => ContactPhoneDTO.fromMap(e)).toList(),
        thumbUrl: map["thumbUrl"],
        apps: map["apps"],
        dateCreation: map["dateCreation"],
        deviceTokens: map["deviceTokens"],
        groups: map["groups"],
        isLocked: map["isLocked"],
        loginTries: map["loginTries"],
        myApps: map["myApps"],
        myTicketViews: map["myTicketViews"],
        organization: map["organization"] != null ? OrganizationDTO.fromMap(map["organization"]) : null,
        organizations: map["organizations"],
        othersEmail: map["othersEmail"],
        participantPermission: map["participantPermission"],
        permissionType: map["permissionType"],
        permissionView: map["permissionView"],
        products: map["products"],
        roleType: map["roleType"],
        type: map["type"],
        webPushSubscriptions: map["webPushSubscriptions"],
        contactStatus: map["contactStatus"] ?? "Lead");
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "email": email,
      "name": name,
      "phoneContacts": phoneContacts.map((e) => e.toMap()).toList(),
      "thumbUrl": thumbUrl,
      "apps": apps,
      "dateCreation": dateCreation,
      "deviceTokens": deviceTokens,
      "groups": groups,
      "isEnabled": isEnabled,
      "isLocked": isLocked,
      "loginTries": loginTries,
      "myApps": myApps,
      "myTicketViews": myTicketViews,
      "organization": organization?.toMap(),
      "organizations": organizations,
      "othersEmail": othersEmail,
      "participantPermission": participantPermission,
      "permissionType": permissionType,
      "permissionView": permissionView,
      "products": products,
      "roleType": roleType,
      "type": type,
      "webPushSubscriptions": webPushSubscriptions,
      "contactStatus": contactStatus,
    };
  }
}
