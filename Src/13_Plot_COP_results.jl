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
using ColorSchemes
using Colors


set_aog_theme!()

axis = (width = 250, height = 250)
axis2 = (width = 500, height = 500, yscale = log10, )


include(joinpath(__proj_directory__,"Src","99_functions.jl"));

### Summary metrics data on COP dataset

Elbowsth = CSV.read(joinpath(__proj_directory__,"Results","COP_elbows_gc_1000.csv"), DataFrame)
Elbowsth.COP = categorical(Elbowsth.Year)
Elbowsth_data = data(Elbowsth)

figu_COP_dimension = draw(
    Elbowsth_data *
        visual(Scatter, show_notch=true) *
        mapping(:COP, :Dimension);
        axis = (width = 250,
        height = 250,
        title = "Dimension of Conversation networks"))

figu_COP_entropy = draw(
    Elbowsth_data *
        visual(Scatter, show_notch=true) *
        mapping(:COP, :Entropy);
        axis = (width = 250,
        height = 250,
        title = "Entropy of Conversation networks"))

SpectralGap = draw(
    Elbowsth_data *
        visual(Scatter, show_notch=true) *
        mapping(:COP, :SpectralGap => :Gap);
        axis = (width = 250,
        height = 250,
        title = "Spectral Gaph of Conversation networks"))

### SVD distro plot
    
SVDs = CSV.read(joinpath(__proj_directory__,"Results","svd_vals_gc_1000.csv"), DataFrame)
SVDs = SVDs[1:15,:]
SVDs.index = collect(1:nrow(SVDs))

SVDs_Data = @chain SVDs begin
    stack(Not([:index]),variable_name=:COP,value_name=:σ)
    data
end
    
color_list = collect(cgrad(:BrBG_7,7))

figu_SVDs = draw(
    SVDs_Data *
        visual(Lines) *
        mapping(:index, :σ, color=:COP);
        axis = (width = 300,
        height = 300,
        yscale = log10,
        title = "First 15 Singular Values")
        )


## Save plots

save(joinpath(__proj_directory__,
        "Plots","figu_COP_dimension.png"),
        figu_COP_dimension,
    px_per_unit = 3)

save(joinpath(__proj_directory__,
    "Plots","figu_COP_entropy.png"),
    figu_COP_entropy,
    px_per_unit = 3)