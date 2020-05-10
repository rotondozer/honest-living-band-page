# Honest Living - band site
A static site built with Elm to host the EP I recorded with my band, and share some of our memories with photos and videos.


### Code
Use the offical installation guide to install Elm: https://guide.elm-lang.org/install/ and the tools for syntax highlighting and formatting.

Following the official guide, this project uses `elm-format` to adhere to best-practices for code formatting, and `elm-analyse` for liniting.
The official guide also covers getting those tools hooked up in your editor: https://guide.elm-lang.org/install/editor.html, but 
you can run the `elm-format` and `elm-analyse` from the command line, once installed.


### Builds
The `src/` directory contains all Elm files for development. Elm is compiled to JS and served through `index.html`.

To compile into JS, run:

`elm make src/Main.elm --output=build/main.js`

Then you can host the html in a local http server. To do so,
Install python and run `python -m SimpleHTTPServer 7800` and go to `localhost:7800` in your browser.

Or, you can run `elm-reactor` in `build/` directory.







