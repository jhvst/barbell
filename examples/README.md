
Here, in `header.html` we have two sections which are to be filled: `|title|` and `|article|`. To fill these bars which the contents of `title.bar` and `article.bar`, run `nix run github:jhvst/barbell -- header.html`. This will produce a file to stdout with the information from the `title.bar` included in the `|title|` section of the header.
