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
    kinetic_energy(system)

Calculate total kinetic energy of the system.
T = Σ(1/2 * m * v²)
"""
function kinetic_energy(system::ThreeBodySystem)
    sum(0.5 * b.mass * norm(b.velocity)^2 for b in system.bodies)
end

"""
    potential_energy(system)

Calculate total gravitational potential energy of the system.
V = -G * Σ(m₁m₂/r)
"""
function potential_energy(system::ThreeBodySystem)
    -sum(
        system.G * b1.mass * b2.mass / norm(b1.position - b2.position)
        for (i,b1) in enumerate(system.bodies)
        for b2 in system.bodies[i+1:end]
    )
end

"""
    gravitational_force(b1, b2, G)

Calculate gravitational force between two bodies.
F = G * m₁m₂/r² * r̂
"""
function gravitational_force(b1::Body, b2::Body, G::Float64)
    r = b2.position - b1.position
    r_mag = norm(r)
    G * b1.mass * b2.mass * r / r_mag^3
end

"""
    hamiltonian(system)

Calculate total energy of the system.
H = T + V
"""
function hamiltonian(system::ThreeBodySystem)
    kinetic_energy(system) + potential_energy(system)
end

"""
    lagrangian(system)

Calculate Lagrangian of the system.
L = T - V
"""
function lagrangian(system::ThreeBodySystem)
    kinetic_energy(system) - potential_energy(system)
end
