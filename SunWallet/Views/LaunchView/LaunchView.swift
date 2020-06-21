import SwiftUI

struct LaunchView: View {    
    // MARK:- Environment
    @EnvironmentObject var dataSource: DataSource
    
    // MARK:- States
    @State private var selectedChartPeriod: Int = 0
    @State private var selectedAssetIndex = 0
    @State private var selectedValue: Double = 0
    @State private var selectedValueChange: Double = 0
    
    // MARK:- Calculated Variables
    private var assets: [Asset] {
        dataSource.launchAssets
    }
    private var currentAsset: Asset {
        assets[selectedAssetIndex]
    }
    private var currentValue: Double {
        selectedValue
    }
    private var currentValueChange: Double {
        selectedValueChange
    }
    
    // MARK:- Subviews
    private var chartView: some View {
        LaunchChartView(
            valueHistory: currentAsset.valueHistory,
            color: .white,
            selectedChartPeriod: $selectedChartPeriod,
            selectedValue: $selectedValue,
            selectedValueChange: $selectedValueChange
        )
    }
    private var assetPicker: some View {
        HStack {
            VStack {
                Divider()
            }
            Text("")
            ForEach(0 ..< assets.count) { index in
                self.makeAssetButton(title: self.assets[index].code, index: index)
            }
            Text("")
            VStack {
                Divider()
            }
        }
    }
    private var assetValues: some View {
        HStack {
            Spacer()
            VStack {
                Text(currentValue.dollarString)
                    .font(.headline)
                    .foregroundColor(Color.white)
                Text("\(currentAsset.title) price")
                    .font(.caption)
                    .foregroundColor(Color.white)
            }
            Spacer()
            Divider()
            Spacer()
            VStack(spacing: 0.0) {
                HStack(spacing: 4.0) {
                    Text(currentValueChange.dollarString)
                        .font(.headline)
                        .foregroundColor(Color.white)
                    
                    dynamicArrow
                }
                
                Text("This year")
                    .font(.caption)
                    .foregroundColor(Color.white)
            }
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: 80)
    }
    
    private var dynamicArrow: some View {
        Image(systemName: currentValueChange.isPositive ? "arrowtriangle.up.fill" : "arrowtriangle.down.fill")
            .foregroundColor(currentValueChange.isPositive ? .green : .red)
            .font(.caption)
    }
    
    private var registerButton: some View {
        Button(action: {}) {
            Text("Get Started")
        }
        .foregroundColor(.gradientEndColor)
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .cornerRadius(8)
    }
    
    private var loginButton: some View {
        Button("Sign In") {
        }
        .foregroundColor(.white)
    }
    
    private var buttonsBlock: some View {
        VStack(spacing: 8) {
            registerButton
                .padding(.horizontal)
            loginButton
                .padding()
        }
    }
    
    var body: some View {
        VStack {
            Spacer()
            LogoView()
            assetPicker
            assetValues
            chartView
            Spacer()
            buttonsBlock
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(LinearGradient.background)
        .edgesIgnoringSafeArea(.all)
    }
    
    // MARK:- Methods
    private func makeAssetButton(title: String, index: Int) -> some View {
        Button(title, action: { self.selectedAssetIndex = index })
            .foregroundColor(self.selectedAssetIndex == index ? .white : .white)
    }
}

struct LaunchView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchView()
            .environmentObject(DataSource())
    }
}
