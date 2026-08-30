import FiniteMPSTangents
using Documenter

DocMeta.setdocmeta!(
    FiniteMPSTangents,
    :DocTestSetup,
    quote
        import FiniteMPSTangents
    end;
    recursive=true,
)

makedocs(
    modules=[FiniteMPSTangents],
    authors="Qiaoyi Li",
    sitename="FiniteMPSTangents.jl",
    remotes=nothing,
    checkdocs=:exports,
    format=Documenter.HTML(
        canonical="https://Qiaoyi-Li.github.io/FiniteMPSTangents.jl",
        edit_link="main",
        repolink="https://github.com/Qiaoyi-Li/FiniteMPSTangents.jl",
    ),
    pages=[
        "Home" => "index.md",
        "API" => "api.md",
    ],
)

deploydocs(
    repo="github.com/Qiaoyi-Li/FiniteMPSTangents.jl.git",
    devbranch="main",
)
