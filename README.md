# BQN Viewmat

This is a clone of [J's Viewmat](https://code.jsoftware.com/wiki/Studio/Viewmat) addon for displaying matrices.

It relies on [raylib-bqn](https://github.com/Brian-ED/raylib-bqn).

Currently the paths to both `libraylib.so` and `raylib.bqn` are hard-coded in `viewmat.bqn` so you will most likely need to modify those values to get it working

# Usage and examples

First pull in Viewmat and some color palettes
```bqn
Viewmat‿viridis‿grayscale ← •Import "viewmat.bqn"
```

### Simple burst

```bqn
Viewmat -∾˜⟜⌽∘⍉⍟2+⌾(×˜)˝⍉⁼>↕10‿10
```
![burst](screenshots/burst.png)

### Multi-dim arrays

```bqn
Viewmat [1‿2⋄3‿4] + 2‿2‿32‿32 •rand.Range 0
```
![multi-dim](screenshots/multi-dim.png)

### One dimensional is OK too! 

```bqn
Viewmat ↕10
```
![one-dim](screenshots/one-dim.png)

### Voronoi

```bqn
c ← >↕∾˜z ← 400
p ← 50‿2 •rand.Range z
m ← (⊑⊢⊐⌊´)⎉1 +˝⎉1×˜ c -⎉1⎉1‿∞ p
viridis Viewmat m
```
![voronoi](screenshots/voronoi.png)

A vibrant _verde_ Voronoi visualization. _Voilà!_

### Perlin noise

Using `perlin.bqn` from [bqn-libs](https://github.com/mlochbaum/bqn-libs) to generate noise

```bqn
NoiseN‿MakeData ← •Import "perlin.bqn"
state ← MakeData@
Viewmat >state⊸NoiseN¨50÷˜↕400‿400
```
![noise](screenshots/noise.png)

Generate noise at multiple scales and sum for fractal noise
```bqn
grayscale Viewmat +˝ (2⋆↕6) {𝕨×>state⊸NoiseN¨𝕨÷˜𝕩}○⊑˘ <↕200‿200
```
![fractal-noise](screenshots/fractal-noise.png)

### RGB

Passing "rgb" as the palette will attempt to interpret the values RGB.
The array may be in the one of following formats
  * m×n (2D) matrix of integers encoding 24-bit RGB, or 32-bit RGBA values
  * m×n×3 array representing RGB values
  * m×n×4 array representing RGBA values

```bqn
c ← 2÷˜•math.Sin÷⟜10(+⌜∾⌈⌜≍-˜⌜)˜↕300
•Show "rgb" Viewmat ⌊255×0.5+⍉c
```
![rgb](screenshots/rgb.png)

Using "rgb" with a 2D matrix of integers will not consider any alpha channel if it exists. If you are passing in 32-bit RGBA values, use the "rgba" argument explicitly.

**Note:** Using "rgba" with integers up to 24-bit will cause the alpha channel to be all `0`, and the resulting Viewmat will be black.

Passing a m×n×4 array will consider the alpha channel regardless of whether "rgb" or "rgba" is used.

# See also

The [bqn-pixbuf](https://github.com/0racle/bqn-pixbuf) library provides a simple interface for reading (and writing) images which plays nicely with Viewmat

```bqn
⟨ReadImg⟩ ← •Import "pixbuf.bqn"
"rgb" Viewmat ReadImg "image.png"
```

# Caveats and limitation

Only tested on Linux, but presumably works anywhere `raylib.bqn` works.
