<img width="2338" height="900" alt="astrac" src="https://github.com/user-attachments/assets/3e74ed0b-7ede-4447-b031-0e673ed0a3bf" />

# ASTRAC
ASTRAC(Autonomously Stabilized Thrust-to-Recovery Avionics Computer) is a self-landing stormworks TVC flight computer coded in stormworks Lua.

## ARCHITECTURE
ASTRAC's architecture consists of one single microcontroller which has three controller loops; one for data processing, and two for throttle and controlling the thrust vector control servos, respectively.

### **Main Controller:** 
The main controller loop takes data from the inertial measurement unit(physics sensor) and processes it, also calculating some other diagnostic telemetry units. By pre-formatting the values and outputting a filtered composite, we can reduce unnesscecary overhead in the sub-controllers(inner loop controllers) as well as reduce their size. Stages are also calculated from these values at this point and are used as init guards in both controller loops.

### **TVC Controller:**
The TVC controller loop takes control of the TVC mounts and servos, which are the only active guidance system that ASTRA uses(with passive guidance and stabilization systems like bottom and top mounted fins). The TVC controller uses a PID controller algorithm to control the vector mounts in the engine, therefore guiding the rocket. The TVC controller cannot be marginally stable; it must be fully stable as any sinuodial occillations will exponentially increase and lead to a crash.

### **Throttle Controller:**
The throttle controller loop controls the throttle input into the jet's combustion chamber, and uses the stage output from the main controller to set vertical speed setpoints, which is also taken from the main controller. The throttle controller, like the TVC controller, uses a PID controller to control the throttle.

# ADDITIONAL SYSTEMS(OPT):

### **base.xxx**
The ```base``` prefix on files signifies that the attached file is for the base station. The base station recieves telemetry from the rocket through a high-range antenna which projects all written composite values from ```astrac.lua``` to the base station, where it is then projected onto two screens(which are powered by scripts primary.lua and secondary.lua, repectively).