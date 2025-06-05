import json
import os
from collections import defaultdict

def load_size_json(path):
    with open(path, 'r') as f:
        return json.load(f)

def extract_symbol_info(node, folder_map, prefix=""):
    """
    Recursively parse symbol tree, group by folder.
    node is dict representing one node in the tree.
    folder_map maps folder path -> list of symbols with sizes
    """
    name = node.get('name', '')
    size = node.get('size', 0)
    children = node.get('children', [])
    
    # Determine folder from symbol name or prefix path
    # Usually, name contains something like 'lib/src/foo/bar.dart::ClassName'
    # Let's extract folder before '::'
    folder = None
    if '::' in name:
        folder = name.split('::')[0]
    else:
        folder = name
    
    # Normalize folder to just folder path without file name
    folder_path = folder
    # For dart files, strip to directory path:
    if folder_path.endswith('.dart'):
        folder_path = os.path.dirname(folder_path)
    
    # Add symbol info to folder_map
    if size > 0:
        folder_map[folder_path].append({'name': name, 'size': size})

    # Recurse children
    for child in children:
        extract_symbol_info(child, folder_map, prefix=name)

def summarize_folder_map(folder_map, top_n=5):
    """
    Summarize size per folder and pick top N symbols by size.
    """
    summary = {}
    for folder, symbols in folder_map.items():
        total_size = sum(s['size'] for s in symbols)
        sorted_symbols = sorted(symbols, key=lambda x: x['size'], reverse=True)[:top_n]
        summary[folder] = {
            'total_size': total_size,
            'top_symbols': sorted_symbols
        }
    return summary

def main(input_path, output_path):
    data = load_size_json(input_path)
    folder_map = defaultdict(list)

    # The tree of symbols is usually in data['code']['tree']
    # Adjust this path if your JSON structure differs
    symbol_tree = data.get('code', {}).get('tree', [])

    for node in symbol_tree:
        extract_symbol_info(node, folder_map)

    summary = summarize_folder_map(folder_map)

    output = {
        'total_size': data.get('code', {}).get('size', 0),
        'folders': summary
    }

    with open(output_path, 'w') as f:
        json.dump(output, f, indent=2)
    print(f"Summary written to {output_path}")

if __name__ == "__main__":
    import sys
    if len(sys.argv) != 3:
        print("Usage: python parse_flutter_size.py <input_json> <output_json>")
    else:
        main(sys.argv[1], sys.argv[2])
