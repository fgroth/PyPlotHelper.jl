using PyPlot

global dark_mode_default_color_cycle = ["red", "green", "turquoise", "blue", "purple", "magenta", "white", "gray"]
global light_mode_default_color_cycle = ["red", "green", "turquoise", "blue", "purple", "magenta", "black", "gray"]

global dark_mode_color_cycle = dark_mode_default_color_cycle
global light_mode_color_cycle = light_mode_default_color_cycle

"""
    set_color_cycle(new_color_cycle::Vector)

Adjust the color cycle variable. Also see [`reset_color_cycle`](@ref).
"""
function set_color_cycle(new_color_cycle::Vector)
    if dark_mode_active
        global dark_mode_color_cycle = new_color_cycle
    else
        global light_mode_color_cycle = new_color_cycle
    end
end
"""
    reset_color_cycle()

Reset the color cycle variable to the default value.
"""
function reset_color_cycle()
    global dark_mode_color_cycle = dark_mode_default_color_cycle
    global light_mode_color_cycle = light_mode_default_color_cycle
end

"""
    get_color(i::Int64=1)

returns a color at position i of commonly used color cycle.
"""
function get_color(i::Int64=1)
    if dark_mode_active
        color_cycle = dark_mode_color_cycle
    else
        color_cycle = light_mode_color_cycle
    end
    
    return color_cycle[mod(i-1,length(color_cycle))+1] # repeat for numbers outside length
end

"""
    get_color_iteration(i::Int64=1)

Get the number of iteration of colorcycle.
"""
function get_color_iteration(i::Int64=1)
    color_cycle_length = 8
    return floor(Int64, (i-1)/color_cycle_length)+1
end

"""
    get_colormap(quantity::String="rho")

returns a colormap typically used for the quantity
"""
function get_colormap(quantity::String="rho")
    # also see https://matplotlib.org/stable/users/explain/colors/colormaps.html
    if lowercase(quantity) in ["rho", "density", "gas_density"]
        return "inferno" #"plasma"
    elseif lowercase(quantity) in ["t(u)","t","temp"]
        return "inferno"
    elseif lowercase(quantity) in ["stars"]
        return "gray"
    elseif startswith(uppercase(quantity),"X-RAY")
        return "afmhot"
    elseif contains(quantity,"SZ")
        return "jet"
    elseif lowercase(quantity) in ["b", "bx", "by", "bz", "bfld"]
        # diverging colormap
        return "twilight_shifted"
    elseif startswith(uppercase(quantity),"V")
        if endswith(uppercase(quantity),"ABS")
            # absolve velocity, choose perceptually uniform colormap
            return "magma"
        else
            # with negative values as well, choose diverging colormap
            return "RdBu"
        end
    else
        error("quantity="*quantity*" value not allowed")
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
