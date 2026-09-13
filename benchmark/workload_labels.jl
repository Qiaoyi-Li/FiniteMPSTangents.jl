"Human-readable labels derived from report metadata without changing workload identity."
module WorkloadLabels

export section_name, symmetry_name, workload_title, workload_description,
       workload_facts

const _FAMILIES = Set(("CM","OR","EC","BC","QH","QL","LP","CO","EP","IP","SA","RA","RC"))

function _get(object,key,default=nothing)
    if object isa AbstractDict
        haskey(object,key) && return object[key]
        haskey(object,Symbol(key)) && return object[Symbol(key)]
    elseif object isa NamedTuple
        hasproperty(object,Symbol(key)) && return getproperty(object,Symbol(key))
    end
    return default
end
_text(x) = isnothing(x) ? "" : strip(string(x))
_params(case) = _get(case,"parameters",Dict{String,Any}())
_family(p) = _text(_get(p,"family"))
_sym(p) = _text(_get(p,"symmetry"))
_isproduct(p) = _sym(p) in ("U1xSU2","U1SU2","U(1)×SU(2)","U(1) × SU(2)")
_isspinless(p) = _text(_get(p,"local_space_preset")) in ("U1Fermion","U1SpinlessFermion")

_label(names,value,default) = get(names,_text(value),isempty(_text(value)) ? default : _text(value))
section_name(value) = _label(Dict("basic"=>"Supporting whole-chain operations", "mul"=>"Sparse operator action on tangent vectors",
    "calobs"=>"Complete observable calculations", "stages"=>"Internal calculation stages"),value,"Other benchmark operations")
symmetry_name(value) = _label(Dict("NoSym"=>"No symmetry", "U1"=>"U(1) symmetry",
    "U₁"=>"U(1) symmetry", "U(1)"=>"U(1) symmetry", "SU2"=>"SU(2) symmetry",
    "SU₂"=>"SU(2) symmetry", "SU(2)"=>"SU(2) symmetry",
    "U1xSU2"=>"U(1) × SU(2) symmetry", "U1SU2"=>"U(1) × SU(2) symmetry",
    "U(1)×SU(2)"=>"U(1) × SU(2) symmetry", "U(1) × SU(2)"=>"U(1) × SU(2) symmetry"),
    value,"Unspecified symmetry")

_display(value) = value isa AbstractString && !isempty(strip(value)) ? strip(value) : nothing

# Explicit display text is also used by external suites. A path or a dispatch
# signature is not a useful fallback title, even if stored in `description`.
function _natural(value)
    value isa AbstractString || return nothing
    s = strip(value)
    isempty(s) && return nothing
    occursin(r"(?:\b(?:BC|LP\d*|OR|QH|QL|CM|EC|CO|EP|IP|SA|RA|RC|O11|O12|O21|O22)\b|base\d+-|aux-[CDN]|/v\d+|[A-Za-z0-9_-]+/[A-Za-z0-9_-]+)",s) && return nothing
    return s
end

function _fallback(case,key,default)
    p = _params(case)
    value = _display(_get(p,key))
    !isnothing(value) && return value
    value = _natural(_get(case,"description"))
    return isnothing(value) ? default : value
end

_base_rank(p) = _get(p,"base_rank",nothing)
_base_name(p) = _base_rank(p) == 4 ? "MPO with a purification leg" : _base_rank(p) == 3 ? "ordinary MPS" :
    _base_rank(p) isa Integer && _base_rank(p)>0 ? "rank-"*string(_base_rank(p))*" base tensor" : "tensor network"

function _ranks(p)
    base,center = _base_rank(p),_get(p,"center_rank",_base_rank(p))
    bra,ket = center,center
    b = _get(p,"actual_bra_center_ranks",nothing)
    k = _get(p,"actual_ket_center_ranks",nothing)
    !isnothing(b) && !isempty(b) && (bra=first(b))
    !isnothing(k) && !isempty(k) && (ket=first(k))
    bc,kc = _get(p,"bra_extra_charge",nothing),_get(p,"ket_extra_charge",nothing)
    !isnothing(base) && bc isa Bool && (bra=base+Int(bc))
    !isnothing(base) && kc isa Bool && (ket=base+Int(kc))
    if isnothing(b) && _family(p)=="CO" && _sym(p)=="SU2" && _get(p,"operator_class")=="onsite"
        bra=base
    end
    # Registration metadata predates the measured per-layer fields in some reports.
    if _family(p)=="LP" && isnothing(bc) && isnothing(kc)
        m=match(r"-bra(\d+)-ket(\d+)",_text(_get(p,"configuration")))
        !isnothing(m) && ((bra,ket)=(parse(Int,m[1]),parse(Int,m[2])))
    end
    return base,bra,ket
end

function _leg_roles(p)
    base,bra,ket=_ranks(p)
    isnothing(base) && return ""
    if !(base in (3,4)) || any(r->!isnothing(r) && !(r in (base,base+1)),(bra,ket))
        return "rank-$(bra) bra center and rank-$(ket) ket center; extra leg roles defined by the workload"
    end
    b=!isnothing(bra) && bra>base
    k=!isnothing(ket) && ket>base
    leg=_sym(p)=="NoSym" ? "component leg" : "charge leg"
    b && k && return "bra and ket each have an extra $(leg)"
    b && return "bra has an extra $(leg); ket has no extra leg"
    k && return "bra has no extra leg; ket has an extra $(leg)"
    return "no extra center legs"
end

function _rank_delta(base,rank)
    difference=rank-base
    difference==0 && return "the same number of legs as the base tensor"
    difference>0 && return "$(difference) more legs than the base tensor"
    return "$(-difference) fewer legs than the base tensor"
end

function _single_center(p)
    base,center=_base_rank(p),_get(p,"center_rank")
    (isnothing(base) || isnothing(center)) && return "tangent center"
    if !(base in (3,4)) || !(center in (base,base+1))
        return "rank-$(center) tangent center, "*_rank_delta(base,center)*" (leg roles defined by the workload)"
    end
    center==base && return "tangent center with no extra leg"
    return _sym(p)=="NoSym" ? "tangent center with an extra component leg" : "tangent center with an extra charge leg"
end

function _layout(p)
    _family(p) in ("BC","EC","EP") && return _base_name(p)
    _family(p) in ("CM","OR","SA","RA","RC") && return _base_name(p)*", "*_single_center(p)
    return _base_name(p)*", "*_leg_roles(p)
end

_direction(p) = get(Dict("right"=>"rightward","left"=>"leftward"),_text(_get(p,"direction")),"")

function _operator_action(p)
    op=_text(_get(p,"operator"))
    op=="I" && return "identity operator"
    op=="O11" && return "single-site operator without auxiliary legs"
    op=="O22" && return "propagation of an existing operator auxiliary channel"
    if op in ("O12","O21")
        right=_get(p,"direction")=="right"
        opening=(op=="O12" && right)||(op=="O21" && !right)
        return opening ? "opening an operator auxiliary channel" : "closing an operator auxiliary channel"
    end
    return "local operator"
end

_half(n) = iseven(n) ? string(n÷2) : string(n)*"/2"
function _sector_quantities(row,sym)
    charge,spin=_get(row,"charge_twice"),_get(row,"spin_twice")
    q=isnothing(charge) ? nothing : _half(charge)
    j=isnothing(spin) ? nothing : _half(spin)
    if isnothing(q) && isnothing(j)
        m=match(r"\]\(([^)]*)\)$",_text(_get(row,"label")))
        if !isnothing(m)
            values=strip.(split(m[1],','))
            if sym in ("U1xSU2","U1SU2") && length(values)==2
                q,j=values
            elseif sym=="U1" && length(values)==1
                q=values[1]
            elseif sym=="SU2" && length(values)==1
                j=values[1]
            end
        end
    end
    return q,j
end

function _sector_text(row,sym; multiplicity=true)
    q,j=_sector_quantities(row,sym)
    parts=String[]
    !isnothing(q) && push!(parts,"charge q="*q)
    !isnothing(j) && push!(parts,"spin j="*j)
    isempty(parts) && return ""
    result=join(parts,", ")
    count=_get(row,"multiplicity")
    multiplicity && !isnothing(count) && (result*=", multiplicity "*string(count))
    return result
end

function _space_text(space,sym; multiplicity=true)
    isnothing(space) && return "not used"
    dim=_get(space,"full_dimension")
    rows=[_sector_text(r,sym;multiplicity) for r in _get(space,"sectors",Any[])]
    filter!(!isempty,rows)
    prefix=isnothing(dim) ? "" : "dimension "*string(dim)
    isempty(rows) && return isempty(prefix) ? "dimension not recorded" : prefix
    return isempty(prefix) ? join(rows,"; ") : prefix*"; "*join(rows,"; ")
end

function _aux_title(p)
    space=_get(p,"auxiliary_space")
    isnothing(space) && return ""
    rows=[_sector_text(r,_sym(p);multiplicity=false) for r in _get(space,"sectors",Any[])]
    filter!(!isempty,rows)
    detail=isempty(rows) ? "dimension "*string(_get(space,"full_dimension","not recorded")) : join(rows,"; ")
    placement=get(Dict("C"=>"on the incoming environment's output side","D"=>"on the incoming environment's input side","N"=>"incoming environment has no auxiliary leg"),
                  _text(_get(p,"incoming_auxiliary_placement")),"")
    return "auxiliary space ("*detail*")"*(isempty(placement) ? "" : ", "*placement)
end

function _model_name(p)
    model=_text(_get(p,"model"))
    model=="TFI" && return "transverse-field Ising model"
    model=="XXZ" && return "anisotropic Heisenberg spin model"
    model=="Heisenberg" && return "Heisenberg spin model"
    model=="Hubbard" && return "Hubbard fermion model"
    _family(p)=="EC" && return "Heisenberg spin model"
    return "specified model"
end

function _observable_class(p)
    kind=_text(_get(p,"operator_class"))
    kind=="onsite" && return _sym(p)=="SU2" ? "single-site matrix elements with an open spin channel" : "single-site observables"
    kind=="two-site" && return "two-site correlations"
    kind=="multisite" && return "multisite correlations"
    kind=="multisite-extra" && return "singlet pairing and spin-bond correlations"
    kind=="mixed" && return _sym(p)=="SU2" ? "combined two-site and four-site correlations" : "combined observables across different numbers of sites"
    return "observables"
end

function _physical_name(p)
    _isspinless(p) && return "spinless fermions"
    _isproduct(p) && return "spinful fermions"
    _sym(p) in ("NoSym","U1","SU2") && return "spin one-half"
    return "registered local physical states"
end

"A workload title shared by all its D values and thread configurations."
function workload_title(case)
    p=_params(case)
    custom=_display(_get(p,"display_title"))
    !isnothing(custom) && return custom
    family=_family(p)
    family in _FAMILIES || return _fallback(case,"display_title","Benchmark operation")
    if family=="CM"
        return join(("Sparse operator action",_model_name(p),_layout(p))," · ")
    elseif family=="OR"
        return join(("Left orthogonal projection of a tangent vector",_layout(p))," · ")
    elseif family=="EC"
        return join(("Full-chain environment construction",_model_name(p),_base_name(p))," · ")
    elseif family=="BC"
        return join(("Left and right canonicalization of base tensors",_base_name(p))," · ")
    elseif family=="EP"
        return join(filter(!isempty,["Complete sparse environment-vector propagation",_direction(p),_model_name(p),_base_name(p)])," · ")
    elseif family=="IP"
        return join(("Whole-chain inner product of two tangent vectors",_layout(p))," · ")
    elseif family=="SA"
        return join(("Complete effective single-site operator action",_model_name(p),_layout(p))," · ")
    elseif family=="RA"
        return join(filter(!isempty,["Recursive tangent environment-vector propagation",_direction(p),_model_name(p),_layout(p)])," · ")
    elseif family=="RC"
        return join(filter(!isempty,["Contraction and reduction of recursive environments into a tangent center",_direction(p),_model_name(p),_layout(p)])," · ")
    elseif family=="QH"
        return join(("Operator action on four half-environment components",_layout(p))," · ")
    elseif family=="QL"
        return join(("Complete closure of left and right environments",_leg_roles(p),"with an operator auxiliary channel")," · ")
    elseif family=="LP"
        pieces=["Local environment propagation",_layout(p),_direction(p),_operator_action(p),_aux_title(p)]
        return join(filter(!isempty,pieces)," · ")
    else
        return join(("Complete observable calculation",_physical_name(p),_observable_class(p),_layout(p))," · ")
    end
end

"One sentence explaining the timed operation."
function workload_description(case)
    p=_params(case)
    custom=_display(_get(p,"display_description"))
    !isnothing(custom) && return custom
    family=_family(p)
    family=="CM" && return "Apply a sparse MPO to a tangent vector over the full chain using prebuilt environments, including accumulation from both directions and the final orthogonal projection."
    family=="OR" && return "Starting from an unprojected tangent vector, apply the left orthogonal projection to every nonterminal center tensor while retaining the component along the base state."
    family=="EC" && return "Build left and right environments over the full chain from an MPO base and the Heisenberg operator, including contraction and allocation; environment cleanup is outside the timed region."
    family=="BC" && return "Construct the base tensor's canonical forms through left and right orthogonal factorizations and contractions, including the associated copying and memory allocation."
    family=="EP" && return "Advance the complete sparse environment vector one site "*_direction(p)*" using the base tensor and the model's sparse operator matrix, contracting all active transitions and accumulating their contributions into the output channels."
    family=="IP" && return "Compute the inner product of two independently generated tangent vectors with matching tensor layouts, a shared base, and the same tangent space, contracting corresponding center tensors and reducing their contributions over the full chain. No operator is applied."
    family=="SA" && return "Apply the complete effective sparse operator at one site to a tangent center, contracting the left and right environment vectors and accumulating the contributions from all active operator transitions."
    family=="RA" && return "Propagate the complete recursive tangent environment vector one site "*_direction(p)*", combining the local base and tangent tensors to produce both the propagated vector and partial contributions for the subsequent center reduction."
    family=="RC" && return "Contract the complete vector of precomputed recursive environment partials with the opposite-side base environments, then reduce the channel contributions into one tangent center. Preparation of the partials is outside the timed region."
    family=="QH" && return "Apply a local operator with input and output auxiliary legs to four precomputed half-environment components: each contracts the site tensor on one side only and records whether the bra and ket tangent insertions have occurred."
    family=="QL" && return "Contract four complementary pairs of left and right environments, covering all tangent insertion distributions, and sum their contributions into one scalar."
    family=="LP" && return "Advance the environment one site "*_direction(p)*" (local action: "*_operator_action(p)*"), including all four components that record whether the bra and ket tangent insertions have occurred."
    family=="CO" && return "Calculate the registered "*_observable_class(p)*" over the full chain, including observable-tree merging, environment contractions, and result storage."
    return _fallback(case,"display_description","Execute the benchmark operation defined by this workload.")
end

const _OBSERVABLE_NAMES=Dict(
    "Sz"=>"longitudinal spin component", "Sx"=>"transverse spin component", "SzSz"=>"longitudinal spin correlation",
    "SpSm"=>"spin raising-lowering correlation", "SmSp"=>"spin lowering-raising correlation",
    "SzSzSz"=>"three-site longitudinal spin correlation", "SzSzSzSz"=>"four-site longitudinal spin correlation",
    "SpSpSmSm"=>"four-site correlation of two spin raising and two spin lowering operators",
    "S"=>"matrix element with an open spin channel", "SS"=>"spin dot-product correlation",
    "SSSS"=>"four-site correlation of two spin dot products", "SSS"=>"spin chirality correlation with the preset's negative-i convention",
    "n"=>"particle number", "nd"=>"double occupancy", "FdagF"=>"particle creation-annihilation correlation",
    "FFdag"=>"particle annihilation-creation correlation", "CpCm"=>"local pair creation-annihilation correlation",
    "TripletPair"=>"triplet pairing correlation", "SingletPair"=>"singlet pairing correlation",
    "SBSB"=>"correlation between spin bonds", "Pair"=>"spinless fermion pairing correlation",
    "FdagNF"=>"particle creation-annihilation correlation with a density insertion")

function _rank_description(rank,base,sym; center=false)
    isnothing(rank) && return "not recorded"
    if !center
        rank==3 && return "rank 3: left virtual bond, physical leg, and right virtual bond"
        rank==4 && return "rank 4: left virtual bond, physical leg, purification leg, and right virtual bond"
        return "rank $(rank), with $(rank) legs; leg roles are defined by the workload"
    end
    if !(base in (3,4)) || !(rank in (base,base+1))
        extra=isnothing(base) ? "" : "; "*_rank_delta(base,rank)
        return "rank $(rank), with $(rank) legs"*extra*"; leg roles are defined by the workload"
    end
    extra=!isnothing(base) && rank>base
    role=sym=="NoSym" ? "extra component leg" : "extra global charge leg"
    legs=base==4 ? "physical and purification legs" : "a physical leg"
    return string(rank)*" legs, including "*legs*(extra ? " and an "*role : "; no extra center leg")
end

function _observable_facts!(facts,p)
    defs=_get(p,"observable_definitions",Any[])
    names=unique([get(_OBSERVABLE_NAMES,_text(_get(d,"name")),"other registered observable") for d in defs])
    !isempty(names) && push!(facts,"Observable definitions"=>join(names,"; "))
    count=_get(p,"observable_count")
    !isnothing(count) && push!(facts,"Number of registered observable values"=>count)
    for n in sort(unique(length(_get(d,"sites",Any[])) for d in defs))
        sites=unique([Tuple(_get(d,"sites",Any[])) for d in defs if length(_get(d,"sites",Any[]))==n])
        label=n==1 ? "Single-site measurement positions" : string(n)*"-site measurement positions"
        text=join([n==1 ? string(first(s)) : "("*join(s,", ")*")" for s in sites],", ")
        !isempty(text) && push!(facts,label=>text)
    end
    widths=_get(p,"merged_tree_widths")
    !isnothing(widths) && length(widths)==2 && push!(facts,"Merged observable-tree widths"=>"left $(widths[1]), right $(widths[2])")
    nodesleft,nodesright=_get(p,"merged_left_nodes"),_get(p,"merged_right_nodes")
    !isnothing(nodesleft) && !isnothing(nodesright) && push!(facts,"Merged observable-tree node counts"=>"left $(nodesleft), right $(nodesright)")
    any(d->any(==(true),_get(d,"fermionic",Any[])),defs) &&
        push!(facts,"Fermionic sign convention"=>"Fermionic operator strings include particle-number parity strings and preserve the preset's operator ordering and signs")
    if _sym(p)=="SU2" && _get(p,"operator_class")=="onsite"
        push!(facts,"Open-channel closure"=>"The operator's spin-1 auxiliary leg contracts with the extra spin-1 charge leg on the ket center")
        push!(facts,"Ket preparation"=>"Apply a spin operator with nonuniform site coefficients to the random base state, avoiding the identically zero action of total spin on a singlet")
    end
end

function _propagation_facts!(facts,p)
    identity_label=_family(p)=="EP" ? "Reachable identity transitions" : "Identity transitions in the operator matrix"
    local_operator_label=_family(p)=="EP" ? "Reachable local-operator transitions" : "Local tensor-operator transitions in the operator matrix"
    for (key,label) in (("input_bond_dimension","Input virtual bond dimension"),
        ("output_bond_dimension","Output virtual bond dimension"),
        ("input_environment_channels","Input environment channels"),
        ("output_environment_channels","Output environment channels"),
        ("active_input_channels","Active input channels"),
        ("active_output_channels","Active output channels"),
        ("local_mpo_nonempty_transitions","Nonempty sparse-operator transitions"),
        ("reachable_transition_count","Reachable sparse-operator transitions"),
        ("identity_transition_count",identity_label),
        ("local_operator_transition_count",local_operator_label))
        value=_get(p,key)
        !isnothing(value) && push!(facts,label=>value)
    end
    for (key,label) in (("local_left_space","Left virtual space at this site"),
                        ("local_right_space","Right virtual space at this site"))
        space=_get(p,key)
        !isnothing(space) && push!(facts,label=>_space_text(space,_sym(p)))
    end
end

function _multiplication_stage_facts!(facts,p)
    for (key,label) in (("left_environment_channels","Left base-environment channels"),
        ("right_environment_channels","Right base-environment channels"),
        ("active_left_channels","Active left base-environment channels"),
        ("active_right_channels","Active right base-environment channels"),
        ("partial_environment_channels","Partial-environment channels"),
        ("active_partial_channels","Active partial-environment channels"),
        ("active_reduction_channels","Active channels included in the center reduction"),
        ("local_center_rank","Measured tangent center rank"),
        ("local_center_norm_relative_to_tangent","Local center norm relative to the full tangent"),
        ("partial_preparation_site","Site used to prepare the partial environments before timing"))
        value=_get(p,key)
        !isnothing(value) && push!(facts,label=>value)
    end
    shape=_get(p,"local_mpo_shape")
    !isnothing(shape) && length(shape)==2 && push!(facts,"Local sparse-operator matrix shape"=>"$(shape[1]) rows × $(shape[2]) columns")
    spaces=_get(p,"local_center_leg_spaces")
    if !isnothing(spaces)
        text=join(["leg $index: "*_space_text(space,_sym(p)) for (index,space) in enumerate(spaces)],"; ")
        push!(facts,"Tangent center leg spaces (output legs followed by input legs)"=>text)
    end
    sites=_get(p,"preparation_site_indices")
    !isnothing(sites) && push!(facts,"Sites visited to prepare the incoming recursion before timing"=>
        (isempty(sites) ? "No incoming tangent recursion is needed" : join(sites,", ")))
    preparation=_display(_get(p,"base_environment_preparation"))
    !isnothing(preparation) && push!(facts,"Base-environment preparation"=>preparation)
end

function _inner_product_facts!(facts,p)
    for (key,label) in (("vector_count","Number of input tangent vectors"),
                        ("reduction_sites","Sites included in the reduction"),
                        ("stored_tensor_entries_per_vector","Stored tensor entries per input vector"))
        value=_get(p,key)
        !isnothing(value) && push!(facts,label=>(value isa AbstractVector ? join(value,", ") : value))
    end
    preparation=_display(_get(p,"tangent_pair_preparation"))
    !isnothing(preparation) && push!(facts,"Tangent pair preparation"=>get(Dict(
        "independent seeded random tangents on a shared base"=>"Two independently generated random tangent vectors, using a fixed seed and a shared base"),preparation,uppercasefirst(preparation)))
    convention=_display(_get(p,"inner_product_convention"))
    !isnothing(convention) && push!(facts,"Inner-product convention"=>get(Dict(
        "left-orthogonal tangent gauge"=>"Sum of local center-tensor inner products in the left-orthogonal tangent gauge"),convention,uppercasefirst(convention)))
end

"Readable facts; values are display-ready scalar text or numbers, never raw metadata objects."
function workload_facts(case)::Vector{Pair{String,Any}}
    p=_params(case)
    family=_family(p)
    facts=Pair{String,Any}[]
    family in _FAMILIES || return facts
    push!(facts,"Symmetry"=>symmetry_name(_sym(p)))
    scope=_display(_get(p,"operation_scope"))
    !isnothing(scope) && push!(facts,"Operation scope"=>get(Dict("full_chain"=>"Whole chain",
        "complete_sparse_site_stage"=>"One complete sparse calculation stage at a single site"),scope,uppercasefirst(replace(scope,'_'=>' '))))
    stage=_display(_get(p,"stage"))
    !isnothing(stage) && push!(facts,"Multiplication stage"=>get(Dict(
        "effective_site_action"=>"Complete effective single-site operator action",
        "tangent_recursion"=>"Recursive tangent environment-vector propagation",
        "center_reduction"=>"Contraction and reduction into a tangent center"),stage,uppercasefirst(replace(stage,'_'=>' '))))
    !isnothing(_get(p,"actual_D")) && push!(facts,"Center bond dimension"=>_get(p,"actual_D"))
    push!(facts,"Meaning of center bond dimension"=>"Full virtual-space dimension: sum each symmetry sector's multiplicity times its irreducible representation dimension")
    base,bra,ket=_ranks(p)
    if family!="QL"
        push!(facts,"Base tensor"=>_rank_description(base,base,_sym(p)))
        if family in ("CM","OR","SA","RA","RC")
            push!(facts,"Tangent center tensor"=>_rank_description(_get(p,"center_rank"),base,_sym(p);center=true))
        elseif !(family in ("BC","EC","EP"))
            push!(facts,"Bra center tensor"=>_rank_description(bra,base,_sym(p);center=true))
            push!(facts,"Ket center tensor"=>_rank_description(ket,base,_sym(p);center=true))
        end
    else
        push!(facts,"Global charge legs"=>_leg_roles(p))
        push!(facts,"Environment pairing"=>"Four complementary pairs cover every distribution of one bra tangent insertion and one ket tangent insertion across the cut")
    end
    physical=_get(p,"physical_space")
    !isnothing(physical) && push!(facts,"Physical leg"=>_physical_name(p)*"; "*_space_text(physical,_sym(p)))
    purification=_get(p,"purification_space")
    !isnothing(purification) && push!(facts,"Purification leg"=>"An additional local degree of freedom using the same space as the physical leg; "*_space_text(purification,_sym(p)))
    if !(family in ("BC","EC","EP")) && base in (3,4) && (bra==base+1 || ket==base+1)
        charge=_get(p,"charge_space")
        label=_sym(p)=="NoSym" ? "Extra component leg" : "Extra global charge leg"
        push!(facts,label=>
            (_sym(p)=="NoSym" ? "An open component index that does not represent a nontrivial symmetry charge; " : "Attached to the tangent center, separately from virtual bonds and operator auxiliary legs; ")*_space_text(charge,_sym(p)))
    end
    auxiliary=_get(p,"auxiliary_space")
    !isnothing(auxiliary) && push!(facts,"Operator auxiliary space"=>_space_text(auxiliary,_sym(p)))
    if family in ("LP","EP","SA","RA","RC")
        direction_label=family=="RC" ? "Recursive environment direction" : "Propagation direction"
        !isempty(_direction(p)) && push!(facts,direction_label=>_direction(p))
        !isnothing(_get(p,"local_site")) && push!(facts,"Local site index"=>_get(p,"local_site"))
    end
    family in ("EP","SA","RA","RC") && _propagation_facts!(facts,p)
    family in ("SA","RA","RC") && _multiplication_stage_facts!(facts,p)
    family=="IP" && _inner_product_facts!(facts,p)
    if family=="LP"
        push!(facts,"Local operator action"=>_operator_action(p))
        structure=get(Dict("I"=>"Identity operator, leaving the physical state unchanged",
            "O11"=>"One physical input leg and one physical output leg",
            "O12"=>"Two input legs and one output leg; one input is an operator auxiliary leg",
            "O21"=>"One input leg and two output legs; one output is an operator auxiliary leg",
            "O22"=>"One physical input, one physical output, one auxiliary input, and one auxiliary output leg"),_text(_get(p,"operator")),"not recorded")
        push!(facts,"Operator leg structure"=>structure)
        placement=get(Dict("C"=>"Tensor output side (codomain)","D"=>"Tensor input side (domain)","N"=>"No auxiliary leg yet"),
                      _text(_get(p,"incoming_auxiliary_placement")),"not recorded")
        push!(facts,"Auxiliary leg position in the incoming environment"=>placement)
        incoming=_get(p,"incoming_auxiliary_space")
        !isnothing(incoming) && push!(facts,"Actual auxiliary space of the incoming environment"=>_space_text(incoming,_sym(p)))
    end
    lengthvalue=_get(p,"length")
    !isnothing(lengthvalue) && push!(facts,"Chain length (number of sites)"=>lengthvalue)
    schedule=_get(p,"bond_schedule",Any[])
    if !isempty(schedule)
        cuts=[string(_get(s,"cut_after_site"))*"→"*string(_get(s,"full_dimension")) for s in schedule]
        push!(facts,"Actual virtual bond dimensions (cut after site → dimension)"=>join(cuts,", "))
        center=findfirst(s->_get(s,"cut_after_site")==8,schedule)
        !isnothing(center) && _sym(p)!="NoSym" &&
            push!(facts,"Central bond sector allocation"=>_space_text(schedule[center],_sym(p)))
    end
    if family in ("CM","EC","EP","SA","RA","RC")
        push!(facts,"Model"=>_model_name(p))
        distances=_get(p,"interaction_distances",family=="EC" ? [1,2] : nothing)
        !isnothing(distances) && push!(facts,"Two-site interaction distances"=>join(distances,", ")*" lattice spacings")
        coefficients=_get(p,"model_parameters",family=="EC" ? Dict("J1"=>1.0,"J2"=>0.2) : Dict())
        for (key,label) in (("J1","Nearest-neighbor spin coupling"),("J2","Next-nearest-neighbor spin coupling"),
            ("Delta","Longitudinal exchange anisotropy"),("h","Transverse field strength"),("t1","Nearest-neighbor hopping amplitude"),
            ("t2","Next-nearest-neighbor hopping amplitude"),("U","On-site interaction strength"),("mu","Chemical potential"))
            value=_get(coefficients,key)
            !isnothing(value) && push!(facts,label=>value)
        end
        family=="CM" && push!(facts,"Environment reuse"=>"Reuse prebuilt environments for the same base state and operator; environment construction is outside this workload's timed region")
    end
    family in ("QH","LP") && push!(facts,"Meaning of the four environment components"=>"Neither tangent inserted, only the bra tangent inserted, only the ket tangent inserted, or both tangents inserted")
    family=="QH" && push!(facts,"Preparation before timing"=>"Contract the site tensor on one side to obtain half-environments; time only operator action and allocation of its result tensors")
    family=="OR" && push!(facts,"Sample starting point"=>"Each sample starts from the same unprojected tangent vector, without repeatedly projecting previously processed data")
    if family=="CO"
        push!(facts,"Observable class"=>_observable_class(p))
        _observable_facts!(facts,p)
        push!(facts,"Observable-tree reset"=>"Each sample starts from the same unmerged observable tree; merging is included in the timed region")
        push!(facts,"Result normalization"=>"No additional division by the bra or ket norm")
    end
    return facts
end

end # module WorkloadLabels
