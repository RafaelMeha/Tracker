//
//  BuildCircleButtonAnimation.swift
//  CryptoTracker
//
//  Created by Oriakhi Collins on 4/24/22.
//

import SwiftUI

struct BuildCircleButtonAnimation: View {
    @Binding  var animate: Bool
    var body: some View {
        Circle()
            .stroke(lineWidth: 5)
            .scale(animate ? 1 : 0)
            .opacity(animate ? 0 : 1)
            .animation(animate ? Animation.easeOut(duration: 1): .none)
        
    }
}

struct BuildCircleButtonAnimation_Previews: PreviewProvider {
    static var previews: some View {
        BuildCircleButtonAnimation(animate: .constant(false))
    }
}
