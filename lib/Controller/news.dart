

class News {
  final int tfo,tpo;
  int? distance;
  final String title, district,address,description, subDistrict, id,type,phone;
  final List<String> images;
  final double rating, lat, lon;
  final bool isFavourite, isPopular;

  News({
    required this.description,
    required this.phone,
    required this.address,
    required this.images,
    required this.rating,
    required this.lat,
    required this.lon,
    this.isFavourite = true,
    this.isPopular = false,
    required this.title,
    required this.district,
    required this.subDistrict,
   required this.tfo,
    required this.tpo,
    required this.id,
    this.type="General",
    this.distance,
  });
}