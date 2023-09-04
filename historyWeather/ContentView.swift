//
//  ContentView.swift
//  historyWeather
//
//  Created by Vera on 2023/7/24.
//

import SwiftUI

struct ContentView: View {
    
    let cityname = "qingdao"
    
    @State private var showingAlert = false
    @ObservedObject var weatherManager = WeatherManager()
    
    var options = ["Qingdao","Shenzhen","Beijing","Shanghai","Guangzhou"]
    @AppStorage("selectedCity") var selecterItem = "Qingdao"
    //UserDefaults.standard.string(forKey: "selectedCity")
    
    
    
    var body: some View {
        
   //     let data = self.weatherManager.weatherData
        
        let data = [
            Day(datetime: "2023-02-27", temp: 30.9, conditions: "Partially cloudy", icon: "cloudy",tempmax: 32.6,tempmin: 28.8),
            Day(datetime: "2023-02-28", temp: 32.9, conditions: "Partially cloudy", icon: "cloudy",tempmax: 33.5,tempmin: 30.2)]

        ZStack(alignment: .bottom){
            ZStack(alignment: .top){
                
                VStack(alignment: .leading){
                    
                    if data.count == 0{
                        Text("Hello😀")
                            .foregroundColor(.white)
                            .font(.largeTitle)
                            .fontWeight(.heavy)
                            //.offset(y: -80)
                    }
                    
                    
                    if data.count>0{
                        Spacer()
                        
                        HStack{
                            VStack(alignment: .leading){
                                Text(data[1].datetime)
                                    .font(.system(size: 18))
                                Text(String(data[1].tempInt)+"°")
                                    .font(.system(size: 60))
                                    .fontWeight(.bold)
                                    .padding([.top,.bottom],4)
                                HStack{
                                    Text(data[1].conditions)
                                        .font(.system(size: 14))
                                    Divider()
                                        .overlay(.white)
                                        .frame(width: 1, height: 16)
                                    Text(String(data[1].tempMin)+"°~"+String(data[1].tempMax)+"°")
                                }
                                
                                Image(systemName: data[1].getConditionName(weather: data[1].icon))
                                    .foregroundColor(.white)
                                    .font(.system(size: 220))
                            }.padding(30)
                            Spacer()
                        }
                        
                        Spacer()
                        
                        HStack{
                            Spacer()
                            VStack(alignment: .trailing){
                                Image(systemName: data[0].getConditionName(weather: data[0].icon))
                                    .foregroundColor(.primary)
                                    .font(.system(size: 66))
                                    .padding([.top,.bottom],2)
                                HStack(alignment: .center){
                                    Text(data[0].datetime)
                                        //.font(.system(size: 14))
                                        .padding(4)
                                    Text(String(data[0].tempInt)+"°")
                                        //.font(.system(size: 14))
                                        .fontWeight(.bold)
                                }.padding(2)
                                
                                
                                
                                HStack{
                                    Text(data[0].conditions)
                                        .font(.system(size: 14))
                                    Divider()
                                        .overlay(.white)
                                        .frame(width: 1, height: 16)
                                    Text(String(data[0].tempMin)+"°~"+String(data[0].tempMax)+"°")
                                        .font(.system(size: 14))
                                }
                                
                            }.padding(30)
                            
                        }
                        Spacer()
                    }
                    
                }
                .frame(width:UIScreen.main.bounds.width,height: UIScreen.main.bounds.height)
               // .offset(y: 80)
                .ignoresSafeArea( edges: .all)
                .background(data.count>0 ? LinearGradient(gradient: Gradient(colors: [bgStartColor(dayOfYear(data[1].datetime)), bgEndColor(dayOfYear(data[1].datetime))]), startPoint: .top, endPoint: .bottom) : LinearGradient(gradient: Gradient(colors: [Color("autumnTop"), Color("autumnEnd")]), startPoint: .top, endPoint: .bottom))
                
                //顶部条
                if data.count>0{
                    Rectangle().frame( height: 6).foregroundColor(data[0].temp<data[1].temp ? Color("hot"):Color("cool")).ignoresSafeArea()}
            }
            HStack{
                
                //定位按钮
//                Button {
//
//                } label: {
//                    Image(systemName: "location").foregroundColor(Color.black)
//                        .overlay(Circle().fill(Color.white.opacity(0.4)).frame(width: 36, height: 36))
//                }.padding(8)
 //               Text(cityname)
                
                //选择器
                Picker("选择城市", selection: $selecterItem) {
                    ForEach(options,id:\.self) { item in
                        Text(item)
                    }
                    
                }
                .accentColor(.black)
                .offset(x:-10.0)
                .onChange(of: selecterItem) { (value) in
                    weatherManager.fetchWeather(cityName: selecterItem)
                    UserDefaults.standard.set(selecterItem,forKey:"selectedCity")
                }
                
                
                Spacer()
                
                //刷新按钮
                Button(action:{
                    weatherManager.fetchWeather(cityName: selecterItem)
                    print("第\(dayOfYear(data[0].datetime))天,\(bgStartColor(dayOfYear(data[1].datetime))),\(bgEndColor(dayOfYear(data[1].datetime)))")
                    self.showingAlert.toggle()
                }){
                    Image(systemName: "arrow.clockwise").foregroundColor(Color.black)
                        .overlay(Circle().fill(Color.white.opacity(0.4)).frame(width: 36, height: 36))
                }.alert(isPresented: self.$showingAlert, content: {
                    Alert(title: Text("Refresh successed"))
                })
                .padding(8)
                
                
            }.padding(30)
            
            if data.count>0{
                Rectangle().frame(height: 12).foregroundColor(data[0].temp<data[1].temp ? Color("hot"):Color("cool")).ignoresSafeArea()}
        }
        
        .onAppear {
            weatherManager.fetchWeather(cityName: selecterItem)
        }
        
        
    }
}


// MARK: - Private Methods
private extension ContentView{
    
    //本年第几天
    func dayOfYear(_ date: String) -> Int {
        let days = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
        let arr = Array(date)
        let y = Int(String(arr[0..<4]))!
        let m = Int(String(arr[5..<7]))!
        let d = Int(String(arr[8...]))!
        var res = 0
        for i in 0..<(m - 1) {
            res += days[i]
        }
        res += d
        if m > 2 && isLeap(y) {
            res += 1
        }
        return res
    }
    
    func isLeap(_ y: Int) -> Bool {
        if y % 4 != 0 { return false }
        else if y % 100 != 0 { return true }
        else if y % 400 != 0 { return false }
        return true
    }
    
    //背景颜色
    func bgStartColor(_ dayOfYear:Int)->Color{
        let hue: Double = Double((Float(dayOfYear)/Float(365))) * 0.7
        var saturation:Double = 0.7
        if dayOfYear<100{
            saturation = Double(dayOfYear)/100 * 0.7
        }else if dayOfYear > 265{
            saturation = Double(365-dayOfYear)/100 * 0.7
        }
        
        print("bgStartColor",hue,saturation)
        return Color(hue: hue, saturation: saturation, brightness: 1)
    }
    
    func bgEndColor(_ dayOfYear:Int)->Color{
        let hue: Double = 0.7 - Double((Float(dayOfYear)/Float(365))) * 0.7
        var saturation:Double = 0.8
        if dayOfYear<100{
            saturation = Double(dayOfYear)/100 * 0.8
        }else if dayOfYear > 265{
            saturation = Double(365-dayOfYear)/100 * 0.8
        }
        
        
        print("bgEndColor",hue)
        return Color(hue: hue, saturation: saturation, brightness: 1)
    }
    
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
