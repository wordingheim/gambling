//
//  gamblingappdashboard.swift
//  personalproject
//
//  Created by Ryan Lien on 10/20/24.
//

import SwiftUI

struct DefaultScreen: View {
    @State private var currentTime = Date()
    @State private var nextLotteryTime = Date().addingTimeInterval(3600) // 1 hour from now
    
    let everyonesPoints = 765423459
    let personalPoints = 108
    let totalPrizePool = 54675.36
    let potentialEarnings = 0.43
    let isOptedIn = true
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 30) {
                timeSection
                statsSection
                statusSection
            }
            .padding()
            .foregroundColor(.white)
        }
        .onReceive(timer) { _ in
            currentTime = Date()
        }
    }
    
    var timeSection: some View {
        VStack(spacing: 20) {
            VStack(spacing: 5) {
                Text("Current Time")
                    .font(.headline)
                Text(formatTime(date: currentTime))
                    .font(.system(size: 48, weight: .bold, design: .monospaced))
            }
            
            VStack(spacing: 5) {
                Text("Time Until Next Round")
                    .font(.headline)
                Text(formatDuration(timeInterval: nextLotteryTime.timeIntervalSince(currentTime)))
                    .font(.system(size: 32, weight: .bold, design: .monospaced))
            }
        }
    }
    
    var statsSection: some View {
        VStack(spacing: 20) {
            HStack {
                statItem(title: "Everyone's Points", value: formatNumber(everyonesPoints))
                Spacer()
                statItem(title: "Total Prize Pool", value: formatCurrency(totalPrizePool))
            }
            HStack {
                statItem(title: "Personal Points", value: formatNumber(personalPoints))
                Spacer()
                statItem(title: "Potential Earnings", value: formatCurrency(potentialEarnings))
            }
        }
    }
    
    func statItem(title: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(title)
                .font(.caption)
                .foregroundColor(.gray)
            Text(value)
                .font(.title3)
                .fontWeight(.semibold)
        }
    }
    
    var statusSection: some View {
        Text("Status: \(isOptedIn ? "Opted In" : "Opted Out")")
            .font(.headline)
    }
    
    func formatTime(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        return formatter.string(from: date)
    }
    
    func formatDuration(timeInterval: TimeInterval) -> String {
        let hours = Int(timeInterval) / 3600
        let minutes = (Int(timeInterval) % 3600) / 60
        let seconds = Int(timeInterval) % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
    
    func formatNumber(_ number: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: number)) ?? "\(number)"
    }
    
    func formatCurrency(_ amount: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 2
        return formatter.string(from: NSNumber(value: amount)) ?? "$\(amount)"
    }
}

struct DefaultScreen_Previews: PreviewProvider {
    static var previews: some View {
        DefaultScreen()
    }
}
