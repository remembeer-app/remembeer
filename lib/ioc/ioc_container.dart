import 'package:dartvex/dartvex.dart';
import 'package:dartvex_auth_better/dartvex_auth_better.dart';
import 'package:dartvex_flutter/dartvex_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:remembeer/app_icon/service/app_icon_service.dart';
import 'package:remembeer/auth/service/convex_auth_service.dart';
import 'package:remembeer/avatar/service/avatar_service.dart';
import 'package:remembeer/convex_api/api.dart';
import 'package:remembeer/drink_log/service/drink_log_service.dart';
import 'package:remembeer/location/service/location_service.dart';

final get = GetIt.instance;

class IoCContainer {
  IoCContainer._();

  static void initialize() {
    _registerConvex();

    get.registerSingleton(LocationService());
    _registerServices();
  }

  static void _registerConvex() {
    get
      ..registerSingleton(
        BetterAuthClient(baseUrl: dotenv.get('CONVEX_SITE_URL')),
      )
      ..registerSingleton(
        ConvexClient(
          dotenv.get('CONVEX_URL'),
          config: ConvexClientConfig(
            connectivitySignal: ConnectivityPlusSignal(),
          ),
        ),
      )
      ..registerSingleton(ConvexClientRuntime(get<ConvexClient>()))
      ..registerSingleton(
        ConvexBetterAuthProvider(client: get<BetterAuthClient>()),
      )
      ..registerSingleton(
        get<ConvexClient>().withAuth(get<ConvexBetterAuthProvider>()),
      )
      ..registerSingleton(
        ConvexApi(get<ConvexClientWithAuth<BetterAuthSession>>()),
      )
      ..registerSingleton(
        ConvexAuthService(
          authProvider: get<ConvexBetterAuthProvider>(),
          client: get<ConvexClientWithAuth<BetterAuthSession>>(),
          api: get<ConvexApi>(),
        ),
      );
  }

  static void _registerServices() {
    get
      ..registerSingleton(
        DrinkLogService(
          api: get<ConvexApi>(),
          locationService: get<LocationService>(),
        ),
      )
      ..registerSingleton(
        AppIconService(
          authService: get<ConvexAuthService>(),
          api: get<ConvexApi>(),
        ),
      )
      ..registerSingleton(
        AvatarService(
          api: get<ConvexApi>(),
          storage: ConvexStorage(
            get<ConvexClientWithAuth<BetterAuthSession>>(),
          ),
        ),
      );
  }
}
