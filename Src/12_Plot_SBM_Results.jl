using Pkg

__proj_directory__ = realpath(dirname(@__FILE__)*"/..")

## 0. include libraries

Pkg.activate(realpath(dirname(@__FILE__)*"/.."))
Pkg.instantiate()

using Revise

using DataFrames, CSV
using DataFramesMeta
using CategoricalArrays
using AlgebraOfGraphics
using CairoMakie

set_aog_theme!()

axis = (width = 250, height = 250)

include(joinpath(__proj_directory__,"Src","99_functions.jl"))

### Between-groups engagement increase plots

Redrawing = CSV.read(joinpath(__proj_directory__,"Results","sbm_dim.csv"), DataFrame)
Redrawing.Cexternal = categorical(Redrawing.Cexternal)
Redrawing.Cinternal = categorical(Redrawing.Cinternal)

Redrawing_Entropy = @chain Redrawing begin
    select([:Entropy, :Cinternal, :Cexternal])
    rename([Symbol("Entropy"), Symbol("Cᵢ"), Symbol("Cₑ")])
    data
end 

Redrawing_Dimension = @chain Redrawing begin
    select([:Dimension, :Cinternal, :Cexternal])
    rename([Symbol("Dimension"), Symbol("Cᵢ"), Symbol("Cₑ")])
    data
end 



figu_Redrawing_Entropy = draw(
    Redrawing_Entropy *
        visual(BoxPlot, show_notch=true) *
        mapping(:Cₑ, :Entropy, layout=:Cᵢ);
    axis = axis, facet=(; linkxaxes=:none, linkyaxes=:none))

figu_Redrawing_Dimension = draw(
    Redrawing_Dimension  *
        visual(BoxPlot, show_notch=true) *
        mapping(:Cₑ, :Dimension , layout=:Cᵢ);
    axis = axis, facet=(; linkxaxes=:none, linkyaxes=:none))


### Predominance growth plots
    
Predominance = CSV.read(joinpath(__proj_directory__,"Results","sbm_growth_dim.csv"), DataFrame)
Predominance.Predominance = categorical(Predominance.Predominance)
Predominance.Cint = categorical(Predominance.Cint)


Predominance_Dimension = @chain Predominance begin
    select([:Dimension, :Predominance, :Cint])
    rename(:Cint => Symbol("Cᵢ"))
    data
end
    
Predominance_Entropy = @chain Predominance begin
    select([:Entropy, :Predominance, :Cint])
    rename(:Cint => Symbol("Cᵢ"))
    data
end

figu_Predominance_Dimension = draw(
    Predominance_Dimension *
        visual(BoxPlot, show_notch=true) *
        mapping(:Predominance, :Dimension, layout=:Cᵢ);
        axis = axis, facet=(; linkxaxes=:none, linkyaxes=:none))

figu_Predominance_Entropy = draw(
    Predominance_Entropy *
        visual(BoxPlot, show_notch=true) *
        mapping(:Predominance, :Entropy, layout=:Cᵢ);
        axis = axis, facet=(; linkxaxes=:none, linkyaxes=:none))

## Save plots

save(joinpath(__proj_directory__,
        "Plots","figu_Redrawing_Entropy.png"),
    figu_Redrawing_Entropy,
    px_per_unit = 3)

save(joinpath(__proj_directory__,
        "Plots","figu_Redrawing_Dimension.png"),
    figu_Redrawing_Dimension,
    px_per_unit = 3)

    

save(joinpath(__proj_directory__,
        "Plots","figu_Predominance_Entropy.png"),
    figu_Predominance_Entropy,
    px_per_unit = 3)

save(joinpath(__proj_directory__,
        "Plots","figu_Predominance_Dimension.png"),
    figu_Predominance_Dimension,
    px_per_unit = 3)