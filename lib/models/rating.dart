class Rating{
  String comment;
  int rating;
  Rating({this.comment,this.rating});

  Rating.fromJson(Map<String, dynamic> json)
      : comment = json["comment"],
        rating = json["rating"];

  Map<String, dynamic> toJsonRating() {
    return {
        "comment": comment,
        "rating": rating,
      };
      }
        

}