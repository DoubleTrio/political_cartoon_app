import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:history_app/tab/tab.dart';

void main() {
  group('TabsBloc', () {
    test('initial state is AppTab.daily', () {
      var state = AppTab.daily;
      expect(TabBloc().state, equals(state));
    });

    blocTest<TabBloc, AppTab>(
      'Emits [AppTab.all] '
      'when UpdateTab(AppTab.daily) is added',
      build: () => TabBloc(),
      act: (bloc) => bloc.add(const UpdateTab(AppTab.all)),
      expect: () => [AppTab.all],
    );

    blocTest<TabBloc, AppTab>(
      'Emits [AppTab.daily] '
      'when UpdateTab(AppTab.daily) is added and the current tab is AppTab.all',
      build: () => TabBloc(),
      seed: () => AppTab.all,
      act: (bloc) => bloc.add(const UpdateTab(AppTab.daily)),
      expect: () => [AppTab.daily],
    );
  });
}
