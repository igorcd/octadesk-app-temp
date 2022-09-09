class MessageProductModel {
  final String name;
  final double price;
  final String image;
  final String url;

  MessageProductModel({required this.name, required this.price, required this.image, required this.url});

  factory MessageProductModel.fromMap(Map<String, dynamic> map) {
    var product = MessageProductModel(
      name: map["name"],
      price: double.parse(map["pricing"]["salePrice"]["amount"].toString()),
      image: map["assets"]["primaryImageUrl"],
      url: map["assets"]["url"],
    );
    return product;
  }
}
