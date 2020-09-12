class APIResponse<T>{
  T data;
  bool error;
  String errorMessage="Some error occurs!";
  APIResponse({this.data,this.error=false,this.errorMessage="Some error occurs"});

}