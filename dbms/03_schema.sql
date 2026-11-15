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

ALTER TABLE category
    ADD CONSTRAINT category_type_valid
    CHECK (category_type IN ('income', 'expense'));

ALTER TABLE financial_transaction
    ADD CONSTRAINT transaction_no_positive CHECK (transaction_no > 0),
    ADD CONSTRAINT transaction_type_valid
        CHECK (transaction_type IN ('income', 'expense')),
    ADD CONSTRAINT transaction_amount_positive CHECK (amount > 0);

CREATE INDEX account_user_id_idx ON account(user_id);
CREATE INDEX transaction_category_id_idx
    ON financial_transaction(category_id);
