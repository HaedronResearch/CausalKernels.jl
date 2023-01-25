
"""
$(TYPEDSIGNATURES)
Roll `fn` across dimension `dim` of array `Xₜ`.
Outputs an array with the same rank as the input, but an eltype based on `fn`.

The function is applied on a slice from the lookback to the current element.

If `w<1` it is assumed to be the lookback (earliest element acessed by the kernel across dimension `dim`).
If `w≥1` it is assumed to be the window size (abs(lookback)+1).

See also `padroll`.
"""
function roll(dim::Integer, fn::F, Xₜ::AbstractArray, w::Integer) where {F<:Function}
	kr = [0:s-1 for s in size(Xₜ)]
	kr[dim] = (w<1 ? w : -(w-1)):0
	k = Kernel{tuple(kr...)}(fn)
	map(k, Xₜ)
end

"""
$(TYPEDSIGNATURES)
Roll with rolling dimension fixed to `1`.
Using this instead of `roll(1, ...)` will be marginally more performant.
"""
function roll(fn::F, Xₜ::AbstractArray, w::Integer) where {F<:Function}
	kr = ((w<1 ? w : -(w-1)):0, (0:s-1 for s in size(Xₜ)[2:end])...)
	map(Kernel{kr}(fn), Xₜ)
end

"""
$(TYPEDSIGNATURES)
Padded roll.
Prepends padding `val` (`Missing` by default) to the output of `maproll(...)`
to make the output the same length as `Xₜ` across dimension `dim`.

Outputs an array with the same rank as the input, but an eltype based on `fn`'s output type unioned to `M`.

See also `roll`.
"""
function padroll(dim::Integer, fn::F, Xₜ::AbstractArray, w::Integer, val::M=missing) where {F<:Function,M}
	out = roll(dim, fn, Xₜ, w)
	padsize = collect(size(out))
	padsize[dim] = size(Xₜ, dim) - size(out, dim)
	padding = fill(val, padsize...)
	cat(padding, out; dims=dim)
end

"""
$(TYPEDSIGNATURES)
Padded roll with rolling dimension fixed to `1`.
Using this instead of `padroll(1, ...)` will be marginally more performant.
"""
function padroll(fn::F, Xₜ::AbstractArray, w::Integer, val::M=missing) where {F<:Function,M}
	out = roll(fn, Xₜ, w)
	padding = fill(val, size(Xₜ, 1) - size(out, 1))
	vcat(padding, out)
end
