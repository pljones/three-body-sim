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
    plot_trajectory_3d(sol, system; kwargs...)

Create a 3D plot of the trajectories of all bodies in the system.
"""
function plot_trajectory_3d(sol, system;
                          body_names=["Earth", "Moon", "Asteroid"],
                          colors=[:blue, :gray, :red])
    plt = plot3d(
        xlabel="X (m)",
        ylabel="Y (m)",
        zlabel="Z (m)",
        title="Three-Body Trajectories",
        legend=:outertopright
    )

    for i in 1:3
        positions = [[sol[j][i*6-5:i*6-3] for j in 1:length(sol)]]
        x = getindex.(positions[1], 1)
        y = getindex.(positions[1], 2)
        z = getindex.(positions[1], 3)

        plot3d!(plt, x, y, z,
                label=body_names[i],
                color=colors[i],
                linewidth=2)
    end

    plt
end


"""
    plot_asteroid_metrics(sol, system)

Plot energy conservation and other metrics for the asteroid.
"""
function plot_asteroid_metrics(sol, system)
    times = sol.t
    total_energy = Float64[]
    kinetic = Float64[]
    potential = Float64[]
    
    for t in 1:length(sol)
        state = sol[t]
        current_system = update_system!(system, state)
        push!(total_energy, hamiltonian(current_system))
        push!(kinetic, kinetic_energy(current_system))
        push!(potential, potential_energy(current_system))
    end
    
    p1 = plot(times, [total_energy kinetic potential],
              label=["Total Energy" "Kinetic Energy" "Potential Energy"],
              title="Energy Conservation",
              xlabel="Time (s)",
              ylabel="Energy (J)")
              
    p1
end

"""
    create_animation(sol, system; kwargs...)

Create an animation of the three-body system evolution.
"""
function create_animation(sol, system;
                        body_names=["Earth", "Moon", "Asteroid"],
                        colors=[:blue, :gray, :red])
    
    # Initialize min and max bounds
    xmin, xmax = Inf, -Inf
    ymin, ymax = Inf, -Inf
    zmin, zmax = Inf, -Inf
    for i in 1:length(sol)
        state = sol[i]
        current_system = update_system!(system, state)
	origin = current_system.bodies[1].position
        for body in current_system.bodies
            pos = body.position .- origin
            x, y, z = pos
            xmin = min(xmin, x)
            xmax = max(xmax, x)
            ymin = min(ymin, y)
            ymax = max(ymax, y)
            zmin = min(zmin, z)
            zmax = max(zmax, z)
        end
    end
    # Pad all dimensions by 10% of total span
    xpad = 0.1 * (xmax - xmin)
    ypad = 0.1 * (ymax - ymin)
    zpad = 0.1 * (zmax - zmin)

    xlim = (xmin - xpad, xmax + xpad)
    ylim = (ymin - ypad, ymax + ypad)
    zlim = (zmin - zpad, zmax + zpad)

    anim = @animate for i in 1:length(sol)
        state = sol[i]
        current_system = update_system!(system, state)
	origin = current_system.bodies[1].position

        plt = plot3d(xlabel="X (m)", ylabel="Y (m)", zlabel="Z (m)",
               xlim=xlim, ylim=ylim, zlim=zlim,
               title="Three-Body System Evolution (t=$(round(sol.t[i]/3600, digits=2)) hours)",
               legend=:outertopright)

        for (j, body) in enumerate(current_system.bodies)
            body_position = body.position .- origin  # position relative to body 1
            scatter3d!(plt, [body_position[1]], [body_position[2]], [body_position[3]],
                      label=body_names[j],
                      color=colors[j],
                      markersize=6)
        end
    end

    anim
end
