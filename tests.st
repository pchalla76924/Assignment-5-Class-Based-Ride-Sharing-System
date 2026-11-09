| check rejects standard premium mixed driver rider |
check := [:condition | condition ifFalse: [self error: 'Assertion failed']].
rejects := [:action | | caught |
    caught := false.
    [action value] on: Error do: [:error | caught := true].
    check value: caught].
standard := StandardRide new initializeID: 1 pickup: 'A' dropoff: 'B' distance: 5.
premium := PremiumRide new initializeID: 2 pickup: 'A' dropoff: 'B' distance: 8.
mixed := OrderedCollection with: standard with: premium.
check value: (mixed first fare = 13).
check value: (mixed last fare = 35).
check value: ((StandardRide new initializeID: 3 pickup: 'A' dropoff: 'B' distance: 0) fare = 3).
check value: ((PremiumRide new initializeID: 4 pickup: 'A' dropoff: 'B' distance: 0) fare = 7).
driver := Driver new initializeID: 7 name: 'Alex' rating: 4.9s1.
rider := Rider new initializeID: 21 name: 'Jordan'.
check value: (driver rideCount = 0 and: [rider rideCount = 0]).
check value: (driver totalEarnings = 0).
mixed do: [:ride | driver addRide: ride. rider requestRide: ride].
check value: (driver rideCount = 2 and: [rider rideCount = 2]).
check value: (driver totalEarnings = 48).
rejects value: [StandardRide new initializeID: 1 pickup: 'A' dropoff: 'B' distance: -1].
rejects value: [StandardRide new initializeID: 1 pickup: 'A' dropoff: 'B' distance: 'five'].
rejects value: [Driver new initializeID: 1 name: 'Alex' rating: -1].
rejects value: [Driver new initializeID: 1 name: 'Alex' rating: 6].
rejects value: [driver addRide: nil].
rejects value: [rider requestRide: nil].
rejects value: [driver addRide: 'not a ride'].
Transcript show: 'PASS: pricing, mixed dispatch, zero distance, histories, earnings,'; cr;
    show: '      negative/nonnumeric inputs, rating bounds, and invalid rides.'; cr!
