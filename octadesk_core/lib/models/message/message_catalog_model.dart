import 'package:octadesk_core/models/message/message_product_model.dart';

class MessageCatalogModel {
  final String id;
  final List<MessageProductModel> products;

  MessageCatalogModel({required this.id, required this.products});

  factory MessageCatalogModel.fromMap(Map<String, dynamic> map) {
    // "extendedData": {
    //             "bot": {
    //                 "allowUserInput": false
    //             },
    //             "interactive": {
    //                 "header": null,
    //                 "footer": null,
    //                 "body": {
    //                     "message": "<p>Com o Octadesk, dá pra gerenciar diferentes conversas com clientes em um só lugar.</p>",
    //                     "options": []
    //                 }
    //             }
    //         },

    // Id
    var id = map["interactive"]["products"]["catalogId"];

    // Sessões
    List<Map<String, dynamic>> sections = List.from(map["interactive"]["products"]["sections"]);

    // Produtos
    var products = sections.fold<List<MessageProductModel>>([], (previousValue, element) {
      List<Map<String, dynamic>> values = List.from(element["options"]);

      var mappedProduct = values.map<MessageProductModel>((e) {
        var product = MessageProductModel.fromMap(Map.from(e));
        return product;
      }).toList();

      return [...previousValue, ...mappedProduct];
    });

    return MessageCatalogModel(
      id: id,
      products: products,
    );
  }
}
