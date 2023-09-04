//
//  date.swift
//  historyWeather
//
//  Created by Vera on 2023/7/25.
//

import Foundation

extension Date{
    
    var today:String{
        let dformatter = DateFormatter()
        dformatter.dateFormat = "yyyy-MM-dd"
        return dformatter.string(from: Date())
    }
    
    var yesterday:String{
        let dformatter = DateFormatter()
        dformatter.dateFormat = "yyyy-MM-dd"
        let nextDate:TimeInterval = TimeInterval(-24*60*60)
        let sDate = Date().addingTimeInterval(nextDate)
        return dformatter.string(from: sDate)
    }
    
    
}



class WeatherManager: ObservableObject {
    
    @Published var weatherData = [Day]()
    
    
    func fetchWeather(cityName:String){
        
        
        
        let urlString = "https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/timeline/\(cityName)/"+Date().yesterday+"/"+Date().today+"?unitGroup=metric&include=days&key=HL5S4AMXRSREWE7Q66Z2PDDXR&contentType=json"
        
        print(urlString)
        
        
        
        if let url = URL(string: urlString){
            
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url, completionHandler: handle(data:response:error:))
            
            task.resume()
        }
        
        
    }
    
    func handle(data:Data?,response:URLResponse?,error:Error?){
        if error != nil{
            print(error!)
            return
        }
        if let safeData = data{
            //let dataString = String(data: safeData, encoding: .utf8)
            let decoder = JSONDecoder()
            do{
                let data =  try decoder.decode(WeatherData.self, from: safeData)
                print(data.days[0].conditions)
                DispatchQueue.main.async {
                    self.weatherData = data.days
                }
                
              
            }catch{
                print(error)
            }
            
            
           // print(dataString)
        }
    }
}


class Solution {
      
 }



