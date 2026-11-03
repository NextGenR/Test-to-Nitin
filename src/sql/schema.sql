-- =========================================================================
-- RRB GROUP D CBT EXAMINATION - COMPLETE DATABASE SCHEMA
-- Compatible with PostgreSQL & Remote Database Cloud API
-- Safe & Idempotent: Run in your Database SQL Editor
-- =========================================================================

-- 1. Ensure candidate_mobile column exists in test_attempts
ALTER TABLE IF EXISTS public.test_attempts ADD COLUMN IF NOT EXISTS candidate_mobile VARCHAR(15);
ALTER TABLE IF EXISTS public.test_attempts ADD COLUMN IF NOT EXISTS candidate_name VARCHAR(100);
ALTER TABLE IF EXISTS public.test_attempts ADD COLUMN IF NOT EXISTS remaining_seconds INTEGER DEFAULT 5400;
ALTER TABLE IF EXISTS public.test_attempts ADD COLUMN IF NOT EXISTS current_question_index INTEGER DEFAULT 0;
ALTER TABLE IF EXISTS public.test_attempts ADD COLUMN IF NOT EXISTS responses JSONB DEFAULT '{}'::jsonb;
ALTER TABLE IF EXISTS public.test_attempts ADD COLUMN IF NOT EXISTS question_states JSONB DEFAULT '{}'::jsonb;
ALTER TABLE IF EXISTS public.test_attempts ADD COLUMN IF NOT EXISTS score NUMERIC(6,2) DEFAULT 0;
ALTER TABLE IF EXISTS public.test_attempts ADD COLUMN IF NOT EXISTS correct_count INTEGER DEFAULT 0;
ALTER TABLE IF EXISTS public.test_attempts ADD COLUMN IF NOT EXISTS incorrect_count INTEGER DEFAULT 0;
ALTER TABLE IF EXISTS public.test_attempts ADD COLUMN IF NOT EXISTS unattempted_count INTEGER DEFAULT 0;
ALTER TABLE IF EXISTS public.test_attempts ADD COLUMN IF NOT EXISTS accuracy NUMERIC(5,2) DEFAULT 0;

-- 2. Candidates Table
CREATE TABLE IF NOT EXISTS public.candidates (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(100) NOT NULL,
    mobile_number VARCHAR(15) NOT NULL UNIQUE,
    passcode VARCHAR(10) NOT NULL,
    roll_number VARCHAR(20) UNIQUE,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    last_login_at TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE public.candidates ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "Allow anon all on candidates" ON public.candidates;
CREATE POLICY "Allow anon all on candidates" ON public.candidates FOR ALL TO anon, authenticated USING (true) WITH CHECK (true);

-- 3. RRB_MOCK_1_responses
CREATE TABLE IF NOT EXISTS public."RRB_MOCK_1_responses" (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name_of_candidate VARCHAR(100) NOT NULL,
    candidate_mobile VARCHAR(15) NOT NULL,
    question_number INTEGER NOT NULL,
    section VARCHAR(100) NOT NULL,
    correct_answer VARCHAR(10) NOT NULL,
    his_answer VARCHAR(10),
    time_taken_by_him INTEGER DEFAULT 0,
    is_correct BOOLEAN GENERATED ALWAYS AS (correct_answer = his_answer) STORED,
    attempt_number INTEGER DEFAULT 1,
    try1 VARCHAR(10),
    try2 VARCHAR(10),
    try3 VARCHAR(10),
    try4 VARCHAR(10),
    try5 VARCHAR(10),
    time_taken_try1 INTEGER DEFAULT 0,
    time_taken_try2 INTEGER DEFAULT 0,
    time_taken_try3 INTEGER DEFAULT 0,
    submitted_at TIMESTAMPTZ DEFAULT NOW(),
    CONSTRAINT unique_mock1_candidate_question UNIQUE (candidate_mobile, question_number)
);

ALTER TABLE public."RRB_MOCK_1_responses" ADD COLUMN IF NOT EXISTS try1 VARCHAR(10);
ALTER TABLE public."RRB_MOCK_1_responses" ADD COLUMN IF NOT EXISTS try2 VARCHAR(10);
ALTER TABLE public."RRB_MOCK_1_responses" ADD COLUMN IF NOT EXISTS try3 VARCHAR(10);
ALTER TABLE public."RRB_MOCK_1_responses" ADD COLUMN IF NOT EXISTS try4 VARCHAR(10);
ALTER TABLE public."RRB_MOCK_1_responses" ADD COLUMN IF NOT EXISTS try5 VARCHAR(10);
ALTER TABLE public."RRB_MOCK_1_responses" ADD COLUMN IF NOT EXISTS time_taken_try1 INTEGER DEFAULT 0;
ALTER TABLE public."RRB_MOCK_1_responses" ADD COLUMN IF NOT EXISTS time_taken_try2 INTEGER DEFAULT 0;
ALTER TABLE public."RRB_MOCK_1_responses" ADD COLUMN IF NOT EXISTS time_taken_try3 INTEGER DEFAULT 0;
ALTER TABLE public."RRB_MOCK_1_responses" ADD COLUMN IF NOT EXISTS attempt_number INTEGER DEFAULT 1;

ALTER TABLE public."RRB_MOCK_1_responses" ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "Allow anon all on RRB_MOCK_1_responses" ON public."RRB_MOCK_1_responses";
CREATE POLICY "Allow anon all on RRB_MOCK_1_responses" ON public."RRB_MOCK_1_responses" FOR ALL TO anon, authenticated USING (true) WITH CHECK (true);

-- 4. RRB_MOCK_2_responses
CREATE TABLE IF NOT EXISTS public."RRB_MOCK_2_responses" (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name_of_candidate VARCHAR(100) NOT NULL,
    candidate_mobile VARCHAR(15) NOT NULL,
    question_number INTEGER NOT NULL,
    section VARCHAR(100) NOT NULL,
    correct_answer VARCHAR(10) NOT NULL,
    his_answer VARCHAR(10),
    time_taken_by_him INTEGER DEFAULT 0,
    is_correct BOOLEAN GENERATED ALWAYS AS (correct_answer = his_answer) STORED,
    attempt_number INTEGER DEFAULT 1,
    try1 VARCHAR(10),
    try2 VARCHAR(10),
    try3 VARCHAR(10),
    try4 VARCHAR(10),
    try5 VARCHAR(10),
    time_taken_try1 INTEGER DEFAULT 0,
    time_taken_try2 INTEGER DEFAULT 0,
    time_taken_try3 INTEGER DEFAULT 0,
    submitted_at TIMESTAMPTZ DEFAULT NOW(),
    CONSTRAINT unique_mock2_candidate_question UNIQUE (candidate_mobile, question_number)
);

ALTER TABLE public."RRB_MOCK_2_responses" ADD COLUMN IF NOT EXISTS try1 VARCHAR(10);
ALTER TABLE public."RRB_MOCK_2_responses" ADD COLUMN IF NOT EXISTS try2 VARCHAR(10);
ALTER TABLE public."RRB_MOCK_2_responses" ADD COLUMN IF NOT EXISTS try3 VARCHAR(10);
ALTER TABLE public."RRB_MOCK_2_responses" ADD COLUMN IF NOT EXISTS try4 VARCHAR(10);
ALTER TABLE public."RRB_MOCK_2_responses" ADD COLUMN IF NOT EXISTS try5 VARCHAR(10);
ALTER TABLE public."RRB_MOCK_2_responses" ADD COLUMN IF NOT EXISTS time_taken_try1 INTEGER DEFAULT 0;
ALTER TABLE public."RRB_MOCK_2_responses" ADD COLUMN IF NOT EXISTS time_taken_try2 INTEGER DEFAULT 0;
ALTER TABLE public."RRB_MOCK_2_responses" ADD COLUMN IF NOT EXISTS time_taken_try3 INTEGER DEFAULT 0;
ALTER TABLE public."RRB_MOCK_2_responses" ADD COLUMN IF NOT EXISTS attempt_number INTEGER DEFAULT 1;

ALTER TABLE public."RRB_MOCK_2_responses" ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "Allow anon all on RRB_MOCK_2_responses" ON public."RRB_MOCK_2_responses";
CREATE POLICY "Allow anon all on RRB_MOCK_2_responses" ON public."RRB_MOCK_2_responses" FOR ALL TO anon, authenticated USING (true) WITH CHECK (true);

-- 5. RRB_MOCK_3_responses
CREATE TABLE IF NOT EXISTS public."RRB_MOCK_3_responses" (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name_of_candidate VARCHAR(100) NOT NULL,
    candidate_mobile VARCHAR(15) NOT NULL,
    question_number INTEGER NOT NULL,
    section VARCHAR(100) NOT NULL,
    correct_answer VARCHAR(10) NOT NULL,
    his_answer VARCHAR(10),
    time_taken_by_him INTEGER DEFAULT 0,
    is_correct BOOLEAN GENERATED ALWAYS AS (correct_answer = his_answer) STORED,
    attempt_number INTEGER DEFAULT 1,
    try1 VARCHAR(10),
    try2 VARCHAR(10),
    try3 VARCHAR(10),
    try4 VARCHAR(10),
    try5 VARCHAR(10),
    time_taken_try1 INTEGER DEFAULT 0,
    time_taken_try2 INTEGER DEFAULT 0,
    time_taken_try3 INTEGER DEFAULT 0,
    submitted_at TIMESTAMPTZ DEFAULT NOW(),
    CONSTRAINT unique_mock3_candidate_question UNIQUE (candidate_mobile, question_number)
);

ALTER TABLE public."RRB_MOCK_3_responses" ADD COLUMN IF NOT EXISTS try1 VARCHAR(10);
ALTER TABLE public."RRB_MOCK_3_responses" ADD COLUMN IF NOT EXISTS try2 VARCHAR(10);
ALTER TABLE public."RRB_MOCK_3_responses" ADD COLUMN IF NOT EXISTS try3 VARCHAR(10);
ALTER TABLE public."RRB_MOCK_3_responses" ADD COLUMN IF NOT EXISTS try4 VARCHAR(10);
ALTER TABLE public."RRB_MOCK_3_responses" ADD COLUMN IF NOT EXISTS try5 VARCHAR(10);
ALTER TABLE public."RRB_MOCK_3_responses" ADD COLUMN IF NOT EXISTS time_taken_try1 INTEGER DEFAULT 0;
ALTER TABLE public."RRB_MOCK_3_responses" ADD COLUMN IF NOT EXISTS time_taken_try2 INTEGER DEFAULT 0;
ALTER TABLE public."RRB_MOCK_3_responses" ADD COLUMN IF NOT EXISTS time_taken_try3 INTEGER DEFAULT 0;
ALTER TABLE public."RRB_MOCK_3_responses" ADD COLUMN IF NOT EXISTS attempt_number INTEGER DEFAULT 1;

ALTER TABLE public."RRB_MOCK_3_responses" ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "Allow anon all on RRB_MOCK_3_responses" ON public."RRB_MOCK_3_responses";
CREATE POLICY "Allow anon all on RRB_MOCK_3_responses" ON public."RRB_MOCK_3_responses" FOR ALL TO anon, authenticated USING (true) WITH CHECK (true);

-- 6. Safe Indexes
CREATE INDEX IF NOT EXISTS idx_candidates_mobile ON public.candidates(mobile_number);
CREATE INDEX IF NOT EXISTS idx_test_attempts_mobile ON public.test_attempts(candidate_mobile);
CREATE INDEX IF NOT EXISTS idx_mock1_candidate ON public."RRB_MOCK_1_responses"(candidate_mobile);
CREATE INDEX IF NOT EXISTS idx_mock2_candidate ON public."RRB_MOCK_2_responses"(candidate_mobile);
CREATE INDEX IF NOT EXISTS idx_mock3_candidate ON public."RRB_MOCK_3_responses"(candidate_mobile);

-- 7. Questions Table Schema Enhancements for Inline SVG Diagrams & Visual Options
ALTER TABLE IF EXISTS public.questions ADD COLUMN IF NOT EXISTS image_svg TEXT;
ALTER TABLE IF EXISTS public.questions ADD COLUMN IF NOT EXISTS image_svg_hi TEXT;
ALTER TABLE IF EXISTS public.questions ADD COLUMN IF NOT EXISTS image_url TEXT;
ALTER TABLE IF EXISTS public.questions ADD COLUMN IF NOT EXISTS image_url_hi TEXT;
ALTER TABLE IF EXISTS public.questions ADD COLUMN IF NOT EXISTS option_svgs JSONB;
ALTER TABLE IF EXISTS public.questions ADD COLUMN IF NOT EXISTS option_images JSONB;

ALTER TABLE IF EXISTS public.questions ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "Allow anon read on questions" ON public.questions;
CREATE POLICY "Allow anon read on questions" ON public.questions FOR SELECT TO anon, authenticated USING (true);
DROP POLICY IF EXISTS "Allow anon write on questions" ON public.questions;
CREATE POLICY "Allow anon write on questions" ON public.questions FOR ALL TO anon, authenticated USING (true) WITH CHECK (true);

-- 8. RRB_NTPC_MOCK_1_responses (Graduate Level CBT-1)
CREATE TABLE IF NOT EXISTS public."RRB_NTPC_MOCK_1_responses" (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name_of_candidate VARCHAR(100) NOT NULL,
    candidate_mobile VARCHAR(15) NOT NULL,
    question_number INTEGER NOT NULL,
    section VARCHAR(100) NOT NULL,
    correct_answer VARCHAR(10) NOT NULL,
    his_answer VARCHAR(10),
    time_taken_by_him INTEGER DEFAULT 0,
    is_correct BOOLEAN GENERATED ALWAYS AS (correct_answer = his_answer) STORED,
    attempt_number INTEGER DEFAULT 1,
    try1 VARCHAR(10),
    try2 VARCHAR(10),
    try3 VARCHAR(10),
    try4 VARCHAR(10),
    try5 VARCHAR(10),
    time_taken_try1 INTEGER DEFAULT 0,
    time_taken_try2 INTEGER DEFAULT 0,
    time_taken_try3 INTEGER DEFAULT 0,
    submitted_at TIMESTAMPTZ DEFAULT NOW(),
    CONSTRAINT unique_ntpc_mock1_candidate_question UNIQUE (candidate_mobile, question_number)
);

ALTER TABLE public."RRB_NTPC_MOCK_1_responses" ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "Allow anon all on RRB_NTPC_MOCK_1_responses" ON public."RRB_NTPC_MOCK_1_responses";
CREATE POLICY "Allow anon all on RRB_NTPC_MOCK_1_responses" ON public."RRB_NTPC_MOCK_1_responses" FOR ALL TO anon, authenticated USING (true) WITH CHECK (true);

CREATE INDEX IF NOT EXISTS idx_ntpc_mock1_candidate ON public."RRB_NTPC_MOCK_1_responses"(candidate_mobile);
