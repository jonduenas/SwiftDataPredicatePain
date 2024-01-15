//
//  ContentView.swift
//  SwiftDataPredicatePain
//
//  Created by Jon Duenas on 1/15/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var notes: [Note]

    var body: some View {
        NavigationSplitView {
            List {
                ForEach(notes) { note in
                    NavigationLink {
                        Text("note at \(note.date, format: Date.FormatStyle(date: .numeric, time: .standard))")
                    } label: {
                        Text(note.date, format: Date.FormatStyle(date: .numeric, time: .standard))
                    }
                }
                .onDelete(perform: deleteNotes)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button(action: addNote) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
        } detail: {
            Text("Select an item")
        }
    }

    private func addNote() {
        withAnimation {
            let newNote = Note(date: Date())
            modelContext.insert(newNote)
        }
    }

    private func deleteNotes(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(notes[index])
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: [Note.self, CoffeeBag.self], inMemory: true)
}
