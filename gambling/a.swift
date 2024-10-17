import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            Color(red: 0.1, green: 0.1, blue: 0.1) // Dark background
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                Text("RETRO INVEST")
                    .font(.custom("RobotoMono-Bold", size: 24))
                    .foregroundColor(.green)
                    .padding()
                
                HStack {
                    VStack(alignment: .leading) {
                        Text("PORTFOLIO VALUE")
                            .font(.custom("RobotoMono-Regular", size: 14))
                            .foregroundColor(.gray)
                        Text("$10,742.89")
                            .font(.custom("RobotoMono-Bold", size: 28))
                            .foregroundColor(.green)
                    }
                    Spacer()
                    Text("+2.3%")
                        .font(.custom("RobotoMono-Bold", size: 18))
                        .foregroundColor(.green)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(Color.green.opacity(0.2))
                        .cornerRadius(5)
                }
                .padding()
                .background(Color(red: 0.15, green: 0.15, blue: 0.15))
                .cornerRadius(10)
                
                VStack(spacing: 15) {
                    StockRow(symbol: "AAPL", name: "APPLE INC.", price: "$142.53", change: "+0.8%")
                    StockRow(symbol: "GOOGL", name: "ALPHABET INC.", price: "$2,137.24", change: "-1.2%")
                    StockRow(symbol: "TSLA", name: "TESLA INC.", price: "$687.20", change: "+2.1%")
                }
                .padding()
                .background(Color(red: 0.15, green: 0.15, blue: 0.15))
                .cornerRadius(10)
                
                Spacer()
                
                HStack(spacing: 20) {
                    Button(action: {}) {
                        Text("BUY")
                            .font(.custom("RobotoMono-Bold", size: 18))
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.green)
                            .cornerRadius(10)
                    }
                    
                    Button(action: {}) {
                        Text("SELL")
                            .font(.custom("RobotoMono-Bold", size: 18))
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.red)
                            .cornerRadius(10)
                    }
                }
            }
            .padding()
        }
    }
}

struct StockRow: View {
    let symbol: String
    let name: String
    let price: String
    let change: String
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(symbol)
                    .font(.custom("RobotoMono-Bold", size: 16))
                    .foregroundColor(.white)
                Text(name)
                    .font(.custom("RobotoMono-Regular", size: 12))
                    .foregroundColor(.gray)
            }
            Spacer()
            VStack(alignment: .trailing) {
                Text(price)
                    .font(.custom("RobotoMono-Bold", size: 16))
                    .foregroundColor(.white)
                Text(change)
                    .font(.custom("RobotoMono-Regular", size: 14))
                    .foregroundColor(change.hasPrefix("+") ? .green : .red)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
