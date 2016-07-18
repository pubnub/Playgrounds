import UIKit
import XCPlayground
XCPlaygroundPage.currentPage.needsIndefiniteExecution = true
/*:
 # Getting Started with Swift and PubNub
 
 In this playground, you will run through the basics of utilizing the PubNub Swift SDK in your iOS project. You will learn about:
 - Configuring a PubNub client
 - Listening to a PubNub channel
 - Subscribing to a PubNub channel
 - Publishing to a PubNub channel
 - Receiving messages
 
 With these skills you'll be able to incorporate realtime functionality into your iOS applications.
 
 ---
 
 ## Configuring a PubNub client
 
 The first step to using PubNub is importing the framework:
 */
import PubNub

/*:
 In order to use PubNub features, you must create a PubNub client instance.
 In this step, replace the keys passed into the `PNConfiguration` constructor with your own respective publish and subscribe keys.
 */

let config = PNConfiguration(publishKey: "pub-c-63c972fb-df4e-47f7-82da-e659e28f7cb7", subscribeKey: "sub-c-28786a2e-31a3-11e6-be83-0619f8945a4f")
print("publish key: \(config.publishKey) and subscribe key: \(config.subscribeKey)")
let exampleClient = PubNub.clientWithConfiguration(config)

// now let's

// now let's make a func to create pubnub client instances
func createPubNubClientInstance(publishKey: String!, subscribeKey: String!) -> PubNub {
    let createdConfig = PNConfiguration(publishKey: "pub-c-63c972fb-df4e-47f7-82da-e659e28f7cb7", subscribeKey: "sub-c-28786a2e-31a3-11e6-be83-0619f8945a4f")
    return PubNub.clientWithConfiguration(createdConfig)
}

// show it works
print(createPubNubClientInstance("demo", subscribeKey: "demo"))

/*:
 Typically this goes in AppDelegate.swift. Here is an example:
 */

class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    lazy var client: PubNub = {
        let config = PNConfiguration(publishKey: "pub-c-63c972fb-df4e-47f7-82da-e659e28f7cb7", subscribeKey: "sub-c-28786a2e-31a3-11e6-be83-0619f8945a4f")
        let pub = PubNub.clientWithConfiguration(config)
        return pub
    }()
}

/*:
 > **Note:**
 The client variable is declared inside of the example classes below just so the PubNub methods can be demonstrated in the playground. It is still recommended as shown above, to declare it in the `AppDelegate` and access the client variable through the `AppDelegate` when you need it in other classes.
*/

/*:
 ## Publish
 
 You can publish to a channel with the `publish()` function. To publish a message you must first specify a valid publishKey at initialization. A successfully published message is replicated across the PubNub Real-Time Network and sent simultaneously to all subscribed clients on a channel.
 */

import PubNub

class PubNubPublisher: NSObject {
    let client: PubNub
    let publishChannel: String
    
    required init(publishChannel: String) {
        // set client before the first phase of initialization ends
        self.client = createPubNubClientInstance("pub-c-63c972fb-df4e-47f7-82da-e659e28f7cb7", subscribeKey: "sub-c-28786a2e-31a3-11e6-be83-0619f8945a4f")
        self.publishChannel = publishChannel
        super.init()
    }
    
    func publish(message: String?) {
        guard let publishString = message else {
            print("Nothing to publish")
            return
        }
        client.publish(publishString, toChannel: self.publishChannel, withCompletion: { (status) -> Void in
                        if status.error {
                            // Error publishing message to specified channel.
                            print("Error publishing message: \(publishString)")
                        } else {
                            // Handle message publish error. Check 'category' property
                            // to find out possible reason because of which request did fail.
                            // Review 'errorData' property (which has PNErrorData data type) of status
                            // object to get additional information about issue.
                            //
                            // Request can be resent using: status.retry()
                            print("Successful publish of message: \(publishString)")
                        }
        })
    }
}

let publisher = PubNubPublisher(publishChannel: "PlaygroundChannel")
publisher.publish("Hello from the PubNub Swift SDK!")
/*:
 Once a `PublishObject` instance is created, the client will publish a message to 'my_channel' and you can see in the playground whether the message successfully went through or failed with the print statement that is executed.
 */

/*:
 ## Subscribe & Listen
 
 ###Subscribe
 
 Let's go ahead and use the `subscribe()` function next. This function causes the client to create an open TCP socket to the PubNub Real-Time Network and begin listening for messages on a specified channel. To subscribe to a channel the client must send the appropriate subscribeKey at initialization.
 */

/*:
 ### Listen
 
 In order to receive messages from a channel, you must declare your current instance as a listener. Below, the `PubNubSubscriber` class becomes a listener using the `addListener()` method in the initializer by passing in `self`.
 > **Note:**
 Make sure to add the `PNObjectEventListener` protocol in your class declaration.
 */

/*:
 ### Receiving messages
 
Once you declare your current instance as a listener and are subscribed to a channel, you can receive messages with the `client(_:didReceiveMessage:)` PubNub callback function. Below we publish the message: "Hello from the PubNub Swift SDK!" to "PlaygroundChannel". If the message successfully went through, you're able to see that same message from the `print()` statement in the `client(_:didReceiveMessage:)` function.
 */

class PubNubSubscriber: PubNubPublisher, PNObjectEventListener {
    
    required init(publishChannel: String) {
        super.init(publishChannel: publishChannel)
        // add subscription during phase two of initialization
        client.addListener(self)
        client.subscribeToChannels([self.publishChannel], withPresence: false)
    }
    
    // Handle new message from one of channels on which client has been subscribed.
    func client(client: PubNub, didReceiveMessage message: PNMessageResult) {
        // Handle new message stored in message.data.message
        if message.data.actualChannel != nil {
            
            // Message has been received on channel group stored in
            // message.data.subscribedChannel
        }
        else {
            
            // Message has been received on channel stored in
            // message.data.subscribedChannel
        }
        
        // carefully unwrap message payload, it is an optional
        guard let receivedMessage = message.data.message else {
            print("No message payload received")
            return
        }
        
        print("Received message: \(receivedMessage) on channel " +
            "\((message.data.actualChannel ?? message.data.subscribedChannel)!) at " +
            "\(message.data.timetoken)")
        
        //Only needed when running in playground
        XCPlaygroundPage.currentPage.finishExecution()
    }
}

let subscriber = PubNubSubscriber(publishChannel: "PlaygroundChannel")

/*:
 
---
 
# Conclusion
 
Those are the basics to get you up and running with the PubNub Swift SDK. Check out the [PubNub Swift API reference guide](https://www.pubnub.com/docs/swift/api-reference#subscribe).
 */
