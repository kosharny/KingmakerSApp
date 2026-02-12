import SwiftUI
import AppTrackingTransparency
import AdSupport

@main
struct KingmakerSApp: App {
    var body: some Scene {
        WindowGroup {
            MainViewKS()
                .environmentObject(ViewModelKS())
                .onAppear(perform: requestDataTracking)
        }
    }
    
    func requestDataTracking() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            ATTrackingManager.requestTrackingAuthorization { status in
                switch status {
                case .authorized:
                    print("Tracking Authorized")
                case .denied:
                    print("Tracking Denied")
                case .notDetermined:
                    print("Tracking Not Determined")
                case .restricted:
                    print("Tracking Restricted")
                @unknown default:
                    print("Tracking Unknown")
                }
            }
        }
    }
}
