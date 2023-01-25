using CausalKernels
using Test

@testset "vector" begin
	let rend = 10, r = 1:rend, w = 4, lb = -(w-1)
		v = r |> collect
		@testset "basic" begin
			@test all(roll(w->w[lb], v, w) .== 1:rend+lb)
			@test all(roll(1, w->w[lb], v, w) .== 1:rend+lb)

			pv = padroll(w->w[lb], v, w)
			@test all(ismissing.(pv[1:w-1])) && all(pv[w:end] .== 1:rend+lb)

			pv = padroll(1, w->w[lb], v, w)
			@test all(ismissing.(pv[1:w-1])) && all(pv[w:end] .== 1:rend+lb)
		end
	end
end

@testset "matrix" begin
	let rend = 10, ncol = 3, r = 1:rend*ncol, w = 4, lb = -(w-1), col=1
		mlong = collect(reshape(r, rend, ncol))
		mwide = collect(reshape(r, ncol, rend))
		@testset "basic" begin
			@test all(roll(w->w[lb, col], mlong, w) .== mlong[1:rend+lb, col+1])
			@test all(roll(1, w->w[lb, col], mlong, w) .== mlong[1:rend+lb, col+1])
			@test all(roll(2, w->w[col, lb], mwide, w) .== mwide[col+1, 1:rend+lb]')

			pm = padroll(w->w[lb, col], mlong, w)
			@test all(ismissing.(pm[1:w-1, :])) && all(pm[w:end, :] .== mlong[1:rend+lb, col+1])

			pm = padroll(1, w->w[lb, col], mlong, w)
			@test all(ismissing.(pm[1:w-1, :])) && all(pm[w:end, :].== mlong[1:rend+lb, col+1])

			pm = padroll(2, w->w[col, lb], mwide, w)
			@test all(ismissing.(pm[:, 1:w-1])) && all(pm[:, w:end] .== mwide[col+1, 1:rend+lb]')
		end
	end
end

