------------- *Autonomous Vehicle Simulation* -----------------

- Instituto Superiror Técnico - Robotics Course - 2021/22 (P2)
- Lab 2

-   João Luzio  - 93096 - joaoluzio14@tecnico.ulisboa.pt
- Marcelo Forte - 93125 - marcelojsforte@tecnico.ulisboa.pt
- Filipe Ferraz - 93771 - filipe.ferraz@tecnico.ulisboa.pt

---------------------------------------------------------------

------------------------ *Disclamer* --------------------------

1. - MATLAB Version R2021a is mandatory.
     https://www.mathworks.com/products/matlab.html

2. - Energy Minimazation implementation requires CVX software.
     http://cvxr.com/cvx

---------------------------------------------------------------

-------------------------- *Usage* ----------------------------

1. - Open file 'AutonomousVehicle.m' using MATLAB R2021a.

2. - At the top of this file, there are some parameters that
     can be edited/costumized:

     B - Energy Budget (in Joule)

     P0 - Car idle state energy consumption (in Joule)

     lambda - Energy Optimization regularization parameter

     MinimalEnergy - Compute Minimal Energy path details by
     solving an optimization problem (true or false).
     Only select 'true' if CVX software is installed.

3. - Run/Execute file 'AutonomousVehicle.m'.

4. - Once IST Campus Map opens use the left button of the mouse
     in order to select the starting point, and then use the 
     right button to select the final point of the trajectory.
     (If this step is not respected, the script may crash)

5. - The car movement, in real time, should be ploted.
     If a figure window that presents this does not pop, check
     the MATLAB command window for more details.

6. - In MATLAB's command window informations about energy
     consumption, time spent and collisions will be displayed.

---------------------------------------------------------------