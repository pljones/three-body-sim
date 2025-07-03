# Three Body Simulation: Earth-Moon-Asteroid System
# Copyright (C) 2025 pljones

using Test
using CelestialMechanics
using StaticArrays
using LinearAlgebra

@testset "CelestialMechanics.jl" begin
    @testset "Body Construction" begin
        body = Body(1.0, @SVector([0.0, 0.0, 0.0]), @SVector([0.0, 0.0, 0.0]))
        @test body.mass == 1.0
        @test body.position == @SVector([0.0, 0.0, 0.0])
        @test body.velocity == @SVector([0.0, 0.0, 0.0])
        @test_throws AssertionError Body(-1.0, @SVector([0.0, 0.0, 0.0]), @SVector([0.0, 0.0, 0.0]))
    end

    @testset "System Construction" begin
        bodies = (
            Body(1.0, @SVector([0.0, 0.0, 0.0]), @SVector([0.0, 0.0, 0.0])),
            Body(1.0, @SVector([1.0, 0.0, 0.0]), @SVector([0.0, 1.0, 0.0])),
            Body(1.0, @SVector([0.0, 1.0, 0.0]), @SVector([1.0, 0.0, 0.0]))
        )
        system = ThreeBodySystem(bodies, 1.0)
        @test length(system) == 3
        @test system.G == 1.0
        @test_throws AssertionError ThreeBodySystem(bodies, -1.0)
    end

    @testset "Energy Conservation" begin
        bodies = (
            Body(1e24, @SVector([0.0, 0.0, 0.0]), @SVector([0.0, 0.0, 0.0])),
            Body(1e22, @SVector([1e8, 0.0, 0.0]), @SVector([0.0, 1e3, 0.0])),
            Body(1e3, @SVector([1.2e8, 0.0, 1e6]), @SVector([0.0, 8e2, 0.0]))
        )
        system = ThreeBodySystem(bodies, 6.67430e-11)
        
        # Short simulation to test energy conservation
        sol = simulate_system(system, (0.0, 3600.0))  # 1 hour simulation
        
        # Check that energy is conserved within reasonable bounds
        initial_energy = hamiltonian(system)
        final_state = update_system!(system, sol[end])
        final_energy = hamiltonian(final_state)
        
        @test abs((final_energy - initial_energy) / initial_energy) < 1e-10
    end

    @testset "Gravitational Forces" begin
        b1 = Body(1.0, @SVector([0.0, 0.0, 0.0]), @SVector([0.0, 0.0, 0.0]))
        b2 = Body(1.0, @SVector([1.0, 0.0, 0.0]), @SVector([0.0, 0.0, 0.0]))
        G = 1.0
        
        force = gravitational_force(b1, b2, G)
        @test norm(force) ≈ 1.0
        @test force[1] > 0  # Force should be in positive x direction
        @test force[2] ≈ 0.0
        @test force[3] ≈ 0.0
    end
end
