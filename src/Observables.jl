"""
    calObs!(tree::ObservableTree, bra::TangentMPS, ket::TangentMPS=bra; kwargs...)

Evaluate every observable registered in `tree` between the Hilbert-space states
obtained from `bra` and `ket` through the tangent-space natural isomorphism.
All local physical and purification indices, observable auxiliary indices, and
the optional global tangent charge are contracted; every stored result is a
`Number`.

If a registered tensor string has one unmatched auxiliary leg, `addObs!`
normalizes it to the string's left edge. With the default rank-two left
boundary, that leg is propagated as a global bra-oriented charge and may close
against a charged ket center: rank 4 over rank-3 MPS isometries, or rank 5
over rank-4 purified-MPO isometries. Thus the ket charge remains on each
candidate canonical-center tensor `B[i]`; it need not be moved to the state's
left boundary.

`El` and `Er` may instead supply nontrivial boundary intertwiners, following
the same orientation as `FiniteMPS.calObs!`. In particular, an explicit
rank-three `El` may carry and consume the operator string's auxiliary leg;
this preserves the fused-left-boundary workflow without adding the default
open-leg seed.

The user is responsible for making the registered operator string, optional
boundaries, bra/ket boundaries, and tangent charges form a closed tensor
network. There is no charge-mode switch: successful contraction always stores
a scalar. `normalize=true` divides by `norm(bra) * norm(ket)`.

Traversal follows the dependency-ready `FiniteMPS.calObs!` state machine. A
worker publishes each child only after its environment has been stored, so the
child may run immediately without waiting for unrelated nodes at the same tree
depth. `serial=false` is the default; `serial=true`, one Julia thread, or
`ntasks=1` selects the serial traversal. In threaded mode the caller coordinates
`ntasks - 1` contraction workers. `ntasks` may exceed the number of Julia
threads; Julia schedules those tasks over the available threads.

With `disk=true`, left and right environments use separate write-back LRU
caches. A child becomes ready only after it is resident in its cache or an
evicted environment has been serialized and atomically published at its final
path. Cache hits therefore avoid disk I/O, while `maxsize=0` writes every
environment immediately. By default, `maxsize` is the larger merged-tree width;
it applies independently to each side and does not include worker-local
contraction intermediates. No process-level parallel runtime is used.
"""
function calObs!(
	tree::ObservableTree{L},
	bra::TangentMPS{L},
	ket::TangentMPS{L} = bra;
	El = nothing,
	Er = nothing,
	normalize::Bool = false,
	disk::Bool = false,
	serial::Bool = false,
	ntasks::Int = Threads.nthreads(),
	maxsize::Union{Nothing,Int} = nothing,
	verbose::Int = 0,
) where L
	ntasks >= 1 || throw(ArgumentError("ntasks must be positive"))
	isnothing(maxsize) || maxsize >= 0 ||
		throw(ArgumentError("maxsize must be nonnegative"))
	_observable_reset_refs!(tree)

	try
		FiniteMPS.merge!(tree)
		cache_size = isnothing(maxsize) ?
			(disk ? maximum(treewidth(tree)) : 0) : maxsize
		left_boundary = isnothing(El) ? _default_observable_left_boundary(bra, ket) : El
		right_boundary = isnothing(Er) ? _default_observable_right_boundary(bra, ket) : Er
		isnothing(left_boundary) && throw(ArgumentError(
			"bra and ket have different left boundary spaces; provide El explicitly",
		))
		isnothing(right_boundary) && throw(ArgumentError(
			"bra and ket have different right boundary spaces; provide Er explicitly",
		))

		left_levels = _observable_levels(tree.RootL)
		right_levels = _observable_levels(tree.RootR)
		right_uses = _observable_right_use_counts(left_levels)
		threaded = !serial && Threads.nthreads() > 1 && ntasks > 1
		timer = TimerOutput()

		_observable_with_store(
			left_levels,
			right_levels;
			disk=disk,
			maxsize=cache_size,
		) do store
			_observable_store!(
				store,
				tree.RootL,
				ObservableEnv4(observable_left_boundary(left_boundary)),
			)
			_observable_store!(
				store,
				tree.RootR,
				ObservableEnv4(observable_right_boundary(right_boundary)),
			)

			@timeit timer "right tree" begin
				_observable_right_walk!(
					store,
					tree.RootR,
					sum(length, right_levels),
					right_uses,
					tree,
					bra,
					ket;
					threaded=threaded,
					ntasks=ntasks,
				)
			end
			@timeit timer "left tree" begin
				_observable_left_walk!(
					store,
					tree.RootL,
					sum(length, left_levels),
					right_uses,
					tree,
					bra,
					ket;
					threaded=threaded,
					ntasks=ntasks,
				)
			end
		end

		if normalize
			factor = norm(bra) * norm(ket)
			iszero(factor) && throw(ArgumentError("cannot normalize a zero tangent vector"))
			for refs in values(tree.Refs), ref in values(refs)
				ref[] /= factor
			end
		end

		for refs in values(tree.Refs), ref in values(refs)
			isnan(ref[]) && error("an observable leaf was not evaluated")
		end

		if verbose > 0
			show(timer; title = "tangent observables")
			println()
		end

		return timer
	catch
		_observable_reset_refs!(tree)
		rethrow()
	end
end

function _observable_reset_refs!(tree::ObservableTree)
	for refs in values(tree.Refs), ref in values(refs)
		ref[] = NaN
	end
	return nothing
end

function _observable_levels(root)
	levels = Vector{Vector{Any}}()
	frontier = Any[root]
	while !isempty(frontier)
		push!(levels, frontier)
		next_frontier = Any[]
		for node in frontier
			append!(next_frontier, node.children)
		end
		frontier = next_frontier
	end
	return levels
end

function _observable_right_use_counts(left_levels)
	counts = IdDict{Any,Int}()
	for nodes in left_levels, node in nodes
		seen = IdDict{Any,Nothing}()
		for channel in node.Intrs
			right_leaf = channel.LeafR
			haskey(seen, right_leaf) && continue
			seen[right_leaf] = nothing
			counts[right_leaf] = get(counts, right_leaf, 0) + 1
		end
	end
	return counts
end

abstract type _AbstractObservableEnvStore end

const _OBSERVABLE_TEMP_PREFIX = "FiniteMPSTangents-observables-"

mutable struct _ObservableMemoryStore <: _AbstractObservableEnvStore
	environments::IdDict{Any,ObservableEnv4}
	lock::ReentrantLock
end

mutable struct _ObservableDiskCache
	# A node may be resident only, persisted only, or both after read-through.
	# The outer lock makes each LRU transition and its synchronous spill one
	# operation from the perspective of ready-node consumers.
	values::LRU{Any,ObservableEnv4}
	lock::ReentrantLock
	retired::IdDict{Any,Nothing}
	persisted::IdDict{Any,Nothing}
	writeback::Base.RefValue{Bool}
	maxsize::Int
end

mutable struct _ObservableDiskStore <: _AbstractObservableEnvStore
	directory::String
	paths::IdDict{Any,String}
	sides::IdDict{Any,Symbol}
	cacheL::_ObservableDiskCache
	cacheR::_ObservableDiskCache
end

function _ObservableDiskCache(paths, maxsize)
	retired = IdDict{Any,Nothing}()
	persisted = IdDict{Any,Nothing}()
	writeback = Ref(true)
	cache_lock = ReentrantLock()
	function spill(node, environment)
		return lock(cache_lock) do
			writeback[] || return nothing
			haskey(retired, node) && return nothing
			haskey(persisted, node) && return nothing
			_observable_atomic_serialize(paths[node], environment)
			persisted[node] = nothing
			return nothing
		end
	end
	return _ObservableDiskCache(
		LRU{Any,ObservableEnv4}(; maxsize=maxsize, finalizer=spill),
		cache_lock,
		retired,
		persisted,
		writeback,
		maxsize,
	)
end

function _ObservableDiskStore(directory, left_levels, right_levels, maxsize)
	paths = IdDict{Any,String}()
	sides = IdDict{Any,Symbol}()
	for (side, levels) in (("left", left_levels), ("right", right_levels))
		side_directory = joinpath(directory, side)
		mkpath(side_directory)
		for (level_index, nodes) in enumerate(levels)
			for (node_index, node) in enumerate(nodes)
				sides[node] = Symbol(side)
				paths[node] = joinpath(
					side_directory,
					"level_$(level_index)_node_$(node_index)_site_$(node.Op[1]).bin",
				)
			end
		end
	end
	return _ObservableDiskStore(
		directory,
		paths,
		sides,
		_ObservableDiskCache(paths, maxsize),
		_ObservableDiskCache(paths, maxsize),
	)
end

function _observable_disk_cache(store::_ObservableDiskStore, node)
	return store.sides[node] === :left ? store.cacheL : store.cacheR
end

function _observable_with_store(
	f,
	left_levels,
	right_levels;
	disk::Bool,
	maxsize::Int,
)
	if disk
		return mktempdir(; prefix=_OBSERVABLE_TEMP_PREFIX) do directory
			store = _ObservableDiskStore(
				directory,
				left_levels,
				right_levels,
				maxsize,
			)
			try
				return f(store)
			finally
				_observable_clear!(store.cacheL)
				_observable_clear!(store.cacheR)
			end
		end
	else
		store = _ObservableMemoryStore(
			IdDict{Any,ObservableEnv4}(),
			ReentrantLock(),
		)
		try
			return f(store)
		finally
			lock(store.lock) do
				empty!(store.environments)
			end
		end
	end
end

function _observable_atomic_serialize(path::String, environment::ObservableEnv4)
	temporary_path, io = mktemp(dirname(path))
	try
		serialize(io, environment)
		flush(io)
		close(io)
		mv(temporary_path, path; force=true)
	catch
		try
			isopen(io) && close(io)
		catch
		end
		try
			rm(temporary_path; force=true)
		catch
		end
		rethrow()
	end
	return nothing
end

function _observable_clear!(cache::_ObservableDiskCache)
	lock(cache.lock) do
		cache.writeback[] = false
		empty!(cache.values)
		empty!(cache.retired)
		empty!(cache.persisted)
	end
	return nothing
end

function _observable_retire_unlocked!(
	cache::_ObservableDiskCache,
	node,
	path::String,
)
	# Explicit consumption/deletion must not turn into a writeback immediately
	# followed by removal of the same file.
	cache.retired[node] = nothing
	try
		if haskey(cache.values, node)
			delete!(cache.values, node)
		end
	finally
		delete!(cache.retired, node)
	end
	if haskey(cache.persisted, node)
		rm(path; force=true)
		delete!(cache.persisted, node)
	end
	return nothing
end

function _observable_store_unlocked!(
	cache::_ObservableDiskCache,
	node,
	path::String,
	environment::ObservableEnv4,
)
	if haskey(cache.values, node) || haskey(cache.persisted, node)
		error("observable environment was stored more than once")
	end
	if iszero(cache.maxsize)
		_observable_atomic_serialize(path, environment)
		cache.persisted[node] = nothing
	else
		cache.values[node] = environment
	end
	return nothing
end

function _observable_load_unlocked(
	cache::_ObservableDiskCache,
	node,
	path::String,
)
	if haskey(cache.values, node)
		return cache.values[node]
	end

	haskey(cache.persisted, node) || throw(KeyError(node))
	environment = deserialize(path)::ObservableEnv4
	iszero(cache.maxsize) || (cache.values[node] = environment)
	return environment
end

function _observable_store!(
	store::_ObservableMemoryStore,
	node,
	environment::ObservableEnv4,
)
	lock(store.lock) do
		store.environments[node] = environment
	end
	return nothing
end

function _observable_store!(
	store::_ObservableDiskStore,
	node,
	environment::ObservableEnv4,
)
	cache = _observable_disk_cache(store, node)
	lock(cache.lock) do
		_observable_store_unlocked!(
			cache,
			node,
			store.paths[node],
			environment,
		)
	end
	return nothing
end

function _observable_load(store::_ObservableMemoryStore, node)
	return lock(store.lock) do
		store.environments[node]
	end
end

function _observable_load(store::_ObservableDiskStore, node)
	cache = _observable_disk_cache(store, node)
	return lock(cache.lock) do
		_observable_load_unlocked(cache, node, store.paths[node])
	end
end

function _observable_drop!(store::_ObservableMemoryStore, node)
	lock(store.lock) do
		pop!(store.environments, node, nothing)
	end
	return nothing
end

function _observable_drop!(store::_ObservableDiskStore, node)
	cache = _observable_disk_cache(store, node)
	lock(cache.lock) do
		_observable_retire_unlocked!(cache, node, store.paths[node])
	end
	return nothing
end

function _observable_take!(store::_ObservableMemoryStore, node)
	return lock(store.lock) do
		pop!(store.environments, node)
	end
end

function _observable_take!(store::_ObservableDiskStore, node)
	cache = _observable_disk_cache(store, node)
	return lock(cache.lock) do
		path = store.paths[node]
		environment = if haskey(cache.values, node)
			cache.values[node]
		else
			haskey(cache.persisted, node) || throw(KeyError(node))
			deserialize(path)::ObservableEnv4
		end
		_observable_retire_unlocked!(cache, node, path)
		return environment
	end
end

function _observable_right_node(
	store::_AbstractObservableEnvStore,
	right_uses,
	tree::ObservableTree,
	bra::TangentMPS,
	ket::TangentMPS,
	node,
	emit_child,
)
	environment = haskey(right_uses, node) ?
		_observable_load(store, node) : _observable_take!(store, node)
	si = node.Op[1] - 1
	for child in node.children
		op = deepcopy(tree.Ops[si][child.Op[2]])
		op.strength[] = 1.0
		child_environment = observable_pushleft(
			environment,
			bra.base.Al[si], bra.base.Ar[si], bra.B[si],
			op,
			ket.base.Al[si], ket.base.Ar[si], ket.B[si],
		)
		_observable_store!(store, child, child_environment)
		emit_child(child)
	end
	return nothing
end

function _observable_left_node(
	store::_AbstractObservableEnvStore,
	tree::ObservableTree,
	bra::TangentMPS,
	ket::TangentMPS,
	node,
	emit_child,
)
	environment = _observable_take!(store, node)
	si = node.Op[1] + 1
	for child in node.children
		op = deepcopy(tree.Ops[si][child.Op[2]])
		op.strength[] = 1.0
		parent_environment = if node === tree.RootL &&
			environment.e00 isa ObservableLeftEnv{1,1} &&
			isnothing(environment.e10) &&
			isnothing(environment.e01) &&
			isnothing(environment.e11) &&
			!istrivial(getLeftSpace(op))
			observable_seed_left_open(environment, getLeftSpace(op))
		else
			environment
		end
		child_environment = observable_pushright(
			parent_environment,
			bra.base.Al[si], bra.base.Ar[si], bra.B[si],
			op,
			ket.base.Al[si], ket.base.Ar[si], ket.B[si],
		)
		_observable_store!(store, child, child_environment)
		emit_child(child)
	end

	leaf_values = IdDict{Any,Number}()
	writes = Tuple{Any,Number}[]
	right_leaves = Any[]
	for channel in node.Intrs
		right_leaf = channel.LeafR
		if haskey(leaf_values, right_leaf)
			value = leaf_values[right_leaf]
		else
			value = observable_leaf(
				environment,
				_observable_load(store, right_leaf),
			)
			leaf_values[right_leaf] = value
			push!(right_leaves, right_leaf)
		end
		push!(writes, (channel.ref, value))
	end
	return (; writes, right_leaves)
end

struct _ObservableReadyNode{N}
	node::N
end

struct _ObservableFinishedNode{N,R}
	node::N
	result::R
end

struct _ObservableFailedWorker
	task::Task
end

function _observable_walk_serial!(
	process_node,
	commit_node,
	root,
	node_count::Int,
)
	queue = Any[root]
	first = 1
	while first <= length(queue)
		node = queue[first]
		first += 1
		emit_child = child -> begin
			push!(queue, child)
			return nothing
		end
		result = process_node(node, emit_child)
		commit_node(node, result)
	end
	length(queue) == node_count || error("observable tree node count changed during traversal")
	return nothing
end

function _observable_take_ready!(node_pool)
	try
		return take!(node_pool)
	catch exception
		exception isa InvalidStateException && return nothing
		rethrow()
	end
end

function _observable_walk_threaded!(
	process_node,
	commit_node,
	root,
	node_count::Int;
	ntasks::Int,
)
	worker_count = ntasks - 1
	node_pool = Channel{Any}(Inf)
	event_pool = Channel{Any}(Inf)
	cancelled = Threads.Atomic{Bool}(false)

	workers = map(1:worker_count) do _
		Threads.@spawn begin
			while true
				node = _observable_take_ready!(node_pool)
				isnothing(node) && break
				cancelled[] && break

				try
					emit_child = child -> begin
						cancelled[] || put!(event_pool, _ObservableReadyNode(child))
						return nothing
					end
					result = process_node(node, emit_child)
					cancelled[] && break
					put!(event_pool, _ObservableFinishedNode(node, result))
				catch
					cancelled[] = true
					put!(event_pool, _ObservableFailedWorker(current_task()))
					rethrow()
				end
			end
		end
	end

	completed = 0
	failed_task = nothing
	coordinator_exception = nothing
	try
		put!(node_pool, root)
		while completed < node_count
			event = take!(event_pool)
			if event isa _ObservableReadyNode
				cancelled[] || put!(node_pool, event.node)
			elseif event isa _ObservableFinishedNode
				commit_node(event.node, event.result)
				completed += 1
			elseif event isa _ObservableFailedWorker
				failed_task = event.task
				break
			else
				error("unknown observable traversal event")
			end
		end
	catch exception
		cancelled[] = true
		coordinator_exception = exception
	finally
		cancelled[] = true
		isopen(node_pool) && close(node_pool)
		for worker in workers
			try
				wait(worker)
			catch
				isnothing(failed_task) && (failed_task = worker)
			end
		end
	end

	isnothing(coordinator_exception) || throw(coordinator_exception)
	isnothing(failed_task) || throw(TaskFailedException(failed_task))
	completed == node_count || error("observable traversal stopped before every node completed")
	return nothing
end

function _observable_walk_ready!(
	process_node,
	commit_node,
	root,
	node_count::Int;
	threaded::Bool,
	ntasks::Int,
)
	if threaded
		return _observable_walk_threaded!(
			process_node,
			commit_node,
			root,
			node_count;
			ntasks=ntasks,
		)
	else
		return _observable_walk_serial!(
			process_node,
			commit_node,
			root,
			node_count,
		)
	end
end

function _observable_right_walk!(
	store::_AbstractObservableEnvStore,
	root,
	node_count::Int,
	right_uses,
	tree::ObservableTree,
	bra::TangentMPS,
	ket::TangentMPS;
	threaded::Bool,
	ntasks::Int,
)
	process_node = (node, emit_child) -> _observable_right_node(
		store,
		right_uses,
		tree,
		bra,
		ket,
		node,
		emit_child,
	)
	return _observable_walk_ready!(
		process_node,
		(_, _) -> nothing,
		root,
		node_count;
		threaded=threaded,
		ntasks=ntasks,
	)
end

function _observable_left_walk!(
	store::_AbstractObservableEnvStore,
	root,
	node_count::Int,
	right_uses,
	tree::ObservableTree,
	bra::TangentMPS,
	ket::TangentMPS;
	threaded::Bool,
	ntasks::Int,
)
	process_node = (node, emit_child) -> _observable_left_node(
		store,
		tree,
		bra,
		ket,
		node,
		emit_child,
	)
	function commit_node(_, result)
		for (ref, value) in result.writes
			ref[] = value
		end
		for right_leaf in result.right_leaves
			remaining = right_uses[right_leaf] - 1
			if iszero(remaining)
				delete!(right_uses, right_leaf)
				_observable_drop!(store, right_leaf)
			else
				right_uses[right_leaf] = remaining
			end
		end
		return nothing
	end
	_observable_walk_ready!(
		process_node,
		commit_node,
		root,
		node_count;
		threaded=threaded,
		ntasks=ntasks,
	)

	isempty(right_uses) || error("some right observable environments were not consumed")
	return nothing
end

function _default_observable_left_boundary(bra::TangentMPS, ket::TangentMPS)
	bra_space = codomain(bra.base.A[1])[1]
	ket_space = codomain(ket.base.A[1])[1]
	return bra_space == ket_space ? id(bra_space) : nothing
end

function _default_observable_right_boundary(bra::TangentMPS, ket::TangentMPS)
	ket_space = domain(ket.base.A[end])[end]
	bra_space = domain(bra.base.A[end])[end]
	return ket_space == bra_space ? id(ket_space) : nothing
end
