class MDlProductDetails {
  String id;

  MDlProductDetails({
    required this.id,
  });

  Map<String, dynamic> get toJson {
    return {
      'id': id,
    };
  }
}