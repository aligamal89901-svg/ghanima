class StoreShift {
  final String label;
  final String openTime;
  final String closeTime;
  final String phone;
  final String? whatsapp;

  const StoreShift({
    required this.label,
    required this.openTime,
    required this.closeTime,
    required this.phone,
    this.whatsapp,
  });
}

class StoreInfo {
  final String name;
  final String tagline;
  final String address;
  final String mapUrl;
  final String shopPhone;
  final String politeNote;
  final List<StoreShift> shifts;

  const StoreInfo({
    required this.name,
    required this.tagline,
    required this.address,
    required this.mapUrl,
    required this.shopPhone,
    required this.politeNote,
    required this.shifts,
  });

  static const StoreInfo current = StoreInfo(
    name: 'تموينات غنيمة',
    tagline: 'كل اللي تحتاجه، أقرب لك.',
    address: 'حضرموت - مديرية القطن - غنيمة - عرض الشارع العام',
    mapUrl: 'https://maps.app.goo.gl/fzFHnoFKUYU21r6F9',
    shopPhone: '967776085405',
    politeNote: 'يرجى عدم الإزعاج خارج أوقات العمل.',
    shifts: [
      StoreShift(
        label: 'الفترة الصباحية',
        openTime: '7:20 ص',
        closeTime: '1:15 ظ',
        phone: '967776476721',
        whatsapp: '967776476721',
      ),
      StoreShift(
        label: 'الفترة المسائية',
        openTime: '3:30 ع',
        closeTime: '9:00 م',
        phone: '967770254502',
        whatsapp: '967770254502',
      ),
    ],
  );
}