//
//  Homescreen.swift
//  gambling
//
//  Created by Minseo Kim on 10/17/24.
//

import SwiftUI

let bodyfont = Font.custom("RobotoMono-Regular", size: 10)
let boldfont = Font.custom("RobotoMono-Bold", size: 10)
let titlefont = Font.custom("RobotoMono-Bold", size: 36)
let midtitlefont = Font.custom("RobotoMono-Medium", size: 24)

let time = 456
let pool = 5467536
let totalpower = 765423459
let localpower = 108
let erng = 43


private let ll = 14
private let vl = 8

let stats = [
    "pool" : 54675368,
    "totalpower" : 765423459,
    "localpower" : 108,
    "erng" : 43
]

struct metricRow: View{
    var txt: String
    var val: Int
    var sign: String = ""
    var dec: Int = 0
    
    
    var body: some View {
        HStack{
            Text(invcolumnify(txt, vl))
                .font(boldfont)
            Text(" - ")
                .font(bodyfont)
            Text(sign)
                .foregroundStyle(.red)
                .font(boldfont)
            Text(columnify(handlenum(val, dec), ll-sign.count))
                .font(bodyfont)
            
        }
    }
}

struct statsbox: View {
    var dct: Dictionary<String, Int>
    var body: some View{
        HStack{
            VStack() {
                
                metricRow(txt:"T_POW", val:dct["totalpower"]!)
                HStack{
                    metricRow(txt:"L_POW", val:dct["localpower"]!)
                }
                
            }
            VStack() {
                metricRow(txt:"POOL", val:dct["pool"]!, sign:"$", dec:2)
                metricRow(txt:"ERNG", val:dct["erng"]!, sign:"$", dec:2)
                
            }
        }
    }
}

struct IntRangeTextField: View {
    @State private var inputText: String = "" // The text input
    @State private var intValue: Int = 0 // The integer value after validation
    let maxValue: Int // The maximum value (x)

    var body: some View {
        VStack {
            TextField("Amount", text: $inputText)
                .onChange(of: inputText) {
                    let filtered = "0"+inputText.filter { $0.isNumber }
                    self.intValue = min(Int(filtered)!, maxValue)
                    self.inputText = filtered.isEmpty ? "" : "\(self.intValue)"
                }
                .font(bodyfont)
                .textFieldStyle(PlainTextFieldStyle())
                .frame(width:60, height:20)
                .border(.black, width:1)
                .multilineTextAlignment(.center)
                .padding()
            

            Text("Validated Integer: \(intValue)")
                .font(.headline)
            
                            
            
        }
        .padding()
    }
}



struct Homescreen: View {
    let round = 5
    let mult = 0.8
    var body: some View {
        VStack{
            Text("\(stringify(String(time/60), 2)) : \(stringify(String(time%60), 2))")
                .font(titlefont)
            Spacer()
                .frame(height:100)
            VStack{
                Text("Round \(round)")
                    .font(midtitlefont)
                Text("Cashout multiplier: \(String(mult))")
                    .font(bodyfont)
            }
            Spacer()
                .frame(height:100)
            statsbox(dct:stats)
            IntRangeTextField(maxValue:100)
            
        }
    }
}




#Preview {
    Homescreen()
    
}
