#!/usr/bin/env python3
"""Fetch Google Scholar citation counts and write to _data/citations.yml.

Uses a single author-level fill to avoid one HTTP request per publication.
"""

import datetime
import sys

import yaml
from scholarly import scholarly

SCHOLAR_ID = "NeuqUtcAAAAJ"
OUTPUT_FILE = "_data/citations.yml"


def main():
    print(f"Fetching publications for Scholar ID: {SCHOLAR_ID}")

    try:
        author = scholarly.search_author_id(SCHOLAR_ID)
        # Filling the 'publications' section returns num_citations for every
        # paper without a separate request per publication.
        author = scholarly.fill(author, sections=["publications"])
    except Exception as exc:
        print(f"Error fetching author profile: {exc}", file=sys.stderr)
        sys.exit(1)

    papers = {}
    publications = author.get("publications", [])
    print(f"Found {len(publications)} publications.")

    for pub in publications:
        pub_id = pub.get("author_pub_id", "")
        if not pub_id:
            continue
        bib = pub.get("bib", {})
        papers[pub_id] = {
            "citations": pub.get("num_citations", 0),
            "title": bib.get("title", ""),
            "year": str(bib.get("pub_year", "Unknown Year")),
        }

    data = {
        "metadata": {"last_updated": datetime.date.today().isoformat()},
        "papers": papers,
    }

    with open(OUTPUT_FILE, "w", encoding="utf-8") as fh:
        yaml.dump(data, fh, default_flow_style=False, allow_unicode=True)

    print(f"Written {len(papers)} entries to {OUTPUT_FILE}")


if __name__ == "__main__":
    main()
