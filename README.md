# Snap2Card Database

PostgreSQL schema, functions, and protocol layer for the Snap2Card flashcard application.

## Requirements

- PostgreSQL 16+
- A PostgreSQL user with `CREATEDB` privileges

## Quick Start

### 1. Create role and database

```bash
createuser -U <admin_user> snap2card
createdb -U <admin_user> -O snap2card snap2card
```

### 2. Install schema, functions, triggers, and seeds

```bash
./scripts/install.sh ./config/order.txt
```

The script reads the SQL file list from `config/order.txt`, installs them in
dependency order, then runs the seed data in `test/test1/`.


### 3. Connect

```bash
psql -U snap2card -d snap2card
```

## Project Structure

```
schema/
  definitions/    Domain types and composite types (TYPE_ID, TYPE_NAME_CATEGORY, …)
  tables/         Table definitions
  grant/          GRANT statements
  functions/
    support/      Utility functions (ID conversion, GMT)
    insert/       Internal insert functions (FN_*)
    update/       Internal update functions
    retrieve/     Internal read functions
    delete/       Internal delete functions
  triggers/       Trigger functions and trigger definitions
  index/          Index definitions

protocols/        Public API functions (TYPE_ID interface, input validation)

config/
  order.txt       Install order for all SQL files

test/
  test1/          Seed data (accounts, cards, categories, exams)

docs/
  api-v1-0/
    functions.md  Protocol function reference
```

## Three-Layer Architecture

| Layer                | Location          | Responsibility                                    |
| -------------------- | ----------------- | ------------------------------------------------- |
| **Definitions**      | `schema/`         | Types, domains, tables                            |
| **Functions**        | `schema/functions/`| Business logic using raw INT ids                 |
| **Protocols**        | `protocols/`      | Public API — validates TYPE_ID inputs, delegates to functions |

Protocol functions (`CARD_INSERT`, `CATEGORY_LIST`, etc.) are the only functions
called by the application. They accept `TYPE_ID` (`CHAR(15)`) parameters,
validate prefixes and nullability, and call the corresponding `FN_*` functions
which work with raw `INT` ids.

## Custom Error Codes

All protocol functions use these SQLSTATE codes for error handling:

| Code  | Meaning                    |
| ----- | -------------------------- |
| 50001 | Null value not allowed     |
| 50002 | Length / range violation    |
| 50003 | Conflict / already exists   |
| 50004 | Not found                  |
| 50005 | No active session          |
| 50006 | Invalid format / prefix    |
| 50007 | Limit exceeded             |
| 50008 | Bad credentials            |

See [`docs/error.md`](docs/error.md) for details.

## Documentation

- [`docs/api-v1-0/functions.md`](docs/api-v1-0/functions.md) — full protocol function reference
