"""
Test to demonstrate the delimiter issue with stored procedures
"""

# Sample procedure similar to what's in prereq_stored_procs
sample_proc = """
DROP PROCEDURE IF EXISTS test_proc;

CREATE PROCEDURE test_proc (IN p_id int)
BEGIN
  DECLARE v_count INT;
  SELECT COUNT(*) INTO v_count FROM some_table;
  INSERT INTO log_table VALUES (v_count);
END
$$
"""

# Simulate what execute_multiple_sqlscripts does
statements = sample_proc.strip().split(';')

print("="*80)
print("Simulating execute_multiple_sqlscripts splitting")
print("="*80)
print(f"\nOriginal procedure length: {len(sample_proc)} chars")
print(f"Number of statements after split(';'): {len(statements)}")
print("\nStatements created:\n")

for i, stmt in enumerate(statements, 1):
    stmt = stmt.strip()
    if not stmt or stmt == '$$':
        print(f"{i}. [SKIPPED - empty or $$]")
        continue
    preview = stmt.replace('\n', ' ')[:100]
    print(f"{i}. {preview}...")

print("\n" + "="*80)
print("ANALYSIS")
print("="*80)
print("\n⚠ PROBLEM DETECTED!")
print("The procedure is split into multiple incomplete statements.")
print("Each internal semicolon (after DECLARE, SELECT, INSERT) creates a break.")
print("\nExpected: 2 statements (DROP, CREATE PROCEDURE)")
print(f"Actual: {len([s for s in statements if s.strip() and s.strip() != '$$'])} statements")

print("\n" + "="*80)
print("SOLUTION OPTIONS")
print("="*80)
print("\n1. Change procedure delimiter from $$ to ; (end with 'END;' instead of 'END $$')")
print("2. Add DELIMITER $$ before CREATE and DELIMITER ; after END $$")
print("3. Modify execute_multiple_sqlscripts to handle $$ delimiter")
print("\nRecommended: Option 1 - Change END $$ to END;")
