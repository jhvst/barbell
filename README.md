# barbell

Barbell is like the templating system Handlebars, but with BQN's Under doing the heavy lifting

## How-to

`barbell.bqn` takes one input parameter, which is the filename to process. For example, `cbqn barbell.bqn myfile.html`. Next, the current shell directory will be scanned for filenames ending in `.bar`: the name of the file will be made into a variable which is searched from the template. So, if you have a file called `title.bar` which has the contents of `My website`, then any occurance of `{title}` in `myfile.html` will be replaced with `My website`.

## Implementation

Notes:

- If you have clauses in `{title}` which do not match anything, then the bars are kept.

- Currently, the matches have to be precise: the variable will result in no match being made.

