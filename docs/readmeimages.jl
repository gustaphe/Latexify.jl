using Latexify
#using ParameterizedFunctions
#using DiffEqBiological

struct Ket{T}
    x::T
end
@latexrecipe function f(x::Ket)
    return Expr(:latexifymerge, "\\left|", x.x, "\\right>")
end

#=
ode = @ode_def positiveFeedback begin
    dx = v*y^n/(k^n + y^n) - x
    dy = x/(k_2 + x) - y
end v n k k_2
# =#
#=
rn = @reaction_network demoNetwork begin
    (r_bind, r_unbind), A + B ↔ C
    Hill(C, v, k, n), 0 --> X
    d_x, X --> 0
end r_bind r_unbind v k n d_x
# =#

demos = Dict(
             "fraction" => @latexify(x/(y+x)^2),
             "matrix" => latexify(["x/y" 3//7 2+3im; 1 :P_x :(gamma(3))]),
             "ket" => @latexify($(Ket(:a)) + $(Ket(:b))),
             #"ode" => latexify(ode),
             #"rn" => latexify(rn),
             #"rn_arrow" => latexify(rn; env=:arrow),
            )

for (name, value) in demos
    render(
           value, MIME"image/png"();
           name="$(pkgdir(Latexify))/assets/demo_$name",
           dpi=1200,
           background="rgb 1.0 1.0 1.0",
           callshow=false,
           open=false,
           clean=true,
          )
end
