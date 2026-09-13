# Numerical checks for manually invoked benchmark-fixture tests. This file is
# deliberately not included by the registered performance suite.

function chain_orthogonal_residual(B)
    squared = 0.0
    for i in 1:length(B.B)-1
        A = B.base.Al[i].A
        X = B.B[i].A
        if numind(A) == 4
            A = permute(A,((1,2,3),(4,)))
            X = numind(X) == 4 ? permute(X,((1,2,3),(4,))) : permute(X,((1,2,3),(4,5)))
        end
        squared += norm(A' * X)^2
    end
    return sqrt(squared)/max(norm(B),eps())
end

function check_chain_tangent(B; normalized=false)
    @test all(all(isfinite,block) for A in B.B for (_,block) in blocks(A.A))
    magnitude = norm(B)
    @test isfinite(magnitude) && magnitude>0
    normalized && @test isapprox(magnitude,1;atol=1e-12,rtol=1e-12)
    @test chain_orthogonal_residual(B)<1e-10
end

function check_chain_state(f,sym,D,rank;spinless=false)
    expected = bond_spaces(sym,D,rank;spinless)
    actual = [codomain(f.base.A[1].A)[1]; [domain(A.A)[end] for A in f.base.A]]
    @test actual==expected
    @test f.parameters["actual_D"]==dim(actual[9])<=D
    @test f.parameters["bond_schedule"]==
        [merge(Dict("cut_after_site"=>i-1),describe_space(V)) for (i,V) in enumerate(actual)]
    for A in f.base.A
        @test all(all(isfinite,block) for (_,block) in blocks(A.A))
        @test norm(A)>0
    end
    check_chain_tangent(f.tangent;normalized=true)
end

function check_chain_inner(left,right)
    expected = sum(dot(left.B[i].A,right.B[i].A) for i in eachindex(left.B))
    actual = inner(left,right)
    @test isfinite(actual) && abs(actual)>0
    @test isapprox(actual,expected;atol=1e-11,rtol=1e-9)
    @test isapprox(inner(right,left),conj(actual);atol=1e-11,rtol=1e-9)
    @test isapprox(real(inner(left,left)),norm(left)^2;atol=1e-11,rtol=1e-9)
end

function check_chain_case(case,config)
    p = case.parameters
    family,sym,D,rank = (p[key] for key in ("family","symmetry","nominal_D","base_rank"))
    charged = p["center_rank"]>rank
    rng = Xoshiro(case.seed)
    previous = configure_threads(config)
    try
        f = build_state(rng,sym,D,rank,charged)
        check_chain_state(f,sym,D,rank)
        if family=="CM"
            cache = TangentEnvironment(f.base,f.H;disk=false)
            try
                C = partialcopy(f.tangent)
                mul!(C,f.H,f.tangent,1.0,0.0;cache,normalize=false,GCstep=false,disk=false)
                check_chain_tangent(C)
            finally
                finalize(cache)
            end
        elseif family=="OR"
            B = random_tangent(rng,f.base;charged,Q=charge_space(sym),project=false)
            orth!(B;normalize=false)
            check_chain_tangent(B)
        elseif family=="EC"
            cache = TangentEnvironment(f.base,f.H;disk=false)
            try
                for i in eachindex(f.base.A)
                    @test any(!isnothing,FiniteMPSTangents._getEl(cache,i))
                    @test any(!isnothing,FiniteMPSTangents._getEr(cache,i))
                end
            finally
                finalize(cache)
            end
        elseif family=="BC"
            base = BaseMPS(f.psi)
            for i in eachindex(base.A)
                @test codomain(base.A[i].A)==codomain(f.base.A[i].A)
                @test domain(base.A[i].A)==domain(f.base.A[i].A)
                @test norm(base.A[i].A-f.base.A[i].A)<1e-10
            end
        elseif family=="IP"
            right = random_tangent(rng,f.base;charged,Q=charge_space(sym))
            check_chain_tangent(right;normalized=true)
            for action_threads in unique((config.julia_threads,1))
                FiniteMPS.set_num_threads_action(action_threads)
                check_chain_inner(f.tangent,right)
            end
        else
            error("Unsupported chain test family $family")
        end
    finally
        restore_threads(previous)
    end
end
