//
//  ContentView.swift
//  BusinessCalculator
//
//  Created by Maxim Boykin on 25.9.24..
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            // Добавляем градиентный фон
            Color(hex: "#EBEBEB")
                .edgesIgnoringSafeArea(.all) // Применяем градиент на всю область экрана
            
            VStack {
                TabView {
                    // Оборачиваем каждый экран в ZStack
                    ZStack {
                        BasicCalculatorView()
                            .background(Color(hex: "#EBEBEB")
                                    .edgesIgnoringSafeArea(.all) // Градиент для каждого экрана
                            )
                    }
                    .tabItem {
                        Label("Калькулятор", systemImage: "plus.slash.minus")
                    }
                    
                    ZStack {
                        PercentageCalculatorMainView()
                            .background(Color(hex: "#EBEBEB")
                                    .edgesIgnoringSafeArea(.all) // Градиент для каждого экрана
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

