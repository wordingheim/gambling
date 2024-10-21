//
//  gamblingapp_MarketplaceScreen.swift
//  personalproject
//
//  Created by Ryan Lien on 10/20/24.
//
import SwiftUI

struct MarketplaceView: View {
    @State private var showPurchaseHistory = false
    @State private var selectedItem: MarketplaceItem?
    @State private var showConfirmation = false
    @State private var wishlist: [WishlistItem] = []
    
    let items: [MarketplaceItem] = [
        MarketplaceItem(name: "Double Points Boost", description: "Doubles points for the next round", cost: 100, type: .booster),
        MarketplaceItem(name: "Time Extender", description: "Adds 10 minutes to complete a task", cost: 75, type: .booster),
        MarketplaceItem(name: "Extra Life", description: "Allows a second chance in the lottery", cost: 150, type: .booster),
        MarketplaceItem(name: "Hint for Tasks", description: "Provides a hint for a task", cost: 30, type: .lifeline),
        MarketplaceItem(name: "Skip a Round", description: "Opt-out of a round without cashing out", cost: 200, type: .lifeline)
    ]
    
    let seasonalItems: [SeasonalItem] = [
        SeasonalItem(name: "Halloween Special", description: "Limited edition item for Halloween", cost: 250, expirationDate: Date().addingTimeInterval(86400 * 3)),
        SeasonalItem(name: "Christmas Gift", description: "Exclusive gift for the holiday season", cost: 300, expirationDate: Date().addingTimeInterval(86400 * 10)),
        SeasonalItem(name: "New Year Celebration Pack", description: "Special items to celebrate the new year", cost: 350, expirationDate: Date().addingTimeInterval(86400 * 5)),
        SeasonalItem(name: "Valentine's Day Surprise", description: "Unique items for Valentine's Day", cost: 200, expirationDate: Date().addingTimeInterval(86400 * 7))
    ]
    
    let premiumItems: [PremiumItem] = [
        PremiumItem(name: "1000 Points Pack", description: "Purchase 1000 points for in-game use", price: 9.99),
        PremiumItem(name: "Exclusive Skins Bundle", description: "Get exclusive skins for your characters", price: 4.99),
        PremiumItem(name: "VIP Membership", description: "Monthly VIP membership with exclusive benefits", price: 14.99)
    ]
    
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            
            ScrollView {
                VStack(spacing: 20) {
                    Text("Marketplace")
                        .font(.system(.title, design: .monospaced))
                        .fontWeight(.bold)
                    
                    ForEach(MarketplaceItemType.allCases, id: \.self) { type in
                        ItemListView(items: items.filter { $0.type == type }, type: type, selectedItem: $selectedItem, showConfirmation: $showConfirmation, wishlist: $wishlist)
                    }
                    
                    // Seasonal Items Section
                    Text("Limited-Time Events")
                        .font(.system(.title2, design: .monospaced))
                        .fontWeight(.bold)
                    
                    ForEach(seasonalItems) { item in
                        VStack(alignment: .leading) {
                            HStack {
                                Text(item.name)
                                    .font(.headline)
                                Spacer()
                                Text("\(item.cost) points")
                                    .foregroundColor(item.expirationDate < Date() ? .red : .green)
                                Text(formatDate(item.expirationDate))
                                    .foregroundColor(.gray)
                            }
                            Text(item.description)
                                .font(.subheadline)
                        }
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(5)
                    }
                    
                    // Premium Items Section
                    Text("Premium Items")
                        .font(.system(.title2, design: .monospaced))
                        .fontWeight(.bold)
                    
                    ForEach(premiumItems) { item in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(item.name)
                                    .font(.headline)
                                Text(item.description)
                                    .font(.subheadline)
                            }
                            Spacer()
                            Text("$\(item.price, specifier: "%.2f")")
                                .foregroundColor(.green)
                            Button("Buy") {
                                // Handle premium item purchase
                                print("Purchased \(item.name) for $\(item.price)")
                            }
                            .padding(.horizontal)
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(5)
                        }
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(5)
                    }
                    
                    // Wishlist Section
                    Text("Wishlist")
                        .font(.system(.title2, design: .monospaced))
                        .fontWeight(.bold)
                    
                    ForEach(wishlist) { wishlistItem in
                        HStack {
                            Text(wishlistItem.item.name)
                            Spacer()
                            Button("Remove") {
                                if let index = wishlist.firstIndex(where: { $0.id == wishlistItem.id }) {
                                    wishlist.remove(at: index)
                                }
                            }
                            .foregroundColor(.red)
                        }
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(5)
                    }
                    
                    Button("Purchase History") {
                        showPurchaseHistory.toggle()
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    
                    if showPurchaseHistory {
                        PurchaseHistoryView()
                    }
                }
                .padding()
            }
        }
        .foregroundColor(.white)
        .font(.system(.body, design: .monospaced))
        .sheet(item: $selectedItem) { item in
            ItemDetailView(item: item, showConfirmation: $showConfirmation, wishlist: $wishlist)
        }
        .alert(isPresented: $showConfirmation) {
            Alert(
                title: Text("Confirm Purchase"),
                message: Text("Are you sure you want to buy \(selectedItem?.name ?? "") for \(selectedItem?.cost ?? 0) points?"),
                primaryButton: .default(Text("Buy")) {
                    // Handle purchase
                    print("Purchased \(selectedItem?.name ?? "")")
                },
                secondaryButton: .cancel()
            )
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

struct ItemListView: View {
    let items: [MarketplaceItem]
    let type: MarketplaceItemType
    @Binding var selectedItem: MarketplaceItem?
    @Binding var showConfirmation: Bool
    @Binding var wishlist: [WishlistItem]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(type.rawValue)
                .font(.system(.title2, design: .monospaced))
                .fontWeight(.bold)
            
            ForEach(items) { item in
                HStack {
                    VStack(alignment: .leading) {
                        Text(item.name)
                            .font(.headline)
                        Text("\(item.cost) points")
                            .font(.subheadline)
                    }
                    Spacer()
                    Button(action: {
                        selectedItem = item
                    }) {
                        Image(systemName: "info.circle")
                    }
                    Button("Buy") {
                        selectedItem = item
                        showConfirmation = true
                    }
                    .padding(.horizontal)
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(5)
                    Button("Wishlist") {
                        let wishlistItem = WishlistItem(item: item, isNotified: false)
                        wishlist.append(wishlistItem)
                    }
                    .padding(.horizontal)
                    .background(Color.orange)
                    .foregroundColor(.white)
                    .cornerRadius(5)
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

struct ItemDetailView: View {
    let item: MarketplaceItem
    @Binding var showConfirmation: Bool
    @Binding var wishlist: [WishlistItem]
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                Text(item.name)
                    .font(.system(.title, design: .monospaced))
                    .fontWeight(.bold)
                
                Text(item.description)
                    .font(.system(.body, design: .monospaced))
                    .multilineTextAlignment(.center)
                
                Text("\(item.cost) points")
                    .font(.system(.title2, design: .monospaced))
                
                Button("Buy") {
                    showConfirmation = true
                    presentationMode.wrappedValue.dismiss()
                }
                .padding()
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(10)
                
                Button("Add to Wishlist") {
                    let wishlistItem = WishlistItem(item: item, isNotified: false)
                    wishlist.append(wishlistItem)
                    presentationMode.wrappedValue.dismiss()
                }
                .padding()
                .background(Color.orange)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            .padding()
        }
        .foregroundColor(.white)
    }
}

struct PurchaseHistoryView: View {
    let purchaseHistory = [
        PurchaseRecord(item: "Double Points Boost", date: Date().addingTimeInterval(-86400), cost: 100),
        PurchaseRecord(item: "Hint for Tasks", date: Date().addingTimeInterval(-172800), cost: 30),
        PurchaseRecord(item: "Extra Life", date: Date().addingTimeInterval(-259200), cost: 150)
    ]
    
    let activeBoosts = [
        ActiveBoost(name: "Double Points Boost", remainingTime: "45 minutes"),
        ActiveBoost(name: "Time Extender", remainingTime: "2 tasks")
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Purchase History")
                .font(.system(.title2, design: .monospaced))
                .fontWeight(.bold)
            
            ForEach(purchaseHistory) { record in
                HStack {
                    Text(record.item)
                    Spacer()
                    Text("\(record.cost) points")
                    Text(formatDate(record.date))
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(5)
            }
            
            Text("Active Boosts")
                .font(.system(.title2, design: .monospaced))
                .fontWeight(.bold)
            
            ForEach(activeBoosts) { boost in
                HStack {
                    Text(boost.name)
                    Spacer()
                    Text(boost.remainingTime)
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
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

struct MarketplaceItem: Identifiable {
    let id = UUID()
    let name: String
    let description: String
    let cost: Int
    let type: MarketplaceItemType
}

enum MarketplaceItemType: String, CaseIterable {
    case booster = "Boosters"
    case lifeline = "Lifelines"
}

struct SeasonalItem: Identifiable {
    let id = UUID()
    let name: String
    let description: String
    let cost: Int
    let expirationDate: Date
}

struct PremiumItem: Identifiable {
    let id = UUID()
    let name: String
    let description: String
    let price: Double
}

struct WishlistItem: Identifiable {
    let id = UUID()
    let item: MarketplaceItem
    var isNotified: Bool
}

struct PurchaseRecord: Identifiable {
    let id = UUID()
    let item: String
    let date: Date
    let cost: Int
}

struct ActiveBoost: Identifiable {
    let id = UUID()
    let name: String
    let remainingTime: String
}

struct MarketplaceView_Previews: PreviewProvider {
    static var previews: some View {
        MarketplaceView()
    }
}
