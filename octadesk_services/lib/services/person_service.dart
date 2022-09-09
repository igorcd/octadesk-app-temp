import 'package:dio/dio.dart';
import 'package:octadesk_core/dtos/contact/contact_list_dto.dart';
import 'package:octadesk_core/octadesk_core.dart';
import 'package:octadesk_services/http_clients/octa_client.dart';

class PersonService {
  /// GET - Dados do usuário
  static Future<ContactDTO> getPerson(String id) async {
    var resp = await OctaClient.personsService.get('/', queryParameters: {"id": id});
    return ContactDTO.fromMap(resp.data);
  }

  /// PUT - Alterar Status do usuáripo
  static Future<ContactDTO> changePersonStatus({required String newStatus, required String id, required String idContactStatus}) async {
    await OctaClient.chat.put('/rooms/customer', data: {
      "customer": {
        "id": id,
        "idContactStatus": idContactStatus,
        "contactStatus": newStatus,
      }
    });

    var newPerson = await getPerson(id);
    return newPerson;
  }

  /// GET - Get all Contact Status
  static Future<List<ContactStatusDTO>> getContactStatus() async {
    var resp = await OctaClient.personsService.get('/contact-status');
    return List.from(resp.data).map((el) => ContactStatusDTO.fromMap(el)).toList();
  }

  static Future<List<ContactListDTO>> getPersons({required int page, String search = ""}) async {
    var index = page - 1;
    var skip = index * 10;
    var take = 10;

    var filters = {
      "Take": take,
      "PropertySort": "Name",
      "includeExcludedRecords": false,
      "SortDirection": "asc",
      "Skip": skip,
    };

    if (search.isNotEmpty) {
      filters.addAll({
        "ExternalQueries": [
          {
            "PropertyName": "Type",
            "Operator": 2,
            "ValueCompare": 2,
          },
          {
            "PropertyName": "TextSearch",
            "Operator": 4,
            "ValueCompare": search,
          }
        ],
        "ExternalQueriesOr": [],
      });
    }

    var resp = await OctaClient.personsService.post('/filter', data: filters);
    return List.from(resp.data).map((e) => ContactListDTO.fromMap(e)).toList();
  }

  // GET - Person na tela Iniciar nova conversa
  static Future<List<ContactListDTO>> getPersonsToStartNewConversation({required int page, String search = "", CancelToken? cancelToken}) async {
    Map<dynamic, dynamic> dataToSend = {
      "filter": {
        "phoneContacts.Type": "1",
      },
      "options": {
        "fields": "Name Email Organization PhoneContacts",
        "pageSize": 10,
        "pageNumber": page,
        "detailed": true,
      }
    };

    if (search.isNotEmpty) {
      dataToSend["filter"] = {
        "phoneContacts.Type": "1",
        "\$and": [
          {
            "\$or": [
              {
                "Email": {"\$regex": search}
              },
              {
                "Name": {"\$regex": search, "\$options": "i"}
              },
              {
                "Organization.Name": {"\$regex": search, "\$options": "i"}
              }
            ]
          }
        ]
      };
    }

    var resp = await OctaClient.persons.post('/filter', data: dataToSend, cancelToken: cancelToken);
    return List.from(resp.data).map((e) => ContactListDTO.fromMap(e)).toList();
  }

  // GET - Organizações
  static Future<List<OrganizationDTO>> getOrganizations() async {
    var resp = await OctaClient.personsService.get('/organizations/');
    return List.from(resp.data).map((e) => OrganizationDTO.fromMap(e)).toList();
  }
}
