using Pkg

__proj_directory__ = realpath(dirname(@__FILE__)*"/..")

## 0. include libraries

Pkg.activate(realpath(dirname(@__FILE__)*"/.."))
Pkg.instantiate()

using Revise

using DataFrames, CSV
using DataFramesMeta
using AlgebraOfGraphics
using CairoMakie

set_aog_theme!()

axis = (width = 500, height = 500)

include(joinpath(__proj_directory__,"Src","99_functions.jl"))

Rsmpl = CSV.read(joinpath(__proj_directory__,"Results","resample_results.csv"), DataFrame)



Pntws = CSV.read(joinpath(__proj_directory__,"Results","pointwise_results.csv"), DataFrame)


Rsmpl_entropy = @chain Rsmpl begin
    select([:entropy_old, :entropy_new])
    rename([Symbol("2017-2020"), Symbol("2020-2023")])
    stack(variable_name=:Group, value_name=:Entropy)
    data
end 

Rsmpl_dim = @chain Rsmpl begin
    select([:dim_old, :dim_new])
    rename([Symbol("2017-2020"), Symbol("2020-2023")])
    stack([Symbol("2017-2020"), Symbol("2020-2023")], variable_name=:Group, value_name=:Dimension)
    data
end

figu_dim_rsmpl = draw(
    Rsmpl_dim * visual(BoxPlot, show_notch=true) *
    mapping(:Group, :Dimension);
    axis = axis)

figu_entropy_rsmpl = draw(Rsmpl_entropy * visual(BoxPlot, show_notch=true) *
    mapping(:Group, :Entropy);
    axis = axis)

save(joinpath(__proj_directory__,
                "Plots","figu_dim_rsmpl.png"),
        figu_dim_rsmpl,
        px_per_unit = 3)

save(joinpath(__proj_directory__,
                "Plots","figu_entropy_rsmpl.png"),
                figu_entropy_rsmpl,
        px_per_unit = 3)
