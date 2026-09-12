using FiniteMPSTangents
using FiniteMPSTangents.FiniteMPS
using Random

const _ObservableBenchmarkModule = FiniteMPSTangents

function _observable_benchmark_fixture(side, D, kind; charged=false, sparse=false, su2=false, purified=false)
    M = _ObservableBenchmarkModule
    V = su2 ? Rep[SU₂](j => D for j in 0:1//2:2) : charged ? Rep[U₁](n => D for n in -2:2) : ℂ^D
    P = su2 ? SU2Spin.pspace : charged ? U1SpinlessFermion.pspace : ℂ^2
    Q = su2 ? Rep[SU₂](1 => 1) : charged ? Rep[U₁](1 => 1) : ℂ^1
    auxiliary = su2 ? Rep[SU₂](1 => 1) : charged ? Rep[U₁](-1 => 1, 0 => 2, 1 => 1) : ℂ^2
    function make_site(inserted)
        dom = charged && inserted ? Q ⊗ V : V
        purified && (dom = P ⊗ dom)
        return MPSTensor(TensorMap(randn, ComplexF64, V ⊗ P, dom))
    end
    function environment(role)
        cod, dom = [V], [V]
        role == :bra && push!(cod, Q)
        role == :ket && pushfirst!(dom, Q)
        if kind == :O22
            side == :left ? push!(dom, auxiliary) : insert!(cod, 2, auxiliary)
        end
        wrappers = side == :left ?
            (M.ObservableLeftEnv, M.ObservableLeftBraOpen, M.ObservableLeftKetOpen) :
            (M.ObservableRightEnv, M.ObservableRightBraOpen, M.ObservableRightKetOpen)
        W = wrappers[role == :neutral ? 1 : role == :bra ? 2 : 3]
        return W(TensorMap(randn, ComplexF64, prod(cod), prod(dom)))
    end
    E = M.ObservableEnv4(environment(:neutral),
        environment(charged ? :bra : :neutral), environment(charged ? :ket : :neutral),
        environment(:neutral))
    sparse && (E = M.ObservableEnv4(E.e00))
    O = kind == :I ? IdentityOperator(P, su2 ? Rep[SU₂](0 => 1) : ℂ^1, 1, 1.0) :
        LocalOperator(TensorMap(randn, ComplexF64,
            kind == :O22 ? auxiliary ⊗ P : P,
            kind == :O22 ? P ⊗ auxiliary : P), :probe, 1, false)
    return E, make_site(false), make_site(false), make_site(true), O,
        make_site(false), make_site(false), make_site(true)
end

function _observable_benchmark_measure(label, f, samples)
    f()
    f()
    GC.gc()
    times, bytes, allocs = Float64[], Int[], Int[]
    for _ in 1:samples
        measured = @timed f()
        push!(times, measured.time)
        push!(bytes, measured.bytes)
        push!(allocs, Base.gc_alloc_count(measured.gcstats))
    end
    middle = cld(samples, 2)
    println(label, '\t', sort!(times)[middle], '\t', sort!(bytes)[middle], '\t', sort!(allocs)[middle])
    flush(stdout)
end

function benchmark_observable_su2(samples=15)
    M = _ObservableBenchmarkModule
    Random.seed!(0x6a6a_bee2)
    for multiplicity in (4, 8), side in (:left, :right), purified in (false, true), kind in (:I, :O22)
        args = _observable_benchmark_fixture(side, multiplicity, kind;
            charged=kind == :O22, su2=true, purified=purified)
        push = side == :left ? M.observable_pushright : M.observable_pushleft
        label = "local/$side/SU2/D=$(15multiplicity)/multiplicity=$multiplicity/base=$(purified ? 4 : 3)/$kind"
        _observable_benchmark_measure(label, () -> push(args...), samples)
    end
end

function benchmark_observable_contractions()
    M = _ObservableBenchmarkModule
    samples = parse(Int, get(ENV, "OBS_BENCH_SAMPLES", "15"))
    samples > 0 || throw(ArgumentError("OBS_BENCH_SAMPLES must be positive"))
    FiniteMPS.set_num_threads_action(1)
    Random.seed!(0x6a6a_bec0)
    println("package=", pathof(M))
    println("Julia=", VERSION, " FiniteMPS=", pkgversion(FiniteMPS),
        " TensorKit=", pkgversion(FiniteMPS.TensorKit),
        " TensorOperations=", pkgversion(FiniteMPS.TensorOperations))
    println("Julia_threads=", Threads.nthreads(), " BLAS=", BLAS.get_config(),
        " BLAS_threads=", BLAS.get_num_threads(), " samples=", samples)
    println("case\tmedian_seconds\tmedian_bytes\tmedian_allocations")
    for D in (32, 64, 128), side in (:left, :right), kind in (:I, :O11)
        args = _observable_benchmark_fixture(side, D, kind)
        push = side == :left ? M.observable_pushright : M.observable_pushleft
        _observable_benchmark_measure("local/$side/D=$D/$kind", () -> push(args...), samples)
    end
    for side in (:left, :right)
        push = side == :left ? M.observable_pushright : M.observable_pushleft
        args = _observable_benchmark_fixture(side, 64, :I; sparse=true)
        _observable_benchmark_measure("local/$side/D=64/I/e00", () -> push(args...), samples)
        args = _observable_benchmark_fixture(side, 8, :O22; charged=true)
        _observable_benchmark_measure("local/$side/U1/D=40/O22/aux=4", () -> push(args...), samples)
    end
    L = 12
    tangent = TangentMPS(BaseMPS(randMPS(ComplexF64, L, NoSymSpinOneHalf.pspace, ℂ^16)))
    for i in 1:L
        A = tangent.B[i].A
        tangent.B[i] = MPSTensor(TensorMap(randn, ComplexF64, codomain(A), domain(A)))
    end
    tree = ObservableTree(L)
    for i in 1:L
        addObs!(tree, NoSymSpinOneHalf.Sz, i; name=Symbol("Sz$i"))
    end
    FiniteMPS.merge!(tree)
    for serial in (true, false)
        f = () -> calObs!(tree, tangent; serial=serial, ntasks=4)
        _observable_benchmark_measure("tree/L=12/D=16/serial=$serial/ntasks=4", f, samples)
    end
    benchmark_observable_su2(samples)
end

if abspath(PROGRAM_FILE) == (@__FILE__)
    benchmark_observable_contractions()
end
