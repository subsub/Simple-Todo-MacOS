//
//  StatusMenuView.swift
//  Simple Todo
//
//  Created by Subkhan Sarif on 29/06/23.
//

import SwiftUI

struct StatusMenuView: View {
    @EnvironmentObject var taskDelegate: UserDefaultsDelegates
    
    var body: some View {
        HStack {
            statusIcon
            statusText
        }.padding(4)
    }
    
    var statusIcon: some View {
        if taskDelegate.totalTask() == 0  || taskDelegate.totalCompletedTask() == taskDelegate.totalTask() {
            return Image(systemName: "checkmark.circle.fill")
        } else if taskDelegate.totalCompletedTask() == 0 {
            return Image(systemName: "checklist.unchecked")
        } else {
            return Image(systemName: "checklist")
        }
    }
    
    var statusText: some View {
        if taskDelegate.totalTask() == 0 || taskDelegate.totalCompletedTask() == taskDelegate.totalTask() {
            return Text("All Clear")
        } else {
            return Text("\(taskDelegate.totalTask() - taskDelegate.totalCompletedTask()) tasks")
        }
    }
}

struct StatusMenuView_Previews: PreviewProvider {
    static var previews: some View {
        StatusMenuView()
    }
}
