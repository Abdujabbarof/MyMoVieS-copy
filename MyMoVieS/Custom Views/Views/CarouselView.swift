//
//  CarouselView.swift
//  MyMoVieS
//
//  Created by Abdulloh on 01/08/24.
//

import Foundation
import SwiftUI

struct CarouselView: View {
    var images: [Film]
    
    @State private var currentIndex: Int = 0
    @State private var draggOffSet: CGFloat = 0
    @State private var timer: Timer? = nil
    private let autoScrollInterval: TimeInterval = 5.0
    
    private let screenWidth = UIScreen.main.bounds.width
    private let screenHeight = UIScreen.main.bounds.height
    private let itemWidthRatio: CGFloat = 0.75
    private let itemHeightRatio: CGFloat = 0.55
    private let offsetMultiplier: CGFloat = 0.8

    var body: some View {
        NavigationStack {
            VStack {
                ZStack {
                    ForEach(0..<images.count, id: \.self) { index in
                        NavigationLink(destination: DetailedView(movieId: images[index].filmId)) {
                            AsyncImage(url: URL(string: images[index].posterUrl ?? "https://st.kp.yandex.net/images/no-poster.gif")) { image in
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(
                                        width: screenWidth * itemWidthRatio,
                                        height: screenHeight > 700 ? screenHeight * itemHeightRatio : screenHeight * 0.6
                                    )
                                    .cornerRadius(25)
                                    .opacity(currentIndex == index ? 1.0 : 0.5)
                                    .scaleEffect(currentIndex == index ? 1.2 : 0.8)
                                    .offset(x: CGFloat(index - currentIndex) * (screenWidth * offsetMultiplier) + draggOffSet, y: 0)
                                    .animation(.easeInOut, value: currentIndex)
                            } placeholder: {
                                
                            }
                        }
                        .buttonStyle(PlainButtonStyle()) // This ensures that the NavigationLink does not affect the styling of the image
                    }
                }
                .padding(.top, screenHeight > 700 ? screenHeight * -0.02 : screenHeight * -0.02)
                .gesture(
                    DragGesture().onChanged { value in
                        draggOffSet = value.translation.width
                    }
                    .onEnded { value in
                        let threshold: CGFloat = 50
                        if value.translation.width > threshold {
                            withAnimation {
                                currentIndex = max(0, currentIndex - 1)
                            }
                        } else if value.translation.width < -threshold {
                            withAnimation {
                                currentIndex = min(images.count - 1, currentIndex + 1)
                            }
                        }
                        draggOffSet = 0 // Reset offset after dragging
                    }
                )
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Text("Latest movies")
                        .font(screenHeight > 700 ? .largeTitle : .title)
                        .fontWeight(.bold)
                        .padding(.top, 5)
                        .padding(.leading, 5)
                }
            }
            .onAppear {
                startAutoScroll()
            }
            .onDisappear {
                stopAutoScroll()
            }
        }
    }

    private func startAutoScroll() {
        timer = Timer.scheduledTimer(withTimeInterval: autoScrollInterval, repeats: true) { _ in
            withAnimation {
                currentIndex = (currentIndex + 1) % images.count
            }
        }
    }

    private func stopAutoScroll() {
        timer?.invalidate()
        timer = nil
    }
}
