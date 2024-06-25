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
    get_colormap(quantity::String="rho")

returns a colormap typically used for the quantity
"""
function get_colormap(quantity::String="rho")
    if lowercase(quantity) in ["rho", "density", "gas_density"]
        return "inferno" #"plasma"
    elseif lowercase(quantity) in ["t(u)","t","temp"]
        return "inferno"
    else
        error("quantity value not allowed")
    end
end

"""
    main_color()

Return `"white"` for dark-mode, `"black"` for light-mode.
"""
function main_color()
    if dark_mode_active
        return "white"
    else
        return "black"
    end
end

"""
    background_color()

Return `"black"` for dark-mode, `"white"` for light-mode.
"""
function background_color()
    if dark_mode_active
        return "black"
    else
        return "white"
    end
end
