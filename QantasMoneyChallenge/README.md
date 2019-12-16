#  QantasMoneyChallenge - Micah Napier
Thank you for the opportunity to do this coding challenge. It was fun!

## Approach


### Client 
A client was introduced that will assume the responsibility of making network requests to the backend API. To improve on client design having given more time
A mechanism could be created to better manage the URLs by making them configurable so the client can easily change URLs if need be. For now the URLs are just hardcoded in the client.

### Service
A service was introduced with a protocol oriented approach that enables functionality the service to make account and transaction web requests. This makes the service flexible and able to easily extend functionality

### Coordinator
The coordinator pattern was used to manage the flow of the account / transaction screens. This allows the flow and order of view controllers to be easily managed without view controllers
Having to know anything about other view controllers they will be in a flow with.



## Having more time
Unfortunately some thing had to get rushed together given I did not have a lot of time to do the coding challenge. If more time allowed the following things would've been addressed: 

### Caching 
The app currently makes a web call everytime an account cell is tapped. It could be possible to cache the response for a certain amount of time to avoid hammering the backend

### Better data flow
Dependency injection is being used to inject a service capable of making web requests into the view controller. To further reduce view controller responsibilites, a publish / subscribe model 
could be a good fit to where the client publishes data that the view controller cares about. The combine framework accomplishses this task nicely. I decided against using this due to time constaints
and the fact that the feature is 1OS 13+ so wouldn't be widely prevalent in the industry at the moment.

### Loading indication
The screens are just blank until they aren't at the moment. To save on time I decided to leave out a loading indication mechanism.

### Data massaging 
There could always be more time allotted to making data display nicer. Time stamps and currencies as well as using enum coding keys for properties that have underscores and other bits of data would get a makeover if given more time.

### Error handling 
The app is currently not very helpful with errors given it is a coding challenge however if given more time I would create an Enum for errors that would properly catch and distinguish errors and
perhaps even surface to the user. 

### Use of view models
Rather than having the transaction detail view controller knowing about business logic, I would create a view model that would manage the strings rather than throwing everything in the view controller.
The section logic for the transaction view controller could be put in a view model as well to reduce vc complexity. It would also allow for unit testing of the sorting logic.

### Unit tests
Unit tests verifying the sorting and that a group of transactions match specific dates would have been included given more time. Snapshot verification tests would be beneficial to verifiy state.

