import 'package:octadesk_core/dtos/contact/contact_phone_dto.dart';
import 'package:octadesk_core/models/agent/agent_model.dart';

class AgentDTO {
  final String id;
  final String email;
  final String name;
  final int? roleType;
  final int? type;

  final bool? active;
  final bool? availability;
  final int? connectionStatus;
  final bool? connectionStatusManual;
  final Map<String, dynamic>? customFields;
  final bool? isEnabled;
  final String? lastService;
  final List<dynamic>? myApps;
  final String? thumbUrl;
  final List<dynamic>? webPushSubscriptions;

  final String? contactStatus;
  final Map<String, dynamic>? customField;
  final String? facebookId;
  final bool? guest;
  final String? idContactStatus;
  final List<dynamic>? organizations;
  final List<ContactPhoneDTO>? phoneContacts;
  final List<dynamic>? products;
  final List<dynamic>? externalIds;

  AgentDTO({
    required this.active,
    required this.availability,
    required this.connectionStatus,
    required this.connectionStatusManual,
    required this.customFields,
    required this.email,
    required this.id,
    required this.isEnabled,
    required this.lastService,
    required this.myApps,
    required this.name,
    required this.roleType,
    required this.thumbUrl,
    required this.type,
    required this.webPushSubscriptions,
    required this.contactStatus,
    required this.customField,
    required this.facebookId,
    required this.guest,
    required this.idContactStatus,
    required this.organizations,
    required this.phoneContacts,
    required this.products,
    required this.externalIds,
  });

  factory AgentDTO.fromMap(Map<String, dynamic> data) {
    return AgentDTO(
      active: data["active"],
      availability: data["availability"],
      connectionStatus: data["connectionStatus"],
      connectionStatusManual: data["connectionStatusManual"],
      customFields: data["customFields"],
      email: data["email"] ?? "",
      id: data["id"],
      isEnabled: data["isEnabled"],
      lastService: data["lastService"],
      myApps: data["myApps"] != null ? List.from(data["myApps"]) : null,
      name: data["name"],
      roleType: data["roleType"],
      thumbUrl: data["thumbUrl"],
      type: data["type"],
      webPushSubscriptions: List.from(data["webPushSubscriptions"]),
      contactStatus: data["contactStatus"],
      customField: data["customField"] != null ? Map.from(data["customField"]) : null,
      phoneContacts: data["phoneContacts"] != null ? List.from(data["phoneContacts"]).map((e) => ContactPhoneDTO.fromMap(e)).toList() : null,
      facebookId: data["facebookId"],
      guest: data["guest"],
      idContactStatus: data["idContactStatus"],
      organizations: data["organizations"] != null ? List.from(data["organizations"]) : null,
      products: data["products"] != null ? List.from(data["products"]) : null,
      externalIds: data["externalIds"] != null ? List.from(data["externalIds"]) : null,
    );
  }

  factory AgentDTO.fromModel(AgentModel model) {
    return AgentDTO(
      active: null,
      customField: {},
      email: model.email,
      facebookId: null,
      guest: false,
      id: model.id,
      name: model.name,
      organizations: [],
      phoneContacts: [],
      products: [],
      roleType: 2,
      thumbUrl: model.thumbUrl,
      type: 1,
      webPushSubscriptions: [],
      contactStatus: null,
      connectionStatus: null,
      connectionStatusManual: null,
      externalIds: [],
      idContactStatus: null,
      lastService: null,
      availability: null,
      customFields: {},
      isEnabled: true,
      myApps: [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "active": active,
      "availability": availability,
      "connectionStatus": connectionStatus,
      "connectionStatusManual": connectionStatusManual,
      "customFields": customFields,
      "email": email,
      "id": id,
      "isEnabled": isEnabled,
      "lastService": lastService,
      "myApps": myApps,
      "name": name,
      "roleType": roleType,
      "thumbUrl": thumbUrl,
      "type": type,
      "webPushSubscriptions": webPushSubscriptions,
      "contactStatus": contactStatus,
      "customField": customField,
      "phoneContacts": phoneContacts,
      "facebookId": facebookId,
      "guest": guest,
      "idContactStatus": idContactStatus,
      "organizations": organizations,
      "products": products,
      "externalIds": externalIds,
    };
  }
}
