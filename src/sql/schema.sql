-- =========================================================================
-- RRB MOCK TEST PORTAL - DATABASE SCHEMA
-- Execute this script in your Cloud Database SQL Editor
-- =========================================================================

-- 1. CANDIDATES TABLE (Stores Candidate Name, 10-digit Mobile, 4-digit Passcode)
CREATE TABLE IF NOT EXISTS public.candidates (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT NOT NULL,
    mobile_number VARCHAR(15) UNIQUE NOT NULL,
    passcode VARCHAR(10) NOT NULL,
    roll_number VARCHAR(20) UNIQUE,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    last_login_at TIMESTAMPTZ DEFAULT NOW()
);

-- Enable RLS and allow public access for API operations
ALTER TABLE public.candidates ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Allow anon all on candidates" ON public.candidates;
CREATE POLICY "Allow anon all on candidates"
ON public.candidates
FOR ALL
TO anon, authenticated
USING (true)
WITH CHECK (true);

-- 2. TEST ATTEMPTS TABLE (Handles live sync, pause/resume, and test submission)
CREATE TABLE IF NOT EXISTS public.test_attempts (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    candidate_mobile VARCHAR(15) NOT NULL,
    candidate_name TEXT,
    test_id VARCHAR(50) NOT NULL,
    remaining_seconds INTEGER NOT NULL DEFAULT 5400,
    current_question_index INTEGER DEFAULT 0,
    responses JSONB DEFAULT '{}'::jsonb,
    question_states JSONB DEFAULT '{}'::jsonb,
    status VARCHAR(20) DEFAULT 'in_progress', -- 'in_progress', 'paused', 'completed'
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

ALTER TABLE public.test_attempts ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Allow anon all on test_attempts" ON public.test_attempts;
CREATE POLICY "Allow anon all on test_attempts"
ON public.test_attempts
FOR ALL
TO anon, authenticated
USING (true)
WITH CHECK (true);

-- 3. QUESTIONS TABLE (Bilingual RRB Group D Exam Questions)
CREATE TABLE IF NOT EXISTS public.questions (
    id SERIAL PRIMARY KEY,
    test_id VARCHAR(50) NOT NULL DEFAULT 'rrb-group-d-01',
    section VARCHAR(100) NOT NULL,
    question_number INTEGER NOT NULL,
    question_en TEXT NOT NULL,
    question_hi TEXT NOT NULL,
    option_a_en TEXT NOT NULL,
    option_a_hi TEXT NOT NULL,
    option_b_en TEXT NOT NULL,
    option_b_hi TEXT NOT NULL,
    option_c_en TEXT NOT NULL,
    option_c_hi TEXT NOT NULL,
    option_d_en TEXT NOT NULL,
    option_d_hi TEXT NOT NULL,
    correct_option VARCHAR(5) NOT NULL, -- 'A', 'B', 'C', 'D'
    positive_marks NUMERIC(3, 2) DEFAULT 1.00,
    negative_marks NUMERIC(3, 2) DEFAULT 0.33,
    explanation_en TEXT,
    explanation_hi TEXT
);

ALTER TABLE public.questions ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Allow anon select on questions" ON public.questions;
CREATE POLICY "Allow anon select on questions"
ON public.questions
FOR SELECT
TO anon, authenticated
USING (true);

-- Indexes for lightning fast lookups
CREATE INDEX IF NOT EXISTS idx_candidates_mobile ON public.candidates(mobile_number);
CREATE INDEX IF NOT EXISTS idx_attempts_candidate ON public.test_attempts(candidate_mobile, test_id);
CREATE INDEX IF NOT EXISTS idx_questions_test ON public.questions(test_id, section);
