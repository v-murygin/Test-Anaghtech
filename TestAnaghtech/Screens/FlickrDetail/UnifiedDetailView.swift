//
//  UnifiedDetailView.swift
//  TestAnaghtech
//
//  Created by Vladislav Murygin on 1/29/26.
//

import SwiftUI


struct UnifiedDetailView: View {
    
    let item: FlickrItem
    @State private var viewMode: UnifiedDetailViewMode = .native
    
    var body: some View {
        VStack(spacing: 16) {
            header
            content
            
            Spacer(minLength: 0)
        }
        .padding(.horizontal)
        .navigationTitle(item.title)
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private var header: some View {
        Picker("Mode", selection: $viewMode) {
            ForEach(UnifiedDetailViewMode.allCases, id: \.self) { mode in
                Text(mode.rawValue)
            }
        }
        .pickerStyle(.segmented)
    }
    
    @ViewBuilder
    private var content: some View {
        switch viewMode {
        case .native:
            FlickrDetailView(item: item)
        case .html:
            HTMLText(html: item.description)
        }
    }
}

fileprivate enum UnifiedDetailViewMode: String, CaseIterable {
    case native = "Native"
    case html = "HTML"
}
