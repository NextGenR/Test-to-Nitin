-- =========================================================================
-- RRB MOCK TEST PLATFORM - COMPLETE DATABASE SCHEMA
-- Execute this script in your Database SQL Editor
-- Creates response tables: RRB_MOCK_1_responses, RRB_MOCK_2_responses, RRB_MOCK_3_responses
-- =========================================================================

-- 1. CANDIDATES AUTHENTICATION TABLE
CREATE TABLE IF NOT EXISTS public.candidates (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT NOT NULL,
    mobile_number VARCHAR(15) UNIQUE NOT NULL,
    passcode VARCHAR(10) NOT NULL,
    roll_number VARCHAR(20) UNIQUE,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    last_login_at TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE public.candidates ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "Allow anon all on candidates" ON public.candidates;
CREATE POLICY "Allow anon all on candidates"
ON public.candidates FOR ALL TO anon, authenticated
USING (true) WITH CHECK (true);

-- =========================================================================
-- 2. INDIVIDUAL RESPONSE TABLES FOR EACH MOCK TEST
-- Exact columns required:
-- - name_of_candidate
-- - question_number
-- - section
-- - correct_answer
-- - his_answer
-- - time_taken_by_him
-- =========================================================================

-- MOCK TEST 1 RESPONSES
CREATE TABLE IF NOT EXISTS public."RRB_MOCK_1_responses" (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name_of_candidate TEXT NOT NULL,
    candidate_mobile VARCHAR(15),
    question_number INTEGER NOT NULL,
    section VARCHAR(100) NOT NULL,
    correct_answer VARCHAR(10) NOT NULL,
    his_answer VARCHAR(10),
    time_taken_by_him INTEGER DEFAULT 0, -- Time in seconds
    is_correct BOOLEAN GENERATED ALWAYS AS (
        CASE WHEN his_answer IS NOT NULL AND UPPER(TRIM(correct_answer)) = UPPER(TRIM(his_answer)) THEN TRUE ELSE FALSE END
    ) STORED,
    submitted_at TIMESTAMPTZ DEFAULT NOW(),
    CONSTRAINT unique_mock1_candidate_q UNIQUE (candidate_mobile, question_number)
);

ALTER TABLE public."RRB_MOCK_1_responses" ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "Allow anon all on RRB_MOCK_1_responses" ON public."RRB_MOCK_1_responses";
CREATE POLICY "Allow anon all on RRB_MOCK_1_responses"
ON public."RRB_MOCK_1_responses" FOR ALL TO anon, authenticated
USING (true) WITH CHECK (true);

-- MOCK TEST 2 RESPONSES
CREATE TABLE IF NOT EXISTS public."RRB_MOCK_2_responses" (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name_of_candidate TEXT NOT NULL,
    candidate_mobile VARCHAR(15),
    question_number INTEGER NOT NULL,
    section VARCHAR(100) NOT NULL,
    correct_answer VARCHAR(10) NOT NULL,
    his_answer VARCHAR(10),
    time_taken_by_him INTEGER DEFAULT 0, -- Time in seconds
    is_correct BOOLEAN GENERATED ALWAYS AS (
        CASE WHEN his_answer IS NOT NULL AND UPPER(TRIM(correct_answer)) = UPPER(TRIM(his_answer)) THEN TRUE ELSE FALSE END
    ) STORED,
    submitted_at TIMESTAMPTZ DEFAULT NOW(),
    CONSTRAINT unique_mock2_candidate_q UNIQUE (candidate_mobile, question_number)
);

ALTER TABLE public."RRB_MOCK_2_responses" ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "Allow anon all on RRB_MOCK_2_responses" ON public."RRB_MOCK_2_responses";
CREATE POLICY "Allow anon all on RRB_MOCK_2_responses"
ON public."RRB_MOCK_2_responses" FOR ALL TO anon, authenticated
USING (true) WITH CHECK (true);

-- MOCK TEST 3 RESPONSES
CREATE TABLE IF NOT EXISTS public."RRB_MOCK_3_responses" (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name_of_candidate TEXT NOT NULL,
    candidate_mobile VARCHAR(15),
    question_number INTEGER NOT NULL,
    section VARCHAR(100) NOT NULL,
    correct_answer VARCHAR(10) NOT NULL,
    his_answer VARCHAR(10),
    time_taken_by_him INTEGER DEFAULT 0, -- Time in seconds
    is_correct BOOLEAN GENERATED ALWAYS AS (
        CASE WHEN his_answer IS NOT NULL AND UPPER(TRIM(correct_answer)) = UPPER(TRIM(his_answer)) THEN TRUE ELSE FALSE END
    ) STORED,
    submitted_at TIMESTAMPTZ DEFAULT NOW(),
    CONSTRAINT unique_mock3_candidate_q UNIQUE (candidate_mobile, question_number)
);

ALTER TABLE public."RRB_MOCK_3_responses" ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "Allow anon all on RRB_MOCK_3_responses" ON public."RRB_MOCK_3_responses";
CREATE POLICY "Allow anon all on RRB_MOCK_3_responses"
ON public."RRB_MOCK_3_responses" FOR ALL TO anon, authenticated
USING (true) WITH CHECK (true);

-- =========================================================================
-- 3. TEST ATTEMPTS TABLE (Overall Scorecard, Timer & Pause/Resume state)
-- =========================================================================
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.tables WHERE table_schema = 'public' AND table_name = 'test_attempts'
    ) THEN
        CREATE TABLE public.test_attempts (
            id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
            candidate_mobile VARCHAR(15) NOT NULL,
            candidate_name TEXT,
            test_id VARCHAR(50) NOT NULL,
            remaining_seconds INTEGER NOT NULL DEFAULT 5400,
            current_question_index INTEGER DEFAULT 0,
            responses JSONB DEFAULT '{}'::jsonb,
            question_states JSONB DEFAULT '{}'::jsonb,
            status VARCHAR(20) DEFAULT 'in_progress',
            score NUMERIC(6, 2) DEFAULT 0,
            correct_count INTEGER DEFAULT 0,
            incorrect_count INTEGER DEFAULT 0,
            unattempted_count INTEGER DEFAULT 0,
            accuracy NUMERIC(5, 2) DEFAULT 0,
            started_at TIMESTAMPTZ DEFAULT NOW(),
            updated_at TIMESTAMPTZ DEFAULT NOW(),
            completed_at TIMESTAMPTZ,
            CONSTRAINT unique_candidate_test UNIQUE (candidate_mobile, test_id)
        );
    ELSE
        ALTER TABLE public.test_attempts ADD COLUMN IF NOT EXISTS candidate_mobile VARCHAR(15);
        ALTER TABLE public.test_attempts ADD COLUMN IF NOT EXISTS responses JSONB DEFAULT '{}'::jsonb;
        ALTER TABLE public.test_attempts ADD COLUMN IF NOT EXISTS remaining_seconds INTEGER DEFAULT 5400;
        ALTER TABLE public.test_attempts ADD COLUMN IF NOT EXISTS current_question_index INTEGER DEFAULT 0;
        ALTER TABLE public.test_attempts ADD COLUMN IF NOT EXISTS score NUMERIC(6, 2) DEFAULT 0;
        ALTER TABLE public.test_attempts ADD COLUMN IF NOT EXISTS correct_count INTEGER DEFAULT 0;
        ALTER TABLE public.test_attempts ADD COLUMN IF NOT EXISTS incorrect_count INTEGER DEFAULT 0;
        ALTER TABLE public.test_attempts ADD COLUMN IF NOT EXISTS unattempted_count INTEGER DEFAULT 0;
        ALTER TABLE public.test_attempts ADD COLUMN IF NOT EXISTS accuracy NUMERIC(5, 2) DEFAULT 0;
    END IF;
END $$;

ALTER TABLE public.test_attempts ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "Allow anon all on test_attempts" ON public.test_attempts;
CREATE POLICY "Allow anon all on test_attempts"
ON public.test_attempts FOR ALL TO anon, authenticated
USING (true) WITH CHECK (true);

-- 4. QUESTIONS TABLE (If using unified questions table)
ALTER TABLE IF EXISTS public.questions ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "Allow anon select on questions" ON public.questions;
CREATE POLICY "Allow anon select on questions"
ON public.questions FOR SELECT TO anon, authenticated
USING (true);

-- 5. PERFORMANCE INDEXES
CREATE INDEX IF NOT EXISTS idx_candidates_mobile ON public.candidates(mobile_number);
CREATE INDEX IF NOT EXISTS idx_attempts_candidate ON public.test_attempts(candidate_mobile, test_id);
CREATE INDEX IF NOT EXISTS idx_mock1_resp_mobile ON public."RRB_MOCK_1_responses"(candidate_mobile);
CREATE INDEX IF NOT EXISTS idx_mock2_resp_mobile ON public."RRB_MOCK_2_responses"(candidate_mobile);
CREATE INDEX IF NOT EXISTS idx_mock3_resp_mobile ON public."RRB_MOCK_3_responses"(candidate_mobile);
