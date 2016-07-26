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
 
 In order to utilize presence, you must add an object as a listener to your PubNub client instance. Below, the `PubNubPresence` class can be added as a listener to a PubNub client instance using the `addListener()` method in the initializer by passing in `self`. Next, you must subscribe to a channel and set `withPresence:` to `true`. Each PubNub channel has an associated Presence channel, setting `withPresence:` to `true` will subscribe the client instance to the channel's associated Presence channel. Once you have done both of these things, you can receive presence events with the `client(_:didReceivePresenceEvent:)` PubNub callback function. If the event wasn't a state-change, you will see the `print()` statement print out the uuid, presence event, time token, name of the channel the message is coming from and the current number of users subscribed to the channel. Otherwise, you will see the `print()` statement print out the uuid, time token, name of the channel and the changed client state.
 */


class PubNubPresence: NSObject, PNObjectEventListener {
    let client: PubNub
    let publishChannel: String
    
    required init(publishChannel: String) {
        // set client before the first phase of initialization ends
        client = createPubNubClientInstance("pub-c-63c972fb-df4e-47f7-82da-e659e28f7cb7", subscribeKey: "sub-c-28786a2e-31a3-11e6-be83-0619f8945a4f")
        self.publishChannel = publishChannel
        super.init()
        client.addListener(self)
        // add subscription with presence set to 'true' during phase two of initialization

        client.subscribeToChannels([self.publishChannel], withPresence: true)
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
            guard let uuid = event.data.presence.uuid else {
                print("No uuid")
                return
            }
            print("\(uuid) \(event.data.presenceEvent)ed " +
                "at: \(event.data.presence.timetoken) " +
                "on \((event.data.actualChannel ?? event.data.subscribedChannel)!) " +
                "(Occupancy: \(event.data.presence.occupancy))")
        } else {
            guard let uuid = event.data.presence.uuid else {
                print("No uuid")
                return
            }
            print("\(uuid) changed state at: " +
                "\(event.data.presence.timetoken) " +
                "on \(event.data.actualChannel ?? event.data.subscribedChannel) to: " +
                "\(event.data.presence.state)")
        }
        //Only needed when running in playground
        XCPlaygroundPage.currentPage.finishExecution()
    }
}

let presence = PubNubPresence(publishChannel: "my_channel")
