import 'package:equatable/equatable.dart';

class SlotModel extends Equatable {
  final String id;
  final DateTime startAt;
  final String trackName;
  final String trackDescription;
  final String trackType;
  final int durationMin;
  final String marshalName;
  final String marshalId;
  final int totalKarts;
  final int freeKarts;
  final int freeRentalEquipment;
  final int price;
  final int rentalPrice;
  final String meetingPoint;
  final String status;

  const SlotModel({
    required this.id,
    required this.startAt,
    required this.trackName,
    required this.trackDescription,
    required this.trackType,
    required this.durationMin,
    required this.marshalName,
    required this.marshalId,
    required this.totalKarts,
    required this.freeKarts,
    required this.freeRentalEquipment,
    required this.price,
    required this.rentalPrice,
    required this.meetingPoint,
    required this.status,
  });

  bool get isAvailable => freeKarts > 0 && status == 'scheduled';

  factory SlotModel.fromJson(Map<String, dynamic> json) {
    return SlotModel(
      id: json['id'] as String,
      startAt: DateTime.parse(json['start_at'] as String),
      trackName: json['track_config']['name'] as String,
      trackDescription: json['track_config']['description'] as String,
      trackType: json['track_config']['type'] as String,
      durationMin: json['track_config']['duration_min'] as int,
      marshalName: json['marshal']['name'] as String,
      marshalId: json['marshal']['id'] as String,
      totalKarts: json['total_karts'] as int,
      freeKarts: json['free_karts'] as int,
      freeRentalEquipment: json['free_rental_equipment'] as int,
      price: json['price'] as int,
      rentalPrice: json['rental_price'] as int,
      meetingPoint: json['meeting_point'] as String,
      status: json['status'] as String,
    );
  }

  @override
  List<Object?> get props => [
        id,
        startAt,
        trackName,
        trackType,
        freeKarts,
        status,
      ];
}

class SlotsState extends Equatable {
  final List<SlotModel> slots;
  final bool isLoading;
  final String? errorMessage;
  final String? filterTrackType;
  final String? filterMarshalId;
  final bool? filterOnlyAvailable;

  const SlotsState({
    this.slots = const [],
    this.isLoading = false,
    this.errorMessage,
    this.filterTrackType,
    this.filterMarshalId,
    this.filterOnlyAvailable,
  });

  SlotsState copyWith({
    List<SlotModel>? slots,
    bool? isLoading,
    String? errorMessage,
    String? filterTrackType,
    String? filterMarshalId,
    bool? filterOnlyAvailable,
  }) {
    return SlotsState(
      slots: slots ?? this.slots,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      filterTrackType: filterTrackType ?? this.filterTrackType,
      filterMarshalId: filterMarshalId ?? this.filterMarshalId,
      filterOnlyAvailable: filterOnlyAvailable ?? this.filterOnlyAvailable,
    );
  }

  @override
  List<Object?> get props => [
        slots,
        isLoading,
        errorMessage,
        filterTrackType,
        filterMarshalId,
        filterOnlyAvailable,
      ];
}
