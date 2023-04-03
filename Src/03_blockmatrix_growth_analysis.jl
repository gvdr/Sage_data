using Pkg

__proj_directory__ = realpath(dirname(@__FILE__)*"/..")

@show __proj_directory__

## 0. include libraries

Pkg.activate(realpath(dirname(@__FILE__)*"/.."))
Pkg.instantiate()

using Revise

using LinearAlgebra
using Graphs
using Random
using DotProductGraphs
using PROPACK
using SparseArrays
using StatsBase
using DataFrames, CSV


include(joinpath(__proj_directory__,"Src","99_functions.jl"))

## 1. 

Nreps = 100
Cints = 0.3:0.05:0.45
cₑ = 0.05

Predominance = [0.5,0.8,0.9,0.99]


results = Matrix{Float32}(undef,Nreps * length(Cints) * length(Predominance),4)

idx = 0
for i in 1:Nreps, cᵢ in Cints, p in Predominance
    @show idx
    global  idx += 1
    σs = stochastic_block_model(cᵢ,cₑ,blocks(p)) |> get_σs
    results[idx,1] = σs |> d_elbow
    results[idx,2] = σs |> Pentropy
    results[idx,3] = p
    results[idx,4] = cᵢ
end

sbm_dim = DataFrame(
    results,
    ["Dimension", "Entropy","Predominance","Cint"]
)

CSV.write(joinpath(__proj_directory__,"Results","sbm_growth_dim.csv"),sbm_dim)

