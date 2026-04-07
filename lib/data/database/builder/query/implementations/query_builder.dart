import '../i_query_builder.dart';

/// Builds SQL WHERE and LIMIT clauses from optional filter arguments and a row limit.
class QueryBuilder extends IQueryBuilder {
  final int? amount;
  final List<String>? whereArgs;

  const QueryBuilder({this.amount, this.whereArgs});

  @override
  String get query {
    String query_ = '';

    if (whereArgs != null && whereArgs!.isNotEmpty) {
      query_ += ' WHERE ${whereArgs!.map((arg) => '$arg = ?').join(' AND ')}';
    }

    if (amount != null && amount! > 0) {
      query_ += ' LIMIT $amount';
    }

    return query_;
  }
}
