import SwiftUI

struct NavigationConfigurator: UIViewControllerRepresentable {
  let configure: (UINavigationController) -> Void

  func makeUIViewController(context: Context) -> UIViewController {
    UIViewController()
  }

  func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
    if let nc = uiViewController.navigationController {
      configure(nc)
    }
  }
}
