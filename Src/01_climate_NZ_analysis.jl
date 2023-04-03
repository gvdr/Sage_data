using Pkg

__proj_directory__ = realpath(dirname(@__FILE__)*"/..")

## 0. include libraries

Pkg.activate(realpath(dirname(@__FILE__)*"/.."))
Pkg.instantiate()

using Revise

using LinearAlgebra
using Graphs, GraphIO
using Random
using DotProductGraphs
using PROPACK
using SparseArrays
using StatsBase
using DataFrames, CSV


include(joinpath(__proj_directory__,"Src","99_functions.jl"))

## 1. load graphs to memory

old_all = loadgraph(joinpath(__proj_directory__,"OutData","old_all.edges"), "old_all", EdgeListFormat()) 
new_all = loadgraph(joinpath(__proj_directory__,"OutData","new_all.edges"), "new_all", EdgeListFormat()) 
cc_old = loadgraph(joinpath(__proj_directory__,"OutData","cc_old.edges"), "cc_old", EdgeListFormat()) 
cc_new = loadgraph(joinpath(__proj_directory__,"OutData","cc_new.edges"), "cc_new", EdgeListFormat()) 

## 2. compute results for climate dataset

### 2.1 RDPG embedding dimension

## size of original graphs
old_dim = get_σs(old_all; nonzero = true) |> d_elbow
new_dim = get_σs(new_all; nonzero = true) |> d_elbow

## size of giant components
cc_old_dim = get_σs(cc_old; nonzero = true) |> d_elbow
cc_new_dim = get_σs(cc_new; nonzero = true) |> d_elbow

## size of resampled giant components
bootstrap_old = [get_σs(subsample_connected_graph(old_all); nonzero = true) |> d_elbow for _ in Base.oneto(1000)] 
boostrap_new = [get_σs(subsample_connected_graph(new_all); nonzero = true) |> d_elbow for _ in Base.oneto(1000)] 

mean(bootstrap_old)
mean(bootstrap_new)

## 3. Von Neumann Complexity

entropy_old_all = Pentropy(old_all)
entropy_new_all = Pentropy(new_all)
entropy_cc_old = Pentropy(cc_old)
entropy_cc_new = Pentropy(cc_new)

entropy_bootstrap_old = [subsample_connected_graph(old_all) |> Pentropy for _ in Base.oneto(1000)] 
entropy_boostrap_new = [subsample_connected_graph(new_all) |> Pentropy for _ in Base.oneto(1000)] 

mean(entropy_bootstrap_old)
mean(entropy_boostrap_new)

## 4. Spectral gap

## 5. write results

pointwise_results = DataFrame(
    metric = [
        "dim_old", "dim_new", "dim_gc_old", "dim_gc_old",
        "entropy_old_all", "entropy_old_all", "entropy_gc_old", "entropy_gc_new"
        ],
    value = [
        old_dim, new_dim, cc_old_dim, cc_new_dim,
        entropy_old_all, entropy_new_all, entropy_cc_old, entropy_cc_new
    ]
)

CSV.write(
    joinpath(__proj_directory__,"Results","pointwise_results.csv"),
    pointwise_results
)

resample_results = DataFrame(
    dim_old = bootstrap_old,
    dim_new = boostrap_new,
    entropy_old = entropy_bootstrap_old,
    entropy_new = entropy_boostrap_new
)

CSV.write(
    joinpath(__proj_directory__,"Results","resample_results.csv"),
    resample_results
)