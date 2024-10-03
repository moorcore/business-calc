//
//  MenuView.swift
//  BusinessCalculator
//
//  Created by Maxim Boykin on 3.10.24..
//

import SwiftUI

struct MenuView: View {
    @State private var showingSettingsView = false
    @State private var showingInfoView = false
    
    var body: some View {
        VStack(alignment: .leading) {
            Button(action: {
                showingSettingsView = true
            }) {
                HStack {
                    Image(systemName: "gear")
                        .imageScale(.large)
                    Text("Настройки")
                        .font(.headline)
                }
            }
            .sheet(isPresented: $showingSettingsView) {
                SettingsView()
            }
            .padding(.top, 30)
            
            Button(action: {
                showingInfoView = true
            }) {
                HStack {
                    Image(systemName: "info.circle")
                        .imageScale(.large)
                    Text("Инфо")
                        .font(.headline)
                }
            }
            .sheet(isPresented: $showingInfoView) {
                InfoView()
            }
            .padding(.top, 15)
            
            Spacer()
        }
        .padding()
        .padding(.top, 50)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(hex: "#538296"))
        .foregroundStyle(Color(hex: "#EBEBEB"))
        .edgesIgnoringSafeArea(.all)
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView()
    }
}
