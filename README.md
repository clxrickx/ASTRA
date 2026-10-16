# ASTRA
ASTRA(Autonomously Stabilized Thrust-to-Recovery Apparatus) is a self-landing stormworks rocket coded in stormworks Lua.

## ARCHITECTURE
ASTRA's architecture consists of 3 microcontrollers; one main controller which analyzes live data(similar to an outer loop in traditional O/I loop TVC architecture), and two sub-controllers, which analyze formatted data from the main controller and output TVC rotations and thrust, respectively.

### **Main Controller:** 
The main controller takes the radio altimeter altitude(which is mounted parllel to the airframe so that it points straight down), x, y, and z cartesian coordinates, as well as orientation and vertical speed from the physics module. By pre-formatting the values and outputting a filtered composite, we can reduce unnesscecary overhead in the sub-controllers(inner loop controllers) as well as reduce their size. Stages are also calculated from these values at this point and are used as init guards in both sub-controllers.

### **TVC Controller:**
The TVC controller takes control of the TVC mounts and servos, which are the only active guidance system that ASTRA uses(with passive guidance and stabilization systems like bottom and top mounted fins). The TVC controller uses a PID controller algorithm to control the vector mounts in the engine, therefore guiding the rocket. The TVC controller cannot be marginally stable; it must be fully stable as any sinuodial occillations will exponentially increase and lead to a crash.
