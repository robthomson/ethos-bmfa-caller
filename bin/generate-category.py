#!/usr/bin/env python3
"""
Generate sequences.lua and soundlist.csv files from a categories/<name>.json source.

Reads:   categories/<name>.json                   (repo root, not deployed)
Writes:  src/bmfa-caller/categories/<name>/sequences.lua
         src/bmfa-caller/categories/<name>/<cert-key>/soundlist.csv

Usage:
    python generate-category.py                   # process all categories/*.json
    python generate-category.py --cat airplane    # process one category only
"""

import argparse
import csv
import glob
import json
import os

SCRIPT_DIR   = os.path.dirname(os.path.abspath(__file__))
REPO_ROOT    = os.path.normpath(os.path.join(SCRIPT_DIR, ".."))
CATS_SRC     = os.path.join(REPO_ROOT, "categories")
CATS_OUT     = os.path.join(REPO_ROOT, "src", "bmfa-caller", "categories")


def write_lua(data, out_dir):
    lines = []
    lines.append("return {")
    lines.append(f'    key   = "{data["key"]}",')
    lines.append(f'    name  = "{data["name"]}",')
    lines.append("    certs = {")
    for cert in data["certs"]:
        lines.append("        {")
        lines.append(f'            key  = "{cert["key"]}",')
        lines.append(f'            name = "{cert["name"]}",')
        lines.append("            seq  = {")
        for fig in cert["figures"]:
            lines.append(f'                {{file="{fig["file"]}", label="{fig["label"]}"}},')
        lines.append("            },")
        lines.append("        },")
    lines.append("    },")
    lines.append("}")
    lines.append("")

    os.makedirs(out_dir, exist_ok=True)
    path = os.path.join(out_dir, "sequences.lua")
    with open(path, "w", encoding="utf-8", newline="\n") as f:
        f.write("\n".join(lines))
    print(f"  wrote {os.path.relpath(path, REPO_ROOT)}")


def write_csv(data, out_dir):
    disc_key = data["key"]
    for cert in data["certs"]:
        cert_dir = os.path.join(out_dir, cert["key"])
        os.makedirs(cert_dir, exist_ok=True)
        path = os.path.join(cert_dir, "soundlist.csv")
        with open(path, "w", encoding="utf-8", newline="") as f:
            writer = csv.writer(f)
            writer.writerow(["filename", "text"])
            writer.writerow([f"{disc_key}/{cert['key']}/rst.wav", cert["reset_tts"]])
            for fig in cert["figures"]:
                writer.writerow([f"{disc_key}/{cert['key']}/{fig['file']}.wav", fig["tts"]])
        print(f"  wrote {os.path.relpath(path, REPO_ROOT)}")


def process_cat(json_path):
    with open(json_path, encoding="utf-8") as f:
        data = json.load(f)
    print(f"\n--- {data['name']} ({data['key']}) ---")
    out_dir = os.path.join(CATS_OUT, data["key"])
    write_lua(data, out_dir)
    write_csv(data, out_dir)


def main():
    parser = argparse.ArgumentParser(description="Generate Lua + CSV files from category JSON")
    parser.add_argument("--cat", default=None, help="Process a single category (e.g. airplane)")
    args = parser.parse_args()

    if args.cat:
        json_path = os.path.join(CATS_SRC, f"{args.cat}.json")
        if not os.path.exists(json_path):
            print(f"ERROR: not found: {json_path}")
            return 1
        process_cat(json_path)
    else:
        paths = sorted(glob.glob(os.path.join(CATS_SRC, "*.json")))
        if not paths:
            print(f"No .json files found under {CATS_SRC}")
            return 1
        for p in paths:
            process_cat(p)

    print("\nDone.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
