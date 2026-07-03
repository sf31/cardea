# Database Schema

This document records the SQLite schema used by the published app. Treat this
as production data: schema changes must be backward-compatible and migrated.

## Current Production Schema

- Database file: `myapp.db`
- SQLite version: `1`
- Owner: `DatabaseService`
- Source: `lib/data/services/database.service.dart`

## Migration Rules

- Do not edit the version `1` table definitions in a way that assumes existing
  installs will be recreated.
- Any schema change must increment the `openDatabase` version.
- Any schema change must add an `onUpgrade` migration from the previous version.
- Migrations must preserve existing user data.
- Import/export compatibility should be considered when changing persisted
  fields.

## Table: `loyalty_cards`

Created by schema `v1`:

```sql
CREATE TABLE loyalty_cards (
  id TEXT PRIMARY KEY,
  name TEXT,
  barcode TEXT,
  color NUMBER,
  usage_count INTEGER,
  updated_at INTEGER
)
```

Model mapping: `LoyaltyCard`

| Column | Dart field | Type | Notes |
| --- | --- | --- | --- |
| `id` | `id` | `String` | Primary key. |
| `name` | `name` | `String` | Card display name. |
| `barcode` | `barcode` | `String` | Stored barcode payload. |
| `color` | `color` | `Color` | Stored as ARGB integer via `toARGB32()`. |
| `usage_count` | `usageCount` | `int` | Defaults to `0` when missing in `fromMap`. |
| `updated_at` | `updatedAt` | `DateTime` | Milliseconds since epoch; defaults to now when missing. |

## Table: `shopping_items`

Created by schema `v1`:

```sql
CREATE TABLE shopping_items (
  id TEXT PRIMARY KEY,
  name TEXT,
  updated_at INTEGER,
  completed_at INTEGER
)
```

Model mapping: `ShoppingItem`

| Column | Dart field | Type | Notes |
| --- | --- | --- | --- |
| `id` | `id` | `String` | Primary key. Generated with UUID for new items. |
| `name` | `name` | `String` | Item display name. |
| `updated_at` | `updatedAt` | `DateTime` | Milliseconds since epoch; defaults to now when missing. |
| `completed_at` | `completedAt` | `DateTime?` | `NULL` means item is not completed. |

## Repository Behavior

- `GenericRepository.create` uses `ConflictAlgorithm.replace`.
- `GenericRepository.create` and `GenericRepository.update` stamp `updated_at`
  with the current time before writing.
- `GenericRepository.setAll` clears the full table, then inserts each entity.
