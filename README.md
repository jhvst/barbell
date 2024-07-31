# barbell

Barbell is like the templating system Handlebars, but with BQN's Under doing the heavy lifting.
In other words, it uses a categorical lens to update your templates.
This is _way_ cooler than your Rust type system.
Even Haskellites will gasp in disbelief seeing a working piece of software without static types!
You can run it via `bash` which makes it more portable than most templating libraries that either run in the browser or use nodejs/deno with npm/yarn/pnpm/bun build process.

More information of the implementation is documented on [Barbell: Template System in BQN](https://juuso.dev/blogPosts/barbell/barbell.html).

## Technicalities

The main entrypoint is file called `barbell.bqn`, located in `./packages/barbell`.
This file takes one input parameter, which is the filename to process.
For example, `cbqn barbell.bqn myfile.html`.
Next, the current shell directory will be scanned for filenames ending in `.bar`: the name of the file will be made into a variable which is searched from the template.
So, if you have a file called `title.bar` which has the contents of `My website`, then any occurance of `|title|` in `myfile.html` will be replaced with `My website`.

## Implementation

Notes:

- If you have clauses in `|title|` which do not match anything, then the bars are kept.

- Currently, the matches have to be precise: if you add any whitespace around the variable, this will result in no match being made.

## Installation

Nix Flakes:

```
nix run github:jhvst/barbell -- myfile.html
```

Any kind of non-deterministic legacy environment (if you do not know what this means, this is you):

1. Install [the best BQN implementation in C](https://github.com/dzaima/CBQN)
2. Git clone this repository `git clone https://github.com/jhvst/barbell`
3. Run `cbqn ./packages/barbell/barbell.bqn myfile.html`

## is it web-scale?

yes yes, my website's [build-process](https://github.com/jhvst/jhvst.github.io/blob/main/flake.nix) uses it

