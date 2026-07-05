import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/network/api_client.dart';
import 'booking_event.dart';
import 'booking_state.dart';

class BookingBloc extends Bloc<BookingEvent, BookingState> {
  final ApiClient _apiClient;

  BookingBloc(this._apiClient) : super(const BookingState()) {
    on<InitBooking>(_onInit);
    on<UpdateSeats>(_onUpdateSeats);
    on<UpdateRentalCount>(_onUpdateRental);
    on<SubmitBooking>(_onSubmit);
  }

  void _onInit(InitBooking event, Emitter<BookingState> emit) {
    final slot = event.slot;
    emit(BookingState(
      slot: slot,
      seats: 1,
      rentalCount: 0,
      priceTotal: slot.price,
      status: BookingStatus.editing,
    ));
  }

  void _onUpdateSeats(UpdateSeats event, Emitter<BookingState> emit) {
    if (state.slot == null) return;
    final seats = event.seats.clamp(1, state.maxSeats);
    // если мест стало меньше, чем аренда, уменьшаем аренду
    var rental = state.rentalCount;
    if (rental > seats) rental = seats;

    emit(state.copyWith(
      seats: seats,
      rentalCount: rental,
    ));
  }

  void _onUpdateRental(UpdateRentalCount event, Emitter<BookingState> emit) {
    if (state.slot == null) return;
    final count = event.count.clamp(0, [state.maxRental, state.seats].reduce((a, b) => a < b ? a : b));

    emit(state.copyWith(rentalCount: count));
  }

  Future<void> _onSubmit(SubmitBooking event, Emitter<BookingState> emit) async {
    if (state.slot == null) return;
    emit(state.copyWith(status: BookingStatus.submitting));

    try {
      final idempotencyKey =
          '${state.slot!.id}_${DateTime.now().millisecondsSinceEpoch}';
      final result = await _apiClient.createBooking(
        slotId: state.slot!.id,
        seatsCount: state.seats,
        rentalCount: state.rentalCount,
        idempotencyKey: idempotencyKey,
      );
      emit(state.copyWith(
        status: BookingStatus.success,
        bookingId: result['id'] as String,
      ));
    } on ApiException catch (e) {
      emit(state.copyWith(
        status: BookingStatus.error,
        errorMessage: e.message,
      ));
    }
  }
}
