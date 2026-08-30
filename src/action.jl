#    --d   k l  g--
#   |      |/     |
#    --c --T---h--
#   |      |f     |
#   El--b--H---i--Er
#   |      |      |
#    --a   e   j--
function _action1(El::Vector{Union{Nothing, BilayerLeftTensor}}, T::MPSTensor, H::SparseMPOTensor, Er::Vector{Union{Nothing, BilayerRightTensor}};
	timer::Union{Nothing, TimerOutput} = nothing,
	tree_point::Vector{String} = ["_action1"])
	HT = nothing

	if FiniteMPS.get_num_threads_action() > 1
		idx_valid = [(i, j) for i in 1:size(H, 1), j in 1:size(H, 2) if !isnothing(H[i, j])]
		Lock = ReentrantLock()
		Threads.@threads :greedy for (i, j) in idx_valid
			tmp, to = _action1(El[i], T, H[i, j], Er[j], true)

			lock(Lock) do
				if isnothing(HT)
					HT = tmp
				else
					HT = add!!(HT, tmp)
				end
				!isnothing(timer) && merge!(timer, to; tree_point = tree_point)
			end
		end

	else

		for i in 1:size(H, 1)
			for j in 1:size(H, 2)
				isnothing(H[i, j]) && continue
				tmp, to = _action1(El[i], T, H[i, j], Er[j], true)
				if isnothing(HT)
					HT = tmp
				else
					HT = add!!(HT, tmp)
				end
				!isnothing(timer) && merge!(timer, to; tree_point = tree_point)
			end
		end

	end
	return HT
end

function _action1(El::BilayerLeftTensor{N₁,N₂}, T::MPSTensor{N₃}, H::IdentityOperator,
	Er::BilayerRightTensor{N₄,N₅}, timeit::Bool) where {N₁,N₂,N₃,N₄,N₅}
	!timeit && return _action1(El, T, H, Er), TimerOutput()
	LocalTimer = TimerOutput()
	name = "_action1_$(N₁)_$(N₂)_0_$(N₃)_$(N₄)_$(N₅)"
	@timeit LocalTimer name Hx = _action1(El, T, H, Er)
	return Hx, LocalTimer
end

function _action1(El::BilayerLeftTensor{N₁,N₂}, T::MPSTensor{N₃}, H::LocalOperator{N₄,N₅},
	Er::BilayerRightTensor{N₆,N₇}, timeit::Bool) where {N₁,N₂,N₃,N₄,N₅,N₆,N₇}
	!timeit && return _action1(El, T, H, Er), TimerOutput()
	LocalTimer = TimerOutput()
	name = "_action1_$(N₁)_$(N₂)_$(N₄)$(N₅)_$(N₃)_$(N₆)_$(N₇)"
	@timeit LocalTimer name Hx = _action1(El, T, H, Er)
	return Hx, LocalTimer
end

function _action1(El::BilayerLeftTensor{1, 1}, T::MPSTensor{3}, H::LocalOperator{2, 1}, Er::BilayerRightTensor{1, 1})::MPSTensor{4}
	c = H.strength[]
	return @tensor tmp[a e; b j] := c * ((El.A[a c] * T.A[c f h]) * H.A[b e f]) * Er.A[h j]
end

function _action1(El::BilayerLeftTensor{1, 1}, T::MPSTensor{3}, H::IdentityOperator, Er::BilayerRightTensor{1, 2})::MPSTensor{4}
	c = H.strength[]
	return @tensor tmp[a f; i j] := c * (El.A[a c] * T.A[c f h]) * Er.A[h i j]
end

function _action1(El::BilayerLeftTensor{1, 2}, T::MPSTensor{3}, H::IdentityOperator, Er::BilayerRightTensor{1, 1})::MPSTensor{4}
	c = H.strength[]
	return @tensor tmp[a f; d j] := c * (El.A[a c d] * T.A[c f h]) * Er.A[h j]
end

function _action1(El::BilayerLeftTensor{1, 2}, T::MPSTensor{4}, H::IdentityOperator, Er::BilayerRightTensor{1, 1})::MPSTensor{5}
	c = H.strength[]
	return @tensor tmp[a f; k d j] := c * (El.A[a c d] * T.A[c f k h]) * Er.A[h j]
end

function _action1(El::BilayerLeftTensor{1, 2}, T::MPSTensor{3}, H::LocalOperator{1, 1}, Er::BilayerRightTensor{1, 1})::MPSTensor{4}
	c = H.strength[]
	return @tensor tmp[a e; d j] := c * ((El.A[a c d] * T.A[c f h]) * H.A[e f]) * Er.A[h j]
end

function _action1(El::BilayerLeftTensor{1, 2}, T::MPSTensor{4}, H::LocalOperator{1, 1}, Er::BilayerRightTensor{1, 1})::MPSTensor{5}
	c = H.strength[]
	return @tensor tmp[a e; k d j] := c * ((El.A[a c d] * T.A[c f k h]) * H.A[e f]) * Er.A[h j]
end

function _action1(El::BilayerLeftTensor{1, 2}, T::MPSTensor{3}, H::LocalOperator{1, 2}, Er::BilayerRightTensor{1, 2})::MPSTensor{4}
	c = H.strength[]
	return @tensor tmp[a e; d j] := c * ((El.A[a c d] * T.A[c f h]) * H.A[e f i]) * Er.A[h i j]
end

function _action1(El::BilayerLeftTensor{1, 2}, T::MPSTensor{4}, H::LocalOperator{1, 2}, Er::BilayerRightTensor{1, 2})::MPSTensor{5}
	c = H.strength[]
	return @tensor tmp[a e; k d j] := c * ((El.A[a c d] * T.A[c f k h]) * H.A[e f i]) * Er.A[h i j]
end

function _action1(El::BilayerLeftTensor{1, 1}, T::MPSTensor{3}, H::LocalOperator{1, 2}, Er::BilayerRightTensor{1, 2})::MPSTensor{3}
	c = H.strength[]
	return @tensor tmp[a e; j] := c * ((El.A[a c] * T.A[c f h]) * H.A[e f i]) * Er.A[h i j]
end

function _action1(El::BilayerLeftTensor{1, 1}, T::MPSTensor{3}, H::LocalOperator{2, 2}, Er::BilayerRightTensor{1, 2})::MPSTensor{4}
	c = H.strength[]
	return @tensor tmp[a e; b j] := c * ((El.A[a c] * T.A[c f h]) * Er.A[h i j]) * H.A[b e f i]
end

function _action1(El::BilayerLeftTensor{1, 1}, T::MPSTensor{4}, H::LocalOperator{2, 2}, Er::BilayerRightTensor{1, 2})::MPSTensor{5}
	c = H.strength[]
	return @tensor tmp[a e; k b j] := c * ((El.A[a c] * T.A[c f k h]) * Er.A[h i j]) * H.A[b e f i]
end

function _action1(El::BilayerLeftTensor{1, 1}, T::MPSTensor{4}, H::LocalOperator{1, 2}, Er::BilayerRightTensor{1, 2})::MPSTensor{4}
	c = H.strength[]
	return @tensor tmp[a e; k j] := c * ((El.A[a c] * T.A[c f k h]) * H.A[e f i]) * Er.A[h i j]
end

function _action1(El::BilayerLeftTensor{1, 1}, T::MPSTensor{5}, H::LocalOperator{1, 2}, Er::BilayerRightTensor{1, 2})::MPSTensor{5}
	c = H.strength[]
	return @tensor tmp[a e; k l j] := c * ((El.A[a c] * T.A[c f k l h]) * Er.A[h i j]) * H.A[e f i]
end

function _action1(El::BilayerLeftTensor{1, 1}, T::MPSTensor{3}, H::IdentityOperator, Er::BilayerRightTensor{1, 1})::MPSTensor{3}
	c = H.strength[]
	return @tensor tmp[a f; j] := c * (El.A[a c] * T.A[c f h]) * Er.A[h j]
end

function _action1(El::BilayerLeftTensor{1, 1}, T::MPSTensor{4}, H::IdentityOperator, Er::BilayerRightTensor{1, 1})::MPSTensor{4}
	c = H.strength[]
	return @tensor tmp[a f; k j] := c * (El.A[a c] * T.A[c f k h]) * Er.A[h j]
end

function _action1(El::BilayerLeftTensor{1, 1}, T::MPSTensor{5}, H::IdentityOperator, Er::BilayerRightTensor{1, 1})::MPSTensor{5}
	c = H.strength[]
	return @tensor tmp[a f; k l j] := c * (El.A[a c] * T.A[c f k l h]) * Er.A[h j]
end

function _action1(El::BilayerLeftTensor{1, 1}, T::MPSTensor{4}, H::IdentityOperator, Er::BilayerRightTensor{1, 2})::MPSTensor{5}
	c = H.strength[]
	return @tensor tmp[a f; k i j] := c * (El.A[a c] * T.A[c f k h]) * Er.A[h i j]
end

function _action1(El::BilayerLeftTensor{1, 1}, T::MPSTensor{3}, H::LocalOperator{1, 1}, Er::BilayerRightTensor{1, 1})::MPSTensor{3}
	c = H.strength[]
	return @tensor tmp[a e; j] := c * ((El.A[a c] * T.A[c f h]) * H.A[e f]) * Er.A[h j]
end

function _action1(El::BilayerLeftTensor{1, 1}, T::MPSTensor{4}, H::LocalOperator{1, 1}, Er::BilayerRightTensor{1, 1})::MPSTensor{4}
	c = H.strength[]
	return @tensor tmp[a e; k j] := c * ((El.A[a c] * T.A[c f k h]) * H.A[e f]) * Er.A[h j]
end

function _action1(El::BilayerLeftTensor{1, 1}, T::MPSTensor{5}, H::LocalOperator{1, 1}, Er::BilayerRightTensor{1, 1})::MPSTensor{5}
	c = H.strength[]
	return @tensor tmp[a e; k l j] := c * ((El.A[a c] * T.A[c f k l h]) * H.A[e f]) * Er.A[h j]
end

function _action1(El::BilayerLeftTensor{1, 1}, T::MPSTensor{4}, H::LocalOperator{2, 1}, Er::BilayerRightTensor{1, 1})::MPSTensor{5}
	c = H.strength[]
	return @tensor tmp[a e; k b j] := c * ((El.A[a c] * T.A[c f k h]) * Er.A[h j]) * H.A[b e f]
end

function _action1(El::BilayerLeftTensor{2, 1}, T::MPSTensor{3}, H::LocalOperator{2, 1}, Er::BilayerRightTensor{1, 1})::MPSTensor{3}
	c = H.strength[]
	return @tensor tmp[a e; j] := c * ((El.A[a b c] * T.A[c f h]) * H.A[b e f]) * Er.A[h j]
end

function _action1(El::BilayerLeftTensor{2, 1}, T::MPSTensor{4}, H::LocalOperator{2, 1}, Er::BilayerRightTensor{1, 1})::MPSTensor{4}
	c = H.strength[]
	return @tensor tmp[a e; k j] := c * ((El.A[a b c] * T.A[c f k h]) * H.A[b e f]) * Er.A[h j]
end

function _action1(El::BilayerLeftTensor{2, 1}, T::MPSTensor{5}, H::LocalOperator{2, 1}, Er::BilayerRightTensor{1, 1})::MPSTensor{5}
	c = H.strength[]
	return @tensor tmp[a e; k l j] := c * ((El.A[a b c] * T.A[c f k l h]) * H.A[b e f]) * Er.A[h j]
end

function _action1(El::BilayerLeftTensor{2, 1}, T::MPSTensor{3}, H::IdentityOperator, Er::BilayerRightTensor{1, 2})::MPSTensor{3}
	c = H.strength[]
	return @tensor tmp[a f; j] := c * (El.A[a b c] * T.A[c f h]) * Er.A[h b j]
end

function _action1(El::BilayerLeftTensor{2, 1}, T::MPSTensor{4}, H::IdentityOperator, Er::BilayerRightTensor{1, 2})::MPSTensor{4}
	c = H.strength[]
	return @tensor tmp[a f; k j] := c * (El.A[a b c] * T.A[c f k h]) * Er.A[h b j]
end

function _action1(El::BilayerLeftTensor{2, 1}, T::MPSTensor{3}, H::LocalOperator{1, 1}, Er::BilayerRightTensor{1, 2})::MPSTensor{3}
	c = H.strength[]
	return @tensor tmp[a e; j] := c * (El.A[a b c] * (H.A[e f] * T.A[c f h])) * Er.A[h b j]
end

function _action1(El::BilayerLeftTensor{2, 1}, T::MPSTensor{4}, H::LocalOperator{1, 1}, Er::BilayerRightTensor{1, 2})::MPSTensor{4}
	c = H.strength[]
	return @tensor tmp[a e; k j] := c * (El.A[a b c] * (H.A[e f] * T.A[c f k h])) * Er.A[h b j]
end

function _action1(El::BilayerLeftTensor{2, 1}, T::MPSTensor{3}, H::LocalOperator{2, 2}, Er::BilayerRightTensor{1, 2})::MPSTensor{3}
	c = H.strength[]
	return @tensor tmp[a e; j] := c * ((El.A[a b c] * T.A[c f h]) * H.A[b e f i]) * Er.A[h i j]
end

function _action1(El::BilayerLeftTensor{2, 1}, T::MPSTensor{4}, H::LocalOperator{2, 2}, Er::BilayerRightTensor{1, 2})::MPSTensor{4}
	c = H.strength[]
	return @tensor tmp[a e; k j] := c * ((El.A[a b c] * T.A[c f k h]) * H.A[b e f i]) * Er.A[h i j]
end

function _action1(El::BilayerLeftTensor{2, 1}, T::MPSTensor{5}, H::LocalOperator{1, 1}, Er::BilayerRightTensor{1, 2})::MPSTensor{5}
	c = H.strength[]
	return @tensor tmp[a e; k l j] := c * (El.A[a b c] * (H.A[e f] * T.A[c f k l h])) * Er.A[h b j]
end

function _action1(El::BilayerLeftTensor{2, 2}, T::MPSTensor{3}, H::IdentityOperator, Er::BilayerRightTensor{1, 2})::MPSTensor{4}
	c = H.strength[]
	return @tensor tmp[a f; d j] := c * (T.A[c f h] * Er.A[h b j]) * El.A[a b c d]
end

function _action1(El::BilayerLeftTensor{2, 2}, T::MPSTensor{4}, H::IdentityOperator, Er::BilayerRightTensor{1, 2})::MPSTensor{5}
	c = H.strength[]
	return @tensor tmp[a f; k d j] := c * (T.A[c f k h] * Er.A[h b j]) * El.A[a b c d]
end

function _action1(El::BilayerLeftTensor{2, 2}, T::MPSTensor{3}, H::LocalOperator{2, 2}, Er::BilayerRightTensor{1, 2})::MPSTensor{4}
	c = H.strength[]
	return @tensor tmp[a e; d j] := c * ((T.A[c f h] * Er.A[h i j]) * H.A[b e f i]) * El.A[a b c d]
end

function _action1(El::BilayerLeftTensor{2, 2}, T::MPSTensor{4}, H::LocalOperator{2, 2}, Er::BilayerRightTensor{1, 2})::MPSTensor{5}
	c = H.strength[]
	return @tensor tmp[a e; k d j] := c * ((T.A[c f k h] * Er.A[h i j]) * H.A[b e f i]) * El.A[a b c d]
end

function _action1(El::BilayerLeftTensor{2, 2}, T::MPSTensor{3}, H::LocalOperator{2, 1}, Er::BilayerRightTensor{1, 1})::MPSTensor{4}
	c = H.strength[]
	return @tensor tmp[a e; d j] := c * ((T.A[c f h] * Er.A[h j]) * H.A[b e f]) * El.A[a b c d]
end

function _action1(El::BilayerLeftTensor{2, 2}, T::MPSTensor{4}, H::LocalOperator{2, 1}, Er::BilayerRightTensor{1, 1})::MPSTensor{5}
	c = H.strength[]
	return @tensor tmp[a e; k d j] := c * ((T.A[c f k h] * Er.A[h j]) * H.A[b e f]) * El.A[a b c d]
end

function _action1(El::BilayerLeftTensor{2, 2}, T::MPSTensor{3}, H::LocalOperator{1, 1}, Er::BilayerRightTensor{1, 2})::MPSTensor{4}
	c = H.strength[]
	return @tensor tmp[a e; d j] := c * ((T.A[c f h] * H.A[e f]) * Er.A[h b j]) * El.A[a b c d]
end

# ================ action0 =================
#      --d   e  f--
#     |      |     |
#      --c --S--h--
#     |            |
#     El--b     b--
#     |            |
#      --a      i--
function _action0(El::Vector{Union{Nothing, BilayerLeftTensor}}, S::MPSTensor, Er::Vector{Union{Nothing, BilayerRightTensor}})
	HS = nothing
	for i in 1:length(El)
		tmp = _action0(El[i], S, Er[i])
		if isnothing(HS)
			HS = tmp
		else
			add!(HS, tmp)
		end
	end
	return HS
end

_action0(::Nothing, ::MPSTensor, ::BilayerRightTensor) = nothing
function _action0(El::BilayerLeftTensor{1, 2}, S::MPSTensor{2}, Er::BilayerRightTensor{1, 1})::MPSTensor{3}
	return @tensor tmp[a d; i] := (El.A[a c d] * S.A[c h]) * Er.A[h i]
end
function _action0(El::BilayerLeftTensor{1, 1}, S::MPSTensor{2}, Er::BilayerRightTensor{1, 2})::MPSTensor{3}
	return @tensor tmp[a b; i] := (El.A[a c] * S.A[c h]) * Er.A[h b i]
end
function _action0(El::BilayerLeftTensor{2, 1}, S::MPSTensor{3}, Er::BilayerRightTensor{1, 2})::MPSTensor{3}
	return @tensor tmp[a e; i] := (El.A[a b c] * S.A[c e h]) * Er.A[h b i]
end
function _action0(El::BilayerLeftTensor{1, 1}, S::MPSTensor{3}, Er::BilayerRightTensor{1, 1})::MPSTensor{3}
	return @tensor tmp[a e; i] := (El.A[a c] * S.A[c e h]) * Er.A[h i]
end
