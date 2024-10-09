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
    @AppStorage("showTabs") private var showTabs: Bool = true
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                if showTabs {
                    mainContentWithTabs
                        .overlay(
                            Color.black.opacity(showMenu ? 0.3 : 0)
                                .ignoresSafeArea()
                                .onTapGesture {
                                    withAnimation {
                                        showMenu = false
                                    }
                                }
                        )
                } else {
                    BasicCalculatorView()
                        .background(Color.adaptiveBackground
                                    .edgesIgnoringSafeArea(.all)
                        )
                        .overlay(
                            Color.black.opacity(showMenu ? 0.3 : 0)
                                .ignoresSafeArea()
                                .onTapGesture {
                                    withAnimation {
                                        showMenu = false
                                    }
                                }
                        )
                }

                if showMenu {
                    MenuView()
                        .frame(width: geometry.size.width / 2)
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
        }
    }

    var mainContentWithTabs: some View {
        ZStack {
            Color.adaptiveBackground
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                TabView {
                    ZStack {
                        BasicCalculatorView()
                            .background(Color.adaptiveBackground
                                    .edgesIgnoringSafeArea(.all)
                            )
                    }
                    .tabItem {
                        Label("Калькулятор", systemImage: "plus.slash.minus")
                    }
                    
                    ZStack {
                        PercentageCalculatorMainView()
                            .background(Color.adaptiveBackground
                                    .edgesIgnoringSafeArea(.all)
                            )
                    }
                    .tabItem {
                        Label("Проценты", systemImage: "percent")
                    }
                }
                .tint(Color.adaptiveText)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
