# Query timings

All 18 statements in `04_queries.sql` were executed three times on a disposable local PostgreSQL database.

- PostgreSQL version: 18.4 (Postgres.app)
- Seed data before runs (users, accounts, categories, transactions): 3, 3, 3, 3
- Timing source: `EXPLAIN (ANALYZE, BUFFERS, VERBOSE, SUMMARY)` execution time, in milliseconds.
- Each run was wrapped in `BEGIN` / `ROLLBACK`, so INSERT, UPDATE, and DELETE statements did not persist changes.
- These are local timings on the small sample dataset; they are for the assignment run and are not a production benchmark.

| # | Query | Type | Run 1 (ms) | Run 2 (ms) | Run 3 (ms) | Average (ms) |
|---:|---|---|---:|---:|---:|---:|
| 1 | Create a user | WRITE | 0.190 | 0.069 | 0.077 | 0.112 |
| 2 | Find a user by email, for sign-in or duplicate checking | READ | 0.015 | 0.012 | 0.012 | 0.013 |
| 3 | Update a user's profile | WRITE | 0.240 | 0.070 | 0.063 | 0.124 |
| 4 | Delete a user who has no accounts | WRITE | 0.211 | 0.192 | 0.189 | 0.197 |
| 5 | List a user's accounts | READ | 0.037 | 0.032 | 0.036 | 0.035 |
| 6 | Create an account for a user | WRITE | 0.215 | 0.211 | 0.239 | 0.222 |
| 7 | Rename an account | WRITE | 0.091 | 0.077 | 0.096 | 0.088 |
| 8 | Delete an account with no remaining transactions | WRITE | 0.215 | 0.190 | 0.200 | 0.202 |
| 9 | List categories, optionally limited to a transaction type | READ | 0.021 | 0.020 | 0.018 | 0.020 |
| 10 | Create a category | WRITE | 0.088 | 0.065 | 0.081 | 0.078 |
| 11 | Update a category | WRITE | 0.077 | 0.070 | 0.063 | 0.070 |
| 12 | Delete a category when no transactions reference it | WRITE | 0.206 | 0.189 | 0.179 | 0.191 |
| 13 | Find one transaction | READ | 0.021 | 0.019 | 0.021 | 0.020 |
| 14 | Create a transaction | WRITE | 0.340 | 0.280 | 0.273 | 0.298 |
| 15 | Update a transaction's details | WRITE | 0.078 | 0.098 | 0.088 | 0.088 |
| 16 | Delete a transaction | WRITE | 0.047 | 0.066 | 0.045 | 0.053 |
| 17 | List transactions for an account with category details | READ | 0.058 | 0.040 | 0.044 | 0.047 |
| 18 | List all transactions belonging to a user across their accounts | READ | 0.053 | 0.052 | 0.067 | 0.057 |
