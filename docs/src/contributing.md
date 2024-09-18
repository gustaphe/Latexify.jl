# Contributing

You can contribute to Latexify.jl in several ways.
The simplest way is to make a feature request or bug report on Github.
We also happily accept pull requests.

## Adding Latexify support to other packages

The best way to extend the usefulness of Latexify is to add recipes for types in other packages.
How recipes work is explained in [Recipes](@ref).
You can either import Latexify into the other package or, preferably, create an [extension](https://pkgdocs.julialang.org/dev/creating-packages/#Conditional-loading-of-code-in-packages-(Extensions)).

Note that the Latexify.jl repository is *not* the place to collect recipes for other types -- it belongs with other methods for that type like `display` or plot recipes.
If the maintainers of a package do not want to take on the maintenance burden of latex recipes, you can also create a glue package, which loads both the package you want to extend and Latexify, and just runs `@latexrecipe`.
This is slightly less convenient to the package users, but can work as a good staging ground for a later pull request.

## Adding operators

The `latexify` pipeline is messy, and understanding and modifying [`latexoperation`](@ref) can be quite daunting.
Luckily, there is a special case for infix operators, that is symbols like `+` which go in between two operands when written out as math.
Introducing a new one of these is relatively simple:
1. Identify whether the operator is a comparison, a bitwise operator, an arithmetic operator or a special case.
2. Insert the operator into the appropriate `Dict` in `src/symbol_translations.jl` as a pair where the key is the `Symbol` representation of the function, and the value is the string that represents it in LaTeX code.
3. With a bit of luck you are already done, but it may be that the default [precedence and associativity](https://docs.julialang.org/en/v1/manual/mathematical-operations/#Operator-Precedence-and-Associativity) are not compatible with what you would expect for typed out mathematics:

### Precedence and associativity

This problem will take the form of excessive or missing parentheses in latexified code.
If so, the functions `precedence` and `associativity` in `src/latexoperation.jl` should be updated to have special case for your operator.
For instance, to indicate that an operator `:foo` is right-associative and has the same precedence as multiplication, `precedence` could have `op == :foo && return precedence(:*)` and `associativity` could have `op == :foo && return :right`.

## Tests and documentation

Not all possible interactions in Latexify are tested, but more is better.
When making a pull request, please do try to consider as many edge cases as possible and write tests that catch them.

Most of the time, documenting small changes is not necessary.
For a symbol to be latexified in a specific way it should already be the self-evident way to do it.

Bespoke documentation issues and pull requests are more than welcome!
