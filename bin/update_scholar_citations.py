#!/usr/bin/env python3
"""Fetch citation counts from Semantic Scholar and write to _data/citations.yml.

Uses the Semantic Scholar public API (no key required, no CI blocking).
Find your author ID at semanticscholar.org — it's the number in the URL:
  https://www.semanticscholar.org/author/<name>/<ID>
"""

import datetime
import os
import sys
import time

import requests
import yaml

# ── Configuration ────────────────────────────────────────────────────────────
# Set S2_AUTHOR_ID here or via the environment variable of the same name.
S2_AUTHOR_ID = os.environ.get("S2_AUTHOR_ID", "2303408035")

# Fallback: search by name + institution if no ID is configured.
AUTHOR_NAME = "Jose Miguel Rojas"
AUTHOR_INSTITUTION = "Sheffield"

OUTPUT_FILE = "_data/citations.yml"
S2_API = "https://api.semanticscholar.org/graph/v1"
# ─────────────────────────────────────────────────────────────────────────────


def find_author_id() -> str:
    query = f"{AUTHOR_NAME} {AUTHOR_INSTITUTION}".strip()
    print(f"Searching Semantic Scholar for: {query!r}")
    resp = requests.get(
        f"{S2_API}/author/search",
        params={"query": query, "fields": "name,affiliations,paperCount"},
        timeout=30,
    )
    resp.raise_for_status()
    authors = resp.json().get("data", [])
    if not authors:
        print(f"No author found for '{query}'", file=sys.stderr)
        sys.exit(1)
    author = authors[0]
    print(f"Found: {author['name']} (ID: {author['authorId']}, "
          f"{author.get('paperCount', '?')} papers)")
    return author["authorId"]


def get_papers(author_id: str) -> dict:
    papers = {}
    params = {
        "fields": "title,year,citationCount",
        "limit": 100,
    }
    url = f"{S2_API}/author/{author_id}/papers"

    while True:
        resp = requests.get(url, params=params, timeout=30)
        resp.raise_for_status()
        data = resp.json()

        for paper in data.get("data", []):
            paper_id = paper["paperId"]
            papers[paper_id] = {
                "citations": paper.get("citationCount", 0),
                "title": paper.get("title", ""),
                "year": str(paper.get("year") or "Unknown Year"),
            }

        cursor = data.get("nextCursor")
        if not cursor:
            break
        params["token"] = cursor
        time.sleep(0.3)  # stay well within the rate limit

    return papers


def main():
    author_id = S2_AUTHOR_ID or find_author_id()
    print(f"Fetching papers for author ID: {author_id}")

    papers = get_papers(author_id)
    print(f"Retrieved {len(papers)} papers.")

    data = {
        "metadata": {"last_updated": datetime.date.today().isoformat()},
        "papers": papers,
    }

    with open(OUTPUT_FILE, "w", encoding="utf-8") as fh:
        yaml.dump(data, fh, default_flow_style=False, allow_unicode=True)

    print(f"Written to {OUTPUT_FILE}")


if __name__ == "__main__":
    main()
