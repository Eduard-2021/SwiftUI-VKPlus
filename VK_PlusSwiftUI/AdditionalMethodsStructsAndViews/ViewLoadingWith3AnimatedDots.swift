//
//  ViewLoadingWith3AnimatedDots.swift
//  VK_PlusSwiftUI
//
//  Created by Eduard on 31.10.2021.
//

import SwiftUI

struct  ViewLoadingWith3AnimatedDots: View {
    @State var firstСircleOpacity: Double = 1
    @State var secondСircleOpacity: Double = 0.5
    @State var thirdСircleOpacity: Double = 0.1
    @State var isStopPressed = false
    
    var heigth: CGFloat
    let duration: Double = 0.2
    let maxOpacity: Double = 1
    let averageOpacity: Double = 0.5
    let minOpacity: Double = 0.1
    let sizeCircle: CGFloat = 15
    private let dispGroup = DispatchGroup()
    
    var body: some View {
        HStack {
            Spacer()
            Circle()
                .fill(Color.black.opacity(firstСircleOpacity))
                .frame(width: sizeCircle, height: sizeCircle)
            Spacer().frame(width: sizeCircle/2)
            Circle()
                .fill(Color.black.opacity(secondСircleOpacity))
                .frame(width: sizeCircle, height: sizeCircle)
            Spacer().frame(width: sizeCircle/2)
            Circle()
                .fill(Color.black.opacity(thirdСircleOpacity))
                .frame(width: sizeCircle, height: sizeCircle)
            Spacer()
        }
        .frame(height: heigth)
        .onTapGesture {
            isStopPressed = true
        }
        .onAppear(){
            firstСircleOpacity = maxOpacity
            secondСircleOpacity = averageOpacity
            thirdСircleOpacity = minOpacity
            DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                animate()
            }
        }
    }
    
    private func animate() {
        withAnimation(.easeIn(duration: duration)) {firstСircleOpacity = averageOpacity}
        withAnimation(.easeIn(duration: duration)) {secondСircleOpacity = maxOpacity}
        withAnimation(.easeIn(duration: duration)) {thirdСircleOpacity = averageOpacity}
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            withAnimation(.easeIn(duration: duration)) {firstСircleOpacity = minOpacity}
            withAnimation(.easeIn(duration: duration)) {secondСircleOpacity = averageOpacity}
            withAnimation(.easeIn(duration: duration)) {thirdСircleOpacity = maxOpacity}
            DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                withAnimation(.easeIn(duration: duration)) {firstСircleOpacity = averageOpacity}
                withAnimation(.easeIn(duration: duration)) {secondСircleOpacity = minOpacity}
                withAnimation(.easeIn(duration: duration)) {thirdСircleOpacity = averageOpacity}
                DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                    withAnimation(.easeIn(duration: duration)) {firstСircleOpacity = maxOpacity}
                    withAnimation(.easeIn(duration: duration)) {secondСircleOpacity = averageOpacity}
                    withAnimation(.easeIn(duration: duration)) {thirdСircleOpacity = minOpacity}
                    DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                        if !isStopPressed {animate()}
                    }
                }
            }
        }
    }
}


