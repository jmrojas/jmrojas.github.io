#!/usr/bin/env python3
"""Fetch Google Scholar citation counts and write to _data/citations.yml."""

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
        author = scholarly.fill(author, sections=["publications"])
    except Exception as exc:
        print(f"Error fetching author profile: {exc}", file=sys.stderr)
        sys.exit(1)

    papers = {}
    publications = author.get("publications", [])
    print(f"Found {len(publications)} publications, fetching citation counts...")

    for pub in publications:
        pub_id = pub.get("author_pub_id", "")
        if not pub_id:
            continue
        try:
            filled = scholarly.fill(pub)
            bib = filled.get("bib", {})
            papers[pub_id] = {
                "citations": filled.get("num_citations", 0),
                "title": bib.get("title", ""),
                "year": str(bib.get("pub_year", "Unknown Year")),
            }
        except Exception as exc:
            print(f"Warning: skipping {pub_id}: {exc}", file=sys.stderr)

    data = {
        "metadata": {"last_updated": datetime.date.today().isoformat()},
        "papers": papers,
    }

    with open(OUTPUT_FILE, "w", encoding="utf-8") as fh:
        yaml.dump(data, fh, default_flow_style=False, allow_unicode=True)

    print(f"Written {len(papers)} entries to {OUTPUT_FILE}")


if __name__ == "__main__":
    main()
