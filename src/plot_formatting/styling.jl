using PyPlot

"""
    plot_styling(fontsize::Float64=1)

do some default plot styling
"""
function style_plot(; print_columns::Number=1, n_plots_side_by_side::Number=1.0, print_width::Number=-1.0, # define width how it is printed
                      fig_width::Number=4.0, # define width of original figure / or can I just get that somehow? # in inch
                      mode::String="publication") # different presentation and publication mode
    # adjust paper properties depending on mode
    if mode in ["presentation", "pres", "16:9"]
        general_text_size = 11 # / 28.4527559055116 # pt / (pt/cm) = cm
        page_width = 16 # cm (latex beamer)
    elseif mode in ["publication", "pub", "a4"]
        general_text_size = 10 # / 28.4527559055116 # pt / (pt/cm) = cm
        page_width = 21 - 5/2.3622 # cm, pc / (pc/cm) (latex margin)
    end

    if print_width == -1.0
        print_width = page_width / print_columns / n_plots_side_by_side
    end
    print_text_size = fig_width*2.54 / print_width * general_text_size # cm

    # adjust fontsize of desired objects
    axis_label_font_size = print_text_size
    legend_font_size = print_text_size
    global title_font_size = 1.1 * print_text_size

    #rc("figure", dpi=100)
    
    # fonts
    rc("font", size = axis_label_font_size, family = "stixgeneral")
    rc("mathtext", fontset = "stix")
    rc("legend", fontsize = legend_font_size)
    rc("axes", labelsize = axis_label_font_size, titlesize = title_font_size)
    
    # axes: ticks
    rc("xtick", direction = "in", top = true)
    rc("ytick", direction = "in", right = true)
    
end
