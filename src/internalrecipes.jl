@latexrecipe function f(sym::Symbol)
    str = unicode2latex(string(sym))
    vec = split(str, r"\\?_")
    out = Vector{LaTeXString}(undef, length(vec))
    for (i, sub) in pairs(vec)
        if length(sub) > 1
            font = get(kwargs, :long_variable_font, "mathrm")
            if ~isnothing(font)
                out[i] = LaTeXString("\\$font{$sub}")
                continue
            end
        end
        out[i] = LaTeXString(sub)
    end
    length(out) == 1 && return only(out)
    return Expr(:latexify_substack, out...)
end
