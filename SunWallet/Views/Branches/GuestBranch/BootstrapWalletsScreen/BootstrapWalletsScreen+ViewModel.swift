import Combine
import Foundation
import SwiftUI

extension BootstrapWalletsScreen {
    class ViewModel: ObservableObject {
        let objectWillChange = PassthroughSubject<Void, Never>()
        
        @Published
        var restoredMasterKeys: [MasterKey] = []
        
        @Published
        var error: String?
        
        @Published
        var useRestoreMasterKeys: Bool = false { didSet { objectWillChange.send() } }
                
        func restoreFromKeychain() {
            let masterKeys = WalletStore().loadMasterKeys(hint: "Restore previous Master Keys")
            if masterKeys.count > 0 {
                self.restoredMasterKeys = masterKeys
                self.useRestoreMasterKeys = true
            } else {
                self.error = "You don't have previously stored Master Keys"
            }
        }
        
        func newMasterKey() -> MasterKey {
            MasterKey()
        }
    }
}
