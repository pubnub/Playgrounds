//: [Previous](@previous)
import Foundation
import PubNub
import XCPlayground
XCPlaygroundPage.currentPage.needsIndefiniteExecution = true

//Function used to intialize a PubNub client instance
func createPubNubClientInstance(publishKey: String!, subscribeKey: String!) -> PubNub {
    let createdConfig = PNConfiguration(publishKey: publishKey, subscribeKey: subscribeKey)
    return PubNub.clientWithConfiguration(createdConfig)
}
/*:
 ## Presence
 
 Presence is used to track online and offline status of users and devices in realtime.
 
 ### Basic Usage
 
 In order to utilize presence, you must add an object as a listener to your PubNub client instance. Below, the `PubNubPresence` class can be added as a listener to a PubNub client instance using the `addListener()` method in the initializer by passing in `self`. Next, you must subscribe to a channel and set `withPresence:` to `true`. Each PubNub channel has an associated Presence channel, setting `withPresence:` to `true` will subscribe the client instance to the channel's associated Presence channel. Once you have done both of these things, you can receive presence events with the `client(_:didReceivePresenceEvent:)` PubNub callback function.
 
 ### Try it out
 To see this in action, open the assistant editor (Option + Command + Enter). The bottom view outlined in white, is a button. Pressing it will subscribe or unsubscribe the `presenceEventManipulator` object in the `PubNubPresenceViewController` class, from the current channel. As you subscribe and unsubscribe from this channel, the `client(_:didReceivePresenceEvent:)` PubNub callback function will be called. If the event wasn't a state-change, you will see the the top view display the number of users subscribed to the channel and the middle view display the type of event along with the time token the event occurred at. Try it out by pressing the button!
 */

class PubNubPresenceViewController: UIViewController, PNObjectEventListener {
    let client: PubNub
    let channel: String
    
    let occupancyLabel: UILabel
    let presenceEventLabel: UILabel
    let submitPresenceEventButton: UIButton
    
    let presenceEventManipulator: PresenceEventManipulator
    
    required init(channel: String) {
        // set client before the first phase of initialization ends
        client = createPubNubClientInstance("pub-c-63c972fb-df4e-47f7-82da-e659e28f7cb7", subscribeKey: "sub-c-28786a2e-31a3-11e6-be83-0619f8945a4f")
        self.channel = channel
        
        occupancyLabel = UILabel(frame: CGRect(x: 90, y: 250, width: 200, height: 50))
        presenceEventLabel = UILabel(frame: CGRect(x: 65, y: 310, width: 250, height: 100))
        submitPresenceEventButton = UIButton(frame: CGRect(x: 120, y: 420, width: 150, height: 50))
        presenceEventManipulator = PresenceEventManipulator()
        
        super.init(nibName: nil, bundle: nil)
        client.addListener(self)
        // add subscription with presence set to 'true' during phase two of initialization
        client.subscribeToChannels([self.channel], withPresence: true)
        
        occupancyLabel.layer.borderWidth = 2
        occupancyLabel.layer.cornerRadius = 5
        occupancyLabel.textAlignment = .Center
        occupancyLabel.textColor = UIColor.whiteColor()
        self.view.addSubview(occupancyLabel)
        
        presenceEventLabel.layer.borderWidth = 2
        presenceEventLabel.layer.cornerRadius = 5
        presenceEventLabel.textAlignment = .Center
        presenceEventLabel.numberOfLines = 3
        presenceEventLabel.textColor = UIColor.whiteColor()
        self.view.addSubview(presenceEventLabel)
        
        submitPresenceEventButton.layer.borderWidth = 2
        submitPresenceEventButton.layer.cornerRadius = 5
        submitPresenceEventButton.addTarget(self, action: #selector(submitPresenceEvent), forControlEvents: .TouchUpInside)
        submitPresenceEventButton.setTitle("Add user", forState: .Normal)
        submitPresenceEventButton.layer.borderColor = UIColor.whiteColor().CGColor
        self.view.addSubview(submitPresenceEventButton)
        self.view.backgroundColor = UIColor(red: 192/255, green: 57/255, blue: 43/255, alpha: 1)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // New presence event handling.
    func client(client: PubNub, didReceivePresenceEvent event: PNPresenceEventResult) {
        // Handle presence event event.data.presenceEvent (one of: join, leave, timeout,
        // state-change).
        if event.data.actualChannel != nil {
            
            // Presence event has been received on channel group stored in
            // event.data.subscribedChannel
        }
        else {
            
            // Presence event has been received on channel stored in
            // event.data.subscribedChannel
        }
        
        if event.data.presenceEvent != "state-change" {
            occupancyLabel.text = "Occupancy: \(event.data.presence.occupancy)"
            presenceEventLabel.text = "\(event.data.presenceEvent) event at: \(event.data.presence.timetoken)"
        }
    }
    
    //Subscribe or unsubscribe the presenceEventManipulator object
    //from the current channel
    func submitPresenceEvent(sender: UIButton) {
        if sender.titleLabel?.text == "Add user" {
            presenceEventManipulator.joinChannel(self.channel)
            sender.setTitle("Remove user", forState: .Normal)
        } else {
            presenceEventManipulator.leaveChannel(self.channel)
            sender.setTitle("Add user", forState: .Normal)
        }
    }
}

class PresenceEventManipulator: NSObject {
    let client: PubNub
    
    required override init() {
        self.client = createPubNubClientInstance("pub-c-63c972fb-df4e-47f7-82da-e659e28f7cb7", subscribeKey: "sub-c-28786a2e-31a3-11e6-be83-0619f8945a4f")
        super.init()
    }
    
    func joinChannel(channel: String) {
        client.subscribeToChannels([channel], withPresence: true)
    }
    
    func leaveChannel(channel: String) {
        client.unsubscribeFromChannels([channel], withPresence: true)
    }
}

let pubNubPresenceVC = PubNubPresenceViewController(channel: "my_channel")
XCPlaygroundPage.currentPage.liveView = pubNubPresenceVC






















