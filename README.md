# `HDXLSIMDSupport`: Overview

This package provides access to `SIMD`-style, generic quaternions and matrices: you can write `Quaternion<Double>`, `Matrix4x4<Float>`, and so on. The package provides this functionality by wrapping Apple's corresponding, non-generic simd types: `Quaternion<Double>` is ultimately a wrapper around `simd_quatd`, `Matrix4x4<Float>` is ultimately a wrapper around `simd_float4x4`, and so on.

## Warning: Compile Time

The package presently can require 30-40+ minutes to compile in both `Debug` and `Release` configurations. This is simultaneously (a) extremely-unfortunate but also (b) a remarkable improvement over the **6-8 hours* required of some earlier versions. 

If I knew *exactly* what it was about this package that caused such ridiculous compile times, I'd just...fix it. As it is, I have some guesses, but haven't explored them, yet--testing any of these guesses would, at minimum, require extensive refactoring and, at maximum, require an essentially-full rewrite.

Given that the package *works for my needs*, for now I've deliberately accepted the excessive compile times and moved on; it's something I'd like to improve, and I would be happy to discuss further with any interested parties.