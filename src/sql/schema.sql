-- =========================================================================
-- RRB MOCK TEST - ADD try1, try2, try3 RETAKE COLUMNS
-- Execute this script in your Database SQL Editor
-- Adds try1, try2, try3, try4, try5 columns to track repeated test attempts
-- =========================================================================

-- 1. ALTER RRB_MOCK_1_responses
ALTER TABLE public."RRB_MOCK_1_responses" ADD COLUMN IF NOT EXISTS try1 VARCHAR(10);
ALTER TABLE public."RRB_MOCK_1_responses" ADD COLUMN IF NOT EXISTS try2 VARCHAR(10);
ALTER TABLE public."RRB_MOCK_1_responses" ADD COLUMN IF NOT EXISTS try3 VARCHAR(10);
ALTER TABLE public."RRB_MOCK_1_responses" ADD COLUMN IF NOT EXISTS try4 VARCHAR(10);
ALTER TABLE public."RRB_MOCK_1_responses" ADD COLUMN IF NOT EXISTS try5 VARCHAR(10);
ALTER TABLE public."RRB_MOCK_1_responses" ADD COLUMN IF NOT EXISTS time_taken_try1 INTEGER DEFAULT 0;
ALTER TABLE public."RRB_MOCK_1_responses" ADD COLUMN IF NOT EXISTS time_taken_try2 INTEGER DEFAULT 0;
ALTER TABLE public."RRB_MOCK_1_responses" ADD COLUMN IF NOT EXISTS time_taken_try3 INTEGER DEFAULT 0;
ALTER TABLE public."RRB_MOCK_1_responses" ADD COLUMN IF NOT EXISTS attempt_number INTEGER DEFAULT 1;

-- Backfill existing rows in Mock 1 so existing answers become try1
UPDATE public."RRB_MOCK_1_responses"
SET try1 = his_answer,
    time_taken_try1 = time_taken_by_him,
    attempt_number = 1
WHERE try1 IS NULL AND his_answer IS NOT NULL;

-- 2. ALTER RRB_MOCK_2_responses
ALTER TABLE public."RRB_MOCK_2_responses" ADD COLUMN IF NOT EXISTS try1 VARCHAR(10);
ALTER TABLE public."RRB_MOCK_2_responses" ADD COLUMN IF NOT EXISTS try2 VARCHAR(10);
ALTER TABLE public."RRB_MOCK_2_responses" ADD COLUMN IF NOT EXISTS try3 VARCHAR(10);
ALTER TABLE public."RRB_MOCK_2_responses" ADD COLUMN IF NOT EXISTS try4 VARCHAR(10);
ALTER TABLE public."RRB_MOCK_2_responses" ADD COLUMN IF NOT EXISTS try5 VARCHAR(10);
ALTER TABLE public."RRB_MOCK_2_responses" ADD COLUMN IF NOT EXISTS time_taken_try1 INTEGER DEFAULT 0;
ALTER TABLE public."RRB_MOCK_2_responses" ADD COLUMN IF NOT EXISTS time_taken_try2 INTEGER DEFAULT 0;
ALTER TABLE public."RRB_MOCK_2_responses" ADD COLUMN IF NOT EXISTS time_taken_try3 INTEGER DEFAULT 0;
ALTER TABLE public."RRB_MOCK_2_responses" ADD COLUMN IF NOT EXISTS attempt_number INTEGER DEFAULT 1;

UPDATE public."RRB_MOCK_2_responses"
SET try1 = his_answer,
    time_taken_try1 = time_taken_by_him,
    attempt_number = 1
WHERE try1 IS NULL AND his_answer IS NOT NULL;

-- 3. ALTER RRB_MOCK_3_responses
ALTER TABLE public."RRB_MOCK_3_responses" ADD COLUMN IF NOT EXISTS try1 VARCHAR(10);
ALTER TABLE public."RRB_MOCK_3_responses" ADD COLUMN IF NOT EXISTS try2 VARCHAR(10);
ALTER TABLE public."RRB_MOCK_3_responses" ADD COLUMN IF NOT EXISTS try3 VARCHAR(10);
ALTER TABLE public."RRB_MOCK_3_responses" ADD COLUMN IF NOT EXISTS try4 VARCHAR(10);
ALTER TABLE public."RRB_MOCK_3_responses" ADD COLUMN IF NOT EXISTS try5 VARCHAR(10);
ALTER TABLE public."RRB_MOCK_3_responses" ADD COLUMN IF NOT EXISTS time_taken_try1 INTEGER DEFAULT 0;
ALTER TABLE public."RRB_MOCK_3_responses" ADD COLUMN IF NOT EXISTS time_taken_try2 INTEGER DEFAULT 0;
ALTER TABLE public."RRB_MOCK_3_responses" ADD COLUMN IF NOT EXISTS time_taken_try3 INTEGER DEFAULT 0;
ALTER TABLE public."RRB_MOCK_3_responses" ADD COLUMN IF NOT EXISTS attempt_number INTEGER DEFAULT 1;

UPDATE public."RRB_MOCK_3_responses"
SET try1 = his_answer,
    time_taken_try1 = time_taken_by_him,
    attempt_number = 1
WHERE try1 IS NULL AND his_answer IS NOT NULL;
