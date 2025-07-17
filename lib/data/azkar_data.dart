import '../models/azkar.dart';

class AzkarData {
  // أذكار الصباح
  static List<Azkar> morningAzkar = [
    const Azkar(
      id: 1,
      arabicText: 'أَعُوذُ بِاللَّهِ مِنَ الشَّيْطَانِ الرَّجِيمِ',
      transliteration: 'A\'udhu billahi min ash-shaytani\'r-rajim',
      translation: 'أعوذ بالله من الشيطان الرجيم',
      reference: 'القرآن الكريم',
      benefit: 'الاستعاذة من الشيطان',
      count: 1,
      category: 'أذكار الصباح',
    ),
    const Azkar(
      id: 2,
      arabicText: 'بِسْمِ اللَّهِ الرَّحْمَنِ الرَّحِيمِ',
      transliteration: 'Bismillahi\'r-rahmani\'r-rahim',
      translation: 'بسم الله الرحمن الرحيم',
      reference: 'القرآن الكريم',
      benefit: 'البركة في كل عمل',
      count: 1,
      category: 'أذكار الصباح',
    ),
    const Azkar(
      id: 3,
      arabicText: 'قُلْ هُوَ اللَّهُ أَحَدٌ * اللَّهُ الصَّمَدُ * لَمْ يَلِدْ وَلَمْ يُولَدْ * وَلَمْ يَكُن لَّهُ كُفُوًا أَحَدٌ',
      transliteration: 'Qul huwa Allahu ahad, Allahu\'s-samad, lam yalid wa lam yulad, wa lam yakun lahu kufuwan ahad',
      translation: 'قل هو الله أحد، الله الصمد، لم يلد ولم يولد، ولم يكن له كفواً أحد',
      reference: 'سورة الإخلاص',
      benefit: 'تعدل ثلث القرآن',
      count: 3,
      category: 'أذكار الصباح',
    ),
    const Azkar(
      id: 4,
      arabicText: 'قُلْ أَعُوذُ بِرَبِّ الْفَلَقِ * مِن شَرِّ مَا خَلَقَ * وَمِن شَرِّ غَاسِقٍ إِذَا وَقَبَ * وَمِن شَرِّ النَّفَّاثَاتِ فِي الْعُقَدِ * وَمِن شَرِّ حَاسِدٍ إِذَا حَسَدَ',
      transliteration: 'Qul a\'udhu bi rabbi\'l-falaq...',
      translation: 'قل أعوذ برب الفلق من شر ما خلق...',
      reference: 'سورة الفلق',
      benefit: 'الحماية من الشرور',
      count: 3,
      category: 'أذكار الصباح',
    ),
    const Azkar(
      id: 5,
      arabicText: 'قُلْ أَعُوذُ بِرَبِّ النَّاسِ * مَلِكِ النَّاسِ * إِلَهِ النَّاسِ * مِن شَرِّ الْوَسْوَاسِ الْخَنَّاسِ * الَّذِي يُوَسْوِسُ فِي صُدُورِ النَّاسِ * مِنَ الْجِنَّةِ وَالنَّاسِ',
      transliteration: 'Qul a\'udhu bi rabbi\'n-nas...',
      translation: 'قل أعوذ برب الناس ملك الناس إله الناس...',
      reference: 'سورة الناس',
      benefit: 'الحماية من وساوس الشيطان',
      count: 3,
      category: 'أذكار الصباح',
    ),
    const Azkar(
      id: 6,
      arabicText: 'اللَّهُمَّ أَنْتَ رَبِّي لا إِلَهَ إِلا أَنْتَ، خَلَقْتَنِي وَأَنَا عَبْدُكَ، وَأَنَا عَلَى عَهْدِكَ وَوَعْدِكَ مَا اسْتَطَعْتُ، أَعُوذُ بِكَ مِنْ شَرِّ مَا صَنَعْتُ، أَبُوءُ لَكَ بِنِعْمَتِكَ عَلَيَّ، وَأَبُوءُ بِذَنْبِي فَاغْفِرْ لِي فَإِنَّهُ لا يَغْفِرُ الذُّنُوبَ إِلا أَنْتَ',
      transliteration: 'Allahumma anta rabbi la ilaha illa ant...',
      translation: 'اللهم أنت ربي لا إله إلا أنت، خلقتني وأنا عبدك...',
      reference: 'صحيح البخاري',
      benefit: 'سيد الاستغفار',
      count: 1,
      category: 'أذكار الصباح',
    ),
    const Azkar(
      id: 7,
      arabicText: 'أَصْبَحْنَا وَأَصْبَحَ الْمُلْكُ لِلَّهِ، وَالْحَمْدُ لِلَّهِ، لا إِلَهَ إِلا اللَّهُ وَحْدَهُ لا شَرِيكَ لَهُ، لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ وَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيرٌ',
      transliteration: 'Asbahna wa asbahal-mulku lillah...',
      translation: 'أصبحنا وأصبح الملك لله، والحمد لله...',
      reference: 'صحيح مسلم',
      benefit: 'إقرار بملكية الله',
      count: 1,
      category: 'أذكار الصباح',
    ),
    const Azkar(
      id: 8,
      arabicText: 'اللَّهُمَّ بِكَ أَصْبَحْنَا، وَبِكَ أَمْسَيْنَا، وَبِكَ نَحْيَا، وَبِكَ نَمُوتُ، وَإِلَيْكَ النُّشُورُ',
      transliteration: 'Allahumma bika asbahna wa bika amsayna...',
      translation: 'اللهم بك أصبحنا، وبك أمسينا، وبك نحيا، وبك نموت، وإليك النشور',
      reference: 'سنن الترمذي',
      benefit: 'الاعتماد على الله في كل شيء',
      count: 1,
      category: 'أذكار الصباح',
    ),
    const Azkar(
      id: 9,
      arabicText: 'أَصْبَحْنَا عَلَى فِطْرَةِ الإِسْلامِ، وَعَلَى كَلِمَةِ الإِخْلاصِ، وَعَلَى دِينِ نَبِيِّنَا مُحَمَّدٍ صَلَّى اللَّهُ عَلَيْهِ وَسَلَّمَ، وَعَلَى مِلَّةِ أَبِينَا إِبْرَاهِيمَ حَنِيفاً مُسْلِماً وَمَا كَانَ مِنَ الْمُشْرِكِينَ',
      transliteration: 'Asbahna ala fitratil-Islam...',
      translation: 'أصبحنا على فطرة الإسلام، وعلى كلمة الإخلاص...',
      reference: 'مسند أحمد',
      benefit: 'التمسك بالدين الحق',
      count: 1,
      category: 'أذكار الصباح',
    ),
    const Azkar(
      id: 10,
      arabicText: 'سُبْحَانَ اللَّهِ وَبِحَمْدِهِ',
      transliteration: 'Subhan Allahi wa bihamdih',
      translation: 'سبحان الله وبحمده',
      reference: 'صحيح البخاري',
      benefit: 'غرس نخلة في الجنة',
      count: 100,
      category: 'أذكار الصباح',
    ),
    // المزيد من أذكار الصباح...
    const Azkar(
      id: 11,
      arabicText: 'لا إِلَهَ إِلا اللَّهُ وَحْدَهُ لا شَرِيكَ لَهُ، لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ وَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيرٌ',
      transliteration: 'La ilaha illa Allah wahdahu la sharika lah...',
      translation: 'لا إله إلا الله وحده لا شريك له، له الملك وله الحمد وهو على كل شيء قدير',
      reference: 'صحيح البخاري',
      benefit: 'أجر عتق عشر رقاب',
      count: 10,
      category: 'أذكار الصباح',
    ),
    const Azkar(
      id: 12,
      arabicText: 'اللَّهُمَّ أَعِنِّي عَلَى ذِكْرِكَ وَشُكْرِكَ وَحُسْنِ عِبَادَتِكَ',
      transliteration: 'Allahumma a\'inni ala dhikrika wa shukrika wa husni \'ibadatik',
      translation: 'اللهم أعني على ذكرك وشكرك وحسن عبادتك',
      reference: 'سنن أبي داود',
      benefit: 'الاستعانة على العبادة',
      count: 1,
      category: 'أذكار الصباح',
    ),
    const Azkar(
      id: 13,
      arabicText: 'اللَّهُمَّ إِنِّي أَسْأَلُكَ الْعَافِيَةَ فِي الدُّنْيَا وَالآخِرَةِ',
      transliteration: 'Allahumma inni as\'aluka\'l-\'afiyata fi\'d-dunya wa\'l-akhirah',
      translation: 'اللهم إني أسألك العافية في الدنيا والآخرة',
      reference: 'سنن ابن ماجه',
      benefit: 'طلب العافية',
      count: 1,
      category: 'أذكار الصباح',
    ),
    const Azkar(
      id: 14,
      arabicText: 'اللَّهُمَّ إِنِّي أَعُوذُ بِكَ مِنَ الْهَمِّ وَالْحَزَنِ، وَأَعُوذُ بِكَ مِنَ الْعَجْزِ وَالْكَسَلِ، وَأَعُوذُ بِكَ مِنَ الْجُبْنِ وَالْبُخْلِ، وَأَعُوذُ بِكَ مِنْ غَلَبَةِ الدَّيْنِ وَقَهْرِ الرِّجَالِ',
      transliteration: 'Allahumma inni a\'udhu bika min al-hammi wa\'l-hazan...',
      translation: 'اللهم إني أعوذ بك من الهم والحزن، وأعوذ بك من العجز والكسل...',
      reference: 'صحيح البخاري',
      benefit: 'الاستعاذة من الآفات النفسية',
      count: 1,
      category: 'أذكار الصباح',
    ),
    const Azkar(
      id: 15,
      arabicText: 'حَسْبِيَ اللَّهُ لا إِلَهَ إِلا هُوَ عَلَيْهِ تَوَكَّلْتُ وَهُوَ رَبُّ الْعَرْشِ الْعَظِيمِ',
      transliteration: 'Hasbiya Allah la ilaha illa huwa \'alayhi tawakkaltu wa huwa rabbu\'l-\'arshi\'l-\'azim',
      translation: 'حسبي الله لا إله إلا هو عليه توكلت وهو رب العرش العظيم',
      reference: 'سنن أبي داود',
      benefit: 'كفاية من كل هم',
      count: 7,
      category: 'أذكار الصباح',
    ),
    // المزيد من أذكار الصباح لنصل إلى 100+
    const Azkar(
      id: 16,
      arabicText: 'اللَّهُمَّ عَافِنِي فِي بَدَنِي، اللَّهُمَّ عَافِنِي فِي سَمْعِي، اللَّهُمَّ عَافِنِي فِي بَصَرِي، لا إِلَهَ إِلا أَنْتَ',
      transliteration: 'Allahumma \'afini fi badani, Allahumma \'afini fi sam\'i...',
      translation: 'اللهم عافني في بدني، اللهم عافني في سمعي، اللهم عافني في بصري، لا إله إلا أنت',
      reference: 'سنن أبي داود',
      benefit: 'طلب العافية في الجسد والحواس',
      count: 3,
      category: 'أذكار الصباح',
    ),
    const Azkar(
      id: 17,
      arabicText: 'اللَّهُمَّ إِنِّي أَسْأَلُكَ الْعَفْوَ وَالْعَافِيَةَ فِي الدُّنْيَا وَالآخِرَةِ',
      transliteration: 'Allahumma inni as\'aluka\'l-\'afwa wa\'l-\'afiyata fi\'d-dunya wa\'l-akhirah',
      translation: 'اللهم إني أسألك العفو والعافية في الدنيا والآخرة',
      reference: 'سنن ابن ماجه',
      benefit: 'طلب العفو والعافية',
      count: 1,
      category: 'أذكار الصباح',
    ),
    const Azkar(
      id: 18,
      arabicText: 'اللَّهُمَّ إِنِّي أَعُوذُ بِكَ مِنْ زَوَالِ نِعْمَتِكَ، وَتَحَوُّلِ عَافِيَتِكَ، وَفُجَاءَةِ نِقْمَتِكَ، وَجَمِيعِ سَخَطِكَ',
      transliteration: 'Allahumma inni a\'udhu bika min zawali ni\'matik...',
      translation: 'اللهم إني أعوذ بك من زوال نعمتك، وتحول عافيتك، وفجاءة نقمتك، وجميع سخطك',
      reference: 'صحيح مسلم',
      benefit: 'الاستعاذة من زوال النعم',
      count: 1,
      category: 'أذكار الصباح',
    ),
    const Azkar(
      id: 19,
      arabicText: 'اللَّهُمَّ مَا أَصْبَحَ بِي مِنْ نِعْمَةٍ أَوْ بِأَحَدٍ مِنْ خَلْقِكَ فَمِنْكَ وَحْدَكَ لا شَرِيكَ لَكَ، فَلَكَ الْحَمْدُ وَلَكَ الشُّكْرُ',
      transliteration: 'Allahumma ma asbaha bi min ni\'matin aw bi ahadin min khalqika...',
      translation: 'اللهم ما أصبح بي من نعمة أو بأحد من خلقك فمنك وحدك لا شريك لك، فلك الحمد ولك الشكر',
      reference: 'سنن أبي داود',
      benefit: 'شكر الله على النعم',
      count: 1,
      category: 'أذكار الصباح',
    ),
    const Azkar(
      id: 20,
      arabicText: 'رَضِيتُ بِاللَّهِ رَبًّا، وَبِالإِسْلامِ دِينًا، وَبِمُحَمَّدٍ صَلَّى اللَّهُ عَلَيْهِ وَسَلَّمَ رَسُولاً',
      transliteration: 'Raditu billahi rabban, wa bil-Islami dinan, wa bi Muhammadin rasolan',
      translation: 'رضيت بالله رباً، وبالإسلام ديناً، وبمحمد صلى الله عليه وسلم رسولاً',
      reference: 'سنن أبي داود',
      benefit: 'من قالها حق على الله أن يرضيه يوم القيامة',
      count: 3,
      category: 'أذكار الصباح',
    ),
    // يمكن إضافة المزيد حتى نصل لأكثر من 100 ذكر
  ];

  // أذكار المساء
  static List<Azkar> eveningAzkar = [
    const Azkar(
      id: 101,
      arabicText: 'أَعُوذُ بِاللَّهِ مِنَ الشَّيْطَانِ الرَّجِيمِ',
      transliteration: 'A\'udhu billahi min ash-shaytani\'r-rajim',
      translation: 'أعوذ بالله من الشيطان الرجيم',
      reference: 'القرآن الكريم',
      benefit: 'الاستعاذة من الشيطان',
      count: 1,
      category: 'أذكار المساء',
    ),
    const Azkar(
      id: 102,
      arabicText: 'أَمْسَيْنَا وَأَمْسَى الْمُلْكُ لِلَّهِ، وَالْحَمْدُ لِلَّهِ، لا إِلَهَ إِلا اللَّهُ وَحْدَهُ لا شَرِيكَ لَهُ، لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ وَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيرٌ',
      transliteration: 'Amsayna wa amsal-mulku lillah...',
      translation: 'أمسينا وأمسى الملك لله، والحمد لله...',
      reference: 'صحيح مسلم',
      benefit: 'إقرار بملكية الله',
      count: 1,
      category: 'أذكار المساء',
    ),
    const Azkar(
      id: 103,
      arabicText: 'اللَّهُمَّ بِكَ أَمْسَيْنَا، وَبِكَ أَصْبَحْنَا، وَبِكَ نَحْيَا، وَبِكَ نَمُوتُ، وَإِلَيْكَ الْمَصِيرُ',
      transliteration: 'Allahumma bika amsayna wa bika asbahna...',
      translation: 'اللهم بك أمسينا، وبك أصبحنا، وبك نحيا، وبك نموت، وإليك المصير',
      reference: 'سنن الترمذي',
      benefit: 'الاعتماد على الله في كل شيء',
      count: 1,
      category: 'أذكار المساء',
    ),
    // المزيد من أذكار المساء...
  ];

  // أذكار النوم
  static List<Azkar> sleepAzkar = [
    const Azkar(
      id: 201,
      arabicText: 'بِاسْمِكَ اللَّهُمَّ أَمُوتُ وَأَحْيَا',
      transliteration: 'Bismika Allahumma amutu wa ahya',
      translation: 'باسمك اللهم أموت وأحيا',
      reference: 'صحيح البخاري',
      benefit: 'النوم على ذكر الله',
      count: 1,
      category: 'أذكار النوم',
    ),
    const Azkar(
      id: 202,
      arabicText: 'اللَّهُمَّ قِنِي عَذَابَكَ يَوْمَ تَبْعَثُ عِبَادَكَ',
      transliteration: 'Allahumma qini \'adhabaka yawma tab\'athu \'ibadak',
      translation: 'اللهم قني عذابك يوم تبعث عبادك',
      reference: 'سنن أبي داود',
      benefit: 'الاستعاذة من عذاب الآخرة',
      count: 3,
      category: 'أذكار النوم',
    ),
    // المزيد من أذكار النوم...
  ];

  // دالة للحصول على الأذكار حسب الفئة
  static List<Azkar> getAzkarByCategory(String category) {
    switch (category) {
      case 'أذكار الصباح':
        return morningAzkar;
      case 'أذكار المساء':
        return eveningAzkar;
      case 'أذكار النوم':
        return sleepAzkar;
      default:
        return [];
    }
  }

  // دالة للحصول على جميع الأذكار
  static List<Azkar> getAllAzkar() {
    return [...morningAzkar, ...eveningAzkar, ...sleepAzkar];
  }
}
