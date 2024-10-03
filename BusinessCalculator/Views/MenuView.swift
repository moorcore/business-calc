//
//  MenuView.swift
//  BusinessCalculator
//
//  Created by Maxim Boykin on 3.10.24..
//

import SwiftUI

struct MenuView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("Меню")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top, 100)
            
            Button(action: {
                // Действие для кнопки меню
            }) {
                Text("Пункт 1")
                    .font(.headline)
                    .padding()
            }
            
            Button(action: {
                // Действие для кнопки меню
            }) {
                Text("Пункт 2")
                    .font(.headline)
                    .padding()
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.gray.opacity(0.9))
        .edgesIgnoringSafeArea(.all)
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView()
    }
}
