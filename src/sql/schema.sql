-- =========================================================================
-- RRB MOCK TEST PORTAL - DATABASE SETUP SCRIPT
-- Execute this script in your Remote Database SQL Editor
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

-- Enable RLS & Allow Public Access
ALTER TABLE public.candidates ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "Allow anon all on candidates" ON public.candidates;
CREATE POLICY "Allow anon all on candidates"
ON public.candidates
FOR ALL
TO anon, authenticated
USING (true)
WITH CHECK (true);

-- 2. TEST ATTEMPTS TABLE (Fixes existing table column mismatch & enables live sync)
-- Drop existing table if you want a clean slate, OR add missing columns:
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
        -- Table already exists: safely add missing columns
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
ON public.test_attempts
FOR ALL
TO anon, authenticated
USING (true)
WITH CHECK (true);

-- 3. QUESTIONS TABLE (Already exists in your database with 100 RRB questions!)
-- Ensure RLS allows anonymous reading
ALTER TABLE public.questions ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "Allow anon select on questions" ON public.questions;
CREATE POLICY "Allow anon select on questions"
ON public.questions
FOR SELECT
TO anon, authenticated
USING (true);

-- 4. PERFORMANCE INDEXES
CREATE INDEX IF NOT EXISTS idx_candidates_mobile ON public.candidates(mobile_number);
CREATE INDEX IF NOT EXISTS idx_attempts_candidate ON public.test_attempts(candidate_mobile, test_id);
CREATE INDEX IF NOT EXISTS idx_questions_test ON public.questions(test_id, question_number);
