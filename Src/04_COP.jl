using Pkg

__proj_directory__ = realpath(dirname(@__FILE__)*"/..")

Pkg.activate(realpath(dirname(@__FILE__)*"/.."))
Pkg.instantiate()

using Revise

using Graphs, GraphIO # to load graph
using ParserCombinator # to use DOT format
using PROPACK
using KrylovKit
using SparseArrays
using DotProductGraphs
using CSV, DataFrames
#using IterativeSolvers

include(joinpath(__proj_directory__,"Src","99_functions.jl"))


## 1. read in the two graphs

# K = 100
# years = 20:26
# elbows = zeros(Float32,length(years),2)
# svd_vals = zeros(Float32,K,length(years))
# for i in Base.oneto(length(years))
#     year = years[i]
#     @show year
#     this_year_csv = joinpath(__proj_directory__,"RawData","COP","cop"*string(year)*"_min10.csv")
#     this_year_adja = adjm_from_edge_list(this_year_csv)
#     _, _, rvecsstart, _ = svdsolve(this_year_adja)
#     adjavals, _ = svdsolve(this_year_adja,rvecsstart[1],K; krylovdim = K)
#     adjavals /= sum(adjavals)
#     this_year_dim =  d_elbow(adjavals)

#     @show this_year_dim

#     elbows[i,1] = year
#     elbows[i,2] = this_year_dim

# end

# elbows_df = DataFrame(
#     elbows,
#     [:Year,:Dimension]
# )

# elbows_df.Year = Int.(elbows_df.Year)

# CSV.write(joinpath(__proj_directory__,"Results","COP_100_elbows.csv"),elbows_df)


K = 1000

@show "COP_elbows_gc_$K.csv"
years = 20:26
elbows_gc_t = zeros(Float32,length(years),4)
svd_vals_gc_t = zeros(Float32,K,length(years))
for i in Base.oneto(length(years))
    year = years[i]
    @show year
    this_year_csv = joinpath(__proj_directory__,"RawData","COP","cop"*string(year)*"_min10.csv")
    this_year_adja = adjm_from_edge_list(this_year_csv; giant_component = true)
     _, _, rvecsstart, _ = svdsolve(this_year_adja)
    adjavals_gc, _ = svdsolve(this_year_adja,rvecsstart[1],K; krylovdim = K)
    #adjavals_gc, _ = svdl(this_year_adja;nsv = K, log = false)
    adjavals_gc /= sum(adjavals_gc)
    this_year_dim_gc =  d_elbow(adjavals_gc)
    this_year_entropy_gc =  Pentropy(adjavals_gc)
    this_year_sg_gc = spectral_gap(adjavals_gc)

    @show this_year_dim_gc, this_year_entropy_gc, this_year_sg_gc

    svd_vals_gc_t[:,i] = adjavals_gc
    elbows_gc_t[i,1] = year
    elbows_gc_t[i,2] = this_year_dim_gc
    elbows_gc_t[i,3] = this_year_entropy_gc
    elbows_gc_t[i,4] = this_year_sg_gc


end

elbows_gc_t_df = DataFrame(
    elbows_gc_t,
    [:Year,:Dimension,:Entropy,:SpectralGap]
)

elbows_gc_t_df.Year = Int.(elbows_gc_t_df.Year)

CSV.write(joinpath(__proj_directory__,"Results","COP_elbows_gc_$K.csv"),elbows_gc_t_df)

svd_vals_gc_t_df = DataFrame(
    svd_vals_gc_t,
    Symbol.("COP".*string.(years))
)

CSV.write(joinpath(__proj_directory__,"Results","svd_vals_gc_$K.csv"),svd_vals_gc_t_df)
