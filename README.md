# Markdown Resume Generator

A professional tool for generating beautiful HTML and PDF resumes/CVs from Markdown files using Pandoc.

## Features

* Cross-platform support (Linux, macOS, and Windows)
* Clean, professional output in both HTML and PDF formats
* Customizable via CSS styles
* Automated numbering for publication lists
* GitHub Actions integration for CI/CD (Linux-optimized)
* Docker support for consistent builds

## Getting Started

### Prerequisites

#### Linux/macOS (Recommended for CI/CD)
* Pandoc: For Markdown conversion
* wkhtmltopdf: For PDF generation
* Make (optional): For easier build commands
* inotifywait (for `watch.sh` functionality)

```bash
# Ubuntu/Debian
sudo apt update && sudo apt install pandoc wkhtmltopdf make inotify-tools

# macOS with Homebrew
brew install pandoc wkhtmltopdf make fswatch
```

#### Windows
* Pandoc: For Markdown conversion
* wkhtmltopdf: For PDF generation
* PowerShell: For running the `.ps1` scripts

```powershell
# Using Chocolatey (run PowerShell as Administrator)
choco install pandoc wkhtmltopdf -y
```

### Quick Start

1. Clone this repository:
   ```bash
   git clone https://github.com/yourusername/markdown-resume.git
   cd markdown-resume
   ```

2. Place your Markdown CV in the `src/` folder, or modify the example:
   ```bash
   # Copy the example file and customize it
   cp src/sample.md src/my-cv.md
   ```

3. Add the following to your Markdown front matter:
   ```yaml
   ---
   title: Your Name - CV
   style: default  # or any other style folder name in styles/
   margin-left: 1.5cm
   margin-right: 1.8cm
   margin-top: 2cm
   margin-bottom: 1.5cm
   papersize: a4
   ---
   ```

4. Build your CV:

   **Linux/macOS:**
   ```bash
   # Build all Markdown files in src/
   ./compile_all.sh
   
   # Or for a specific file
   ./compile.sh src/my-cv.md pdf
   ./compile.sh src/my-cv.md html
   ```

   **Windows:**
   ```powershell
   # Check if dependencies are installed
   .\check_deps.ps1
   
   # Build all Markdown files in src/
   .\compile_all.ps1
   
   # Or for a specific file
   .\compile.ps1 -SourceFile src/my-cv.md -Format pdf
   .\compile.ps1 -SourceFile src/my-cv.md -Format html
   ```

   **Using Make (Cross-platform):**
   ```bash
   # Will detect OS and use appropriate scripts
   make
   ```

5. Find the output in the `output/` folder.

### Automatic Publication Numbering

For publication lists, use standard Markdown ordered list syntax, but start each item with `1.` to enable automatic numbering:

```markdown
## Publications

1. Most recent publication (2025)
1. Next most recent publication (2024)
1. Older publication (2023)
```

This will be displayed with proper sequential numbering in the output.

## Customization

### Styles

To customize the appearance of your resume:

1. Create a new folder in the `styles/` directory
2. Add CSS files to the folder
3. Reference the style in your Markdown front matter with `style: your-style-name`

### Margins and Page Size

Control PDF margins and page size in your Markdown front matter:

```yaml
---
margin-left: 1.5cm
margin-right: 1.8cm
margin-top: 2cm
margin-bottom: 1.5cm
papersize: a4  # or letter, etc.
---
```

## Advanced Usage

### Watch Mode (Linux/macOS)

Automatically rebuild when files change:

```bash
./watch.sh
# or
make watch
```

### Using Docker

Build without installing dependencies (works on any platform with Docker):

```bash
# Build the Docker image
docker build -t markdown-resume .

# Generate PDFs and HTMLs
docker run -it --rm -v "${PWD}/src:/mdr/src" -v "${PWD}/output:/mdr/output" markdown-resume
# or
make docker
```

## GitHub Actions

The repository includes a GitHub Actions workflow optimized for Linux:

* Automatically builds and validates your CV on every push
* Runs shellcheck on bash scripts
* Tests the compilation process
* Uploads build artifacts
* Commits generated files back to the repository

The CI workflow is intentionally Linux-based for simplicity, reliability, and better compatibility with tools like Pandoc and wkhtmltopdf. For local development, both Windows and Linux/macOS are fully supported.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the [LICENSE.txt](LICENSE.txt) file for details.


