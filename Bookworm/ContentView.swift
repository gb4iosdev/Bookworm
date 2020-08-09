//
//  ContentView.swift
//  Bookworm
//
//  Created by Gavin Butler on 06-08-2020.
//  Copyright © 2020 Gavin Butler. All rights reserved.
//

import SwiftUI


struct ContentView: View {
    
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: Book.entity(), sortDescriptors:
        [NSSortDescriptor(keyPath: \Book.title, ascending: true),
         NSSortDescriptor(keyPath: \Book.author, ascending: true)
        ]) var books: FetchedResults<Book>
    
    @State private var showAddView = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(books, id: \.self) { book in
                    NavigationLink(destination: DetailView(book: book)) {
                        EmojiRatingView(rating: book.rating)
                            .font(.largeTitle)
                        VStack(alignment: .leading) {
                            Text(book.title ?? "Unknown Title")
                                .font(.headline)
                                .foregroundColor(book.rating == 1 ? .red : Color.primary)
                            Text(book.author ?? "Unknown Author")
                                .foregroundColor(.secondary)
                            Text("Reviewed: \(self.formatBookDate(book.date))")
                                .font(.footnote)
                                .foregroundColor(.gray)
                        }
                    }
                }
            .onDelete(perform: deleteBooks)
            }
            .navigationBarTitle("Bookworm")
            .navigationBarItems(leading: EditButton(), trailing:
                Button(action: {
                    self.showAddView = true
                }) {
                    HStack {
                        Image(systemName: "plus")
                    }
                }
            )
            .sheet(isPresented: $showAddView) {
                AddBookView().environment(\.managedObjectContext, self.moc)
            }
        }
    }
    
    func deleteBooks(at offsets: IndexSet) {
        for offset in offsets {
            let book = books[offset]
            moc.delete(book)
        }
        
        try? moc.save()
    }
    
    func formatBookDate(_ date: Date?) -> String {
        
        guard let date = date else { return "<No Date Recorded>" }
        
        return date.bookFormat()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

//Core Data
/*struct ContentView: View {
    
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: Student.entity(), sortDescriptors: []) var students: FetchedResults<Student>
    
    var body: some View {
        VStack {
            List {
                ForEach(students, id: \.id) { student in
                    Text(student.name ?? "Unknown")
                }
            }
            Button("Add") {
                let firstNames = ["Gavin", "Jeff", "Cindy", "Roberto"]
                let lastNames = ["Smith", "Jones", "Butler", "Spizolino"]
                let studentName = firstNames.randomElement()! + " " + lastNames.randomElement()!
                
                let student = Student(context: self.moc)
                student.id = UUID()
                student.name = studentName
                try? self.moc.save()
            }
        }
    }
}*/

//AnyView type erasure as applied to Size Classes:
/*struct ContentView: View {
    @Environment(\.horizontalSizeClass) var sizeClass
    
    var body: some View {
        if sizeClass == .compact {  //Wrap the entire view in anyview
            return AnyView(VStack {
                Text("Active Size Class: ")
                Text("COMPACT")
            }
            .font(.largeTitle))
        } else {
            return AnyView(HStack {
                Text("Active Size Class: ")
                Text("REGULAR")
            }
            .font(.largeTitle))
        }
    }
}*/

//@Environment
/*struct ContentView: View {
     @Environment(\.horizontalSizeClass) var sizeClass
     
     var body: some View {
         if sizeClass == .compact {
             return HStack {
                 Text("Active Size Class: ")
                 Text("COMPACT")
             }
             .font(.largeTitle)
         } else {
             return HStack {
                 Text("Active Size Class: ")
                 Text("REGULAR")
             }
             .font(.largeTitle)
         }
     }
 }*/

//@Binding - share @State with a child view
/*struct PushButton: View {
    let title: String
    @Binding var isOn: Bool
    
    var onColours = [Color.red, Color.yellow]
    var offColours = [Color(white: 0.6), Color(white: 0.4)]
    
    var body: some View {
        Button(title) {
            self.isOn.toggle()
        }
        .padding()
        .background(LinearGradient(gradient: Gradient(colors: isOn ? onColours : offColours), startPoint: .top, endPoint: .bottom))
        .foregroundColor(.white)
        .clipShape(Capsule())
        .shadow(radius: isOn ? 0 : 5)
    }
}

struct ContentView: View {
    @State private var rememberMe = false
    
    var body: some View {
        VStack {
            PushButton(title: "rememberMe", isOn: $rememberMe)
            Text(rememberMe ? "On" : "Off")
        }
    }
}*/
