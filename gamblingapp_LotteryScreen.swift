//
//  gamblingapp_LotteryScreen.swift
//  personalproject
//
//  Created by Ryan Lien on 10/20/24.
//

import SwiftUI

struct LotteryView: View {
    @State private var isOptedIn = true
    @State private var selectedLeaderboard: LeaderboardType = .daily
    @State private var showRewards = false
    
    let currentParticipants = 1234
    let availableModifiers = ["Double Points", "Half Points", "Immunity"]
    let roundStatus = "Ongoing"
    
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            
            ScrollView {
                VStack(spacing: 20) {
                    Text("Lottery")
                        .font(.system(.title, design: .monospaced))
                        .fontWeight(.bold)
                    
                    CurrentRoundView(
                        participants: currentParticipants,
                        modifiers: availableModifiers,
                        status: roundStatus,
                        isOptedIn: $isOptedIn
                    )
                    
                    LeaderboardView(selectedType: $selectedLeaderboard)
                    
                    Button("Show Rewards & Achievements") {
                        showRewards.toggle()
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    
                    if showRewards {
                        RewardsView()
                    }
                }
                .padding()
            }
        }
        .foregroundColor(.white)
        .font(.system(.body, design: .monospaced))
    }
}

struct CurrentRoundView: View {
    let participants: Int
    let modifiers: [String]
    let status: String
    @Binding var isOptedIn: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Current Round Details")
                .font(.system(.title2, design: .monospaced))
                .fontWeight(.bold)
            
            Text("Participants: \(participants)")
            Text("Round Status: \(status)")
            
            Text("Available Modifiers:")
            ForEach(modifiers, id: \.self) { modifier in
                Text("• \(modifier)")
            }
            
            Toggle("Opt-In for Next Round", isOn: $isOptedIn)
                .padding(.vertical)
        }
        .padding()
        .background(Color.gray.opacity(0.2))
        .cornerRadius(10)
    }
}

struct LeaderboardView: View {
    @Binding var selectedType: LeaderboardType
    
    let leaderboardData = [
        User(name: "Alice", points: 1000, rank: 1),
        User(name: "Bob", points: 950, rank: 2),
        User(name: "Charlie", points: 900, rank: 3),
        User(name: "David", points: 850, rank: 4),
        User(name: "Eve", points: 800, rank: 5)
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Leaderboard")
                .font(.system(.title2, design: .monospaced))
                .fontWeight(.bold)
            
            Picker("Leaderboard Type", selection: $selectedType) {
                ForEach(LeaderboardType.allCases, id: \.self) { type in
                    Text(type.rawValue).tag(type)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.bottom)
            
            ForEach(leaderboardData) { user in
                HStack {
                    Text("#\(user.rank)")
                    Text(user.name)
                    Spacer()
                    Text("\(user.points) pts")
                }
                .padding(.vertical, 5)
            }
        }
        .padding()
        .background(Color.gray.opacity(0.2))
        .cornerRadius(10)
    }
}

struct RewardsView: View {
    let achievements = [
        Achievement(name: "First Win", description: "Win your first lottery round", progress: 1.0),
        Achievement(name: "Data Sharer", description: "Share 100 data points", progress: 0.75),
        Achievement(name: "Risk Taker", description: "Participate in 10 consecutive rounds", progress: 0.3),
        Achievement(name: "Jackpot", description: "Win the final round", progress: 0.0)
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Rewards & Achievements")
                .font(.system(.title2, design: .monospaced))
                .fontWeight(.bold)
            
            ForEach(achievements) { achievement in
                VStack(alignment: .leading) {
                    Text(achievement.name)
                        .font(.headline)
                    Text(achievement.description)
                        .font(.subheadline)
                    ProgressView(value: achievement.progress)
                        .progressViewStyle(LinearProgressViewStyle(tint: .green))
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(5)
            }
        }
        .padding()
        .background(Color.gray.opacity(0.2))
        .cornerRadius(10)
    }
}

struct User: Identifiable {
    let id = UUID()
    let name: String
    let points: Int
    let rank: Int
}

struct Achievement: Identifiable {
    let id = UUID()
    let name: String
    let description: String
    let progress: Double
}

enum LeaderboardType: String, CaseIterable {
    case daily = "Daily"
    case weekly = "Weekly"
    case overall = "Overall"
}

struct LotteryView_Previews: PreviewProvider {
    static var previews: some View {
        LotteryView()
    }
}
