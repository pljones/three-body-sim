# Three-Body Simulation System

A Julia-based simulation system for three-body gravitational interactions, specifically designed for Earth-Moon-Asteroid scenarios.

## Overview

This project provides a robust implementation of a three-body gravitational simulation system, focusing on the interaction between Earth, Moon, and an arbitrary asteroid. The simulation uses high-precision numerical integration while maintaining energy conservation.

## Features

- Full 3D gravitational simulation
- High-precision ODE solver integration
- Energy conservation tracking
- Detailed visualization tools including:
  - 3D trajectory plotting
  - Energy conservation metrics
  - System evolution animations
- Clean, modular design
- AGPL-3.0 licensed

## Installation

```julia
using Pkg
Pkg.add(url="https://github.com/pljones/three-body-sim.git")
```

## Quick Start

```julia
using CelestialMechanics

# Define the bodies (Earth, Moon, Asteroid)
earth = Body(5.972e24, @SVector([0.0, 0.0, 0.0]), @SVector([0.0, 0.0, 0.0]))
moon = Body(7.34767309e22, @SVector([384400e3, 0.0, 0.0]), @SVector([0.0, 1022.0, 0.0]))
asteroid = Body(1e5, @SVector([384400e3 * 1.1, 0.0, 20000e3]), @SVector([0.0, 800.0, 0.0]))

# Create system
system = ThreeBodySystem((earth, moon, asteroid), 6.67430e-11)

# Run simulation for 30 days
solution = simulate_system(system, (0.0, 30.0 * 24 * 3600))

# Visualize results
plot_trajectory_3d(solution, system)
plot_asteroid_metrics(solution, system)
```

## Quick Command Line Example

There are two ways you can try this repo out:
```bash
# Clone the repository
$ git clone https://github.com/pljones/three-body-sim.git
$ cd three-body-sim

# Install system requirements (Ubuntu/Debian)
$ sudo apt-get install python3-matplotlib

# Install dependencies (only needed once)
$ julia --project=. -e 'using Pkg; Pkg.instantiate()'

# Run the example simulation
$ julia --project=. examples/basic_simulation.jl

# The script will generate:
# - trajectory.png: 3D visualization of the bodies' paths
# - metrics.png: Energy conservation analysis
```

Or alternatively from within Julia:
```bash
# Start Julia REPL
$ julia

# Import the repository
julia> using Pkg
julia> Pkg.add(url="https://github.com/pljones/three-body-sim.git")

# Import and run a quick simulation
julia> using CelestialMechanics
julia> using StaticArrays

# Create a simple system (scaled down for quick testing)
julia> test_system = ThreeBodySystem(
           (Body(1e24, @SVector([0.0, 0.0, 0.0]), @SVector([0.0, 0.0, 0.0])),
            Body(1e22, @SVector([1e8, 0.0, 0.0]), @SVector([0.0, 1e3, 0.0])),
            Body(1e3,  @SVector([1.2e8, 0.0, 1e6]), @SVector([0.0, 8e2, 0.0]))),
           6.67430e-11)

# Run a quick 24-hour simulation
julia> sol = simulate_system(test_system, (0.0, 24 * 3600))

# Generate and save visualization
julia> using Plots
julia> savefig(plot_trajectory_3d(sol, test_system), "trajectory.png")
julia> savefig(plot_asteroid_metrics(sol, test_system), "metrics.png")
```

## Project Information

- **Created**: 2025-07-03 18:47:14 UTC
- **Author**: @pljones
- **License**: [GNU Affero General Public License v3.0](LICENSE)

## Structure

```
three-body-sim/
├── src/
│   ├── CelestialMechanics.jl    # Main module file
│   ├── types.jl                 # Core type definitions
│   ├── physics.jl              # Physics calculations
│   ├── simulation.jl           # ODE system and evolution
│   └── visualization.jl        # Plotting and animation tools
├── LICENSE
└── README.md
```

## License

Copyright (C) 2025 @pljones

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU Affero General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Affero General Public License for more details.

You should have received a copy of the GNU Affero General Public License
along with this program.  If not, see <https://www.gnu.org/licenses/>.
