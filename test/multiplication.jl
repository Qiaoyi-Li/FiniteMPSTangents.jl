@testset "Projected multiplication" begin
    @testset "On-site subtraction and allocating APIs" begin
        fixture = identity_fixture(1; site=1)
        operator = fixture.operator
        base = fixture.base
        tangent = fixture.tangent

        product = operator * tangent
        @test tangent_difference_norm(product, tangent) < 1e-12
        @test tangent_difference_norm(mul(operator, tangent), tangent) < 1e-12
        @test tangent_difference_norm(
            mul(operator, tangent, 2),
            scaled_copy(tangent, 2),
        ) < 1e-12
        @test tangent_difference_norm(TangentMPS(operator, base), tangent) < 1e-12

        destination = partialcopy(tangent)
        mul!(destination, operator, tangent, 2, 3)
        @test tangent_difference_norm(destination, scaled_copy(tangent, 5)) < 1e-12
    end

    @testset "Memory and disk environments" begin
        fixture = identity_fixture(3; site=2)
        operator = fixture.operator
        base = fixture.base
        tangent = fixture.tangent

        memory_environment = TangentEnvironment(base, operator; disk=false)
        memory_product = TangentMPS{3}(base, Vector{MPSTensor}(undef, 3))
        mul!(memory_product, operator, tangent; cache=memory_environment)
        @test tangent_difference_norm(memory_product, tangent) < 1e-12
        finalize(memory_environment)

        if Base.Threads.nthreads() > 1
            try
                FiniteMPS.set_num_threads_action(min(2, Base.Threads.nthreads()))
                threaded_product = mul(operator, tangent)
                @test tangent_difference_norm(threaded_product, memory_product) < 1e-12
            finally
                FiniteMPS.set_num_threads_action(1)
            end
        end

        disk_environment = TangentEnvironment(base, operator; disk=true, maxsize=1)
        disk_directory = disk_environment.dir
        try
            @test isdir(disk_directory)
            @test any(endswith(".bin"), readdir(disk_directory))

            disk_product = TangentMPS{3}(base, Vector{MPSTensor}(undef, 3))
            mul!(disk_product, operator, tangent; cache=disk_environment)
            @test tangent_difference_norm(disk_product, memory_product) < 1e-12
        finally
            finalize(disk_environment)
        end
        @test !isdir(disk_directory)
    end
end
