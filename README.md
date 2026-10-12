# Aircraft Flight Dynamics Simulator

## Overview

This project is a MATLAB-based aircraft flight dynamics simulator
developed to model and analyze the vertical/longitudinal response of an
aircraft under different initial conditions and elevator deflections.

The project combines basic aircraft aerodynamics, flight dynamics,
numerical simulation, parameter handling, and data visualization in a
modular MATLAB structure.

## Purpose

The main goal of the project is to simulate how an aircraft responds
over time to different initial airspeeds and elevator control inputs.

The simulator can be used to investigate quantities such as:

-   Altitude
-   Airspeed
-   Flight-path angle
-   Pitch angle
-   Angle of attack
-   Pitch rate

## Project Structure

### `main.m`

The main program controls the overall simulation workflow.

It handles:

-   Aircraft parameter selection
-   Custom parameter input
-   Initial-condition input
-   Initial airspeed selection
-   Elevator-deflection selection
-   Running the numerical simulations
-   Processing simulation results
-   Plotting the aircraft response
-   Interactive plot enlargement

### `aircraft_parameters.m`

Defines and returns the aircraft parameters as a single MATLAB `struct`.

The aircraft structure contains parameters such as:

-   Mass
-   Wing area
-   Lift-curve parameters
-   Drag coefficient
-   Air density
-   Gravitational acceleration
-   Thrust
-   Control-response parameters

Using a single structure makes it easier to pass and manage aircraft
properties throughout the project.

### `aerodynamic_calc.m`

Calculates the main aerodynamic quantities required by the simulation.

These include:

-   Dynamic pressure
-   Lift
-   Drag
-   Weight
-   Equilibrium airspeed

### `vertical_dynamics.m`

Contains the aircraft dynamic model used by the numerical solver.

The simulated state vector is:

``` text
[h, Va, gamma, theta, pitch_r]
```

where:

-   `h` = altitude
-   `Va` = airspeed
-   `gamma` = flight-path angle
-   `theta` = pitch angle
-   `pitch_r` = pitch rate

The angle of attack is calculated from:

``` text
alpha = theta - gamma
```

The equations are integrated numerically using MATLAB's `ode45` solver.

## Simulation Inputs

The simulator supports different initial conditions and control inputs.

### Initial Airspeed

Multiple initial airspeeds can be entered and simulated.

Each initial airspeed is represented by a separate row in the final
aircraft-state figure.

### Elevator Deflection

Multiple elevator deflections can also be entered.

Different elevator deflections are plotted as different curves within
each initial-airspeed row.

## Numerical Simulation

The aircraft dynamics are solved using MATLAB's `ode45` numerical
integration method.

For each combination of:

-   Initial airspeed
-   Elevator deflection

the simulator integrates the aircraft state equations over the selected
simulation time.

This allows the transient response of the aircraft to be compared under
different conditions.

## Visualization

The main aircraft-response figure uses a row-by-row structure.

For each initial airspeed, six state plots are displayed:

  Column   Quantity
  -------- -------------------
  1        Altitude
  2        Airspeed
  3        Flight-path angle
  4        Pitch angle
  5        Angle of attack
  6        Pitch rate

Different elevator deflections are represented by different plot colors.

The figure does not use large legends that obscure the plots. Instead,
the simulation cases are printed in the MATLAB Command Window.

## Interactive Plots

The aircraft-response figure includes interactive plot enlargement.

Clicking a subplot enlarges that individual plot so that its response
can be examined more easily.

Clicking the enlarged plot again restores the original multi-row,
six-column layout.

## Example Figure Layout

For three initial airspeeds, the figure is organized approximately as:

``` text
                    Altitude  Airspeed  Gamma  Theta  Alpha  Pitch Rate
Va0 = 45 m/s           [ ]       [ ]      [ ]    [ ]    [ ]      [ ]
Va0 = 50 m/s           [ ]       [ ]      [ ]    [ ]    [ ]      [ ]
Va0 = 55 m/s           [ ]       [ ]      [ ]    [ ]    [ ]      [ ]
```

Each `[ ]` represents a plot containing the responses for the selected
elevator-deflection values.

## Main MATLAB Concepts Demonstrated

This project demonstrates practical use of:

-   MATLAB scripts
-   MATLAB functions
-   Structures
-   Function inputs and outputs
-   Anonymous functions
-   `ode45`
-   Numerical integration
-   Loops
-   Conditional logic
-   Input validation
-   Vector and matrix operations
-   Plotting with `subplot`
-   Multiple curves on the same axes
-   Figure and axes properties
-   Graphics object handles
-   Callback functions
-   Interactive MATLAB figures

## Model Scope

This is an educational aircraft flight-dynamics model rather than a
high-fidelity aircraft simulator.

The aerodynamic and dynamic relationships are intentionally simplified
so that the project remains understandable and computationally
lightweight while demonstrating the fundamental concepts of aircraft
response and MATLAB simulation.

## How to Run

1.  Place all project files in the same MATLAB folder.
2.  Open MATLAB.
3.  Set the project folder as the current MATLAB working directory.
4.  Run:

``` matlab
main
```

5.  Select the desired aircraft parameters and simulation inputs.
6.  Enter the initial airspeeds and elevator deflections.
7.  Review the resulting aircraft-state plots.

## Project Outcome

The completed project provides a modular MATLAB environment for studying
aircraft response to different initial airspeeds and elevator inputs.

It combines aircraft modeling, numerical methods, control inputs, and
interactive visualization into a single simulation workflow.
