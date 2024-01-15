//
//  Models.swift
//  SwiftDataPredicatePain
//
//  Created by Jon Duenas on 1/15/24.
//

import Foundation
import SwiftData

@Model
public final class Note {
    public var date: Date = Date.now
    @Relationship(deleteRule: .nullify, inverse: \CoffeeBag.notes)
    public var coffeeBag: CoffeeBag?
    public var noteText: String = ""
    public var sessionNoteText: String = ""

    init(date: Date, coffeeBag: CoffeeBag? = nil, noteText: String = "", sessionNoteText: String = "") {
        self.date = date
        self.coffeeBag = coffeeBag
        self.noteText = noteText
        self.sessionNoteText = sessionNoteText
    }
}

@Model
public final class CoffeeBag {
    public var roaster: String = ""
    public var name: String = ""
    public var origin: String = ""
    public var bagNote: String = ""
    public var notes: [Note]? = []

    init(roaster: String = "", name: String = "", origin: String = "", bagNote: String = "") {
        self.roaster = roaster
        self.name = name
        self.origin = origin
        self.bagNote = bagNote
        self.notes = notes
    }
}

extension Note {
    struct SearchToken: Identifiable, Equatable {
        enum Scope: Int, Hashable, CaseIterable, CustomStringConvertible {
            case coffeeName
            case roaster
            case origin
            case coffeeNote
            case sessionNote
            case additionalNotes

            var description: String {
                switch self {
                case .coffeeName: "Coffee name contains:"
                case .roaster: "Roaster contains:"
                case .origin: "Origin contains:"
                case .coffeeNote: "Coffee note contains:"
                case .sessionNote: "Session note contains:"
                case .additionalNotes: "Additional notes contain:"
                }
            }
        }

        var scope: Scope
        var searchText: String
        var id: String { scope.description + " " + searchText }

        init(scope: Scope, searchText: String) {
            self.scope = scope
            self.searchText = searchText
        }
    }

    static func predicate(
        searchText: String = "",
        tokens: [SearchToken] = []
    ) -> Predicate<Note> {
        guard !searchText.isEmpty, !tokens.isEmpty else {
            return #Predicate<Note> { _ in true }
        }

        let tokenIndices = tokens.indices
        let tokenScopes = tokens.map { $0.scope.rawValue }
        let tokenSearchTexts = tokens.map { $0.searchText }

        let coffeeName = SearchToken.Scope.coffeeName.rawValue
        let roaster = SearchToken.Scope.roaster.rawValue
        let origin = SearchToken.Scope.origin.rawValue
        let coffeeNote = SearchToken.Scope.coffeeNote.rawValue
        let sessionNote = SearchToken.Scope.sessionNote.rawValue
        let additionalNotes = SearchToken.Scope.additionalNotes.rawValue

        return #Predicate<Note> { note in
            tokenIndices.contains { index in
                note.coffeeBag.flatMap { coffeeBag in
                    if tokenScopes[index] == sessionNote {
                        return note.sessionNoteText.localizedStandardContains(tokenSearchTexts[index])
                    } else if tokenScopes[index] == additionalNotes {
                        return note.noteText.localizedStandardContains(tokenSearchTexts[index])
                    } else if tokenScopes[index] == coffeeName {
                        coffeeBag.name.localizedStandardContains(tokenSearchTexts[index])
                    } else if tokenScopes[index] == roaster {
                        coffeeBag.roaster.localizedStandardContains(tokenSearchTexts[index])
                    } else if tokenScopes[index] == origin {
                        coffeeBag.origin.localizedStandardContains(tokenSearchTexts[index])
                    } else if tokenScopes[index] == coffeeNote {
                        coffeeBag.bagNote.localizedStandardContains(tokenSearchTexts[index])
                    } else {
                        return false
                    }
                } == true
            }
        }
    }
}
