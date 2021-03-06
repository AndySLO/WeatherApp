//
//  WeatherServices.swift
//  WeatherApp
//
//  Created by Andrey Padalka on 9/25/21.
//
import CoreLocation
import Foundation

public final class WeatherService : NSObject {
    private let locationManager = CLLocationManager ()
    private let API_KEY = "00d37332c012d9154d7dd649d7a09073"
    private var completionHandler: ((Weather) ->Void)?
    
    
    public func loadWeatherData(_ completionHandler: @escaping((Weather) -> Void)) {
    self.completionHandler = completionHandler
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
}
 
    //https://aapi.openweathermap.org/data/2.5/weather?lat={lat}&lon={lon}&appid={API key}

    private func makeDataRequest(forCoordinates coordinates: CLLocationCoordinate2D) {
        guard let urlString = "api.openweathermap.org/data/2.5/weather?lat=\(coordinates.latitude)&lon=\(coordinates.longitude)&appid=\(API_KEY)&units=metric".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard error == nil, let data = data else { return }
            if let response = try? JSONDecoder().decode(APIResponse.self, from: data){
                self.completionHandler?(Weather(response: response))
        }
        }.resume()
}



struct APIResponse: Decodable {
    let name: String
    let main: APIMain
    let weather: [APIWeather]
}

struct APIMain: Decodable{
    let temp: Double
}


struct APIWeather: Decodable {
    let description: String
    let iconName: String
}
   
    
    
    
    
    
    
    
    
    
    
    
    enum CodingKeys: String, CodingKey {
        case description
        case iconName = "main"
    }
}
