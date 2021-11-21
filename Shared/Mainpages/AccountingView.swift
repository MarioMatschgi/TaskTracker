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
    
    @State var month = Calendar.current.component(.month, from: Date())
    @State var year = Calendar.current.component(.year, from: Date())
    
    var body: some View {
        VStack {
            
        }
        .navigationTitle("Accounting")
        .toolbar {
            ToolbarItem {
                Picker(selection: $month) {
                    ForEach(1..<13) { i in
                        Text(DateTimeUtil.getMonthText(i)).tag(i)
                    }
                } label: { }
            }
            ToolbarItem {
                Picker(selection: $year) {
                    ForEach(getYearRange(), id: \.self) { i in
                        Text(String(i)).tag(i)
                    }
                } label: { }
            }
        }
    }
    
    func getYearRange() -> [Int] {
        let start = Calendar.current.component(.year, from: Date())
        let end = start - 10
        
        return (end...start).reversed()
    }
}
