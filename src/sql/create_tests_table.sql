-- ==============================================================================
-- TURNKEY SQL: Create & Seed "tests" Table for Dynamic Mock Test Series
-- Run this in your Remote Database SQL Editor to enable dynamic test discovery!
-- ==============================================================================

-- 1. Create tests catalog table
CREATE TABLE IF NOT EXISTS public.tests (
    id SERIAL PRIMARY KEY,
    test_id VARCHAR(50) UNIQUE NOT NULL,
    title VARCHAR(150) NOT NULL,
    description TEXT,
    questions_count INTEGER DEFAULT 100,
    duration_mins INTEGER DEFAULT 90,
    response_table VARCHAR(100),
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 2. Enable Row Level Security (RLS) & Public Access Policies
ALTER TABLE public.tests ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Allow anon read on tests" ON public.tests;
CREATE POLICY "Allow anon read on tests" 
ON public.tests FOR SELECT TO anon, authenticated 
USING (true);

DROP POLICY IF EXISTS "Allow anon write on tests" ON public.tests;
CREATE POLICY "Allow anon write on tests" 
ON public.tests FOR ALL TO anon, authenticated 
USING (true) WITH CHECK (true);

-- 3. Populate existing Mock 1, Mock 2, and Mock 3
INSERT INTO public.tests (id, test_id, title, description, questions_count, duration_mins, response_table, is_active)
VALUES
(1, 'rrb_cbt_mock_1', 'RRB Group D CBT Mock Test 01', 'Based on official Railway Recruitment Board pattern with high-yield General Science and Math.', 100, 90, 'RRB_MOCK_1_responses', true),
(2, 'rrb_cbt_mock_2', 'RRB Group D CBT Mock Test 02', 'Comprehensive evaluation covering Physics, Chemistry, Reasoning series, and Railway GK.', 100, 90, 'RRB_MOCK_2_responses', true),
(3, 'rrb_cbt_mock_3', 'RRB Group D CBT Mock Test 03', 'Advanced full-length test simulation with authentic TCS iON timing and negative marking.', 100, 90, 'RRB_MOCK_3_responses', true)
ON CONFLICT (test_id) DO UPDATE SET
    title = EXCLUDED.title,
    description = EXCLUDED.description,
    questions_count = EXCLUDED.questions_count,
    duration_mins = EXCLUDED.duration_mins,
    response_table = EXCLUDED.response_table,
    is_active = EXCLUDED.is_active;

-- ==============================================================================
-- HOW TO PUBLISH MOCK 4, MOCK 5, ETC. IN THE FUTURE:
--
-- Step 1: Insert test definition:
--   INSERT INTO public.tests (id, test_id, title, description, questions_count, duration_mins, response_table, is_active)
--   VALUES (4, 'rrb_cbt_mock_4', 'RRB Group D CBT Mock Test 04', 'Full syllabus mock test with latest current affairs.', 100, 90, 'RRB_MOCK_4_responses', true);
--
-- Step 2: Create responses table for Mock 4:
--   CREATE TABLE IF NOT EXISTS public."RRB_MOCK_4_responses" (
--       id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
--       name_of_candidate VARCHAR(100) NOT NULL,
--       candidate_mobile VARCHAR(15) NOT NULL,
--       question_number INTEGER NOT NULL,
--       section VARCHAR(100) NOT NULL,
--       correct_answer VARCHAR(10) NOT NULL,
--       his_answer VARCHAR(10),
--       time_taken_by_him INTEGER DEFAULT 0,
--       is_correct BOOLEAN GENERATED ALWAYS AS (correct_answer = his_answer) STORED,
--       attempt_number INTEGER DEFAULT 1,
--       try1 VARCHAR(10),
--       try2 VARCHAR(10),
--       try3 VARCHAR(10),
--       try4 VARCHAR(10),
--       try5 VARCHAR(10),
--       time_taken_try1 INTEGER DEFAULT 0,
--       time_taken_try2 INTEGER DEFAULT 0,
--       time_taken_try3 INTEGER DEFAULT 0,
--       submitted_at TIMESTAMPTZ DEFAULT NOW(),
--       CONSTRAINT unique_mock4_candidate_question UNIQUE (candidate_mobile, question_number)
--   );
--   ALTER TABLE public."RRB_MOCK_4_responses" ENABLE ROW LEVEL SECURITY;
--   CREATE POLICY "Allow anon all on RRB_MOCK_4_responses" ON public."RRB_MOCK_4_responses" FOR ALL TO anon, authenticated USING (true) WITH CHECK (true);
--
-- Step 3: Insert questions for 'rrb_cbt_mock_4' into the questions table.
-- The web application will immediately detect Mock 4 on the Dashboard without redeploying code!
-- ==============================================================================

