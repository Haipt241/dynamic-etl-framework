"""
Find where evadb_stage references are located
"""
import re
import sql_object_scripts as sqlobj

print("="*80)
print("Locating evadb_stage References")
print("="*80)

# Check create_prod_views
print("\n1. Checking create_prod_views...")
matches_views = list(re.finditer(r'`evadb_stage`\.', sqlobj.create_prod_views))
print(f"   Found: {len(matches_views)} references")

if matches_views:
    print("\n   First example:")
    match = matches_views[0]
    start = max(0, match.start() - 100)
    end = min(len(sqlobj.create_prod_views), match.end() + 100)
    context = sqlobj.create_prod_views[start:end]
    print(f"   {context}")

# Check create_prod_fxviews
print("\n2. Checking create_prod_fxviews...")
matches_fxviews = list(re.finditer(r'`evadb_stage`\.', sqlobj.create_prod_fxviews))
print(f"   Found: {len(matches_fxviews)} references")

if matches_fxviews:
    print("\n   First example:")
    match = matches_fxviews[0]
    start = max(0, match.start() - 100)
    end = min(len(sqlobj.create_prod_fxviews), match.end() + 100)
    context = sqlobj.create_prod_fxviews[start:end]
    print(f"   {context}")

print("\n" + "="*80)
print(f"Total evadb_stage references: {len(matches_views) + len(matches_fxviews)}")
print("="*80)
