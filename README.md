# CausalKernels.jl

A kernel is [causal](https://en.wikipedia.org/wiki/Causal_filter) if it only utilizes current and previous inputs in the rolling dimension.
In most cases the rolling dimension is interpreted as a time dimension.

CausalKernels.jl is a small package that allows you to apply causal kernels to arrays, mainly for time series aplications.
This package is a performant replacement for [MapSlide.jl](https://github.com/kevindirect/MapSlide.jl), however "expanding" operations are
currently unimplemented here.

## Exports
The functions `roll` and `padroll`.

## Notes
We don't use any extension support from StaticKernels.jl.
In the future wrappers for extension across non-rolling dimensions may be included.
We export a function `padroll` that prepends padding to the roll dimension after the rolling map is applied.

## Implementation
[StaticKernels.jl](https://github.com/stev47/StaticKernels.jl) is currently the backend for this package.
The code is fairly simple. We limit the kernel bounds from a negative lookback `-(w-1)` (where `w` is the window size, `w≥0`) to `0` (current time) and fully expand across the other dimensions.
This means the kernel function `fn` for `roll`/`padroll` can access data across all non-time slices in each time window.

By contrast using the StaticKernels.jl `@kernel` macro will always slide a minimal kernel across all dimensions. Not acessing future values in
the kernel function will make the kernel causal, but for tabular data / time series we often do not want to stride across non-roll dimensions.
If you want this behavior it is easy to define and run a kernel with StaticKernels.jl.

## Future
In the future part or all of this package may be reimplemented with [LoopVectorization.jl](https://github.com/JuliaSIMD/LoopVectorization.jl).
