# Three Body Simulation: Earth-Moon-Asteroid System
# Copyright (C) 2025 pljones
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

using CelestialMechanics
using StaticArrays
using Plots

# Define the bodies (Earth, Moon, Asteroid)
earth = Body(5.972e24, @SVector([0.0, 0.0, 0.0]), @SVector([0.0, 0.0, 0.0]))
moon = Body(7.34767309e22, @SVector([384400e3, 0.0, 0.0]), @SVector([0.0, 1022.0, 0.0]))
asteroid = Body(1e5, @SVector([384400e3 * 1.1, 0.0, 20000e3]), @SVector([0.0, 800.0, 0.0]))

# Create system
system = ThreeBodySystem((earth, moon, asteroid), 6.67430e-11)

# Run simulation for 30 days
solution = simulate_system(system, (0.0, 30.0 * 24 * 3600))

# Generate plots
trajectory_plot = plot_trajectory_3d(solution, system)
metrics_plot = plot_asteroid_metrics(solution, system)

# Save results
savefig(trajectory_plot, "trajectory.png")
savefig(metrics_plot, "metrics.png")
