# Honest Living - honestlivingband.com
A static site built with Elm to host the EP I recorded with my band, and share some of our memories with photos and videos.


## Builds
The `src/` directory contains all Elm files for development. Elm is compiled to `main.js` and served through `index.html` at the project root.

To compile into JS, run:

`elm make src/Main.elm --output=main.js`

> NOTE: Do not commit dev builds. The latest `master` build is used by GitHub pages to host the public site. For this reason, only commit builds on master for the sake of deploying.

## Development

### Getting started
Use the offical installation guide to install Elm: https://guide.elm-lang.org/install/ and the tools for syntax highlighting and formatting.

Following the official guide, this project uses `elm-format` to adhere to best-practices for code formatting, and `elm-analyse` for liniting.
The official guide also covers getting those tools hooked up in your editor: https://guide.elm-lang.org/install/editor.html, but 
you can run the `elm-format` and `elm-analyse` from the command line, once installed.

### Daily Stuff 
Whenever possible, use `elm reactor` for development. Not only is it faster (because you don't have to make a new build each time), but you avoid accidentally committing the build.

When that is not sufficient, you can host the html in a local http server. To do so, install python and run `python -m SimpleHTTPServer 7800` and go to `localhost:7800` in your browser.

> We specify the port `7800` here because the default, `8000` is also used by `elm reactor`. This makes it easier to swap between the two, or have both open at the same time if necessary.

## Deploys
This site is currently hosted by GitHub pages, using the latest build on master. For this purpose, avoid creating builds on master for development.

To deploy, merge `dev/feature_branch` into `master`. Then on `master`, create a new build and commit that separately. Push `master` and GH Pages will serve the `index.html` file located at the root of the project.





