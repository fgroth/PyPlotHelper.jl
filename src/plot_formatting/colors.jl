using PyPlot

"""
    get_color(i::Int64=1)

returns a color at position i of commonly used color cycle.
"""
function get_color(i::Int64=1)
    if dark_mode_active
        color_cycle = ["red", "green", "turquoise", "blue", "purple", "magenta", "white", "gray"]
    else
        color_cycle = ["red", "green", "turquoise", "blue", "purple", "magenta", "black", "gray"]
    end
    
    return color_cycle[mod(i-1,length(color_cycle))+1] # repeat for numbers outside length
end


"""
    get_colorbar(quantity::String="rho")

returns a colormap typically used for the quantity
"""
function get_colormap(quantity::String="rho")
    if lowercase(quantity) in ["rho", "density", "gas_density"]
        return "plasma"
    else
        error("quantity value not allowed")
    end
end
