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
    Body(mass, position, velocity)

A celestial body with mass, position, and velocity.

# Arguments
- `mass::Float64`: Mass of the body in kilograms
- `position::SVector{3,Float64}`: Position vector in meters
- `velocity::SVector{3,Float64}`: Velocity vector in meters per second
"""
struct Body
    mass::Float64
    position::SVector{3,Float64}
    velocity::SVector{3,Float64}
    
    function Body(mass::Float64, position::SVector{3,Float64}, velocity::SVector{3,Float64})
        @assert mass > 0 "Mass must be positive"
        new(mass, position, velocity)
    end
end

"""
    ThreeBodySystem(bodies, G)

A system of three celestial bodies under gravitational interaction.

# Arguments
- `bodies::NTuple{3,Body}`: Tuple of three bodies
- `G::Float64`: Gravitational constant
"""
struct ThreeBodySystem
    bodies::NTuple{3,Body}
    G::Float64
    
    function ThreeBodySystem(bodies::NTuple{3,Body}, G::Float64)
        @assert G > 0 "Gravitational constant must be positive"
        new(bodies, G)
    end
end

# Interface implementations
Base.length(system::ThreeBodySystem) = length(system.bodies)
Base.iterate(system::ThreeBodySystem) = iterate(system.bodies)
Base.iterate(system::ThreeBodySystem, state) = iterate(system.bodies, state)
