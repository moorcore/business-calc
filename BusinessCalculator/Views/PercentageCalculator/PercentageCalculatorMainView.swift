//
//  PercentageCalculatorMainView.swift
//  BusinessCalculator
//
//  Created by Maxim Boykin on 25.9.24..
//

import SwiftUI

struct PercentageCalculatorMainView: View {
    @State private var showingFindPercentage = false
    @State private var showingIncreaseByPercentage = false
    @State private var showingDecreaseByPercentage = false
    @State private var showingWhatPercentageIs = false
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Text("Процентные вычисления")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(Color.adaptiveText)
                .padding(.top, 40)
            
            Spacer()
            
            Button(action: {
                showingFindPercentage = true
            }) {
                Text("Найти % от числа")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.adaptiveButtonBackground)
                    .foregroundColor(Color.adaptiveText)
                    .cornerRadius(10)
                    .shadow(radius: 5)
            }
            .sheet(isPresented: $showingFindPercentage) {
                FindPercentageView()
            }
            
            Button(action: {
                showingIncreaseByPercentage = true
            }) {
                Text("Прибавить %")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.adaptiveButtonBackground)
                    .foregroundColor(Color.adaptiveText)
                    .cornerRadius(10)
                    .shadow(radius: 5)
            }
            .sheet(isPresented: $showingIncreaseByPercentage) {
                IncreaseByPercentageView()
            }
            
            Button(action: {
                showingDecreaseByPercentage = true
            }) {
                Text("Вычесть %")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.adaptiveButtonBackground)
                    .foregroundColor(Color.adaptiveText)
                    .cornerRadius(10)
                    .shadow(radius: 5)
            }
            .sheet(isPresented: $showingDecreaseByPercentage) {
                DecreaseByPercentageView()
            }
            
            Button(action: {
                showingWhatPercentageIs = true
            }) {
                Text("Найти % одного числа от другого")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.adaptiveButtonBackground)
                    .foregroundColor(Color.adaptiveText)
                    .cornerRadius(10)
                    .shadow(radius: 5)
            }
            .sheet(isPresented: $showingWhatPercentageIs) {
                WhatPercentageIsView()
            }
            
            Spacer()
        }
        .padding()
        .background(Color.adaptiveBackground)
        .edgesIgnoringSafeArea(.all)
    }
}

struct PercentageCalculatorMainView_Previews: PreviewProvider {
    static var previews: some View {
        PercentageCalculatorMainView()
    }
}

