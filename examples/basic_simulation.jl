# Three Body Simulation: Earth-Moon-Asteroid System
# Copyright (C) 2025 pljones
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# Ensure dependencies are installed
using Pkg
Pkg.activate(".")
Pkg.instantiate()

using CelestialMechanics
using StaticArrays

using Plots
pyplot() # Use PyPlot backend

# Define the bodies (Earth, Moon, Asteroid)
print("Setting up bodies...")
earth = Body(5.972e24, @SVector([0.0, 0.0, 0.0]), @SVector([0.0, 0.0, 0.0]))
moon = Body(7.34767309e22, @SVector([384400e3, 0.0, 0.0]), @SVector([0.0, 1022.0, 0.0]))
asteroid = Body(1e5, @SVector([384400e3 * 1.1, 0.0, 20000e3]), @SVector([0.0, 800.0, 0.0]))
println("")

# Create system
print("Creating three body system...")
system = ThreeBodySystem((earth, moon, asteroid), 6.67430e-11)
println("")

# Run simulation for 30 days
print("Running simulation over 30 days...")
solution = simulate_system(system, (0.0, 30.0 * 24 * 3600))
println("")

# Generate plots
print("Plotting trajectories...")
trajectory_plot = plot_trajectory_3d(solution, system)
println("")

print("Plotting asteroid metrics...")
metrics_plot = plot_asteroid_metrics(solution, system)
println("")

print("Creating animation...")
orbits_anim = create_animation(solution, system)
println("")

# Save results
savefig(trajectory_plot, "trajectory.png")
savefig(metrics_plot, "metrics.png")
gif(orbits_anim, "orbits.gif", fps=30)
