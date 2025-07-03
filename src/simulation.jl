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

"""
    SimulationState

Mutable structure to track simulation progress and metrics.
"""
mutable struct SimulationState
    t::Float64
    positions::Vector{Vector{SVector{3,Float64}}}
    velocities::Vector{Vector{SVector{3,Float64}}}
    accelerations::Vector{Vector{SVector{3,Float64}}}
    energy::Vector{Float64}
    
    SimulationState() = new(0.0, [], [], [], [])
end

"""
    system_evolution!(du, u, system, t)

ODE system evolution function for the three-body problem.
"""
function system_evolution!(du, u, system, t)
    # Reconstruct current state
    positions = [SVector{3,Float64}(u[i:i+2]) for i in 1:6:18]
    velocities = [SVector{3,Float64}(u[i:i+2]) for i in 4:6:18]
    
    # Calculate forces
    forces = [@SVector zeros(3) for _ in 1:3]
    for i in 1:3, j in i+1:3
        f = gravitational_force(
            Body(system.bodies[i].mass, positions[i], velocities[i]),
            Body(system.bodies[j].mass, positions[j], velocities[j]),
            system.G
        )
        forces[i] += f
        forces[j] -= f
    end
    
    # Update derivatives
    for i in 1:3
        du[i*6-5:i*6-3] = velocities[i]  # position derivatives
        du[i*6-2:i*6] = forces[i] / system.bodies[i].mass  # velocity derivatives
    end
end

"""
    get_state(system)

Convert system state to ODE solver format.
"""
function get_state(system::ThreeBodySystem)
    vcat([vcat(b.position, b.velocity) for b in system.bodies]...)
end

"""
    update_system!(system, state)

Update system with new state from ODE solver.
"""
function update_system!(system::ThreeBodySystem, state)
    ThreeBodySystem(
        tuple([Body(b.mass, 
                   SVector{3,Float64}(state[i:i+2]),
                   SVector{3,Float64}(state[i+3:i+5]))
               for (i, b) in zip(1:6:18, system.bodies)]...),
        system.G
    )
end

"""
    simulate_system(system, tspan; kwargs...)

Simulate the three-body system over the specified time span.
"""
function simulate_system(system::ThreeBodySystem, tspan;
                       save_interval=3600.0,  # Save every hour
                       reltol=1e-10,
                       abstol=1e-10)
    prob = ODEProblem(system_evolution!, get_state(system), tspan, system)
    solve(prob, Tsit5(),
          reltol=reltol,
          abstol=abstol,
          saveat=save_interval)
end
