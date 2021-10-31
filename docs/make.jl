using Documenter
using Combinatorics

DocMeta.setdocmeta!(Combinatorics, :DocTestSetup, :(using Combinatorics); recursive=true)

makedocs(
    sitename="Combinatorics.jl",
    repo="github.com/gdalle/Combinatorics.jl/",
    format = Documenter.HTML(
        prettyurls = get(ENV, "CI", nothing) == "true"
    ),
    pages = ["index.md", "api.md"]
)

deploydocs(;
    repo="github.com/gdalle/Combinatorics.jl",
    devbranch="master",
)
