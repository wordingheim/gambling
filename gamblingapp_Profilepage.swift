//
//  gamblingapp_Profilepage.swift
//  personalproject
//
//  Created by Ryan Lien on 10/21/24.
//
import SwiftUI

struct MyProfileView: View {
    @State private var name = "John Doe"
    @State private var email = "john.doe@example.com"
    @State private var bankAccount = "****1234"
    @State private var dataSharing = true
    @State private var notifications = true
    @State private var referralCode = "JOHND123"
    @State private var selectedTab = 0
    @State private var isEditingProfile = false
    @State private var twoFactorAuth = false
    @State private var biometricLogin = false
    @State private var isDataOptionsExpanded = false
    @State private var allDataSharingEnabled = true
    @State private var dataOptions: [DataOption] = [
        DataOption(name: "Health Data", isEnabled: true),
        DataOption(name: "Screen Time", isEnabled: true),
        DataOption(name: "Payment History", isEnabled: true),
        DataOption(name: "Exercise Data", isEnabled: true),
        DataOption(name: "Location Data", isEnabled: true),
        DataOption(name: "App Usage", isEnabled: true),
        DataOption(name: "Browsing History", isEnabled: true)
    ]
    
    let cashOutHistory = [
        CashOut(date: Date().addingTimeInterval(-86400 * 7), amount: 100),
        CashOut(date: Date().addingTimeInterval(-86400 * 14), amount: 50)
    ]
    
    let pendingCashOuts = [
        CashOut(date: Date(), amount: 75, status: .pending)
    ]
    
    let friends = [
        Friend(name: "Alice", points: 1000, rank: 5),
        Friend(name: "Bob", points: 850, rank: 12),
        Friend(name: "Charlie", points: 1200, rank: 3)
    ]
    
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            
            ScrollView {
                VStack(spacing: 20) {
                    Text("My Profile")
                        .font(.system(.title, design: .monospaced))
                        .fontWeight(.bold)
                    
                    userInfoSection
                    securityAndPrivacySection
                    dataOptionsSection
                    dataPreferencesSection
                    cashOutSection
                    friendsSection
                }
                .padding()
            }
        }
        .foregroundColor(.white)
        .font(.system(.body, design: .monospaced))
        .sheet(isPresented: $isEditingProfile) {
            EditProfileView(name: $name, email: $email, bankAccount: $bankAccount)
        }
    }
    
    private var userInfoSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("User Information")
                    .font(.system(.headline, design: .monospaced))
                Spacer()
                Button("Edit") {
                    isEditingProfile = true
                }
                .foregroundColor(.blue)
            }
            
            VStack(alignment: .leading, spacing: 5) {
                Text("Name: \(name)")
                Text("Email: \(email)")
                Text("Bank Account: \(bankAccount)")
            }
        }
        .padding()
        .background(Color.gray.opacity(0.2))
        .cornerRadius(10)
    }
    
    private var securityAndPrivacySection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Security & Privacy")
                .font(.system(.headline, design: .monospaced))
            
            Toggle("Enable Two-Factor Authentication", isOn: $twoFactorAuth)
            Toggle("Use Biometric Login", isOn: $biometricLogin)
            
            Button("Change Password") {
                // Action to change password
            }
            .padding(.vertical, 5)
            .padding(.horizontal, 10)
            .background(Color.blue)
            .cornerRadius(5)
            
            Text("We value your privacy. Your data is encrypted and never shared without your consent.")
                .font(.system(.caption, design: .monospaced))
                .padding(.top, 5)
        }
        .padding()
        .background(Color.gray.opacity(0.2))
        .cornerRadius(10)
    }
    
    private var dataOptionsSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Button(action: {
                withAnimation {
                    isDataOptionsExpanded.toggle()
                }
            }) {
                HStack {
                    Text("Data Sharing Options")
                        .font(.system(.headline, design: .monospaced))
                    Spacer()
                    Image(systemName: isDataOptionsExpanded ? "chevron.up" : "chevron.down")
                }
            }
            
            if isDataOptionsExpanded {
                VStack(alignment: .leading, spacing: 10) {
                    Toggle("Enable All Data Sharing", isOn: $allDataSharingEnabled)
                        .onChange(of: allDataSharingEnabled) { newValue in
                            for i in dataOptions.indices {
                                dataOptions[i].isEnabled = newValue
                            }
                        }
                    
                    Divider()
                    
                    ForEach($dataOptions) { $option in
                        Toggle(option.name, isOn: $option.isEnabled)
                            .onChange(of: option.isEnabled) { _ in
                                updateAllDataSharingToggle()
                            }
                    }
                }
                .padding(.leading)
            }
        }
        .padding()
        .background(Color.gray.opacity(0.2))
        .cornerRadius(10)
    }
    
    private func updateAllDataSharingToggle() {
        allDataSharingEnabled = dataOptions.allSatisfy { $0.isEnabled }
    }

    private var dataPreferencesSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("General Data Preferences")
                .font(.system(.headline, design: .monospaced))
            
            Toggle("Allow Anonymous Data Sharing", isOn: $dataSharing)
            Toggle("Enable Notifications", isOn: $notifications)
        }
        .padding()
        .background(Color.gray.opacity(0.2))
        .cornerRadius(10)
    }
    
    private var cashOutSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Cash-Out History")
                .font(.system(.headline, design: .monospaced))
            
            Picker("", selection: $selectedTab) {
                Text("Completed").tag(0)
                Text("Pending").tag(1)
            }
            .pickerStyle(SegmentedPickerStyle())
            
            if selectedTab == 0 {
                ForEach(cashOutHistory) { cashOut in
                    CashOutRow(cashOut: cashOut)
                }
            } else {
                ForEach(pendingCashOuts) { cashOut in
                    CashOutRow(cashOut: cashOut)
                }
            }
        }
        .padding()
        .background(Color.gray.opacity(0.2))
        .cornerRadius(10)
    }
    
    private var friendsSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Friends")
                .font(.system(.headline, design: .monospaced))
            
            VStack(alignment: .leading, spacing: 5) {
                Text("Referral Code: \(referralCode)")
                Text("Earn 50 points for each friend who signs up!")
                
                Button("Share Referral Code") {
                    // Share referral code action
                }
                .padding(.vertical, 5)
                .padding(.horizontal, 10)
                .background(Color.blue)
                .cornerRadius(5)
            }
            
            Divider()
            
            ForEach(friends) { friend in
                FriendRow(friend: friend)
            }
            
            Button("Invite More Friends") {
                // Invite friends action
            }
            .padding(.vertical, 5)
            .padding(.horizontal, 10)
            .background(Color.green)
            .cornerRadius(5)
        }
        .padding()
        .background(Color.gray.opacity(0.2))
        .cornerRadius(10)
    }
}

struct EditProfileView: View {
    @Binding var name: String
    @Binding var email: String
    @Binding var bankAccount: String
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Edit Profile")) {
                    TextField("Name", text: $name)
                    TextField("Email", text: $email)
                    SecureField("Bank Account", text: $bankAccount)
                }
            }
            .navigationBarTitle("Edit Profile", displayMode: .inline)
            .navigationBarItems(trailing: Button("Done") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}

struct CashOutRow: View {
    let cashOut: CashOut
    
    var body: some View {
        HStack {
            Text(formattedDate(cashOut.date))
            Spacer()
            Text("$\(cashOut.amount)")
            if cashOut.status == .pending {
                Text("(Pending)")
                    .foregroundColor(.yellow)
            }
        }
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter.string(from: date)
    }
}

struct FriendRow: View {
    let friend: Friend
    
    var body: some View {
        HStack {
            Text(friend.name)
            Spacer()
            Text("\(friend.points) pts")
            Text("Rank: \(friend.rank)")
        }
    }
}

struct CashOut: Identifiable {
    let id = UUID()
    let date: Date
    let amount: Int
    var status: Status = .completed
    
    enum Status {
        case completed, pending
    }
}

struct Friend: Identifiable {
    let id = UUID()
    let name: String
    let points: Int
    let rank: Int
}

struct DataOption: Identifiable {
    let id = UUID()
    let name: String
    var isEnabled: Bool
}

struct MyProfileView_Previews: PreviewProvider {
    static var previews: some View {
        MyProfileView()
    }
}
