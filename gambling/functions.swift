//
//  functions.swift
//  gambling
//
//  Created by Minseo Kim on 10/18/24.
//
import SwiftUI
let stringify: (String, Int) -> String = {(s,i) in
    var str = s
    while str.count < i {
        str = "0"+str
    }
    return str
        
}

let commafy: (Int) -> String = {(i) in
    var num = i
    var s = ""
    while num > 0 {
        let rem = num%1000
        num = num / 1000
        s = "," + String(rem) + s
    }
    s = String(s.dropFirst())
    
    return s
}


let columnify: (String, Int) -> String = {(s, i) in
    let diff = i-s.count
    return String(repeating: " ", count: diff) + s

}

let invcolumnify: (String, Int) -> String = {(s, i) in
    let diff = i-s.count
    return s + String(repeating: " ", count: diff)

}




let handlenum: (Int, Int) -> String = {(s, i) in
    if i == 0 {
        return commafy(s)
    } else {
        let divisor = Int(pow(10.0, Double(i)))
        let bf = s/divisor
        let af = s%divisor
        return commafy(bf) + "." + stringify(String(af), 2)
    }
}
