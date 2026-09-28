class ApiConstants{
  ApiConstants._();
  static const String baseUrl='https://petstore.swagger.io/v2';
  static const int staticPrefix =20260902;
  static const String userPrefix = 'wpt_2026';
  
  static int getDynamicId(){
    return DateTime.now().millisecondsSinceEpoch;
  }
}