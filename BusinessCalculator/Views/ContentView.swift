//
//  ContentView.swift
//  BusinessCalculator
//
//  Created by Maxim Boykin on 25.9.24..
//

import SwiftUI

struct ContentView: View {
    @State private var showMenu = false
    @State private var dragOffset: CGFloat = 0

    var body: some View {
        ZStack {
            mainContent
                .overlay(
                    Color.black.opacity(showMenu ? 0.3 : 0)
                        .ignoresSafeArea()
                        .onTapGesture {
                            withAnimation {
                                showMenu = false
                            }
                        }
                )
                .gesture(
                    DragGesture()
                        .onEnded { value in
                            if value.translation.width > 100 {
                                withAnimation {
                                    showMenu = true
                                }
                            }
                        }
                )

            if showMenu {
                MenuView()
                    .frame(width: 250)
                    .transition(.move(edge: .leading))
                    .animation(.easeInOut, value: showMenu)
                    .gesture(
                        DragGesture()
                            .onEnded { value in
                                if value.translation.width < -100 {
                                    withAnimation {
                                        showMenu = false
                                    }
                                }
                            }
                    )
            }
        }
    }

    var mainContent: some View {
        ZStack {
            Color(hex: "#EBEBEB")
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                TabView {
                    ZStack {
                        BasicCalculatorView()
                            .background(Color(hex: "#EBEBEB")
                                    .edgesIgnoringSafeArea(.all)
                            )
                    }
                    .tabItem {
                        Label("Калькулятор", systemImage: "plus.slash.minus")
                    }
                    
                    ZStack {
                        PercentageCalculatorMainView()
                            .background(Color(hex: "#EBEBEB")
                                    .edgesIgnoringSafeArea(.all)
                            )
                    }
                    .tabItem {
                        Label("Проценты", systemImage: "percent")
                    }
                }
                .tint(Color(hex: "#538296"))
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
