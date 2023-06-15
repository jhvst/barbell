# barbell

Barbell is like the templating system Handlebars, but with BQN's Under doing the heavy lifting

## Demo

[BQNPad](https://bqnpad.mechanize.systems/s?bqn=eyJkb2MiOiJwYWlycyDihpAg4p%2Bo4p%2BoXCJhdXRob3JcIiwgXCJKdXVzb1wi4p%2BpLCDin6hcImRhdGVcIiwgXCIyMDIwXCLin6ksIOKfqFwidGl0bGVcIiwgXCJqMVwi4p%2Bp4p%2BpXG5cbmlucHV0IOKGkCBcIjxodG1sPjxoZWFkPjx0aXRsZT57dGl0bGV9PC90aXRsZT48L2hlYWQ%2BPGJvZHk%2BPGgxPnt0aXRsZX08L2gxPjxwPnthdXRob3J9IGFuZCB7dW5tYXRjaGVkfSBwYWlyLjwvcD48L2JvZHk%2BPC9odG1sPlxuXCJcblxuYiDihpAgXCJ7XCLijbdpbnB1dFxuZSDihpAgwrtcIn1cIuKNt2lucHV0XG5cbmZyYWdzIOKGkCDigKJTaG93ICgrYGUrYikg4oq4IOKKlCAoaW5wdXQpXG5rZXlzIOKGkCDigKJTaG93IHviiL5cIntcIuKAvyjiipHwnZWpKeKAv1wifVwifcKocGFpcnMgXG52YWxzIOKGkCDigKJTaG93IHsx4oqR8J2VqX3CqHBhaXJzIFxubWFzayDihpAg4oCiU2hvdyBrZXlz4oqQZnJhZ3NcbnZhbHVlcyDihpAg4oCiU2hvdyAoKOKJoHBhaXJzKeKJoOKKoikg4oq4IC8ga2V5cyDiipAgZnJhZ3NcbuKIvih2YWx1ZXPiio92YWxzKeKMvigoKOKJoHBhaXJzKeKJoG1hc2sp4oq4LykgZnJhZ3MiLCJwcmV2U2Vzc2lvbnMiOltdLCJjdXJyZW50U2Vzc2lvbiI6eyJjZWxscyI6W10sImNyZWF0ZWRBdCI6MTY4NTcyNDIxNDg3OX0sImN1cnJlbnRDZWxsIjp7ImZyb20iOjAsInRvIjo0MzAsInJlc3VsdCI6bnVsbH19)

## How-to

`barbell.bqn` takes one input parameter, which is the filename to process. For example, `cbqn barbell.bqn myfile.html`. Next, the current shell directory will be scanned for filenames ending in `.bar`: the name of the file will be made into a variable which is searched from the template. So, if you have a file called `title.bar` which has the contents of `My website`, then any occurance of `|title|` in `myfile.html` will be replaced with `My website`.

## Implementation

Notes:

- If you have clauses in `|title|` which do not match anything, then the bars are kept.

- Currently, the matches have to be precise: the variable will result in no match being made.

