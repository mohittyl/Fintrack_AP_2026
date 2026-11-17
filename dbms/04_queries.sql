-- Fintrack application query catalog
-- PostgreSQL; positional parameters are shown as $1, $2, etc.

-- Create a user. $1 = user_name, $2 = email.
-- WRITE
INSERT INTO app_user (user_name, email)
VALUES ($1, $2)
RETURNING user_id, user_name, email;

-- Find a user by email, for sign-in or duplicate checking. $1 = email.
-- READ
SELECT user_id, user_name, email
FROM app_user
WHERE email = $1;

-- Update a user's profile. $1 = user_id, $2 = user_name, $3 = email.
-- WRITE
UPDATE app_user
SET user_name = $2,
    email = $3
WHERE user_id = $1
RETURNING user_id, user_name, email;

-- List a user's accounts. $1 = user_id.
-- READ
SELECT a.account_id, a.account_name, u.user_id, u.user_name
FROM account AS a
JOIN app_user AS u ON u.user_id = a.user_id
WHERE a.user_id = $1
ORDER BY a.account_id;

-- Create an account for a user. $1 = user_id, $2 = account_name.
-- WRITE
INSERT INTO account (user_id, account_name)
VALUES ($1, $2)
RETURNING account_id, user_id, account_name;

-- Rename an account. $1 = account_id, $2 = account_name.
-- WRITE
UPDATE account
SET account_name = $2
WHERE account_id = $1
RETURNING account_id, user_id, account_name;

-- Delete an account with no remaining transactions. $1 = account_id.
-- WRITE
DELETE FROM account
WHERE account_id = $1
RETURNING account_id, user_id, account_name;

-- List categories, optionally limited to a transaction type.
-- $1 = 'income' or 'expense'; pass NULL to list all categories.
-- READ
SELECT category_id, category_name, category_type
FROM category
WHERE $1 IS NULL OR category_type = $1
ORDER BY category_type, category_name;

-- Create a category. $1 = category_name, $2 = category_type.
-- WRITE
INSERT INTO category (category_name, category_type)
VALUES ($1, $2)
RETURNING category_id, category_name, category_type;

-- Update a category. $1 = category_id, $2 = category_name, $3 = category_type.
-- WRITE
UPDATE category
SET category_name = $2,
    category_type = $3
WHERE category_id = $1
RETURNING category_id, category_name, category_type;

-- Delete a category when no transactions reference it. $1 = category_id.
-- WRITE
DELETE FROM category
WHERE category_id = $1
RETURNING category_id, category_name, category_type;

-- List transactions for an account with category details.
-- $1 = account_id; $2 = inclusive start date; $3 = inclusive end date.
-- READ
SELECT t.account_id, t.transaction_no, t.transaction_date,
       t.transaction_type, t.amount, t.description,
       c.category_id, c.category_name, c.category_type,
       a.account_name
FROM financial_transaction AS t
JOIN account AS a ON a.account_id = t.account_id
JOIN category AS c ON c.category_id = t.category_id
WHERE t.account_id = $1
  AND t.transaction_date >= $2
  AND t.transaction_date <= $3
ORDER BY t.transaction_date DESC, t.transaction_no DESC;

-- List all transactions belonging to a user across their accounts.
-- $1 = user_id; $2 = inclusive start date; $3 = inclusive end date.
-- READ
SELECT t.account_id, a.account_name, t.transaction_no,
       t.transaction_date, t.transaction_type, t.amount,
       t.description, c.category_id, c.category_name
FROM account AS a
JOIN financial_transaction AS t ON t.account_id = a.account_id
JOIN category AS c ON c.category_id = t.category_id
WHERE a.user_id = $1
  AND t.transaction_date >= $2
  AND t.transaction_date <= $3
ORDER BY t.transaction_date DESC, a.account_id, t.transaction_no DESC;
