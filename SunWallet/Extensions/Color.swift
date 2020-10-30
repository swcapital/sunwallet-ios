import SwiftUI

extension Color {
    static let darkGray: Color = Color(red: 0.3, green: 0.3, blue: 0.3)
    static let lightGray: Color = Color(red: 0.9, green: 0.9, blue: 0.9)
    static let blueGray: Color = Color(red: 0.3, green: 0.3, blue: 0.7)
    
    static let primary: Color = Color(red: 255 / 255, green: 169 / 255, blue: 39 / 255)
    static let lightBlue: Color = Color(red: 139 / 255, green: 170 / 255, blue: 245 / 255)
    
    static let gradientStartColor: Color = Color(red: 1, green: 202 / 255, blue: 63 / 255)
    static let gradientEndColor: Color = Color(red: 1, green: 169 / 255, blue: 39 / 255)
    /*
    static let redColor: Color = Color(red: 241.0/255.0, green: 51.0/255.0, blue: 50.0/255.0)
    static let greenColor: Color = Color(red: 0.0/255.0, green: 175.0/255.0, blue: 130.0/255.0)
    static let yellowColor: Color = Color(red: 255.0/255.0, green: 227.0/255.0, blue: 37.0/255.0)
    static let darkOrangeColor: Color = Color(red: 255.0/255.0, green: 106.0/255.0, blue: 0.0/255.0)
    static let lightOrangeColor: Color = Color(red: 255.0/255.0, green: 150.0/255.0, blue: 0.0/255.0)
    static let blackColor: Color = Color(red: 42.0/255.0, green: 42.0/255.0, blue: 42.0/255.0)
    static let darkGrayColor: Color = Color(red: 171.0/255.0, green: 171.0/255.0, blue: 171.0/255.0)
    static let lightGrayColor: Color = Color(red: 224.0/255.0, green: 224.0/255.0, blue: 224.0/255.0)
    static let whiteColor: Color = Color(red: 245.0/255.0, green: 244.0/255.0, blue: 244.0/255.0)
 
    
    static let redColor: Color = Color(red: 255.0/255.0, green: 69.0/255.0, blue: 60.0/255.0)
    static let blueColor: Color = Color(red: 69.0/255.0, green: 60.0/255.0, blue: 255.0/255.0) */

    
    
    static let greenColor: Color = Color(red: 0.0/255.0, green: 175.0/255.0, blue: 130.0/255.0)
    static let darkOrangeColor: Color = Color(red: 255.0/255.0, green: 106.0/255.0, blue: 0.0/255.0)
    static let lightOrangeColor: Color = Color(red: 255.0/255.0, green: 150.0/255.0, blue: 0.0/255.0)
    static let blackColor: Color = Color(red: 42.0/255.0, green: 42.0/255.0, blue: 42.0/255.0)
    static let darkGrayColor: Color = Color(red: 171.0/255.0, green: 171.0/255.0, blue: 171.0/255.0)
    static let lightGrayColor: Color = Color(red: 224.0/255.0, green: 224.0/255.0, blue: 224.0/255.0)
    static let whiteColor: Color = Color(red: 245.0/255.0, green: 244.0/255.0, blue: 244.0/255.0)
    
    
    static let redColor: Color = Color(red: 191.0/255.0, green: 63.0/255.0, blue: 87.0/255.0)
    static let blueColor: Color = Color(red: 32.0/255.0, green: 15.0/255.0, blue: 140.0/255.0)
    static let lightBlueColor: Color = Color(red: 39.0/255.0, green: 3.0/255.0, blue: 166.0/255.0)
    static let darkBlueColor: Color = Color(red: 20.0/255.0, green: 18.0/255.0, blue: 89.0/255.0)
    
    static let yellowColor: Color = Color(red: 242.0/255.0, green: 183.0/255.0, blue: 5.0/255.0)
    static let darkYellowColor: Color = Color(red: 242.0/255.0, green: 159.0/255.0, blue: 5.0/255.0)

    
    
    
}

extension Color {
    init(hex: UInt, alpha: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xff) / 255,
            green: Double((hex >> 08) & 0xff) / 255,
            blue: Double((hex >> 00) & 0xff) / 255,
            opacity: alpha
        )
    }
}
