Object subclass: #Ride
    instanceVariableNames: 'rideID pickupLocation dropoffLocation distance fare'
    classVariableNames: ''
    poolDictionaries: ''
    category: 'RideSharing'!

!Ride methodsFor: 'initialization'!
initializeID: anID pickup: aPickup dropoff: aDropoff distance: miles
    ((miles isKindOf: Number) and: [miles isFinite and: [miles >= 0]])
        ifFalse: [self error: 'Distance must be finite and nonnegative'].
    rideID := anID.
    pickupLocation := aPickup.
    dropoffLocation := aDropoff.
    distance := miles.
    fare := 0.
    ^self
!!

!Ride methodsFor: 'accessing'!
distance
    ^distance
!
fare
    fare := 2 + (1.5s1 * distance).
    ^fare
!
rideType
    ^'Base'
!
rideDetails
    Transcript show: self rideType; show: ' ride #'; show: rideID printString;
        show: ': '; show: pickupLocation; show: ' -> '; show: dropoffLocation;
        show: ', '; show: distance printString; show: ' miles, fare $';
        show: (self fare printString copyUpTo: $s); cr
!!

Ride subclass: #StandardRide
    instanceVariableNames: ''
    classVariableNames: ''
    poolDictionaries: ''
    category: 'RideSharing'!

!StandardRide methodsFor: 'pricing'!
rideType
    ^'Standard'
!
fare
    fare := 3 + (2 * distance).
    ^fare
!!

Ride subclass: #PremiumRide
    instanceVariableNames: ''
    classVariableNames: ''
    poolDictionaries: ''
    category: 'RideSharing'!

!PremiumRide methodsFor: 'pricing'!
rideType
    ^'Premium'
!
fare
    fare := 7 + (3.5s1 * distance).
    ^fare
!!

Object subclass: #Driver
    instanceVariableNames: 'driverID name rating assignedRides'
    classVariableNames: ''
    poolDictionaries: ''
    category: 'RideSharing'!

!Driver methodsFor: 'initialization'!
initializeID: anID name: aName rating: aRating
    ((aRating isKindOf: Number) and: [aRating isFinite and: [
        aRating >= 0 and: [aRating <= 5]]])
        ifFalse: [self error: 'Rating must be between 0 and 5'].
    driverID := anID. name := aName. rating := aRating.
    assignedRides := OrderedCollection new.
    ^self
!!

!Driver methodsFor: 'rides'!
addRide: aRide
    (aRide isKindOf: Ride) ifFalse: [self error: 'A Ride is required'].
    assignedRides add: aRide
!
rideCount
    ^assignedRides size
!
totalEarnings
    ^assignedRides inject: 0 into: [:total :each | total + each fare]
!
getDriverInfo
    Transcript show: 'Driver #'; show: driverID printString; show: ': ';
        show: name; show: ', rating '; show: (rating printString copyUpTo: $s);
        show: ', completed rides '; show: assignedRides size printString; cr
!!

Object subclass: #Rider
    instanceVariableNames: 'riderID name requestedRides'
    classVariableNames: ''
    poolDictionaries: ''
    category: 'RideSharing'!

!Rider methodsFor: 'initialization'!
initializeID: anID name: aName
    riderID := anID. name := aName.
    requestedRides := OrderedCollection new.
    ^self
!!

!Rider methodsFor: 'rides'!
requestRide: aRide
    (aRide isKindOf: Ride) ifFalse: [self error: 'A Ride is required'].
    requestedRides add: aRide
!
rideCount
    ^requestedRides size
!
viewRides
    Transcript show: 'Rider #'; show: riderID printString; show: ': ';
        show: name; show: ', requested rides ';
        show: requestedRides size printString; cr.
    requestedRides do: [:each | each rideDetails]
!!

| rides driver rider |
rides := OrderedCollection new.
rides add: (StandardRide new initializeID: 101 pickup: 'Campus'
    dropoff: 'Library' distance: 5).
rides add: (PremiumRide new initializeID: 102 pickup: 'Airport'
    dropoff: 'Hotel' distance: 8).
driver := Driver new initializeID: 7 name: 'Alex' rating: 4.9s1.
rider := Rider new initializeID: 21 name: 'Jordan'.
rides do: [:each |
    rider requestRide: each.
    driver addRide: each.
    Transcript show: 'Calculated fare: $'; show: (each fare printString copyUpTo: $s); cr.
    each rideDetails].
driver getDriverInfo.
Transcript show: 'Total earnings: $'; show: (driver totalEarnings printString copyUpTo: $s); cr.
rider viewRides!
