//
//  Alert.swift
//  Tic Tac Toe
//
//  Created by Hanamantraya Nagonde on 14/10/21.
//

import SwiftUI

struct AlertItem: Identifiable {
    let id = UUID()
    var title: Text
    var message: Text
    var buttonTitle: Text
}

struct AlertContext {
    static let humanWin = AlertItem(title: Text("You win"),
                             message: Text("You are so smart"),
                             buttonTitle: Text("Hell Yea"))
    
    static let computerWin = AlertItem(title: Text("Computer win"),
                             message: Text("Try next time"),
                             buttonTitle: Text("Okay"))
    
    static let draw = AlertItem(title: Text("Match Draw"),
                             message: Text("You are so smart"),
                             buttonTitle: Text("Hell Yea"))
}
