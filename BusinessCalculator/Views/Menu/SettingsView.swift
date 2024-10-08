//
//  SettingsView.swift
//  BusinessCalculator
//
//  Created by Maxim Boykin on 3.10.24..
//

import SwiftUI

struct SettingsView: View {
    
    @AppStorage("showTabs") private var showTabs: Bool = true
    @AppStorage("customLogic") private var customLogic: Bool = false
    @AppStorage("saveState") private var saveState: Bool = false

    var body: some View {
        VStack(spacing: 20) {
            Text("Настройки")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(Color(hex: "#538296"))
                .padding(.top, 40)

            Toggle(isOn: $showTabs) {
                Text("Показывать вкладки")
                    .font(.headline)
                    .foregroundColor(Color(hex: "#538296"))
            }
            .padding()
            .toggleStyle(SwitchToggleStyle(tint: Color(hex: "#538296")))

            Toggle(isOn: $customLogic) {
                Text("Отображать цепь операций")
                    .font(.headline)
                    .foregroundColor(Color(hex: "#538296"))
            }
            .padding()
            .toggleStyle(SwitchToggleStyle(tint: Color(hex: "#538296")))
            
            Toggle(isOn: $saveState) {
                Text("Сохранять результат")
                    .font(.headline)
                    .foregroundColor(Color(hex: "#538296"))
            }
            .padding()
            .toggleStyle(SwitchToggleStyle(tint: Color(hex: "#538296")))

            Spacer()
        }
        .padding()
        .background(Color(hex: "#EBEBEB"))
        .edgesIgnoringSafeArea(.all)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}

