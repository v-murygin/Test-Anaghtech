//
//  HTMLText.swift
//  TestAnaghtech
//
//  Created by Vladislav Murygin on 2/12/25.
//


import SwiftUI

struct HTMLText: View {

    let html: String

    var body: some View {
        GeometryReader { geometry in
            HTMLTextView(html: html, containerWidth: geometry.size.width)
        }
    }
}

private struct HTMLTextView: UIViewRepresentable {

    let html: String
    let containerWidth: CGFloat

    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()

        textView.backgroundColor = .clear
        textView.isEditable = false
        textView.isSelectable = true
        textView.isScrollEnabled = false

        textView.textContainerInset = .zero
        textView.textContainer.lineFragmentPadding = 0
        textView.textContainer.widthTracksTextView = true
        textView.textContainer.lineBreakMode = .byWordWrapping

        textView.setContentHuggingPriority(.required, for: .vertical)
        textView.setContentCompressionResistancePriority(.required, for: .vertical)

        return textView
    }

    func updateUIView(_ uiView: UITextView, context: Context) {
        if context.coordinator.lastHtml != html {
            context.coordinator.lastHtml = html
            uiView.attributedText = NSAttributedString.html(withBody: html)
        }

        uiView.frame.size.width = containerWidth

       
        let size = uiView.sizeThatFits(CGSize(width: containerWidth, height: .greatestFiniteMagnitude))
        
        uiView.frame.size.height = size.height
    }

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    final class Coordinator {
        var lastHtml: String?
    }
}
