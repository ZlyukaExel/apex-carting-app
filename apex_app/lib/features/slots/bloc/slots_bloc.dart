import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/network/api_client.dart';
import 'slots_event.dart';
import 'slots_state.dart';

class SlotsBloc extends Bloc<SlotsEvent, SlotsState> {
  final ApiClient _apiClient;

  SlotsBloc(this._apiClient) : super(const SlotsState()) {
    on<LoadSlots>(_onLoadSlots);
    on<UpdateSlotsFilter>(_onUpdateFilter);
  }

  Future<void> _onLoadSlots(LoadSlots event, Emitter<SlotsState> emit) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      final jsonList = await _apiClient.getSlots(
        dateFrom: event.dateFrom,
        dateTo: event.dateTo,
        trackType: event.trackType,
        marshalId: event.marshalId,
        onlyAvailable: event.onlyAvailable,
      );
      final slots = jsonList.map((j) => SlotModel.fromJson(j)).toList();
      slots.sort((a, b) => a.startAt.compareTo(b.startAt));
      emit(state.copyWith(
        slots: slots,
        isLoading: false,
      ));
    } on ApiException catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: e.message,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Ошибка загрузки: $e',
      ));
    }
  }

  Future<void> _onUpdateFilter(
      UpdateSlotsFilter event, Emitter<SlotsState> emit) async {
    emit(state.copyWith(
      filterTrackType: event.trackType,
      filterMarshalId: event.marshalId,
      filterOnlyAvailable: event.onlyAvailable,
    ));
    // загружаем с новыми фильтрами
    add(LoadSlots(
      dateFrom: event.dateFrom,
      dateTo: event.dateTo,
      trackType: event.trackType,
      marshalId: event.marshalId,
      onlyAvailable: event.onlyAvailable,
    ));
  }
}
