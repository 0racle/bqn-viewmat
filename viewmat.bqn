#!/usr/bin/env bqn

GetEnv ← ¯1↓1⊑·•SH"printenv"⋈⊢
pathToLib ← •file.RealPath "/usr/local/lib/libraylib.so"
rl ← ⟨pathToLib⟩ •Import (GetEnv"BQNLIB")∾"/raylib-bqn/raylib.bqn"

⟨Viewmat,grayscale,turbo,viridis⟩⇐

GetVm1 ← {
  val ← ⥊ mat ← 𝕩
  max ← ⌈´ val
  min ← ⌊´ val
  ⌊ 𝕨 GetHue (mat-min)÷max-min
}

GetHue ← {
  x ← 𝕩×1-˜≠𝕨
  b ← 𝕨⊏˜⌊x
  t ← 𝕨⊏˜⌈x
  k ← x-⌊x
  (t×k)+b×¬k
}

grayscale ← [0‿0‿0,255‿255‿255]

turbo ← [
  48‿18‿59,64‿64‿162,70‿107‿227,66‿148‿255,
  41‿187‿236,24‿220‿195,49‿241‿153,107‿254‿100,
  163‿253‿61,204‿237‿52,237‿208‿58,253‿173‿53,
  251‿128‿34,236‿82‿15,210‿49‿5,172‿23‿1,122‿4‿3
]

viridis ← [
  68‿1‿84,72‿21‿104,72‿38‿118,69‿55‿128,
  63‿71‿136,57‿85‿140,50‿100‿142,45‿113‿142,
  40‿125‿142,35‿138‿141,31‿150‿139,32‿163‿134,
  41‿175‿128,60‿188‿117,86‿190‿103,116‿208‿85,
  148‿216‿64,184‿222‿41,220‿227‿24,253‿231‿37
]

GetPalette ← {
  0<≠𝕨 ? 𝕨 ;
  0‿1≡(⌊´∾⌈´)⥊𝕩 ? grayscale ;
  turbo
}

RGB256 ← {256|⌊∘÷⟜256⍟(⌽↕3)𝕩}

GetColors ← {
  𝕨≡"rgb" ? (255∾˜RGB256)¨⥊𝕩 ;
  palette ← 𝕨 GetPalette 𝕩
  rgb ← palette GetVm1 𝕩
  colors ← <˘∾⟜255˘∾˝rgb
}

Viewmat ← {𝕊𝕩: ⟨⟩𝕊𝕩; 𝕨𝕊𝕩:

  shape ← ≢𝕩
  h‿w ← size ← ≢ mat ← ∾˘˝⍟(2-˜=) 0‿0↓𝕩
  colors ← 𝕨 GetColors mat
  winw‿winh ← 100⌈⌊800‿800×(⍋size)⊏1∾÷˝∧size

  title ← "viewmat ("∾")"∾˜∾1↓∾˝'x'≍˘•Repr¨shape
  rl.SetTraceLogLevel rl.rlTraceLogLevel.rL_LOG_ERROR
  rl.InitWindow winw‿winh‿title
  rl.SetExitKey rl.keyboardKey.key_q

  white ← 255‿255‿255‿255
  img ← rl.GenImageColor⟨w,h,white⟩
  rl.ImageDrawPixel¨ (⟨⋈img⟩)⊸∾¨(∾˝⍉↕w‿h)∾⟜⋈¨colors
  tex ← rl.LoadTextureFromImage img

  Draw ← {𝕊:
    rl.BeginDrawing⟨⟩
      rl.DrawTexturePro⟨tex,
        0‿0‿w‿h,
        0‿0‿(rl.GetScreenWidth⟨⟩)‿(rl.GetScreenHeight⟨⟩),
        0‿0,
        0,
        white
      ⟩
    rl.EndDrawing⟨⟩
  }

  Draw⟨⟩

  {𝕊:
    rl.BeginDrawing⟨⟩
      Draw⍟rl.IsWindowResized⟨⟩
    rl.EndDrawing⟨⟩
  }•_while_(¬rl.WindowShouldClose∘⟨⟩)@
}
