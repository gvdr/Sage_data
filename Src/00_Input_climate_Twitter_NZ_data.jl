using Pkg

__proj_directory__ = realpath(dirname(@__FILE__)*"/..")

Pkg.activate(realpath(dirname(@__FILE__)*"/.."))
Pkg.instantiate()

using Revise

using Graphs, GraphIO # to load graph
using ParserCombinator # to use DOT format

include(joinpath(__proj_directory__,"Src","99_functions.jl"))

## 1. read in the two graphs

graph_old = loadgraph(joinpath(__proj_directory__,"RawData","old_clima.dot"), "old", DOTFormat())
graph_new = loadgraph(joinpath(__proj_directory__,"RawData","new_clima.dot"), "new", DOTFormat())

## 2. extract connected components

cc_old = get_giant_component(graph_old)
cc_new = get_giant_component(graph_new)

## 3. write graphs to file

savegraph(joinpath(__proj_directory__,"OutData","old_all.edges"), graph_old, "old_all", EdgeListFormat()) 
savegraph(joinpath(__proj_directory__,"OutData","new_all.edges"), graph_new, "new_all", EdgeListFormat()) 
savegraph(joinpath(__proj_directory__,"OutData","cc_old.edges"), cc_old, "cc_old", EdgeListFormat()) 
savegraph(joinpath(__proj_directory__,"OutData","cc_new.edges"), cc_new, "cc_new", EdgeListFormat()) 
