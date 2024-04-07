//
//  MultiSelector.swift
//  Goals
//
//  Created by Zach Barton on 12/21/23.
//

// SEE https://www.fline.dev/multi-selector-in-swiftui/ for an explanation of this code.

import SwiftUI

struct MultiSelector<LabelView: View, Selectable: Identifiable & Hashable>: View {
    let label: LabelView
    let options: [Selectable]
    let optionToString: (Selectable) -> String
    var selected: Binding<[Selectable]>

    private var formattedSelectedListString: String {
        ListFormatter.localizedString(byJoining: selected.wrappedValue.map { optionToString($0) })
    }

    var body: some View {
        NavigationLink(destination: MultiSelectionView(options: options, optionToString: optionToString, selected: selected)) {
            HStack {
                label
                Spacer()
                Text(formattedSelectedListString)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.trailing)
            }
        }
    }
}

struct MultiSelectionView<Selectable: Identifiable & Hashable>: View {
    let options: [Selectable]
    let optionToString: (Selectable) -> String

    @Binding
    var selected: Array<Selectable>
    
    var body: some View {
        List {
            ForEach(options) { selectable in
                Button(action: { toggleSelection(selectable: selectable) }) {
                    HStack {
                        Text(optionToString(selectable)).foregroundColor(.primary)

                        Spacer()

                        if selected.contains(where: { $0.id == selectable.id }) {
                            Image(systemName: "checkmark")
                        }
                    }
                }.tag(selectable.id)
            }
        }.listStyle(GroupedListStyle())
    }

    private func toggleSelection(selectable: Selectable) {
        if let existingIndex = selected.firstIndex(where: { $0.id == selectable.id }) {
            selected.remove(at: existingIndex)
        } else {
            selected.append(selectable)
            print(selected.map { optionToString($0) }.joined(separator: ", ") )
        }
    }
}

