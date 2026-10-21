<img width="2338" height="900" alt="astrac" src="https://github.com/user-attachments/assets/3e74ed0b-7ede-4447-b031-0e673ed0a3bf" />

# [ASTRAC]([url](https://youtu.be/Ydh8ZOWIW-U))
ASTRAC(Autonomously Stabilized Thrust-to-Recovery Avionics Computer) is a self-landing stormworks TVC flight computer coded in stormworks Lua.
Showcase: [https://youtu.be/Ydh8ZOWIW-U](url)

## ARCHITECTURE
ASTRAC's architecture consists of one single microcontroller which has three controller loops; one for data processing, and two for throttle and controlling the thrust vector control servos, respectively.

### **Main Controller:** 
The main controller loop takes data from the inertial measurement unit(physics sensor) and processes it, also calculating some other diagnostic telemetry units. By pre-formatting the values and outputting a filtered composite, we can reduce unnesscecary overhead in the sub-controllers(inner loop controllers) as well as reduce their size. Stages are also calculated from these values at this point and are used as init guards in both controller loops.

### **TVC Controller:**
The TVC controller loop takes control of the TVC mounts and servos, which are the only active guidance system that ASTRA uses(with passive guidance and stabilization systems like bottom and top mounted fins). The TVC controller uses a PID controller algorithm to control the vector mounts in the engine, therefore guiding the rocket. The TVC controller cannot be marginally stable; it must be fully stable as any sinuodial occillations will exponentially increase and lead to a crash.

### **Throttle Controller:**
The throttle controller loop controls the throttle input into the jet's combustion chamber, and uses the stage output from the main controller to set vertical speed setpoints, which is also taken from the main controller. The throttle controller, like the TVC controller, uses a PID controller to control the throttle.

## TUNING
Tuning ASTRAC to your own TVC rocket is rather simple if you can read some basic code. There are and will not be a huge list of variables at the top of ASTRAC.lua with all the tunable parameters. It is up to you to see where parameters should be changed and what parameters should not. If you need help, reach out. Please note that all parameters are currently tuned to ASTRA, and you will probably need to tune everything for your own rocket.

### PID Tuning
ASTRAC hosts three PID loops, one for the throttle and two for each axis/DoF of the TVC(x and z axes). The argument for each is ```(setpoint, processed_variable, Kp, Ki, Kd)```. You should not touch ```setpoint``` or ```processed_variable``` unless you know what you are doing. Kp, Ki, and Kd are the constants for the proportional term, integral term, and derivative term.

### Target Altitude/Stages
ASTRAC computes target altitudes through the staging system. By changing the arugments on when a stage's conditions are met, you can effectively change the length of each stage, and therefore, your maximum altitude, restricted only by your rocket's capabilities. (L96-122)

### Climb/Descent Vertical Speeds
ASTRAC computes climb and descent thrusts based on a target vertical speed in feet per minute. These values can be changed for each stage. (L126-138)