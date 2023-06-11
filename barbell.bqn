pairs ← {⟨¯4↓𝕩,(•file.Chars •wdpath∾"/"∾𝕩)⟩}¨{4=+´¯4↑𝕩∊".bar"}¨⊸/•file.List •wdpath∾"/."
input ← •file.Chars •wdpath∾"/"∾ ⊑ •args

b ← "|"⍷input
e ← "|"⍷input

frags ← (+`e+»b) ⊸ ⊔ input
keys ← ⊑⌜pairs
vals ← ⊑∘⌽⌜pairs
mask ← frags∊keys
values ← (mask / keys ⊐ frags) ⊸ ⊏ vals
reps ← values⌾(mask⊸/) frags

changed ← (⟨-1,0,1⟩+3⥊⊢)¨⊑⌽⊔mask
nmask ← {+´𝕩⍷(∾changed)}¨↕≠frags
neighbors ← ∾{⟨↕0,(1⊑𝕩)⊑reps,↕0⟩}¨changed
•Out ∾neighbors⌾(nmask⊸/) reps

