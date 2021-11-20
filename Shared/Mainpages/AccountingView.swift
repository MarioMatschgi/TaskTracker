//
//  HistoryView.swift
//  TaskTracker
//
//  Created by Mario Elsnig on 16.11.21.
//

import SwiftUI

struct AccountingView: View {
    @EnvironmentObject var model: Model
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
//        Text("List of tasks, how long they took and if you click on the element -> navigationlink/sheet to detail page where you can see timestamps")
        VStack {
            
        }
        .navigationTitle("Accounting")
    }
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        AccountingView()
    }
}
