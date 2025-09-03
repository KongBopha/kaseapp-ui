class AResponse 
{
  AResponse({
    this.data, 
    this.statusCode,
    this.message
    });

  // response body
  dynamic data;

  // http status code
  int? statusCode;
  dynamic  message;
}