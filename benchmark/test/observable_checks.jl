function check_complete_observables(prepared,config,symmetry,klass;spinless=false,check_reference=true)
    (;fixture,bra,ket,template) = prepared
    open = symmetry == "SU2" && klass == "onsite"
    trial_tree = deepcopy(template)
    _oc_calobs(trial_tree,bra,ket,config)
    results = [r[] for refs in values(trial_tree.Refs) for r in values(refs)]
    !isempty(results) && all(isfinite,results) && any(x -> abs(x)>1e-14,results) || return false
    # Independent identity/inner-product and charged-action checks are manual tests.
    if check_reference && klass == "two-site"
        identity_tree = ObservableTree(16)
        addObs!(identity_tree,id(PerformanceFixtures.physical_space(symmetry;spinless)),8;name=:I)
        _oc_calobs(identity_tree,bra,ket,config)
        isapprox(identity_tree.Refs["I"][(8,)][],inner(bra,ket);atol=1e-9,rtol=1e-8) || return false
    elseif check_reference && open
        probe_action = InteractionTree(16)
        addIntr!(probe_action,SU2Spin.SS[2],1,1.0;name=:S)
        probe = TangentMPS(AutomataMPO(probe_action),fixture.base)
        isapprox(trial_tree.Refs["S"][(1,)][],inner(probe,ket);atol=1e-9,rtol=1e-8) || return false
    end
    return true
end
