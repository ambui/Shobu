//
//  ChatService.swift
//  Chat1

//  Class that uses Multipeer Connectivity to form a chatroom with users on the same network
//
//

import Foundation
import MultipeerConnectivity

protocol ChatServiceDelegate {
    
    func connectedDevicesChanged(_ manager: ChatService, connectedDevices: [String])
    func messageReceived(_ manager: ChatService, message: String)
    
}


class ChatService: NSObject {
    
    let chatServiceType = "chat-ame"
    let myPeerId = MCPeerID(displayName: UIDevice.current.name)
    let serviceAdvertiser : MCNearbyServiceAdvertiser
    let serviceBrowser: MCNearbyServiceBrowser
    var delegate : ChatServiceDelegate?
    
    override init() {
        self.serviceAdvertiser = MCNearbyServiceAdvertiser(peer: myPeerId, discoveryInfo: nil, serviceType: chatServiceType)
        self.serviceBrowser = MCNearbyServiceBrowser(peer: myPeerId, serviceType: chatServiceType)
        
        super.init()
        
        self.serviceAdvertiser.delegate = self
        self.serviceAdvertiser.startAdvertisingPeer()
        
        self.serviceBrowser.delegate = self
        self.serviceBrowser.startBrowsingForPeers()
    }
    
    deinit {
        print("ChatService deinit")
        self.serviceAdvertiser.stopAdvertisingPeer()
        self.serviceBrowser.stopBrowsingForPeers()
    }
    
    lazy var session: MCSession = {
        let session = MCSession(peer: self.myPeerId, securityIdentity: nil, encryptionPreference: MCEncryptionPreference.optional)
        session.delegate = self
        return session
    }()
    
    
    func sendMessage( _ message: String ) {
        if session.connectedPeers.count > 0 {
            do {
                try self.session.send(message.data(using: String.Encoding.utf8, allowLossyConversion: false)!, toPeers: session.connectedPeers, with: MCSessionSendDataMode.reliable)
            } catch let error as NSError {
                print("\(error)")
            }
        }
    }
    
    func disconnect() {
        self.session.disconnect()
        print("discon")
    }

}

extension ChatService : MCNearbyServiceAdvertiserDelegate {
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
        print("didNotStartAdvertisingPeer: \(error)")
    }
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        print("didReceiveInvitationFromPeer \(peerID)")
        invitationHandler(true, self.session)
    }
    
}

extension ChatService : MCNearbyServiceBrowserDelegate {
    
    func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {
        print("didNotStartBrowsingForPeers: \(error)")
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        print("foundPeer: \(peerID.displayName)")
        print("invitePeer: \(peerID.displayName)")
        browser.invitePeer(peerID, to: self.session, withContext: nil, timeout: 20)
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        print("lostPeer: \(peerID.displayName)")
        self.delegate?.connectedDevicesChanged(self, connectedDevices: session.connectedPeers.map({$0.displayName}))
    }
    
}

extension MCSessionState {
    
    func stringValue() -> String {
        switch(self) {
        case .notConnected: return "NotConnected"
        case .connecting: return "Connecting"
        case .connected: return "Connected"
        }
    }
    
}

extension ChatService : MCSessionDelegate {
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        print("peer \(peerID) didChangeState: \(state.stringValue())")
        if state == .notConnected {
            print("retry invitePeer")
            serviceBrowser.invitePeer(peerID, to: self.session, withContext: nil, timeout: 20)
        }
        else {
            serviceBrowser.stopBrowsingForPeers()
            print("connectedDevicesChanged")
            self.delegate?.connectedDevicesChanged(self, connectedDevices: session.connectedPeers.map({$0.displayName}))
            
        }
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        let str = NSString(data: data, encoding: String.Encoding.utf8.rawValue) as! String
        print("received from \(peerID.displayName): \(str)")
        self.delegate?.messageReceived(self, message: "\(str)")

    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        print("didReceiveStream")
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        print("didFinishReceivingResourceWithName")
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        print("didStartReceivingResourceWithName")
    }
    
}



