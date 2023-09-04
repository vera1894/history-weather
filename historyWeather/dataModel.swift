//
//  dataModel.swift
//  historyWeather
//
//  Created by Vera on 2023/7/25.
//

import Foundation

struct WeatherData: Decodable{
    let resolvedAddress: String
    let days: [Day]
}

struct Day:Decodable{
    
    let datetime: String
    let temp:Double
    let conditions:String
    let icon:String
    let tempmax: Double
    let tempmin: Double
    
    var tempInt:Int{
        lroundf(Float(temp))
    }
    
    var tempMax : Int{
        lroundf(Float(tempmax))
    }
    
    var tempMin : Int{
        lroundf(Float(tempmin))
    }
    
    func getConditionName(weather:String)->String{
        switch weather {
        case "snow":
            return "cloud.snow"
        case "rain":
            return "cloud.rain"
        case "fog":
            return "cloud.fog"
        case "wind":
            return "wind"
        case "cloudy":
            return "cloud"
        case "partly-cloudy-day":
            return "cloud.sun"
        case "partly-cloudy-night":
            return "cloud.moon"
        case "clear-day":
            return "sun.max"
        case "clear-night":
            return "moon"
        default:
            return  "cloud"
        }
    }
}
