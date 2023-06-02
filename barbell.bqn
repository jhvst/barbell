pairs ← {⟨∾"{"‿(¯4↓𝕩)‿"}",(•file.Chars •wdpath∾"/"∾𝕩)⟩}¨{4=+´¯4↑𝕩∊".bar"}¨⊸/•file.List •wdpath∾"/."
input ← •file.Chars •wdpath∾"/"∾ ⊑ •args

b ← "{"⍷input
e ← »"}"⍷input

frags ← (+`e+b) ⊸ ⊔ (input)
keys ← {⊑𝕩}¨pairs
vals ← {1⊑𝕩}¨pairs
mask ← keys⊐frags
values ← ((≠pairs)≠⊢) ⊸ / keys ⊐ frags
•Out ∾(values⊏vals)⌾(((≠pairs)≠mask)⊸/) frags
