# Three Body Simulation: Earth-Moon-Asteroid System
# Copyright (C) 2025 pljones
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

module CelestialMechanics

using StaticArrays
using LinearAlgebra
using DifferentialEquations
using Plots
using LaTeXStrings
using Dates

const SIMULATION_START = DateTime(2025, 7, 3, 18, 41, 31)
const SIMULATION_USER = "pljones"

include("types.jl")
include("physics.jl")
include("simulation.jl")
include("visualization.jl")

export Body, ThreeBodySystem
export kinetic_energy, potential_energy, gravitational_force
export hamiltonian, lagrangian
export simulate_system, get_state, update_system!
export plot_trajectory_3d, plot_asteroid_metrics, create_animation

end # module
