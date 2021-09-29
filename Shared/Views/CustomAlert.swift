//
//  CustomAlert.swift
//  Netliphy
//
//  Created by Дмитрий on 26.09.2021.
//

import SwiftUI

struct CustomAlert: ViewModifier {
    @Binding var isPresented: Bool
    
    func body(content: Content) -> some View {
        ZStack(alignment: .bottom) {
            content
            if isPresented {
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(.red)
                        .frame(height: 50)
                    Label {
                        Text("Error message")
                            .foregroundColor(.white)
                            .font(.footnote)
                    } icon: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.body.weight(.bold))
                            .foregroundColor(.white)
                    }
                    .padding()
                }
                .animation(.spring(), value: isPresented)
                .onTapGesture {
                    isPresented.toggle()
                }
                .padding()
            }
        }
    }
}
