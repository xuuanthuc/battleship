// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;
import 'package:template/src/bloc/connectivity/connectivity_bloc.dart' as _i4;
import 'package:template/src/bloc/game_play/game_play_cubit.dart' as _i6;
import 'package:template/src/network/api_provider.dart' as _i3;
import 'package:template/src/screens/game_clients/bloc/game_client_cubit.dart'
    as _i5;

extension GetItInjectableX on _i1.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i1.GetIt $initDependencies({
    String? environment,
    _i2.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i2.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    gh.singleton<_i3.ApiProvider>(_i3.ApiProvider());
    gh.factory<_i4.ConnectivityBloc>(() => _i4.ConnectivityBloc());
    gh.factory<_i5.GameClientCubit>(() => _i5.GameClientCubit());
    gh.factory<_i6.GamePlayCubit>(() => _i6.GamePlayCubit());
    return this;
  }
}
