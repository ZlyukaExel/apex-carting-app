import 'package:equatable/equatable.dart';

import '../../slots/bloc/slots_state.dart';

abstract class BookingEvent extends Equatable {
  const BookingEvent();

  @override
  List<Object?> get props => [];
}

class InitBooking extends BookingEvent {
  final SlotModel slot;
  const InitBooking(this.slot);

  @override
  List<Object?> get props => [slot];
}

class UpdateSeats extends BookingEvent {
  final int seats;
  const UpdateSeats(this.seats);

  @override
  List<Object?> get props => [seats];
}

class UpdateRentalCount extends BookingEvent {
  final int count;
  const UpdateRentalCount(this.count);

  @override
  List<Object?> get props => [count];
}

class SubmitBooking extends BookingEvent {
  const SubmitBooking();
}
