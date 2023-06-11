pairs ← {⟨¯4↓𝕩,(•file.Chars •wdpath∾"/"∾𝕩)⟩}¨{4=+´¯4↑𝕩∊".bar"}¨⊸/•file.List •wdpath∾"/."
input ← •file.Chars •wdpath∾"/"∾ ⊑ •args

b ← "|"⍷input
e ← "|"⍷input

frags ← (+`e+»b) ⊸ ⊔ input
keys ← {0⊑𝕩}¨pairs
vals ← {1⊑𝕩}¨pairs
mask ← keys⊐frags
values ← ((≠pairs)≠⊢) ⊸ / keys ⊐ frags
reps ← (values⊏vals)⌾(((≠pairs)≠mask)⊸/) frags

changed ← {⟨𝕩-1,𝕩,𝕩+1⟩}¨(({⟨1,0,1⟩≡𝕩}¨(¯3↑¨1↓↑frags ∊ reps))⊸/) ({𝕩-1}¨↕≠frags)
neighbors ← {⟨¯1↓0⊑𝕩,1⊑𝕩,1↓2⊑𝕩⟩}¨{𝕩⊏reps}¨changed
nmask ← {+´𝕩⍷(∾changed)}¨↕≠frags
•Out ∾(∾neighbors)⌾(nmask⊸/) reps

