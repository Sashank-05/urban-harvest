List<Map<String, String>> plantList = [
  {'category': 'Flowers','name': 'Rose', 'img': '/images/flowers/rose.png'},
  {'category': 'Flowers','name': 'Marigold', 'img': '/images/flowers/marigold.png'},
  {'category': 'Flowers', 'name': 'Hibiscus', 'img': '/images/flowers/hibiscus.png'},
  {'category':'Flowers','name': 'Jasmine', 'img': '/images/flowers/jasmine.png'},
  {'category':'Flowers','name':'Sunflower','img':'/images/flowers/sunflower.png'},
  {'category':'Vegetables','name':'Cabbage','img':'/images/vegetables/cabbage.png'},
  {'category':'Vegetables','name':'Cauliflower','img':'/images/vegetables/cauliflower.png'},
  {'category':'Vegetables','name':'Chilli','img':'/images/vegetables/chilli.png'},
  {'category':'Vegetables','name':'Green Beans','img':'/images/vegetables/green-beans.png'},
  {'category':'Vegetables','name':'Tomato','img':'/images/vegetables/tomatoes.png'},
  {'category':'Greens','name':'Aloevera','img':'/images/greens/aloevera.png'},
  {'category':'Greens','name':'Coriander','img':'/images/greens/coriander.png'},
  {'category':'Greens','name':'Mint','img':'/images/greens/mint.png'},
  {'category':'Greens','name':'Curry Leaves','img':'/images/greens/tropical-leaves.png'},
];

Map<String, String> imageDict = {
  'Rose': 'assets/img/landing/flowers/rose.png',
  'Marigold': 'assets/img/landing/flowers/marigold.png',
  'Hibiscus':'assets/img/landing/flowers/hibiscus.png',
  'Jasmine':'assets/img/landing/flowers/jasmine.png',
  'Sunflower':'assets/img/landing/flowers/sunflower.png',
  'Cabbage':'assets/img/landing/vegetables/cabbage.png',
  'Cauliflower':'assets/img/landing/vegetables/cauliflower.png',
  'Chilli':'assets/img/landing/vegetables/chilli.png',
  'Green Beans':'assets/img/landing/vegetables/green-beans.png',
  'Tomato':'assets/img/landing/vegetables/tomato.png',
  'Aloevera':'assets/img/landing/greens/aloevera.png',
  'Coriander':'assets/img/landing/greens/coriander.png',
  'Mint':'assets/img/landing/greens/mint.png',
  'Curry Leaves':'assets/img/landing/greens/tropical-leaves.png',
};

//this is what it is searching for
Map<String, List<String>> searchQueryResults(String searchQuery) {
  Map<String, List<String>> results = {
    'Flowers': [],
    'Vegetables': [],
    'Greens': [],
  };
  String lowerCaseQuery = searchQuery.toLowerCase();

  for (var plant in plantList) {
    if (plant['name']!.toLowerCase().contains(lowerCaseQuery)) {
      results[plant['category']]!.add(plant['name']!);
    }
  }

  // Remove keys with empty lists from the results map
  results.removeWhere((key, value) => value.isEmpty);

  return results;
}
