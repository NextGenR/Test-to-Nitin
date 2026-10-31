# RRB Mock Test - Online Computer-Based Test (CBT) Portal

An authentic, production-grade **Railway Recruitment Board (RRB) Mock Examination Portal** engineered strictly to replicate the official **TCS iON CBT engine** layout, navigation rules, question palette, and evaluation schemes.

---

## 🌟 Key Highlights & Features

### 1. Candidate Login Page
* **Full Name, 10-Digit Mobile Number (Mandatory Validation), and 4-Digit Passcode**.
* **Dynamic Arithmetic Security Captcha** (e.g. `7 + 5 = ?`) with refresh capability to prevent automated submissions.
* **Passcode Recording & Auth**:
  - Automatically records candidate credentials into the cloud database upon first login.
  - Returning candidates are authenticated against their recorded 4-digit passcode.
  - Seamless local session caching ensures persistence across browser refreshes.

### 2. Candidate Dashboard Page
* **Candidate Profile Bar**: Displays Name, Roll Number, System Node ID (`C001`), and real-time server connectivity status.
* **Test Series Section**:
  - Prominently showcases **RRB Mock Test** category.
  - **RRB Group D CBT Mock Test 01**: 100 Questions &bull; 100 Marks &bull; 90 Minutes.
  - Dynamic **"Resume Test"** status badge if an in-progress exam was paused.
  - Comprehensive Pre-Exam Instructions modal with the official TCS iON legend and candidate declaration agreement.
* **Attempt History & Scorecards**: Review previous attempts, marks, accuracy, and sectional performance.

### 3. TCS iON CBT Examination Engine
* **Exact TCS iON Desktop Interface**:
  - **Countdown Timer**: Real-time timer synchronized with exam regulations (flashes warning when `<15m` and `<5m`).
  - **Pause & Resume**: Candidates can pause the exam at any moment; answers and timer state freeze and sync live to the database.
  - **Bilingual Question Display**: Switch between **English** and **Hindi (हिंदी)** dynamically on each question.
  - **Font Resizer**: Accessible `A-`, `A`, `A+` controls.
  - **Official Action Buttons**:
    - `Save & Next` (Green)
    - `Clear Response` (Neutral)
    - `Save & Mark for Review` (Amber)
    - `Mark for Review & Next` (Purple)
    - `Previous`
  - **Official Question Palette States**:
    1. **Answered** (Green polygon)
    2. **Not Answered** (Red polygon)
    3. **Not Visited** (Grey square)
    4. **Marked for Review** (Purple circle)
    5. **Answered & Marked for Review** (Purple circle with green indicator — *counted for evaluation* as per RRB rules).
  - **Exam Utilities**:
    - Complete Question Paper overview modal.
    - Instructions modal accessible mid-exam.
    - Submission confirmation dialog displaying sectional attempt breakdown.
    - Detailed Result Scorecard with marks obtained, accuracy %, qualifying status, sectional analysis, and full question solution review.

---

## 📊 Exam Pattern (RRB Group D CBT)

| Section / Subject | Questions | Marks |
| :--- | :---: | :---: |
| **General Science** | 25 | 25 |
| **Mathematics** | 25 | 25 |
| **General Intelligence & Reasoning** | 30 | 30 |
| **General Awareness & Current Affairs** | 20 | 20 |
| **Total** | **100** | **100** |

* **Total Duration:** 90 Minutes (5400 seconds)
* **Marking Scheme:** `+1.00` for Correct, `-0.33` (1/3rd) for Incorrect, `0` for Unattempted.

---

## 🗄️ Database Setup (SQL Script)

To initialize the remote cloud database tables, open your Database SQL Editor and run the script located at `src/sql/schema.sql`:

```sql
-- 1. CANDIDATES TABLE
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
CREATE POLICY "Allow anon all on candidates" ON public.candidates FOR ALL TO anon, authenticated USING (true) WITH CHECK (true);

-- 2. TEST ATTEMPTS TABLE (Live Sync & Pause/Resume)
CREATE TABLE IF NOT EXISTS public.test_attempts (
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

ALTER TABLE public.test_attempts ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Allow anon all on test_attempts" ON public.test_attempts FOR ALL TO anon, authenticated USING (true) WITH CHECK (true);

-- 3. QUESTIONS TABLE (Bilingual Question Bank)
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
    correct_option VARCHAR(5) NOT NULL,
    positive_marks NUMERIC(3, 2) DEFAULT 1.00,
    negative_marks NUMERIC(3, 2) DEFAULT 0.33,
    explanation_en TEXT,
    explanation_hi TEXT
);

ALTER TABLE public.questions ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Allow anon select on questions" ON public.questions FOR SELECT TO anon, authenticated USING (true);
```

---

## 🚀 Running Locally

```bash
# Install dependencies
npm install

# Start local development server
npm run dev

# Build for production
npm run build
```
