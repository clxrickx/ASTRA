# ASTRA
ASTRA(Autonomously Stabilized Thrust-to-Recovery Apparatus) is a self-landing stormworks rocket coded in stormworks Lua.

## ARCHITECTURE
ASTRA's architecture consists of 3 microcontrollers; one main controller which analyzes live data(similar to an outer loop in traditional O/I loop TVC architecture), and two sub-controllers, which analyze formatted data from the main controller and output TVC rotations and thrust, respectively.

**Main Controller:** The main controller takes the radio altimeter altitude(which is mounted parllel to the airframe so that it points straight down), x and y cartesian coordinates from the GPS module, and azimuth and zenith rotations from the gyroscope module. By pre-formatting the values, we can reduce unesscecary overhead in the sub-controllers(inner loop controllers). Stage is also calculated from these values at this stage and are used as init guards in both sub-controllers.