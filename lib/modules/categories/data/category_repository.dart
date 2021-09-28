import 'package:injectable/injectable.dart';
import 'package:mysql1/mysql1.dart';
import 'package:onde_gastei_api/application/database/i_database_connection.dart';
import 'package:onde_gastei_api/exceptions/database_exception.dart';
import 'package:onde_gastei_api/logs/i_log.dart';
import 'package:onde_gastei_api/modules/categories/data/i_category_repository.dart';
import 'package:onde_gastei_api/modules/categories/view_model/category_save_input_model.dart';

@LazySingleton(as: ICategoryRepository)
class CategoryRepository implements ICategoryRepository {
  CategoryRepository({required this.connection, required this.log});

  final IDatabaseConnection connection;
  final ILog log;

  @override
  Future<int> createCategory(
      CategorySaveInputModel categorySaveInputModel) async {
    MySqlConnection? conn;

    try {
      conn = await connection.openConnection();
      final result = await conn.query('''
          insert into categoria (descricao, codigo_icone, codigo_cor, id_usuario) values (?,?,?,?)
      ''', [
        categorySaveInputModel.description,
        categorySaveInputModel.iconCode,
        categorySaveInputModel.colorCode,
        categorySaveInputModel.userId
      ]);

      return result.insertId ?? 0;
    } on MySqlException catch (e, s) {
      log.error('Erro ao criar categoria', e, s);
      throw DatabaseException();
    } finally {
      await conn?.close();
    }
  }
}
