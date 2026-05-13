// ============================================================================
// kvpairs.scad - Lightweight Key-Value Pair Library
// ============================================================================
// A simple, functional key-value store implementation for OpenSCAD
// 
// Data Structure:
//   A KV store is represented as a list of 2-element arrays:
//   [
//       ["key1", value1],
//       ["key2", value2],
//       ["key3", value3],
//       ...
//   ]
//
// Features:
//   - Create new stores
//   - Get/retrieve values by key
//   - Set/update key-value pairs
//   - Delete keys
//   - List all keys or entries
//   - Merge two stores
//   - Clone/copy stores
// ============================================================================

// ============================================================================
// CORE FUNCTIONS
// ============================================================================

// Create a new empty key-value store
// Returns: Empty list for use as a KV store
function kv_new() = [];

// Create a new KV store with initial pairs
// Parameters:
//   pairs - list of [key, value] pairs
// Returns: KV store containing all provided pairs
// Example: kv_new_with([ ["name", "Cube"], ["size", 10] ])
function kv_new_with(pairs = []) = pairs;

// ============================================================================
// GET OPERATIONS
// ============================================================================

// Get a value from the store by key
// Parameters:
//   store - the KV store
//   key - the key to look up
//   default - default value if key not found (optional)
// Returns: The value associated with the key, or default/undef if not found
// Example: kv_get(store, "name")
function kv_get(store, key, default = undef) =
    let(matches = [for (pair = store) if (pair[0] == key) pair[1]])
    len(matches) > 0 ? matches[0] : default;

// Check if a key exists in the store
// Parameters:
//   store - the KV store
//   key - the key to check
// Returns: true if key exists, false otherwise
function kv_has(store, key) =
    len([for (pair = store) if (pair[0] == key) pair]) > 0;

// ============================================================================
// SET/UPDATE OPERATIONS
// ============================================================================

// Add or update a key-value pair
// Parameters:
//   store - the KV store
//   key - the key to add/update
//   value - the value to store
// Returns: New store with the pair added or updated
// Example: kv_set(store, "name", "NewName")
function kv_set(store, key, value) =
    concat([for (pair = store) if (pair[0] != key) pair], [[key, value]]);

// Add multiple key-value pairs at once
// Parameters:
//   store - the KV store
//   pairs - list of [key, value] pairs to add
// Returns: New store with all pairs added/updated
// Example: kv_set_multi(store, [ ["x", 10], ["y", 20] ])
function kv_set_multi(store, pairs) =
    concat([for (pair = store) if (!_key_in_list(pairs, pair[0])) pair], pairs);

// ============================================================================
// DELETE OPERATIONS
// ============================================================================

// Delete a key-value pair from the store
// Parameters:
//   store - the KV store
//   key - the key to delete
// Returns: New store with the pair removed
// Example: kv_delete(store, "name")
function kv_delete(store, key) =
    [for (pair = store) if (pair[0] != key) pair];

// Delete multiple keys at once
// Parameters:
//   store - the KV store
//   keys - list of keys to remove
// Returns: New store with all specified keys removed
// Example: kv_delete_multi(store, ["name", "color"])
function kv_delete_multi(store, keys) =
    [for (pair = store) if (!_contains_key(keys, pair[0])) pair];

// Clear all entries from the store
// Parameters:
//   store - the KV store (ignored, included for API consistency)
// Returns: Empty store
function kv_clear(store) = [];

// ============================================================================
// LIST/INSPECT OPERATIONS
// ============================================================================

// Get all keys from the store
// Parameters:
//   store - the KV store
// Returns: List of all keys in the store
// Example: kv_keys(store) => ["name", "size", "color"]
function kv_keys(store) =
    [for (pair = store) pair[0]];

// Get all values from the store
// Parameters:
//   store - the KV store
// Returns: List of all values in the store (in key order)
// Example: kv_values(store) => ["Cube", 10, "red"]
function kv_values(store) =
    [for (pair = store) pair[1]];

// Get all entries as a list of [key, value] pairs
// Parameters:
//   store - the KV store
// Returns: List of all [key, value] pairs
// Example: kv_entries(store) => [["name", "Cube"], ["size", 10]]
function kv_entries(store) = store;

// Get the number of key-value pairs in the store
// Parameters:
//   store - the KV store
// Returns: Number of entries
// Example: kv_size(store) => 3
function kv_size(store) = len(store);

// Check if the store is empty
// Parameters:
//   store - the KV store
// Returns: true if empty, false otherwise
function kv_is_empty(store) = len(store) == 0;

// ============================================================================
// TRANSFORM OPERATIONS
// ============================================================================

// Create a copy/clone of the store
// Parameters:
//   store - the KV store to copy
// Returns: Independent copy of the store
// Note: Creates shallow copy of the structure; nested objects still reference original
function kv_clone(store) =
    [for (pair = store) [pair[0], pair[1]]];

// Merge two stores, with second store's values taking precedence
// Parameters:
//   store1 - first KV store
//   store2 - second KV store (values override store1)
// Returns: New merged store combining both
// Example: kv_merge(store1, store2)
function kv_merge(store1, store2) =
    kv_set_multi(store1, store2);

// Filter store to keep only specified keys
// Parameters:
//   store - the KV store
//   keys - list of keys to keep
// Returns: New store containing only the specified keys
// Example: kv_pick(store, ["name", "size"])
function kv_pick(store, keys) =
    [for (key = keys) 
        if (kv_has(store, key))
            [key, kv_get(store, key)]
    ];

// Filter store to remove specified keys
// Parameters:
//   store - the KV store
//   keys - list of keys to exclude
// Returns: New store without the specified keys
// Example: kv_omit(store, ["temp", "debug"])
function kv_omit(store, keys) =
    [for (pair = store)
        if (!_contains_key(keys, pair[0]))
            pair
    ];

// ============================================================================
// UTILITY FUNCTIONS
// ============================================================================

// Convert store to a human-readable string representation
// Parameters:
//   store - the KV store
// Returns: String representation of the store
function kv_to_string(store) =
    str("KVStore(", kv_size(store), " entries, keys:", kv_keys(store), ")");

// Check if store contains a specific value
// Parameters:
//   store - the KV store
//   value - the value to search for
// Returns: true if value exists in store, false otherwise
function kv_contains_value(store, value) =
    let(values = kv_values(store))
    len([for (v = values) if (v == value) v]) > 0;

// Internal helper - check if key is in list of pairs
function _key_in_list(pairs, key) =
    len([for (pair = pairs) if (pair[0] == key) pair]) > 0;

// Internal helper - check if specific key exists in key list
function _contains_key(keys, key) =
    len([for (k = keys) if (k == key) k]) > 0;

// ============================================================================
// EXAMPLE USAGE (uncomment to test)
// ============================================================================

// // Create stores
// store1 = kv_new_with([
//     ["name", "Coaster Holder"],
//     ["size", 89],
//     ["color", "SaddleBrown"]
// ]);

// store2 = kv_new_with([
//     ["height", 150],
//     ["color", "Red"]
// ]);

// // Get operations
// name = kv_get(store1, "name");                      // "Coaster Holder"
// missing = kv_get(store1, "missing", "N/A");         // "N/A"
// has_size = kv_has(store1, "size");                  // true

// // Set operations
// store3 = kv_set(store1, "material", "PETG");        // Add new pair
// store4 = kv_set(store1, "size", 100);               // Update existing
// store5 = kv_set_multi(store1, [["x", 10], ["y", 20]]);

// // Delete operations
// store6 = kv_delete(store3, "material");             // Remove pair
// store7 = kv_delete_multi(store1, ["color", "size"]);

// // List operations
// keys = kv_keys(store1);                             // ["name", "size", "color"]
// values = kv_values(store1);                         // ["Coaster Holder", 89, "SaddleBrown"]
// size = kv_size(store1);                             // 3
// empty = kv_is_empty(store1);                        // false

// // Transform operations
// merged = kv_merge(store1, store2);                  // Merge two stores
// subset = kv_pick(store1, ["name", "size"]);        // Keep only these keys
// filtered = kv_omit(store1, ["color"]);             // Remove these keys
// cloned = kv_clone(store1);                          // Make a copy

// // Utility operations
// description = kv_to_string(store1);                 // "KVStore(3 entries, ...)"
// has_value = kv_contains_value(store1, 89);          // true

// echo(description = description);
// echo(merged = kv_to_string(merged));
// echo(subset = kv_to_string(subset));
// echo(filtered = kv_to_string(filtered));
// echo(cloned = kv_to_string(cloned));
// echo(has_value = has_value);
// echo(missing = missing);
// echo(has_size = has_size);
