//
//  IssueCommentView.swift
//  Simple Todo
//
//  Created by Subkhan Sarif on 05/07/23.
//

import SwiftUI
import MarkdownUI

struct IssueCommentView: View {
    @EnvironmentObject var jiraController: JiraController
    var jiraKey: String
    @State var comments: [TaskComment] = []
    @State var isLoading: Bool = true
    
    var body: some View {
        VStack {
            VStack {
                if isLoading {
                    EmptyView()
                } else if comments.isEmpty {
                    Text("No Comment")
                        .frame(maxWidth: .infinity, alignment: .leading)
                } else {
                    ScrollView {
                        ForEach(comments) { comment in
                            VStack {
                                HStack {
                                    AsyncImage(url: URL(string: comment.author?.avatarUrls?["16x16"] ?? ""))
                                        .frame(width: 16, height: 16)
                                        .clipShape(Circle())
                                    Text(comment.author?.displayName ?? "")
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                }
                                HStack {
                                    Markdown(comment.body ?? "")
                                        .markdownBlockStyle(\.blockquote) { configuration in
                                            configuration
                                                .padding(EdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 8))
                                                .overlay(alignment: .leading) {
                                                    Rectangle()
                                                        .fill(ColorTheme.instance.textDefault.opacity(0.1))
                                                        .frame(width: 4)
                                                }
                                                .background(ColorTheme.instance.textInactive.opacity(0.3))
                                                .foregroundColor(ColorTheme.instance.textDefault.opacity(0.6))
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                        }
                                        .markdownTextStyle(\.code, textStyle: {
                                            ForegroundColor(ColorTheme.instance.textDefault)
                                            FontFamilyVariant(.monospaced)
                                            BackgroundColor(ColorTheme.instance.textDefault.opacity(0.2))
                                        })
                                        .padding(EdgeInsets(top: 0, leading: 24, bottom: 0, trailing: 0))
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                }
                            }
                            .padding(EdgeInsets(top: 4, leading: 0, bottom: 4, trailing: 0))
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .padding(8)
            .background(ColorTheme.instance.textInactive.opacity(0.1))
        }
        .onChange(of: comments) { comments in
            if (!isLoading || comments.isEmpty) {
                return
            }
            
            extractCommentBody(comments)
        }
        .onChange(of: jiraController.newComment, perform: { newComment in
            isLoading = true
            loadComments()
        })
        .onAppear {
            isLoading = true
            loadComments()
        }
    }
    
    func loadComments() {
        jiraController.loadIssueComments(by: jiraKey) { comments in
            guard let comments = comments else {
                return
            }
            if comments.isEmpty {
                self.isLoading = false
            } else {
                self.comments = comments
            }
        }
    }
    
    func extractCommentBody(_ comments: [TaskComment]) {
        Task {
            let (isUpdated, newComments) = await jiraController.extractCommentsBody(comments)
            DispatchQueue.main.async {
                self.comments = newComments
                self.isLoading = !isUpdated
            }
        }
    }
}

struct IssueCommentView_Previews: PreviewProvider {
    static var previews: some View {
        IssueCommentView(jiraKey: "PFM-2119")
            .environmentObject(JiraController.instance)
    }
}
