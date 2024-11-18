import 'package:flutter/material.dart';

class RegionSelectionView extends StatelessWidget {
  const RegionSelectionView({super.key});

  // List of predefined regions in Beni Suef
  final List<String> regions = const [
    'Al Teraa',
    'Beni Suef City Center',
    'Mohamed Metwally St.',
    'Saad Zaghloul St.',
    'Beni Suef University',
    'Beni Suef Mall',
    'El-Shahidy St.',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Your Region'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Choose a region in Beni Suef to see popular places:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: regions.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      title: Text(regions[index]),
                      onTap: () {
                        // Navigate to PopularPlacesView with the selected region
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                PopularPlacesView(region: regions[index]),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// This widget displays popular places based on the selected region
class PopularPlacesView extends StatelessWidget {
  final String region;

  const PopularPlacesView({required this.region, super.key});

  @override
  Widget build(BuildContext context) {
    // List of popular places in Beni Suef with detailed data
    final List<Map<String, String>> popularPlaces = [
      {
        'name': 'El-Gendy Restaurant',
        'category': 'Restaurant',
        'region': 'Al Teraa'
      },
      {
        'name': 'El Hariry Restaurant',
        'category': 'Restaurant',
        'region': 'Beni Suef City Center'
      },
      {
        'name': 'Afandina Restaurant',
        'category': 'Restaurant',
        'region': 'Mohamed Metwally St.'
      },
      {'name': 'Grand Cafe', 'category': 'Cafe', 'region': 'Al Teraa St.'},
      {
        'name': 'Totti Cafe',
        'category': 'Cafe',
        'region': 'Mohamed Metwally St.'
      },
      {
        'name': 'Coffee Break',
        'category': 'Cafe',
        'region': 'Saad Zaghloul St.'
      },
      {
        'name': 'Misr Library',
        'category': 'Library',
        'region': 'Beni Suef University'
      },
      {
        'name': 'Al Shorouk Library',
        'category': 'Library',
        'region': 'Beni Suef City Center'
      },
      {
        'name': 'El-Ezaby Pharmacy',
        'category': 'Pharmacy',
        'region': 'Beni Suef City Center'
      },
      {
        'name': 'El Gomhoria Pharmacy',
        'category': 'Pharmacy',
        'region': 'Al Teraa St.'
      },
      {
        'name': 'Carrefour',
        'category': 'Food Shop',
        'region': 'Beni Suef Mall'
      },
      {
        'name': 'Metro Market',
        'category': 'Food Shop',
        'region': 'El-Shahidy St.'
      },
    ];

    // Filter the list of places to show only those in the selected region
    final List<Map<String, String>> filteredPlaces =
        popularPlaces.where((place) => place['region'] == region).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Popular Places in $region'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: filteredPlaces.length,
                itemBuilder: (context, index) {
                  final place = filteredPlaces[index];
                  return Card(
                    child: ListTile(
                      leading: Icon(
                        Icons.place,
                        color: Theme.of(context).primaryColor,
                      ),
                      title: Text(place['name']!),
                      subtitle: Text('${place['category']}'),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
