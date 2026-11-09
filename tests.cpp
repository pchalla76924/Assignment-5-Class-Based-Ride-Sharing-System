#define main rides_demo_main
#include "main.cpp"
#undef main
#include <cassert>
#include <limits>

template<class F> void rejects(F action) {
    bool rejected = false;
    try { action(); } catch (const std::invalid_argument&) { rejected = true; }
    assert(rejected);
}
int main() {
    auto standard = std::make_shared<StandardRide>(1, "A", "B", 5);
    auto premium = std::make_shared<PremiumRide>(2, "A", "B", 8);
    std::vector<std::shared_ptr<Ride>> mixed{standard, premium};
    assert(mixed[0]->fare() == 13.0 && mixed[1]->fare() == 35.0);
    assert(StandardRide(3, "A", "B", 0).fare() == 3.0);
    assert(PremiumRide(4, "A", "B", 0).fare() == 7.0);
    Driver driver(7, "Alex", 4.9);
    Rider rider(21, "Jordan");
    assert(driver.rideCount() == 0 && rider.rideCount() == 0);
    assert(driver.totalEarnings() == 0);
    for (auto ride : mixed) { driver.addRide(ride); rider.requestRide(ride); }
    assert(driver.rideCount() == 2 && rider.rideCount() == 2);
    assert(driver.totalEarnings() == 48.0);
    rejects([] { StandardRide bad(1, "A", "B", -1); });
    rejects([] { StandardRide bad(1, "A", "B", std::numeric_limits<double>::quiet_NaN()); });
    rejects([] { StandardRide bad(1, "A", "B", std::numeric_limits<double>::infinity()); });
    rejects([] { Driver bad(1, "Alex", 6); });
    rejects([] { Driver bad(1, "Alex", -1); });
    rejects([] { Driver bad(1, "Alex", std::numeric_limits<double>::quiet_NaN()); });
    rejects([&] { driver.addRide(nullptr); });
    rejects([&] { rider.requestRide(nullptr); });
    std::cout << "PASS: pricing, mixed dispatch, zero distance, histories, earnings,\n"
              << "      negative/nonfinite inputs, rating bounds, and null rides.\n";
}
