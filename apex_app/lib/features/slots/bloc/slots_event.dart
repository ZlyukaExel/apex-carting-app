import 'package:equatable/equatable.dart';

abstract class SlotsEvent extends Equatable {
  const SlotsEvent();

  @override
  List<Object?> get props => [];
}

class LoadSlots extends SlotsEvent {
  final DateTime? dateFrom;
  final DateTime? dateTo;
  final String? trackType;
  final String? marshalId;
  final bool? onlyAvailable;

  const LoadSlots({
    this.dateFrom,
    this.dateTo,
    this.trackType,
    this.marshalId,
    this.onlyAvailable,
  });

  @override
  List<Object?> get props => [dateFrom, dateTo, trackType, marshalId, onlyAvailable];
}

class UpdateSlotsFilter extends SlotsEvent {
  final DateTime? dateFrom;
  final DateTime? dateTo;
  final String? trackType;
  final String? marshalId;
  final bool? onlyAvailable;

  const UpdateSlotsFilter({
    this.dateFrom,
    this.dateTo,
    this.trackType,
    this.marshalId,
    this.onlyAvailable,
  });

  @override
  List<Object?> get props => [dateFrom, dateTo, trackType, marshalId, onlyAvailable];
}
