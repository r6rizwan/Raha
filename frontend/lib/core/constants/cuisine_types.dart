const allCuisineTypes = [
  'Indian',
  'Kerala',
  'Punjabi',
  'Filipino',
  'Pakistani',
  'Lebanese',
  'Saudi',
  'Gulf',
  'Emirati',
];

const cuisineTypesByNationality = {
  'Indian': ['Indian', 'Kerala', 'Punjabi'],
  'Filipino': ['Filipino'],
  'Pakistani': ['Pakistani'],
  'Lebanese': ['Lebanese'],
  'Saudi': ['Saudi', 'Gulf'],
  'Emirati': ['Emirati', 'Gulf'],
  'British': ['British', 'Continental'],
  'Egyptian': ['Egyptian', 'Middle Eastern'],
};

List<String> cuisineTypesForNationality(String? nationality) {
  final preferred = cuisineTypesByNationality[nationality] ?? const <String>[];
  return [
    ...preferred.where(allCuisineTypes.contains),
    ...allCuisineTypes.where((cuisine) => !preferred.contains(cuisine)),
  ];
}
