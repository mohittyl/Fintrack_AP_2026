# Fintrack Database Normalization

This note shows how Fintrack's income and expense data can be organized to reduce repeated information and avoid update, insertion, and deletion anomalies. The example assumes users can create accounts, record transactions, and assign each transaction a category.

## Starting point

A first draft could keep all the details needed to display a transaction in one relation:

`TransactionRecord(user_id, user_name, email, account_id, account_name, transaction_no, transaction_date, transaction_type, amount, category_id, category_name, description)`

A user can have multiple accounts and transactions, so their name and email may appear repeatedly. Account names and category names are also repeated across transactions. This makes it possible for the same account or category to have different names in different rows after an incomplete update.

For this design, `transaction_no` is unique within a user's account. The identifying key for a transaction is therefore `(account_id, transaction_no)`. Each account belongs to one user, and each transaction belongs to one account and one category.

## First Normal Form (1NF)

A relation is in 1NF when each field contains one value and each row has a key. The starting relation stores one transaction per row. Amount, date, type, account, and category are individual values; multiple transactions are never packed into one field.

`TransactionRecord(user_id, user_name, email, account_id, account_name, transaction_no, transaction_date, transaction_type, amount, category_id, category_name, description)`

**Primary key:** `(account_id, transaction_no)`

The values are atomic, and the key identifies one transaction within its account.

## Second Normal Form (2NF)

A relation is in 2NF when it is in 1NF and each non-key attribute depends on the whole key. Here, the transaction key is composite. Account details depend on `account_id` alone, while transaction date, type, amount, category, and description depend on `(account_id, transaction_no)`. The account details are therefore only partially dependent on the key.

Separate account facts from transaction facts:

### Account

`Account(account_id, user_id, user_name, email, account_name)`

**Primary key:** `account_id`

### Transaction

`Transaction(account_id, transaction_no, transaction_date, transaction_type, amount, category_id, category_name, description)`

**Primary key:** `(account_id, transaction_no)`  
**Foreign key:** `account_id` references `Account(account_id)`

Account attributes now depend on the account key. Transaction attributes depend on the full transaction key. User and category names remain in this intermediate design and are addressed in 3NF.
