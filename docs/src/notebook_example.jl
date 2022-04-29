### A Pluto.jl notebook ###
# v0.19.2

using Markdown
using InteractiveUtils

# ╔═╡ ed981180-8cdc-4c50-af44-703c7d026f64
using Latexify

# ╔═╡ ee6bed72-ac2a-4e7d-a5c1-3b4aa5307f85
using Unitful, UnitfulLatexify

# ╔═╡ 6f2f3fea-a917-4c4a-8bd7-2ed4dfc83143
begin
	using LaTeXStrings
    Markdown.html(io::IO, ls::LaTeXString) = 
        Markdown.html(io, Markdown.LaTeX(
            repr(MIME"text/latex"(), ls)
        ))

    Markdown.htmlinline(io::IO, ls::LaTeXString) = 
        Markdown.htmlinline(io, Markdown.LaTeX(
            repr(MIME"text/latex"(), ls)
        ))
end

# ╔═╡ 1b133663-31b9-4980-9f9d-93e9dfa741ae
md"""
# Latexify.jl with Pluto.jl

Here's some examples of how to use Latexify in a Pluto notebook, as well as some interactions. Much of this will translate well to other contexts.
"""

# ╔═╡ 15c8bc1c-6894-42bb-931f-1765594ca0d8
md"""
## First steps

The simplest interaction is the latexification of a single object by itself:
"""

# ╔═╡ fcb34ae2-ec84-4d52-8b8e-6f84e0581279
latexify(3.25)

# ╔═╡ f88d4567-674f-45e5-b001-57c03afd238e
md"""
We can also latexify expressions, either by feeding an `Expr` to `latexify` or by using the `@latexify` macro:
"""

# ╔═╡ c0890ff5-9e74-4a6d-a112-43b5a20ddbb4
latexify(:(x=1/2))

# ╔═╡ 648c21fd-8df4-4daa-bdb6-f9e6b5627328
@latexify x = 3/2

# ╔═╡ db26d58e-71d8-4dcc-9d5b-4feb750ac3a9
md"""
Note that Pluto incorrectly identifies this last one as an assignment and prints a 
redundant line of `@latexify x =`. To get around this, you can either surround the 
entire cell with `begin/end`, use a 1-tuple on the lhs or interpolate into a markdown 
string as described further down.
"""

# ╔═╡ df171771-7fb0-4653-b242-3ef07cc13dc5
begin
	@latexify x = 2y^2
end

# ╔═╡ bde5edde-4cee-4769-9d08-dc528c37e479
@latexify (x,) = sqrt(y)

# ╔═╡ 8dda3f67-d151-4dc9-8967-5bb1fd4799cb
md"""
To avoid extra work when -- for instance -- assigning variables, `@latexrun` will both latexify *and evaluate* an expression:
"""

# ╔═╡ 222127c1-9aaa-41e2-b53d-64357c3c5d78
@latexrun x = 120_000

# ╔═╡ f921d066-8173-43f7-a43c-14e7c4468ad9
md"The value of x is now $x"

# ╔═╡ ae496255-7a05-4a6a-8bf4-c3990c1f0856
md"""
When working with variable expressions you might want to also immediately see the *result* of the evaluation, which is why `@latexdefine` adds a last right hand side:
"""

# ╔═╡ 91ff3209-b5c3-44bb-8b49-f99f67677adc
@latexdefine y = sqrt(x)

# ╔═╡ 17431768-8a89-4a9d-ac90-7c671865d7e7
md"The value of y is $y"

# ╔═╡ 9c339b7e-aefd-4cd3-bdd3-9190fc3516ae
md"""
Sometimes you'll want to change the formatting of this added right hand side, which 
is what the `post` keyword argument is for. It takes a function which is run on the 
evaluated result before latexification (but does not for instance change the stored 
value of any assignments):
"""

# ╔═╡ 63d91b6c-65f5-4311-b34a-56a75c04594b
@latexdefine y  post=x->round(x; sigdigits=3)

# ╔═╡ dcd5e334-d6a4-4068-85b0-ab69c1c92486
Markdown.parse("""
## Interpolation

One very useful tool for maths heavy notebooks is interpolating latexified 
expressions into Markdown cells. There's two ways to do this. One is to use 
`Markdown.parse`, and one allows you to use the `md` string macro, but currently 
requires a bit of a hack. The second method is described at the end of this document, and the first method follows:
""")

# ╔═╡ ace4e51a-d0a2-408d-a4d7-48827889efef
Markdown.parse("""
There is maths in this cell: $(@latexify f(x) = x < 0 ? x^2 : x)

I can say for sure that $(@latexrun f_0 = 2.5), because otherwise it wouldn't be true 
that $(@latexdefine f_1 = -f_0).
""")

# ╔═╡ 0b8ff60f-f1ee-4c5d-bdc8-5bdea86aa332
md"""
For extra fine control, you can include latexified variables in manual math, using 
the kwarg `env=:raw`: (This is necessary since otherwise there would be nested math 
environments)
"""

# ╔═╡ 7fb2446c-e40d-4841-aa67-54406240cd7a
Markdown.parse("""
``g_0 \\neq $(@latexdefine f_0  env=:raw)``
""")

# ╔═╡ 26a04208-4cbe-4114-8c41-be9334bd7e6a
md"""
## Tabular material

You can use the `mdtable` function to latexify entire arrays in a markdown table:
"""

# ╔═╡ c7da7350-7815-4ba8-a1f8-be9f830bc8a2
mdtable(rand(4,3); head=latexify.(["x", "y", "z"]))

# ╔═╡ 1e0d856c-b5a7-4b0b-beb5-3052de07e2df
md"""
## Custom type latexification

You can latexify your own types by defining latex recipes, which encapsulate a 
function that turns an instance of your type into something that Latexify already 
knows how to work with:
"""

# ╔═╡ bd4bff73-c173-4898-a618-f77584e011e9
struct Element
	symbol::Symbol
	mass_number::Int
	atomic_number::Int
	charge::Int
end

# ╔═╡ 172e261c-ed25-4952-809e-2231c64bfd25
@latexrecipe function f(e::Element)
	return Expr(:latexifymerge,
		"{}^{", e.mass_number,
		"}_{", e.atomic_number,
		"}\\mathrm{", e.symbol,
		"}^{", 
		e.charge in (-1, 0, 1) ? "" : abs(e.charge),
		e.charge > 0 ? "+" : "",
		e.charge < 0 ? "-" : "",
		"}" 
	)
end

# ╔═╡ ae632f5d-f569-4518-8d8b-278deb98b473
mdtable(
	Element.([:Mg, :Cl], [24, 35], [12, 17], [2, -1]); 
	head=["Ion"]
)

# ╔═╡ 71da7938-0abc-4b16-8bb9-9253182cc738
md"""
## Interactions
"""

# ╔═╡ b423da4c-e9d4-46b6-938f-55413c7db0b7
md"""
### Unitful
"""

# ╔═╡ c0e6fa03-df17-49cb-9bc6-2e0abb5c208a
Markdown.parse("""
With `UnitfulLatexify`, units and quantities can readily be latexified: 
$(latexify(612.2u"nm")). When using the macros, you'll want to use the *value* of the 
quantity rather than the representation as a number times a unitstring. You do this by
(double) interpolating: $(@latexrun g = $(9.82u"m/s^2")). The `post` kwarg comes in
extra handy for converting units: $(@latexdefine F = $(3u"kg")*g  post=u"N")
""")

# ╔═╡ 95b3e184-657d-41d7-9ab5-e6226e7ce1eb
md"""
## md interpolation hack

If you include the code below, latexifications can be interpolated directly into 
`md""` strings. It can sometimes be a little more buggy than the `Markdown.parse` 
method described above.
"""

# ╔═╡ fd3c147e-c0fe-46c1-b515-964cebd94a97
md"""
One issue with this is that you get no inline math: $(@latexdefine exp(1))
"""

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
LaTeXStrings = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
Latexify = "23fbe1c1-3f47-55db-b15f-69d7ec21a316"
Unitful = "1986cc42-f94f-5a68-af5c-568840ba703d"
UnitfulLatexify = "45397f5d-5981-4c77-b2b3-fc36d6e9b728"

[compat]
LaTeXStrings = "~1.3.0"
Latexify = "~0.15.14"
Unitful = "~1.11.0"
UnitfulLatexify = "~1.6.2"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.8.0-beta3"
manifest_format = "2.0"
project_hash = "2567eaca283a82433739c5aeb86154abc6341aac"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"
version = "0.5.2+0"

[[deps.ConstructionBase]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "f74e9d5388b8620b4cee35d4c5a618dd4dc547f4"
uuid = "187b0558-2788-49d3-abe0-74a17ed4e7c9"
version = "1.3.0"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.Formatting]]
deps = ["Printf"]
git-tree-sha1 = "8339d61043228fdd3eb658d86c926cb282ae72a8"
uuid = "59287772-0a20-5a39-b81b-1366585eb4c0"
version = "0.4.2"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[deps.LaTeXStrings]]
git-tree-sha1 = "f2355693d6778a178ade15952b7ac47a4ff97996"
uuid = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
version = "1.3.0"

[[deps.Latexify]]
deps = ["Formatting", "InteractiveUtils", "LaTeXStrings", "MacroTools", "Markdown", "Printf", "Requires"]
git-tree-sha1 = "6f14549f7760d84b2db7a9b10b88cd3cc3025730"
uuid = "23fbe1c1-3f47-55db-b15f-69d7ec21a316"
version = "0.15.14"

[[deps.Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"

[[deps.LinearAlgebra]]
deps = ["Libdl", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[deps.MacroTools]]
deps = ["Markdown", "Random"]
git-tree-sha1 = "3d3e902b31198a27340d0bf00d6ac452866021cf"
uuid = "1914dd2f-81c6-5fcd-8719-6d5c9610ff09"
version = "0.5.9"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"
version = "0.3.20+0"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[deps.Random]]
deps = ["SHA", "Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[deps.Requires]]
deps = ["UUIDs"]
git-tree-sha1 = "838a3a4188e2ded87a4f9f184b4b0d78a1e91cb7"
uuid = "ae029012-a4dd-5104-9daa-d747884805df"
version = "1.3.0"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"
version = "0.7.0"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[deps.Unitful]]
deps = ["ConstructionBase", "Dates", "LinearAlgebra", "Random"]
git-tree-sha1 = "b649200e887a487468b71821e2644382699f1b0f"
uuid = "1986cc42-f94f-5a68-af5c-568840ba703d"
version = "1.11.0"

[[deps.UnitfulLatexify]]
deps = ["LaTeXStrings", "Latexify", "Unitful"]
git-tree-sha1 = "09e48b62c14ea4ce8865f2141c4fe9bf8a76455e"
uuid = "45397f5d-5981-4c77-b2b3-fc36d6e9b728"
version = "1.6.2"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl", "OpenBLAS_jll"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"
version = "5.1.0+0"
"""

# ╔═╡ Cell order:
# ╟─1b133663-31b9-4980-9f9d-93e9dfa741ae
# ╠═ed981180-8cdc-4c50-af44-703c7d026f64
# ╟─15c8bc1c-6894-42bb-931f-1765594ca0d8
# ╠═fcb34ae2-ec84-4d52-8b8e-6f84e0581279
# ╟─f88d4567-674f-45e5-b001-57c03afd238e
# ╠═c0890ff5-9e74-4a6d-a112-43b5a20ddbb4
# ╠═648c21fd-8df4-4daa-bdb6-f9e6b5627328
# ╟─db26d58e-71d8-4dcc-9d5b-4feb750ac3a9
# ╠═df171771-7fb0-4653-b242-3ef07cc13dc5
# ╠═bde5edde-4cee-4769-9d08-dc528c37e479
# ╟─8dda3f67-d151-4dc9-8967-5bb1fd4799cb
# ╠═222127c1-9aaa-41e2-b53d-64357c3c5d78
# ╠═f921d066-8173-43f7-a43c-14e7c4468ad9
# ╟─ae496255-7a05-4a6a-8bf4-c3990c1f0856
# ╠═91ff3209-b5c3-44bb-8b49-f99f67677adc
# ╠═17431768-8a89-4a9d-ac90-7c671865d7e7
# ╟─9c339b7e-aefd-4cd3-bdd3-9190fc3516ae
# ╠═63d91b6c-65f5-4311-b34a-56a75c04594b
# ╟─dcd5e334-d6a4-4068-85b0-ab69c1c92486
# ╠═ace4e51a-d0a2-408d-a4d7-48827889efef
# ╟─0b8ff60f-f1ee-4c5d-bdc8-5bdea86aa332
# ╠═7fb2446c-e40d-4841-aa67-54406240cd7a
# ╟─26a04208-4cbe-4114-8c41-be9334bd7e6a
# ╠═c7da7350-7815-4ba8-a1f8-be9f830bc8a2
# ╟─1e0d856c-b5a7-4b0b-beb5-3052de07e2df
# ╠═bd4bff73-c173-4898-a618-f77584e011e9
# ╠═172e261c-ed25-4952-809e-2231c64bfd25
# ╠═ae632f5d-f569-4518-8d8b-278deb98b473
# ╟─71da7938-0abc-4b16-8bb9-9253182cc738
# ╟─b423da4c-e9d4-46b6-938f-55413c7db0b7
# ╠═ee6bed72-ac2a-4e7d-a5c1-3b4aa5307f85
# ╠═c0e6fa03-df17-49cb-9bc6-2e0abb5c208a
# ╟─95b3e184-657d-41d7-9ab5-e6226e7ce1eb
# ╠═6f2f3fea-a917-4c4a-8bd7-2ed4dfc83143
# ╠═fd3c147e-c0fe-46c1-b515-964cebd94a97
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
