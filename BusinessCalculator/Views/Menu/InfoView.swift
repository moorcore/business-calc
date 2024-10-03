//
//  InfoView.swift
//  BusinessCalculator
//
//  Created by Maxim Boykin on 3.10.24..
//

import SwiftUI

struct InfoView: View {
    var body: some View {
        
        VStack(spacing: 20) {
            Spacer()
            Text("О приложении")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(Color(hex: "#538296"))
                .padding(.top, 40)
            
            Text("Это приложение 'Business Calculator' создано для выполнения простых вычислений, включая расчёты с процентами.")
                .font(.body)
                .foregroundColor(Color(hex: "#538296"))
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Text("Разработчик")
                .font(.title2)
                .fontWeight(.medium)
                .foregroundColor(Color(hex: "#538296"))
                .padding(.top, 20)
            
            Text("Максим Бойкин")
                .font(.headline)
                .foregroundColor(Color(hex: "#538296"))
            
            Text("iOS-разработчик и энтузиаст SwiftUI. Приложение создано с использованием новейших технологий Swift и SwiftUI для лучшего пользовательского опыта.")
                .font(.body)
                .foregroundColor(Color(hex: "#538296"))
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Spacer()
        }
        .padding()
        .background(Color(hex: "#EBEBEB"))
        .edgesIgnoringSafeArea(.all)
    }
}

struct InfoView_Previews: PreviewProvider {
    static var previews: some View {
        InfoView()
    }
}

