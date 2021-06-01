import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hawktoons/all_cartoons/all_cartoons.dart';
import 'package:hawktoons/latest_cartoon/latest_cartoon.dart';
import 'package:hawktoons/settings/cubit/settings_screen_cubit.dart';
import 'package:hawktoons/settings/flow/settings_flow.dart';
import 'package:hawktoons/settings/models/models.dart';
import 'package:hawktoons/tab/tab.dart';
import 'package:mocktail/mocktail.dart';
import 'package:political_cartoon_repository/political_cartoon_repository.dart';

import '../../fakes.dart';
import '../../helpers/helpers.dart';
import '../../keys.dart';
import '../../mocks.dart';

void main() {
  group('TabFlow', () {
    late AllCartoonsBloc allCartoonsBloc;
    late LatestCartoonBloc latestCartoonBloc;
    late ImageTypeCubit imageTypeCubit;
    late ScrollHeaderCubit scrollHeaderCubit;
    late SelectCartoonCubit selectCartoonCubit;
    late SettingsScreenCubit settingsScreenCubit;
    late ShowBottomSheetCubit showBottomSheetCubit;
    late SortByCubit sortByCubit;
    late TabBloc tabBloc;
    late TagCubit tagCubit;

    setUpAll(() {
      registerFallbackValue<AllCartoonsState>(FakeAllCartoonsState());
      registerFallbackValue<AllCartoonsEvent>(FakeAllCartoonsEvent());
      registerFallbackValue<AppTab>(AppTab.latest);
      registerFallbackValue<LatestCartoonState>(FakeLatestCartoonState());
      registerFallbackValue<LatestCartoonEvent>(FakeLatestCartoonEvent());
      registerFallbackValue<ImageType>(ImageType.all);
      registerFallbackValue<SelectPoliticalCartoonState>(
        FakeSelectPoliticalCartoonState()
      );
      registerFallbackValue<SettingsScreen>(SettingsScreen.main);
      registerFallbackValue<SortByMode>(SortByMode.latestPosted);
      registerFallbackValue<TabEvent>(FakeTabEvent());
      registerFallbackValue<Tag>(Tag.all);
    });

    setUp(() {
      allCartoonsBloc = MockAllCartoonsBloc();
      latestCartoonBloc = MockLatestCartoonBloc();
      selectCartoonCubit = MockSelectCartoonCubit();
      tabBloc = MockTabBloc();
      tagCubit = MockTagCubit();
      sortByCubit = MockSortByCubit();
      imageTypeCubit = MockImageTypeCubit();
      scrollHeaderCubit = MockScrollHeaderCubit();
      settingsScreenCubit = MockSettingsScreenCubit();
      showBottomSheetCubit = MockShowBottomSheetCubit();

      when(() => allCartoonsBloc.state)
        .thenReturn(const AllCartoonsState.initial());
      when(() => showBottomSheetCubit.state).thenReturn(false);
      when(() => latestCartoonBloc.state).thenReturn(
        const DailyCartoonInProgress()
      );
      when(() => selectCartoonCubit.state)
        .thenReturn(const SelectPoliticalCartoonState());
      when(() => imageTypeCubit.state).thenReturn(ImageType.all);
      when(() => scrollHeaderCubit.state).thenReturn(false);
      when(() => tabBloc.state).thenReturn(AppTab.latest);
    });


    group('semantics', () {
      testWidgets('passes guidelines for light theme', (tester) async {
        await tester.pumpApp(
          const TabFlow(),
          latestCartoonBloc: latestCartoonBloc,
          showBottomSheetCubit: showBottomSheetCubit,
          tabBloc: tabBloc,
        );

        expect(tester, meetsGuideline(textContrastGuideline));
        expect(tester, meetsGuideline(androidTapTargetGuideline));
      });

      testWidgets('passes guidelines for dark theme', (tester) async {
        await tester.pumpApp(
          const TabFlow(),
          mode: ThemeMode.dark,
          latestCartoonBloc: latestCartoonBloc,
          showBottomSheetCubit: showBottomSheetCubit,
          tabBloc: tabBloc,
        );

        expect(tester, meetsGuideline(textContrastGuideline));
        expect(tester, meetsGuideline(androidTapTargetGuideline));
      });
    });

    group('TabSelector', () {
      testWidgets('finds TabSelector', (tester) async {
        await tester.pumpApp(
          const TabFlow(),
          latestCartoonBloc: latestCartoonBloc,
          showBottomSheetCubit: showBottomSheetCubit,
          tabBloc: tabBloc,
        );
        expect(find.byType(TabSelector), findsOneWidget);
      });

      testWidgets(
        'tabBloc.add(UpdateTab(AppTab.latest)) '
        'is invoked when the "Latest" tab is tapped', (tester) async {
        await tester.pumpApp(
          const TabFlow(),
          latestCartoonBloc: latestCartoonBloc,
          showBottomSheetCubit: showBottomSheetCubit,
          tabBloc: tabBloc,
        );
        await tester.tap(find.byKey(latestCartoonTabKey));
        verify(() => tabBloc.add(UpdateTab(AppTab.latest))).called(1);
      });
    });

    testWidgets(
      'tabBloc.add(UpdateTab(AppTab.settings)) '
      'is invoked when the "Settings" tab is tapped', (tester) async {
      await tester.pumpApp(
        const TabFlow(),
        latestCartoonBloc: latestCartoonBloc,
        showBottomSheetCubit: showBottomSheetCubit,
        tabBloc: tabBloc,
      );
      await tester.tap(find.byKey(settingsTabKey));
      verify(() => tabBloc.add(UpdateTab(AppTab.settings))).called(1);
    });

    testWidgets(
      'tabBloc.add(UpdateTab(AppTab.all)) '
      'is invoked when the "All" tab is tapped', (tester) async {
      await tester.pumpApp(
        const TabFlow(),
        latestCartoonBloc: latestCartoonBloc,
        showBottomSheetCubit: showBottomSheetCubit,
        tabBloc: tabBloc,
      );
      await tester.tap(find.byKey(allCartoonTabKey));
      verify(() => tabBloc.add(UpdateTab(AppTab.all))).called(1);
    });

    testWidgets('renders all cartoons view', (tester) async {
      when(() => tabBloc.state).thenReturn(AppTab.all);
      await tester.pumpApp(
        const TabFlow(),
        allCartoonsBloc: allCartoonsBloc,
        scrollHeaderCubit: scrollHeaderCubit,
        selectCartoonCubit: selectCartoonCubit,
        showBottomSheetCubit: showBottomSheetCubit,
        tabBloc: tabBloc,
      );
      expect(find.byType(AllCartoonsView), findsOneWidget);
    });

    testWidgets('renders SettingsFlowView', (tester) async {
      when(() => tabBloc.state).thenReturn(AppTab.settings);
      when(() => settingsScreenCubit.state).thenReturn(SettingsScreen.main);
      await tester.pumpApp(
        const TabFlow(),
        selectCartoonCubit: selectCartoonCubit,
        settingsScreenCubit: settingsScreenCubit,
        showBottomSheetCubit: showBottomSheetCubit,
        tabBloc: tabBloc,
      );
      expect(find.byType(SettingsFlowView), findsOneWidget);
    });

    group('FilterPopUp', () {
      setUp(() {
        when(() => tabBloc.state).thenReturn(AppTab.all);
        when(() => tagCubit.state).thenReturn(Tag.all);
        when(() => sortByCubit.state).thenReturn(SortByMode.earliestPosted);
        whenListen(showBottomSheetCubit, Stream.value(true));
      });

      testWidgets('shows filter pop up and closes', (tester) async {
        when(() => tabBloc.state).thenReturn(AppTab.latest);
        await tester.pumpApp(
          const TabFlow(),
          mode: ThemeMode.dark,
          latestCartoonBloc: latestCartoonBloc,
          imageTypeCubit: imageTypeCubit,
          showBottomSheetCubit: showBottomSheetCubit,
          sortByCubit: sortByCubit,
          tabBloc: tabBloc,
          tagCubit: tagCubit,
        );
        await tester.pump(const Duration(seconds: 1));
        expect(find.byType(FilterPopUp), findsOneWidget);
        await tester.tapAt(const Offset(0, 500));
        verify(showBottomSheetCubit.closeSheet).called(1);
      });
    });
  });
}