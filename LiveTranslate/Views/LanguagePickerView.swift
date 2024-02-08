//
//  LanguagePicker.swift
//  Live Translate
//
//  Created by Ken Zhang on 1/18/24.
//

import SwiftUI

struct LanguagePickerView<Content: View>: View {
    let content: Content
    @Binding var selection: Language
    
    @State private var showingPicker = false
    
    init(selection: Binding<Language>, @ViewBuilder content: () -> Content) {
        self._selection = selection
        self.content = content()
    }
    
    var body: some View {
        VStack {
            Button(action: { showingPicker = true }) {
                Text(selection.details.name)
                    .padding()
                    .foregroundStyle(.black)
                    .frame(minWidth: 110, maxHeight: 40)
                    .font(.system(size: 16))
                    .overlay(
                        RoundedRectangle(cornerRadius: 5.0)
                            .stroke(hex2Color(hex: "#DEDEDE"), lineWidth: 1)
                    )
            }
            .sheet(isPresented: $showingPicker) {
                NavigationView {
                    List(Language.allCases) { language in
                        let selected = language == selection
                        Button(action: {
                            self.selection = language
                            showingPicker = false
                        }) {
                            Text(language.details.name)
                                .foregroundStyle(selected ? .white : .black)
                                .fontWeight(selected ? .bold : .light)
                        }
                        .listRowBackground(selected ? User.mainColor : .white)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .toolbar {
                        ToolbarItem(placement: .confirmationAction) {
                            Button(action: {showingPicker = false }) {
                                Image(systemName: "xmark")
                                    .font(.subheadline)
                                    .foregroundColor(hex2Color(hex: "#B6B8B8"))
                            }
                        }
                    }
                }
            }
            .padding(.vertical, 4)
            content
        }
    }
}

#Preview {
    LanguagePickerView(selection: .constant(.english)) {
        RecordButtonView(recording: .constant(false), color: User.secondaryColor) {}
    }
}
