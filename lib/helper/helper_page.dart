//helpul functions throughout the app

//convert string to double
double convertStringToDouble(String string){
  double? amount = double.tryParse(string);
  return amount ?? 0;
}