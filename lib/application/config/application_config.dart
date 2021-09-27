import 'package:dotenv/dotenv.dart' show env, load;
import 'package:get_it/get_it.dart';
import 'package:onde_gastei_api/application/config/database_connection_configuration.dart';
import 'package:onde_gastei_api/application/config/service_locator_config.dart';
import 'package:onde_gastei_api/application/router/router_configure.dart';
import 'package:onde_gastei_api/logs/i_log.dart';
import 'package:onde_gastei_api/logs/log.dart';
import 'package:shelf_router/shelf_router.dart';

class ApplicationConfig {
  Future<void> loadConfigApplication(Router router) async {
    await _loadEnv();
    _loadDependencies();
    _loadDatabaseConfig();
    _configLogger();
    _loadRoutersConfigure(router);
  }

  void _loadDependencies() => configureDependencies();

  void _loadRoutersConfigure(Router router) =>
      RouterConfigure(router).configure();

  void _configLogger() => GetIt.I.registerLazySingleton<ILog>(() => Log());

  Future<void> _loadEnv() async => load();

  void _loadDatabaseConfig() {
    final databaseConfig = DatabaseConnectionConfiguration(
        host: env['DATABASE_HOST'] ?? env['databaseHost']!,
        user: env['DATABASE_USER'] ?? env['databaseUser']!,
        password: env['DATABASE_PASSWORD'] ?? env['databasePassword']!,
        port: int.tryParse(env['DATABASE_PORT'] ?? env['databasePort']!) ?? 0,
        databaseName: env['DATABASE_NAME'] ?? env['databaseName']!);

    GetIt.I.registerSingleton(databaseConfig);
  }
}
