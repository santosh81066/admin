class Bookings {
  final int? statusCode;
  final bool? success;
  final List<String>? messages;
  final List<BookingData>? bookingData;

  Bookings({
    this.statusCode,
    this.success,
    this.messages,
    this.bookingData,
  });

  Bookings.fromJson(Map<String, dynamic> json)
      : statusCode = json['statusCode'] as int?,
        success = json['success'] as bool?,
        messages = (json['messages'] as List?)
            ?.map((dynamic e) => e as String)
            .toList(),
        bookingData = (json['data'] as List?)
            ?.map(
                (dynamic e) => BookingData.fromJson(e as Map<String, dynamic>))
            .toList();

  Map<String, dynamic> toJson() => {
        'statusCode': statusCode,
        'success': success,
        'messages': messages,
        'bookingData': bookingData?.map((e) => e.toJson()).toList()
      };
}

class BookingData {
  final int? id;
  final String? address;
  final dynamic time;
  final dynamic amount;
  final dynamic minutes;
  final int? userid;
  final String? bookingStatus;
  final int? startotp;
  final int? endotp;
  final String? purohitCategory;
  final dynamic familyMembers;
  final dynamic goutram;
  final String? eventName;
  final String? purohithName;
  final String? username;
  final int? _originalAmount;
  final double? percentage = 10.0;

  BookingData({
    this.id,
    this.address,
    this.time,
    this.amount,
    this.minutes,
    this.userid,
    this.bookingStatus,
    this.startotp,
    this.endotp,
    this.purohitCategory,
    this.familyMembers,
    this.goutram,
    this.eventName,
    this.purohithName,
    this.username,
  }) : _originalAmount = amount != null ? amount.toInt() : null;

  BookingData.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int?,
        address = json['address'] as String?,
        time = json['time'],
        amount = json['amount'],
        minutes = json['minutes'],
        userid = json['userid'] as int?,
        bookingStatus = json['booking status'] as String?,
        startotp = json['startotp'] as int?,
        endotp = json['endotp'] as int?,
        purohitCategory = json['purohit_category'] as String?,
        familyMembers = json['familyMembers'],
        goutram = json['goutram'],
        eventName = json['event_name'] as String?,
        purohithName = json['purohith_name'] as String?,
        username = json['username'] as String?,
        _originalAmount =
            json['amount'] != null ? (json['amount'] as num).toInt() : null;

  Map<String, dynamic> toJson() => {
        'id': id,
        'address': address,
        'time': time,
        'amount': amount,
        'minutes': minutes,
        'userid': userid,
        'booking status': bookingStatus,
        'startotp': startotp,
        'endotp': endotp,
        'purohit_category': purohitCategory,
        'familyMembers': familyMembers,
        'goutram': goutram,
        'event_name': eventName,
        'purohith_name': purohithName,
        'username': username
      };

  int? getAmountWithPercentageIncrease() {
    if (_originalAmount == null || percentage == null) {
      return amount;
    }
    return (_originalAmount! * (1 + percentage! / 100)).toInt();
  }
}
