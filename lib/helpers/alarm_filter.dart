class IncidentFilter {
  List<FilterCondition> _filters;

  IncidentFilter() {
    _filters = new List<FilterCondition>();
  }

  IncidentFilter addWhere(String field, String conditionKey, String conditionValue) {
    this._filters.add(new FilterCondition(field, conditionKey, conditionValue));
    return this;
  }

  List<FilterCondition> get filters => _filters;
}

class FilterCondition {
  String _field;
  String _key;
  String _value;

  FilterCondition(String field, String conditionKey, String conditionValue) {
    this._field = field;
    this._key = conditionKey;
    this._value = conditionValue;
  }

  String get field => _field;
  String get key => _key;
  String get value => _value;
}