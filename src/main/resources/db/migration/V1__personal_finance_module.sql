-- Personal Finance Module
-- Uses shared PostgreSQL database with schema 'manacommunity'

-- Finance Accounts
CREATE TABLE IF NOT EXISTS manacommunity.finance_accounts (
    id              BIGSERIAL PRIMARY KEY,
    user_id         BIGINT       NOT NULL,
    account_name    VARCHAR(100) NOT NULL,
    account_type    VARCHAR(30)  NOT NULL DEFAULT 'BANK',
    balance         NUMERIC(15,2) NOT NULL DEFAULT 0.00,
    currency        VARCHAR(10)  NOT NULL DEFAULT 'INR',
    institution     VARCHAR(100),
    account_number_masked VARCHAR(20),
    color           VARCHAR(20),
    icon            VARCHAR(50),
    active          BOOLEAN      NOT NULL DEFAULT TRUE,
    include_in_total BOOLEAN     NOT NULL DEFAULT TRUE,
    created_at      TIMESTAMP    NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMP    NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_finance_accounts_user ON manacommunity.finance_accounts(user_id);

-- Finance Categories
CREATE TABLE IF NOT EXISTS manacommunity.finance_categories (
    id            BIGSERIAL PRIMARY KEY,
    user_id       BIGINT,
    name          VARCHAR(80)  NOT NULL,
    category_type VARCHAR(20)  NOT NULL,
    icon          VARCHAR(50),
    color         VARCHAR(20),
    is_system     BOOLEAN      NOT NULL DEFAULT FALSE,
    sort_order    INT          NOT NULL DEFAULT 0,
    created_at    TIMESTAMP    NOT NULL DEFAULT NOW(),
    updated_at    TIMESTAMP    NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_finance_categories_user ON manacommunity.finance_categories(user_id);

-- Seed system categories
INSERT INTO manacommunity.finance_categories (name, category_type, is_system, icon, sort_order)
SELECT * FROM (VALUES
    ('Salary',          'INCOME',  TRUE, 'wallet',          1),
    ('Freelance',       'INCOME',  TRUE, 'briefcase',       2),
    ('Investment',      'INCOME',  TRUE, 'trending-up',     3),
    ('Other Income',    'INCOME',  TRUE, 'plus-circle',     4),
    ('Food & Dining',   'EXPENSE', TRUE, 'utensils',        5),
    ('Transport',       'EXPENSE', TRUE, 'car',             6),
    ('Shopping',        'EXPENSE', TRUE, 'shopping-bag',    7),
    ('Bills & Utilities','EXPENSE',TRUE, 'zap',             8),
    ('Entertainment',   'EXPENSE', TRUE, 'film',            9),
    ('Health',          'EXPENSE', TRUE, 'heart',          10),
    ('Education',       'EXPENSE', TRUE, 'book',           11),
    ('Rent',            'EXPENSE', TRUE, 'home',           12),
    ('Maintenance',     'EXPENSE', TRUE, 'tool',           13),
    ('Other Expense',   'EXPENSE', TRUE, 'more-horizontal',14)
) AS v(name, category_type, is_system, icon, sort_order)
WHERE NOT EXISTS (SELECT 1 FROM manacommunity.finance_categories WHERE is_system = TRUE LIMIT 1);

-- Finance Transactions
CREATE TABLE IF NOT EXISTS manacommunity.finance_transactions (
    id                    BIGSERIAL PRIMARY KEY,
    user_id               BIGINT        NOT NULL,
    account_id            BIGINT        NOT NULL REFERENCES manacommunity.finance_accounts(id),
    txn_type              VARCHAR(20)   NOT NULL,
    amount                NUMERIC(15,2) NOT NULL,
    category_id           BIGINT        REFERENCES manacommunity.finance_categories(id),
    txn_date              DATE          NOT NULL,
    description           VARCHAR(255),
    payee                 VARCHAR(100),
    transfer_to_account_id BIGINT       REFERENCES manacommunity.finance_accounts(id),
    source_module         VARCHAR(50),
    source_ref_id         VARCHAR(100),
    notes                 TEXT,
    recurring_instance    BOOLEAN       NOT NULL DEFAULT FALSE,
    created_at            TIMESTAMP     NOT NULL DEFAULT NOW(),
    updated_at            TIMESTAMP     NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_finance_txn_user      ON manacommunity.finance_transactions(user_id);
CREATE INDEX IF NOT EXISTS idx_finance_txn_account   ON manacommunity.finance_transactions(account_id);
CREATE INDEX IF NOT EXISTS idx_finance_txn_date      ON manacommunity.finance_transactions(user_id, txn_date);
CREATE INDEX IF NOT EXISTS idx_finance_txn_category  ON manacommunity.finance_transactions(category_id);

-- Finance Budgets
CREATE TABLE IF NOT EXISTS manacommunity.finance_budgets (
    id                 BIGSERIAL PRIMARY KEY,
    user_id            BIGINT        NOT NULL,
    category_id        BIGINT        NOT NULL REFERENCES manacommunity.finance_categories(id),
    budget_amount      NUMERIC(15,2) NOT NULL,
    period             VARCHAR(20)   NOT NULL DEFAULT 'MONTHLY',
    budget_year        INT           NOT NULL,
    budget_month       INT,
    alert_threshold_pct INT          NOT NULL DEFAULT 80,
    created_at         TIMESTAMP     NOT NULL DEFAULT NOW(),
    updated_at         TIMESTAMP     NOT NULL DEFAULT NOW(),
    CONSTRAINT uq_budget_user_cat_period UNIQUE (user_id, category_id, budget_year, budget_month)
);

CREATE INDEX IF NOT EXISTS idx_finance_budgets_user ON manacommunity.finance_budgets(user_id);

-- Finance Bills
CREATE TABLE IF NOT EXISTS manacommunity.finance_bills (
    id                BIGSERIAL PRIMARY KEY,
    user_id           BIGINT        NOT NULL,
    name              VARCHAR(100)  NOT NULL,
    amount            NUMERIC(15,2) NOT NULL,
    due_date          DATE          NOT NULL,
    category_id       BIGINT        REFERENCES manacommunity.finance_categories(id),
    status            VARCHAR(20)   NOT NULL DEFAULT 'PENDING',
    recurring         BOOLEAN       NOT NULL DEFAULT FALSE,
    recurrence_period VARCHAR(20),
    auto_pay          BOOLEAN       NOT NULL DEFAULT FALSE,
    notes             TEXT,
    created_at        TIMESTAMP     NOT NULL DEFAULT NOW(),
    updated_at        TIMESTAMP     NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_finance_bills_user ON manacommunity.finance_bills(user_id);

-- Finance Recurring Transactions
CREATE TABLE IF NOT EXISTS manacommunity.finance_recurring_txns (
    id            BIGSERIAL PRIMARY KEY,
    user_id       BIGINT        NOT NULL,
    account_id    BIGINT        NOT NULL REFERENCES manacommunity.finance_accounts(id),
    txn_type      VARCHAR(20)   NOT NULL,
    amount        NUMERIC(15,2) NOT NULL,
    category_id   BIGINT        REFERENCES manacommunity.finance_categories(id),
    description   VARCHAR(255),
    payee         VARCHAR(100),
    frequency     VARCHAR(20)   NOT NULL,
    start_date    DATE          NOT NULL,
    end_date      DATE,
    next_due_date DATE          NOT NULL,
    active        BOOLEAN       NOT NULL DEFAULT TRUE,
    created_at    TIMESTAMP     NOT NULL DEFAULT NOW(),
    updated_at    TIMESTAMP     NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_finance_recurring_user ON manacommunity.finance_recurring_txns(user_id);
