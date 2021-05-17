import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:history_app/all_cartoons/all_cartoons.dart';
import 'package:history_app/auth/auth.dart';
import 'package:history_app/auth/flow/auth_flow.dart';
import 'package:history_app/auth/view/login_page.dart';
import 'package:history_app/daily_cartoon/bloc/daily_cartoon.dart';
import 'package:history_app/daily_cartoon/daily_cartoon.dart';
import 'package:history_app/home/home.dart';
import 'package:mocktail/mocktail.dart';
import 'package:political_cartoon_repository/political_cartoon_repository.dart';

import '../../fakes.dart';
import '../../helpers/helpers.dart';
import '../../mocks.dart';

void main() {
  setupCloudFirestoreMocks();
  group('AuthFlow', () {
    late TabBloc tabBloc;
    late AllCartoonsBloc allCartoonsBloc;
    late TagCubit tagCubit;
    late SortByCubit sortByCubit;
    late ShowBottomSheetCubit showBottomSheetCubit;
    late DailyCartoonBloc dailyCartoonBloc;
    late ScrollHeaderCubit scrollHeaderCubit;
    late AuthenticationBloc authenticationBloc;
    late FirestorePoliticalCartoonRepository cartoonRepository;
    late ImageTypeCubit imageTypeCubit;

    PoliticalCartoon mockCartoon = MockPoliticalCartoon();

    Widget wrapper(Widget child) {
      return RepositoryProvider(
        create: (context) => cartoonRepository,
        child: MultiBlocProvider(providers: [
          BlocProvider.value(value: tagCubit),
          BlocProvider.value(value: allCartoonsBloc),
          BlocProvider.value(value: sortByCubit),
          BlocProvider.value(value: showBottomSheetCubit),
          BlocProvider.value(value: dailyCartoonBloc),
          BlocProvider.value(value: tabBloc),
          BlocProvider.value(value: scrollHeaderCubit),
          BlocProvider.value(value: authenticationBloc),
        ], child: child),
      );
    }
    setUpAll(() async {
      await Firebase.initializeApp();

      registerFallbackValue<AllCartoonsState>(FakeAllCartoonsState());
      registerFallbackValue<AllCartoonsEvent>(FakeAllCartoonsEvent());
      registerFallbackValue<DailyCartoonState>(FakeDailyCartoonState());
      registerFallbackValue<DailyCartoonEvent>(FakeDailyCartoonEvent());
      registerFallbackValue<AuthenticationState>(FakeAuthenticationState());
      registerFallbackValue<AuthenticationEvent>(FakeAuthenticationEvent());
      registerFallbackValue<TabEvent>(FakeTabEvent());
      registerFallbackValue<AppTab>(AppTab.daily);
      registerFallbackValue<Tag>(Tag.all);
      registerFallbackValue<SortByMode>(SortByMode.latestPosted);
      registerFallbackValue<ImageType>(ImageType.all);


      tabBloc = MockTabBloc();
      allCartoonsBloc = MockAllCartoonsBloc();
      tagCubit = MockTagCubit();
      sortByCubit = MockSortByCubit();
      showBottomSheetCubit = MockShowBottomSheetCubit();
      dailyCartoonBloc = MockDailyCartoonBloc();
      scrollHeaderCubit = MockScrollHeaderCubit();
      authenticationBloc = MockAuthenticationBloc();
      cartoonRepository = MockPoliticalCartoonRepository();
      imageTypeCubit = MockImageTypeCubit();


      when(() => allCartoonsBloc.state).thenReturn(
        const AllCartoonsState.initial()
      );
      when(() => showBottomSheetCubit.state).thenReturn(false);
      when(() => dailyCartoonBloc.state).thenReturn(DailyCartoonInProgress());
      when(() => imageTypeCubit.state).thenReturn(ImageType.all);
      when(() => tagCubit.state).thenReturn(Tag.all);
      when(cartoonRepository.getLatestPoliticalCartoon)
        .thenAnswer((_) => Stream.value(mockCartoon));
      when(() => cartoonRepository.politicalCartoons(
        sortByMode: sortByCubit.state,
        imageType: imageTypeCubit.state,
        tag: tagCubit.state,
      )).thenAnswer((_) => Future.value([mockCartoon]));
    });

    group('LoginPage', () {
      testWidgets('shows LoginPage', (tester) async {
        when(() => authenticationBloc.state).thenReturn(Uninitialized());
        await tester.pumpApp(wrapper(const AuthFlow()));
        expect(find.byType(LoginScreen), findsOneWidget);
      });
    });

    group('HomeFlow', () {
      testWidgets('shows HomeFlow', (tester) async {
        when(() => sortByCubit.state).thenReturn(SortByMode.latestPublished);
        when(() => authenticationBloc.state)
          .thenReturn(Authenticated('user-id'));
        when(() => scrollHeaderCubit.state).thenReturn(false);
        when(() => allCartoonsBloc.state).thenReturn(
          const AllCartoonsState.initial().copyWith(cartoons: [mockCartoon])
        );
        await tester.pumpApp(wrapper(const AuthFlow()));
        expect(find.byType(HomeFlow), findsOneWidget);
      });
    });
  });
}