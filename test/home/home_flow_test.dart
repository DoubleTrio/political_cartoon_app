import 'package:bloc_test/bloc_test.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:history_app/blocs/blocs.dart';
import 'package:history_app/daily_cartoon/bloc/daily_cartoon.dart';
import 'package:history_app/daily_cartoon/daily_cartoon.dart';
import 'package:history_app/filtered_cartoons/filtered_cartoons.dart';
import 'package:history_app/home/home_flow.dart';
import 'package:history_app/widgets/widgets.dart';
import 'package:mocktail/mocktail.dart';
import 'package:political_cartoon_repository/political_cartoon_repository.dart';

import '../fakes.dart';
import '../helpers/helpers.dart';
import '../mocks.dart';

const _dailyCartoonTabKey = Key('TabSelector_DailyTab');
const _allCartoonsTabKey = Key('TabSelector_AllTab');
const _resetFilterButtonKey = Key('ButtonRowHeader_ResetButton');
const _applyFilterButtonKey = Key('ButtonRowHeader_ApplyFilterButton');

final sortByMode = SortByMode.latestPosted;
final tag = Tag.tag5;

final _tagButtonKey = Key('Tag_Button_${tag.index}');
final _sortByTileKey = Key('SortByMode_Button_${sortByMode.index}');


void main() {
  group('HomeFlow', () {
    setupCloudFirestoreMocks();

    late TabBloc tabBloc;
    late AllCartoonsBloc allCartoonsBloc;
    late TagCubit tagCubit;
    late SortByCubit sortByCubit;
    late ShowBottomSheetCubit showBottomSheetCubit;
    late DailyCartoonBloc dailyCartoonBloc;
    late FilteredCartoonsBloc filteredCartoonsBloc;
    late ScrollHeaderCubit scrollHeaderCubit;

    Widget wrapper(Widget child) {
      return MultiBlocProvider(providers: [
        BlocProvider.value(value: tagCubit),
        BlocProvider.value(value: allCartoonsBloc),
        BlocProvider.value(value: sortByCubit),
        BlocProvider.value(value: showBottomSheetCubit),
        BlocProvider.value(value: dailyCartoonBloc),
        BlocProvider.value(value: tabBloc),
        BlocProvider.value(value: filteredCartoonsBloc),
        BlocProvider.value(value: scrollHeaderCubit),
      ], child: child);
    }
    setUpAll(() async {
      registerFallbackValue<AllCartoonsState>(FakeAllCartoonsState());
      registerFallbackValue<AllCartoonsEvent>(FakeAllCartoonsEvent());
      registerFallbackValue<FilteredCartoonsState>(FakeFilteredCartoonsState());
      registerFallbackValue<FilteredCartoonsEvent>(FakeFilteredCartoonsEvent());
      registerFallbackValue<DailyCartoonState>(FakeDailyCartoonState());
      registerFallbackValue<DailyCartoonEvent>(FakeDailyCartoonEvent());
      registerFallbackValue<TabEvent>(FakeTabEvent());
      registerFallbackValue<AppTab>(AppTab.daily);
      registerFallbackValue<Tag>(Tag.all);
      registerFallbackValue<SortByMode>(SortByMode.latestPosted);

      await Firebase.initializeApp();

      tabBloc = MockTabBloc();
      allCartoonsBloc = MockAllCartoonsBloc();
      tagCubit = MockTagCubit();
      sortByCubit = MockSortByCubit();
      showBottomSheetCubit = MockShowBottomSheetCubit();
      dailyCartoonBloc = MockDailyCartoonBloc();
      filteredCartoonsBloc = MockFilteredCartoonsBloc();
      scrollHeaderCubit = MockScrollHeaderCubit();

      when(() => allCartoonsBloc.state).thenReturn(AllCartoonsLoading());
      when(() => showBottomSheetCubit.state).thenReturn(false);
      when(() => dailyCartoonBloc.state).thenReturn(DailyCartoonInProgress());
      when(() => filteredCartoonsBloc.state)
        .thenReturn(FilteredCartoonsLoading());
    });

    testWidgets('finds TabSelector', (tester) async {
      var state = AppTab.daily;
      when(() => tabBloc.state).thenReturn(state);

      await tester.pumpApp(wrapper(HomeFlow()));

      expect(find.byType(TabSelector), findsOneWidget);
    });

    testWidgets('tabBloc.add(UpdateTab(AppTab.all)) '
        'is invoked when the "All" tab is tapped', (tester) async {
      when(() => tabBloc.state).thenReturn(AppTab.daily);
      await tester.pumpApp(wrapper(HomeFlow()));
      await tester.tap(find.byKey(_allCartoonsTabKey));
      verify(() => tabBloc.add(UpdateTab(AppTab.all))).called(1);
    });

    testWidgets('tabBloc.add(UpdateTab(AppTab.daily)) '
        'is invoked when the "Daily" tab is tapped', (tester) async {
      when(() => tabBloc.state).thenReturn(AppTab.all);
      when(() => scrollHeaderCubit.state).thenReturn(false);

      await tester.pumpApp(wrapper(HomeFlow()));
      await tester.tap(find.byKey(_dailyCartoonTabKey));
      verify(() => tabBloc.add(UpdateTab(AppTab.daily))).called(1);
    });

    group('FilterPopUp', () {
      setUp(() {
        when(() => tabBloc.state).thenReturn(AppTab.daily);
        when(() => tagCubit.state).thenReturn(Tag.all);
        when(() => sortByCubit.state).thenReturn(SortByMode.earliestPosted);
        whenListen(showBottomSheetCubit, Stream.value(true));
      });

      testWidgets('shows filter pop up and closes', (tester) async {
        await tester.pumpApp(wrapper(HomeFlow()));
        await tester.pump(const Duration(seconds: 1));
        expect(find.byType(FilterPopUp), findsOneWidget);
        await tester.tapAt(const Offset(0, 500));
        verify(showBottomSheetCubit.closeSheet).called(1);
      });
    });
  });
}
