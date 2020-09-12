class SearchData{
  double from,to;
  int type; //0 for price
            //1 for book name
            //2 for language
            //3 for isbn
            //4 for category
  String searcName;
  SearchData({this.from,this.searcName,this.to,this.type});
}