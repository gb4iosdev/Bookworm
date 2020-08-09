//
//  AddBookView.swift
//  Bookworm
//
//  Created by Gavin Butler on 07-08-2020.
//  Copyright © 2020 Gavin Butler. All rights reserved.
//

import SwiftUI

struct AddBookView: View {
    
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentationMode
    
    @State private var title = ""
    @State private var author = ""
    @State private var rating = 3
    @State private var genre = ""
    @State private var review = ""
    @State private var reviewDate = Date()
    
    let genres = ["Fantasy", "Horror", "Kids", "Mystery", "Poetry", "Romance", "Thriller"]
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Name of book:", text: $title)
                    TextField("Author's name:", text: $author)
                    Picker("Genre", selection: $genre) {
                        ForEach(genres, id: \.self) { genre in
                            Text(genre)
                        }
                    }
                }
                Section(header: Text("Rating:").font(.headline)) {
                    RatingView(rating: $rating)
                    .pickerStyle(SegmentedPickerStyle())
                    TextField("Write a Review", text: $review)
                    Text("Review Date: \(self.formatBookDate(self.reviewDate))")
                }
                Section {
                    Button("Save") {
                        let book = Book(context: self.moc)
                        book.title = self.title
                        book.author = self.author
                        book.rating = Int16(self.rating)
                        if !self.genre.isEmpty {
                            book.genre = self.genre
                        }
                        book.review = self.review
                        book.date = Date()
                        
                        try? self.moc.save()
                        self.presentationMode.wrappedValue.dismiss()
                    }
                }
            }
            .navigationBarTitle("Add Book")
        }
    }
    
    func formatBookDate(_ date: Date?) -> String {
        
        guard let date = date else { return "<No Date Recorded>" }
        
        return date.bookFormat()
    }
}

struct AddBookView_Previews: PreviewProvider {
    static var previews: some View {
        AddBookView()
    }
}
