//
//  CommentEditorView.swift
//  Simple Todo
//
//  Created by Subkhan Sarif on 08/07/23.
//

import SwiftUI

struct CommentEditorView: View {
    @EnvironmentObject var jiraController: JiraController
    var taskId: String
    @Binding var commentAdded: Bool
    @State var comment: String = ""
    @State var maxHeight: Double = 40
    
    var body: some View {
        HStack {
            ZStack {
                if maxHeight <= 40 {
                    Text("Add a comment...")
                        .transition(.move(edge: .trailing).combined(with: .opacity))
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                }
                TextEditor(text: $comment)
                    .background(.white.opacity(0))
                    .padding(EdgeInsets(top: 8, leading: 4, bottom: 8, trailing: 4))
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            }
            .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 4))
            .frame(maxWidth: .infinity, alignment: .leading)
            if maxHeight >= 100 {
                VStack {
                    Button("Save →") {
                        composeAndPostComment()
                    }
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .foregroundColor(ColorTheme.instance.textButtonDefault)
                    .buttonStyle(.plain)
                    .frame(maxHeight: .infinity, alignment: .bottom)
                }
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 8, trailing: 8))
                .frame(maxHeight: .infinity, alignment: .bottom)
            }
        }
        .transition(.scale)
        .onChange(of: comment, perform: { newComment in
            withAnimation {
                if newComment.isEmpty && maxHeight > 40 {
                    maxHeight = 40
                } else if !newComment.isEmpty && maxHeight <= 40 {
                    maxHeight = 100
                }
            }
        })
        .padding(EdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4))
        .background(ColorTheme.instance.textInactive.opacity(maxHeight <= 40 ? 0.1 : 0.3))
        .cornerRadius(8)
        .frame(maxWidth: .infinity, maxHeight: maxHeight, alignment: .leading)
    }
    
    func composeAndPostComment() {
        let commentData = NewCommentData(
            body: CommentBody(
                content: [
                    CommentContent(
                        content: [
                            Content(
                            text: comment,
                            type: "text"
                            )
                        ],
                        type: "paragraph")
                ],
                type: "doc",
                version: 1
            )
        )
        jiraController.postComment(for: taskId, data: commentData) { success in
            commentAdded = success
            comment = ""
        }
    }
}

struct CommentEditorView_Previews: PreviewProvider {
    static var previews: some View {
        CommentEditorView(
            taskId: "PFM-2119",
            commentAdded: .constant(false)
        )
            .environmentObject(JiraController.instance)
    }
}
