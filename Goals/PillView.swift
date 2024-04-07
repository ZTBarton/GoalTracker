//
//  PillView.swift
//  Goals
//
//  Created by Zach Barton on 12/21/23.
//

import SwiftUI

struct PillView: View {
    var text: String

    var body: some View {
        Text(text)
            .font(.system(size: 12, weight: .medium))
            .foregroundColor(.white)
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(getPillColor(status: text))
            .clipShape(Capsule())
    }
    
    private func getPillColor(status: String) -> Color {
        switch status {
        case Constants.StatusStrings[1]:
            return Color.blue
        case Constants.StatusStrings[2]:
            return Color.green
        case Constants.StatusStrings[3]:
            return Color.yellow
        case Constants.StatusStrings[4]:
            return Color.red
        default:
            return Color.gray
            
        }
    }

}
