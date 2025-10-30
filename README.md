# workflow-kit Documentation

> Comprehensive documentation for workflow-kit GitHub Actions workflows

[![Deploy Docs](https://github.com/workflow-kit/docs/actions/workflows/deploy-docs.yml/badge.svg)](https://github.com/workflow-kit/docs/actions/workflows/deploy-docs.yml)

## 📚 Documentation

Visit the documentation site: **[workflow-kit.github.io/docs](https://workflow-kit.github.io/docs/)**

## 🚀 Quick Start

This documentation is built with [MkDocs Material](https://squidfunk.github.io/mkdocs-material/).

### Local Development

```bash
# Install dependencies
pip install -r requirements.txt

# Serve locally
mkdocs serve

# Access at http://localhost:8000
```

### Build

```bash
# Build static site
mkdocs build

# Output in site/ directory
```

## 🛠️ Stack

- **MkDocs** — Static site generator
- **Material for MkDocs** — Theme
- **Mermaid** — Diagrams
- **GitHub Pages** — Hosting

## 📂 Structure

```
docs/
├── docs/                      # Documentation source
│   ├── index.md              # Homepage
│   ├── getting-started.md    # Getting started guide
│   ├── workflows/            # Workflow documentation
│   │   └── pr-auto-labeler/  # PR Auto-Labeler workflow
│   └── assets/               # Images and static files
├── mkdocs.yml                # MkDocs configuration
├── requirements.txt          # Python dependencies
├── Dockerfile               # Docker build
└── .github/workflows/       # GitHub Actions
    └── deploy-docs.yml      # Auto-deploy to GitHub Pages
```

## 🔄 Deployment

Documentation is automatically deployed to GitHub Pages when changes are pushed to `main` branch.

The deployment workflow:
1. Installs dependencies
2. Builds the MkDocs site
3. Deploys to `gh-pages` branch
4. GitHub Pages serves the site

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test locally with `mkdocs serve`
5. Submit a pull request

## 📝 License

MIT License - see [LICENSE](LICENSE) for details.

---

**Made with ❤️ by the workflow-kit team**

