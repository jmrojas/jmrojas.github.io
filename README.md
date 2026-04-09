# jmrojas.github.io

Personal academic website of [José Miguel Rojas](https://jmrojas.github.io), Lecturer in Software Testing at the University of Sheffield.

Built with [Jekyll](https://jekyllrb.com) and the [al-folio](https://github.com/alshedivat/al-folio) theme, hosted on [GitHub Pages](https://pages.github.com).

## Maintenance

### Adding a new publication

Add a BibTeX entry to `_bibliography/papers.bib`. To feature it on the home page, add `selected = {true}` to the entry.

### Updating the bio

Edit `_pages/about.md`.

### Updating teaching

Edit `_pages/teaching.md`.

### Updating the CV

Replace `cv/cv-jmrojas-en.pdf` (and `cv/cv-jmrojas-es.pdf` for the Spanish version). The structured CV page is driven by `_data/cv.yml`.

### Updating social links

Edit `_data/socials.yml`.

## Local development

```bash
bundle install
bundle exec jekyll serve
```

The site will be available at `http://localhost:4000`.

## Deployment

Pushing to `master` triggers the GitHub Actions workflow (`.github/workflows/deploy.yml`), which builds the site and deploys it to the `gh-pages` branch. Make sure the GitHub Pages source in the repository settings is set to **Deploy from branch: gh-pages**.
