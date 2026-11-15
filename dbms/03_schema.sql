-- Fintrack database schema

CREATE TABLE app_user (
    user_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    user_name TEXT NOT NULL,
    email TEXT NOT NULL UNIQUE
);

CREATE TABLE account (
    account_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    user_id BIGINT NOT NULL REFERENCES app_user(user_id),
    account_name TEXT NOT NULL
);

CREATE TABLE category (
    category_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    category_name TEXT NOT NULL,
    category_type TEXT NOT NULL
);

CREATE TABLE financial_transaction (
    account_id BIGINT NOT NULL REFERENCES account(account_id),
    transaction_no INTEGER NOT NULL,
    transaction_date DATE NOT NULL,
    transaction_type TEXT NOT NULL,
    amount NUMERIC(12, 2) NOT NULL,
    category_id BIGINT NOT NULL REFERENCES category(category_id),
    description TEXT,
    PRIMARY KEY (account_id, transaction_no)
);
