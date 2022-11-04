class UsersQueryBuilder {
  int page;
  int limit;
  bool active;
  String search;

  UsersQueryBuilder({
    this.page = 1,
    this.limit = 20,
    this.search = "",
    this.active = true,
  });

  Map<String, dynamic> toMap() {
    var index = page - 1;
    var skip = index * limit;

    var filters = {
      "take": limit,
      "propertySort": "Name",
      "includeExcludedRecords": true,
      "sortDirection": "asc",
      "skip": skip,
      "externalQueries": [
        {
          "PropertyName": "Type",
          "Operator": 2,
          "ValueCompare": 2,
        },
        {
          "propertyName": "IsEnabled",
          "operator": 2,
          "valueCompare": active,
        }
      ],
    };

    if (search.isNotEmpty) {
      (filters["externalQueries"] as List<dynamic>).add(
        {
          "PropertyName": "TextSearch",
          "Operator": 4,
          "ValueCompare": search,
        },
      );
    }

    return filters;
  }
}
