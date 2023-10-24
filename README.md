# markdown-resume

A tool that uses [pandoc](https://pandoc.org/MANUAL.html#pandocs-markdown) to generate a good looking CV in .pdf and .html formats from a vanilla markdown file.

You can see a real-world CV built with the tool [**HERE**](sample.pdf).

Supports working with multiple markdown files at the same time (if, for example, you need your CV in multiple languages), and doesn't depend on jekyll nor LaTeX.

Absolutely no dependencies if you use GitHub CI to build the resulting files!. Just put your resume markdown file under `src/`, commit and push. You'll find a zip file with the output files in the [CI workflow summary page](https://github.com/actions/upload-artifact#where-does-the-upload-go).

## Usage

Create a markdown file under [`src/`](src/) - on build it will be used to generate the corresponding .pdf and .html files under [`output/`](output/)

You can use [`src/sample.md`](src/sample.md) for reference and [`output/sample.pdf`](output/sample.pdf) to see what it generates. Most of it should be self-explanatory. Other than that:

- The `title` variable from the frontmatter gets set as the first `h1` in the content
- The `style` variable in the front matter chooses the style to use (from the [`styles/`](styles/) directory)
- Some markdown elements might have a special function in a given style (like the `h4` -> `code` used for time periods in the default style). Again, consult the samples to see how it fits together.

### Why is there a hidden `.Makefile` in the root directory?

I left it as a reminder to never try to use hand-written Makefiles for anything non-trivial - it's not worth it.


