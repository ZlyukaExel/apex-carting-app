import 'package:equatable/equatable.dart';

import '../../slots/bloc/slots_state.dart';

enum BookingStatus { initial, editing, submitting, success, error }

class BookingState extends Equatable {
  final SlotModel? slot;
  final int seats;
  final int rentalCount;
  final int priceTotal;
  final BookingStatus status;
  final String? errorMessage;
  final String? bookingId;

  const BookingState({
    this.slot,
    this.seats = 1,
    this.rentalCount = 0,
    this.priceTotal = 0,
    this.status = BookingStatus.initial,
    this.errorMessage,
    this.bookingId,
  });

  int get maxSeats {
    if (slot == null) return 1;
    // не больше 3 и не больше свободных картов
    return [slot!.freeKarts, slot!.totalKarts, 3].reduce((a, b) => a < b ? a : b);
  }

  int get maxRental {
    if (slot == null) return 0;
    return slot!.freeRentalEquipment;
  }

  BookingState copyWith({
    SlotModel? slot,
    int? seats,
    int? rentalCount,
    int? priceTotal,
    BookingStatus? status,
    String? errorMessage,
    String? bookingId,
  }) {
    final s = slot ?? this.slot;
    final seat = seats ?? this.seats;
    final rental = rentalCount ?? this.rentalCount;
    final total = priceTotal ?? (s != null ? seat * s.price + rental * s.rentalPrice : this.priceTotal);
    return BookingState(
      slot: s,
      seats: seat,
      rentalCount: rental,
      priceTotal: total,
      status: status ?? this.status,
      errorMessage: errorMessage,
      bookingId: bookingId ?? this.bookingId,
    );
  }

  @override
  List<Object?> get props => [
        slot,
        seats,
        rentalCount,
        priceTotal,
        status,
        errorMessage,
        bookingId,
      ];
}
