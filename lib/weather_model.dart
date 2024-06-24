class Weather {
  final String cityName;
  final double temperature;
  final String mainCondition;
  Weather(
      {required this.cityName,
      required this.temperature,
      required this.mainCondition});

      
  factory Weather.fromJson(Map<String, dynamic> json) {
    //factory doesnt always create a new instance of  the class - weather.fromjson is a factory constructor ; <> for parameters
    return Weather(
      cityName: json['name'],   //mapping json to class 
      temperature: json['main']['temp'].toDouble(),  //accesses the nested json  
      mainCondition: json['weather'][0]['main'],  //main - value assigned to the maincondition 
    );
  }
}

//for deserialization we make objects from map to make objects we need constructor and for constructor we need map 
// for serialization  object should be converted to map 