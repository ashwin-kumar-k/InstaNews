//
//  SafariView.swift
//  News
//
//  Created by Ashwin Kumar on 14/03/24.
//

import SwiftUI
import SafariServices

// SwiftUI view for displaying a SafariViewController
struct SafariView: UIViewControllerRepresentable {
    let url : URL // URL to load in SafariViewController
    
    // Function to create SafariViewController
    func makeUIViewController(context: Context) -> some UIViewController {
        return SFSafariViewController(url: url) // Initialize and return SafariViewController with given URL
    }
    
    // Function to update SafariViewController
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        // No update needed
    }
}
