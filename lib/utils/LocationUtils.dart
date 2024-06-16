import 'dart:math';

class LocationUtils {
  static double? calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    // Implémentation du calcul de la distance entre deux points géographiques
    // Utiliser une formule comme la formule de Haversine
    // Retourner la distance en kilomètres, ou null si la distance ne peut pas être calculée

    // Exemple de calcul de la distance avec la formule de Haversine
    const double earthRadius = 6371.0; // Rayon de la terre en kilomètres
    double dLat = _toRadians(lat2 - lat1);
    double dLon = _toRadians(lon2 - lon1);
    double a = pow(sin(dLat / 2), 2) +
        cos(_toRadians(lat1)) * cos(_toRadians(lat2)) *
            pow(sin(dLon / 2), 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    double distance = earthRadius * c;

    return distance;
  }

  static double _toRadians(double degree) {
    return degree * pi / 180.0;
  }
}
