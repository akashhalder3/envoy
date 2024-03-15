-- Initial schema for TRISA self hosted node data storage.
-- NOTE: all primary keys are ULIDs but rather than using the 16 byte blob version of
-- the ULIDs we're using the string representation to make database queries easier and
-- because use of the sqlite3 storage backend isn't considered to be performance
-- intensive. NOTE: the oklog/v2 ulid package provides Scan for both []byte and string.
BEGIN;

-- Accounts manages the customer accounts of the VASP (e.g. the address book) to make it
-- easier to create travel rule transactions as the originator (including storing
-- IVMS101 data and travel addresses).
CREATE TABLE IF NOT EXISTS accounts (
    id              TEXT PRIMARY KEY,
    customer_id     TEXT,
    first_name      TEXT,
    last_name       TEXT,
    travel_address  TEXT NOT NULL UNIQUE,
    ivms101         BLOB,
    created         DATETIME NOT NULL,
    modified        DATETIME NOT NULL
);

-- CryptoAddresses represent the crypto wallet address records for a specific account.
CREATE TABLE IF NOT EXISTS crypto_addresses (
    id              TEXT PRIMARY KEY,
    account_id      TEXT NOT NULL,
    crypto_address  TEXT NOT NULL UNIQUE,
    network         TEXT NOT NULL,
    asset_type      TEXT,
    tag             TEXT,
    created         DATETIME NOT NULL,
    modified        DATETIME NOT NULL,
    FOREIGN KEY (account_id) REFERENCES accounts(id) ON DELETE CASCADE
);

COMMIT;