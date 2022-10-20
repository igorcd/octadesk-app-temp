class UsersQueryBuilder {
  int page;
  int limit;
  String search;

  UsersQueryBuilder({
    this.page = 1,
    this.limit = 20,
    this.search = "",
  });

  Map<String, dynamic> toMap() {
    var index = page - 1;
    var skip = index * limit;

    var filters = {
      "Take": limit,
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

    return filters;
  }
}
