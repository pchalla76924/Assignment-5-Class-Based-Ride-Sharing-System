#include <cmath>
#include <iomanip>
#include <iostream>
#include <memory>
#include <stdexcept>
#include <string>
#include <utility>
#include <vector>

class Ride {
private:
    int rideID_;
    std::string pickupLocation_, dropoffLocation_;
    double distance_;
    mutable double fare_ = 0.0;
protected:
    void setFare(double amount) const { fare_ = amount; }
public:
    Ride(int id, std::string pickup, std::string dropoff, double miles)
        : rideID_(id), pickupLocation_(std::move(pickup)),
          dropoffLocation_(std::move(dropoff)), distance_(miles) {
        if (!std::isfinite(miles) || miles < 0) throw std::invalid_argument("Distance must be finite and nonnegative");
    }
    virtual ~Ride() = default;
    double distance() const { return distance_; }
    virtual std::string type() const { return "Base"; }
    virtual double fare() const {
        setFare(2.0 + 1.5 * distance_);
        return fare_;
    }
    virtual void rideDetails() const {
        std::cout << type() << " ride #" << rideID_ << ": "
                  << pickupLocation_ << " -> " << dropoffLocation_
                  << ", " << distance_ << " miles, fare $" << fare() << '\n';
    }
};

class StandardRide : public Ride {
public:
    using Ride::Ride;
    std::string type() const override { return "Standard"; }
    double fare() const override {
        double amount = 3.0 + 2.0 * distance();
        setFare(amount);
        return amount;
    }
};

class PremiumRide : public Ride {
public:
    using Ride::Ride;
    std::string type() const override { return "Premium"; }
    double fare() const override {
        double amount = 7.0 + 3.5 * distance();
        setFare(amount);
        return amount;
    }
};

class Driver {
private:
    int driverID_;
    std::string name_;
    double rating_;
    std::vector<std::shared_ptr<Ride>> assignedRides_;
public:
    Driver(int id, std::string name, double rating)
        : driverID_(id), name_(std::move(name)), rating_(rating) {
        if (!std::isfinite(rating) || rating < 0 || rating > 5)
            throw std::invalid_argument("Rating must be between 0 and 5");
    }
    void addRide(const std::shared_ptr<Ride>& ride) {
        if (!ride) throw std::invalid_argument("Ride cannot be null");
        assignedRides_.push_back(ride);
    }
    std::size_t rideCount() const { return assignedRides_.size(); }
    double totalEarnings() const {
        double total = 0.0;
        for (const auto& ride : assignedRides_) total += ride->fare();
        return total;
    }
    void getDriverInfo() const {
        std::cout << "Driver #" << driverID_ << ": " << name_
                  << ", rating " << rating_ << ", completed rides "
                  << assignedRides_.size() << '\n';
    }
};

class Rider {
private:
    int riderID_;
    std::string name_;
    std::vector<std::shared_ptr<Ride>> requestedRides_;
public:
    Rider(int id, std::string name)
        : riderID_(id), name_(std::move(name)) {}
    void requestRide(const std::shared_ptr<Ride>& ride) {
        if (!ride) throw std::invalid_argument("Ride cannot be null");
        requestedRides_.push_back(ride);
    }
    std::size_t rideCount() const { return requestedRides_.size(); }
    void viewRides() const {
        std::cout << "Rider #" << riderID_ << ": " << name_
                  << ", requested rides " << requestedRides_.size() << '\n';
        for (const auto& ride : requestedRides_) ride->rideDetails();
    }
};

int main() {
    std::cout << std::fixed << std::setprecision(2);
    std::vector<std::shared_ptr<Ride>> rides = {
        std::make_shared<StandardRide>(101, "Campus", "Library", 5.0),
        std::make_shared<PremiumRide>(102, "Airport", "Hotel", 8.0)
    };
    Driver driver(7, "Alex", 4.9);
    Rider rider(21, "Jordan");
    for (const auto& ride : rides) {
        rider.requestRide(ride);
        driver.addRide(ride);
        std::cout << "Calculated fare: $" << ride->fare() << '\n';
        ride->rideDetails(); // Calls through the shared Ride interface.
    }
    driver.getDriverInfo();
    std::cout << "Total earnings: $" << driver.totalEarnings() << '\n';
    rider.viewRides();
    return 0;
}
