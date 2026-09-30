-- Personal Finance Module
-- Uses shared PostgreSQL database with schema 'manacommunity'

-- Finance Accounts
CREATE TABLE IF NOT EXISTS manacommunity.pf_account (
    id                    BIGSERIAL PRIMARY KEY,
    user_id               BIGINT        NOT NULL,
    account_name          VARCHAR(100)  NOT NULL,
    account_type          VARCHAR(30)   NOT NULL DEFAULT 'BANK',
    balance               NUMERIC(15,2) NOT NULL DEFAULT 0.00,
    currency              VARCHAR(3)    NOT NULL DEFAULT 'INR',
    institution           VARCHAR(50),
    account_number_masked VARCHAR(30),
    color                 VARCHAR(20),
    icon                  VARCHAR(50),
    is_active             BOOLEAN       NOT NULL DEFAULT TRUE,
    include_in_total      BOOLEAN       NOT NULL DEFAULT TRUE,
    created_at            TIMESTAMP     NOT NULL DEFAULT NOW(),
    updated_at            TIMESTAMP     NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_pf_account_user ON manacommunity.pf_account(user_id);

-- Finance Categories
CREATE TABLE IF NOT EXISTS manacommunity.pf_category (
    id            BIGSERIAL PRIMARY KEY,
    user_id       BIGINT,
    name          VARCHAR(80)  NOT NULL,
    category_type VARCHAR(20)  NOT NULL,
    icon          VARCHAR(50),
    color         VARCHAR(20),
    is_system     BOOLEAN      NOT NULL DEFAULT FALSE,
    sort_order    INT          NOT NULL DEFAULT 0,
    created_at    TIMESTAMP    NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_pf_category_user ON manacommunity.pf_category(user_id);

-- Seed system categories
INSERT INTO manacommunity.pf_category (name, category_type, is_system, icon, sort_order)
SELECT * FROM (VALUES
    ('Salary',           'INCOME',  TRUE, 'wallet',          1),
    ('Freelance',        'INCOME',  TRUE, 'briefcase',       2),
    ('Investment',       'INCOME',  TRUE, 'trending-up',     3),
    ('Other Income',     'INCOME',  TRUE, 'plus-circle',     4),
    ('Food & Dining',    'EXPENSE', TRUE, 'utensils',        5),
    ('Transport',        'EXPENSE', TRUE, 'car',             6),
    ('Shopping',         'EXPENSE', TRUE, 'shopping-bag',    7),
    ('Bills & Utilities','EXPENSE', TRUE, 'zap',             8),
    ('Entertainment',    'EXPENSE', TRUE, 'film',            9),
    ('Health',           'EXPENSE', TRUE, 'heart',          10),
    ('Education',        'EXPENSE', TRUE, 'book',           11),
    ('Rent',             'EXPENSE', TRUE, 'home',           12),
    ('Maintenance',      'EXPENSE', TRUE, 'tool',           13),
    ('Other Expense',    'EXPENSE', TRUE, 'more-horizontal',14)
) AS v(name, category_type, is_system, icon, sort_order)
WHERE NOT EXISTS (SELECT 1 FROM manacommunity.pf_category WHERE is_system = TRUE LIMIT 1);

-- Finance Transactions
CREATE TABLE IF NOT EXISTS manacommunity.pf_transaction (
    id                     BIGSERIAL PRIMARY KEY,
    user_id                BIGINT        NOT NULL,
    account_id             BIGINT        NOT NULL REFERENCES manacommunity.pf_account(id),
    txn_type               VARCHAR(20)   NOT NULL,
    amount                 NUMERIC(15,2) NOT NULL,
    category_id            BIGINT        REFERENCES manacommunity.pf_category(id),
    txn_date               DATE          NOT NULL,
    description            VARCHAR(255),
    payee                  VARCHAR(255),
    transfer_to_account_id BIGINT        REFERENCES manacommunity.pf_account(id),
    source_module          VARCHAR(50),
    source_ref_id          BIGINT,
    notes                  TEXT,
    is_recurring_instance  BOOLEAN       NOT NULL DEFAULT FALSE,
    created_at             TIMESTAMP     NOT NULL DEFAULT NOW(),
    updated_at             TIMESTAMP     NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_pf_txn_user     ON manacommunity.pf_transaction(user_id);
CREATE INDEX IF NOT EXISTS idx_pf_txn_account  ON manacommunity.pf_transaction(account_id);
CREATE INDEX IF NOT EXISTS idx_pf_txn_date     ON manacommunity.pf_transaction(user_id, txn_date);
CREATE INDEX IF NOT EXISTS idx_pf_txn_category ON manacommunity.pf_transaction(category_id);

-- Finance Budgets
CREATE TABLE IF NOT EXISTS manacommunity.pf_budget (
    id                  BIGSERIAL PRIMARY KEY,
    user_id             BIGINT        NOT NULL,
    category_id         BIGINT        NOT NULL REFERENCES manacommunity.pf_category(id),
    budget_amount       NUMERIC(15,2) NOT NULL,
    period              VARCHAR(20)   NOT NULL DEFAULT 'MONTHLY',
    budget_year         INT           NOT NULL,
    budget_month        INT,
    alert_threshold_pct INT           NOT NULL DEFAULT 80,
    created_at          TIMESTAMP     NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMP     NOT NULL DEFAULT NOW(),
    CONSTRAINT uq_pf_budget_user_cat_period UNIQUE (user_id, category_id, budget_year, budget_month)
);

CREATE INDEX IF NOT EXISTS idx_pf_budget_user ON manacommunity.pf_budget(user_id);

-- Finance Bills
CREATE TABLE IF NOT EXISTS manacommunity.pf_bill (
    id                BIGSERIAL PRIMARY KEY,
    user_id           BIGINT        NOT NULL,
    name              VARCHAR(150)  NOT NULL,
    amount            NUMERIC(15,2) NOT NULL,
    due_date          DATE          NOT NULL,
    category_id       BIGINT        REFERENCES manacommunity.pf_category(id),
    status            VARCHAR(20)   NOT NULL DEFAULT 'PENDING',
    is_recurring      BOOLEAN       NOT NULL DEFAULT FALSE,
    recurrence_period VARCHAR(20),
    auto_pay          BOOLEAN       NOT NULL DEFAULT FALSE,
    notes             TEXT,
    created_at        TIMESTAMP     NOT NULL DEFAULT NOW(),
    updated_at        TIMESTAMP     NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_pf_bill_user ON manacommunity.pf_bill(user_id);

-- Finance Recurring Transactions
CREATE TABLE IF NOT EXISTS manacommunity.pf_recurring_txn (
    id            BIGSERIAL PRIMARY KEY,
    user_id       BIGINT        NOT NULL,
    account_id    BIGINT        NOT NULL REFERENCES manacommunity.pf_account(id),
    txn_type      VARCHAR(20)   NOT NULL,
    amount        NUMERIC(15,2) NOT NULL,
    category_id   BIGINT        REFERENCES manacommunity.pf_category(id),
    description   VARCHAR(255),
    payee         VARCHAR(255),
    frequency     VARCHAR(20)   NOT NULL,
    start_date    DATE          NOT NULL,
    end_date      DATE,
    next_due_date DATE          NOT NULL,
    is_active     BOOLEAN       NOT NULL DEFAULT TRUE,
    created_at    TIMESTAMP     NOT NULL DEFAULT NOW(),
    updated_at    TIMESTAMP     NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_pf_recurring_user ON manacommunity.pf_recurring_txn(user_id);
