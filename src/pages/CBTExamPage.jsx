import React, { useState, useEffect, useRef } from 'react';
import Navbar from '../components/Navbar';
import QuestionPanel from '../components/QuestionPanel';
import QuestionPalette from '../components/QuestionPalette';
import InstructionsModal from '../components/InstructionsModal';
import QuestionPaperModal from '../components/QuestionPaperModal';
import SubmitConfirmModal from '../components/SubmitConfirmModal';
import ScorecardModal from '../components/ScorecardModal';
import PauseModal from '../components/PauseModal';
import { Clock } from 'lucide-react';
import { SECTIONS } from '../data/mockQuestions';
import { fetchTestQuestions, syncTestAttempt } from '../services/apiService';

const TOTAL_DURATION_SECONDS = 90 * 60; // 90 minutes (5400 seconds)

export default function CBTExamPage({
  candidate,
  initialAttempt,
  defaultLang = 'en',
  onFinishExam
}) {
  const [questions, setQuestions] = useState([]);
  const [loadingQuestions, setLoadingQuestions] = useState(true);
  const [currentQuestionIndex, setCurrentQuestionIndex] = useState(initialAttempt?.currentQuestionIndex || 0);
  const [activeSectionId, setActiveSectionId] = useState('science');
  const [currentLang, setCurrentLang] = useState(defaultLang);
  const [fontSize, setFontSize] = useState('normal');

  // Exam state
  const [remainingSeconds, setRemainingSeconds] = useState(
    initialAttempt?.remainingSeconds !== undefined ? initialAttempt.remainingSeconds : TOTAL_DURATION_SECONDS
  );
  const [isPaused, setIsPaused] = useState(false);
  const [responses, setResponses] = useState(initialAttempt?.responses || {});
  const [questionStates, setQuestionStates] = useState(initialAttempt?.questionStates || {});
  const [selectedOption, setSelectedOption] = useState(null);

  // Modals
  const [showInstructions, setShowInstructions] = useState(false);
  const [showQuestionPaper, setShowQuestionPaper] = useState(false);
  const [showSubmitConfirm, setShowSubmitConfirm] = useState(false);
  const [showScorecard, setShowScorecard] = useState(false);
  const [finalResults, setFinalResults] = useState(null);

  // Periodic heartbeat sync reference
  const syncTimeoutRef = useRef(null);

  // 1. Load questions (remote DB or local fallback)
  useEffect(() => {
    let mounted = true;
    fetchTestQuestions('rrb_cbt_mock_1').then((loaded) => {
      if (mounted) {
        setQuestions(loaded);
        setLoadingQuestions(false);
      }
    });
    return () => {
      mounted = false;
    };
  }, []);

  // 2. Active section computation
  const activeSection = SECTIONS.find((s) => s.id === activeSectionId) || SECTIONS[0];

  // Sync active section when currentQuestionIndex changes
  useEffect(() => {
    const sec = SECTIONS.find((s) => currentQuestionIndex >= s.startIndex && currentQuestionIndex <= s.endIndex);
    if (sec && sec.id !== activeSectionId) {
      setActiveSectionId(sec.id);
    }
    // Update selectedOption from stored responses
    setSelectedOption(responses[currentQuestionIndex] !== undefined ? responses[currentQuestionIndex] : null);

    // If question is not visited, mark as not_answered when first viewed
    setQuestionStates((prev) => {
      const currentState = prev[currentQuestionIndex];
      if (!currentState || currentState === 'not_visited') {
        return {
          ...prev,
          [currentQuestionIndex]: 'not_answered'
        };
      }
      return prev;
    });
  }, [currentQuestionIndex]);

  // 3. Countdown timer
  useEffect(() => {
    if (isPaused || showScorecard) return;

    const timer = setInterval(() => {
      setRemainingSeconds((prev) => {
        if (prev <= 1) {
          clearInterval(timer);
          handleAutoSubmit();
          return 0;
        }
        return prev - 1;
      });
    }, 1000);

    return () => clearInterval(timer);
  }, [isPaused, showScorecard]);

  // 4. Live Sync to DB (Heartbeat every 15 seconds or on important state change)
  const triggerSync = (forcedStatus = null) => {
    if (!candidate?.mobile_number) return;

    const attemptData = {
      candidateMobile: candidate.mobile_number,
      candidateName: candidate.name,
      testId: 'rrb_cbt_mock_1',
      remainingSeconds,
      currentQuestionIndex,
      responses,
      questionStates,
      status: forcedStatus || (isPaused ? 'paused' : 'in_progress')
    };

    syncTestAttempt(attemptData);
  };

  useEffect(() => {
    if (syncTimeoutRef.current) clearTimeout(syncTimeoutRef.current);
    syncTimeoutRef.current = setTimeout(() => {
      triggerSync();
    }, 15000);

    return () => {
      if (syncTimeoutRef.current) clearTimeout(syncTimeoutRef.current);
    };
  }, [remainingSeconds, responses, questionStates, isPaused]);

  // Question navigation actions
  const handleSelectQuestion = (index) => {
    setCurrentQuestionIndex(index);
  };

  const handleSelectSection = (sectionId) => {
    setActiveSectionId(sectionId);
    const sec = SECTIONS.find((s) => s.id === sectionId);
    if (sec) {
      setCurrentQuestionIndex(sec.startIndex);
    }
  };

  const handleSaveAndNext = () => {
    const updatedResponses = { ...responses };
    const updatedStates = { ...questionStates };

    if (selectedOption !== null && selectedOption !== undefined) {
      updatedResponses[currentQuestionIndex] = selectedOption;
      updatedStates[currentQuestionIndex] = 'answered';
    } else {
      updatedStates[currentQuestionIndex] = 'not_answered';
    }

    setResponses(updatedResponses);
    setQuestionStates(updatedStates);

    if (currentQuestionIndex < questions.length - 1) {
      setCurrentQuestionIndex(currentQuestionIndex + 1);
    }
  };

  const handleSaveAndMarkReview = () => {
    const updatedResponses = { ...responses };
    const updatedStates = { ...questionStates };

    if (selectedOption !== null && selectedOption !== undefined) {
      updatedResponses[currentQuestionIndex] = selectedOption;
      updatedStates[currentQuestionIndex] = 'review_answered';
    } else {
      updatedStates[currentQuestionIndex] = 'review';
    }

    setResponses(updatedResponses);
    setQuestionStates(updatedStates);

    if (currentQuestionIndex < questions.length - 1) {
      setCurrentQuestionIndex(currentQuestionIndex + 1);
    }
  };

  const handleMarkReviewAndNext = () => {
    const updatedStates = { ...questionStates };
    if (responses[currentQuestionIndex] !== undefined && responses[currentQuestionIndex] !== null) {
      updatedStates[currentQuestionIndex] = 'review_answered';
    } else {
      updatedStates[currentQuestionIndex] = 'review';
    }
    setQuestionStates(updatedStates);

    if (currentQuestionIndex < questions.length - 1) {
      setCurrentQuestionIndex(currentQuestionIndex + 1);
    }
  };

  const handleClearResponse = () => {
    setSelectedOption(null);
    setResponses((prev) => {
      const copy = { ...prev };
      delete copy[currentQuestionIndex];
      return copy;
    });
    setQuestionStates((prev) => ({
      ...prev,
      [currentQuestionIndex]: 'not_answered'
    }));
  };

  const handlePreviousQuestion = () => {
    if (currentQuestionIndex > 0) {
      setCurrentQuestionIndex(currentQuestionIndex - 1);
    }
  };

  // Toggle Pause/Resume
  const handleTogglePause = () => {
    const nextPause = !isPaused;
    setIsPaused(nextPause);
    triggerSync(nextPause ? 'paused' : 'in_progress');
  };

  // Evaluation & Final Submission
  const calculateResults = () => {
    let score = 0;
    let correctCount = 0;
    let incorrectCount = 0;
    let unattemptedCount = 0;

    const sectionalScores = SECTIONS.map((sec) => {
      let secCorrect = 0;
      let secIncorrect = 0;
      let secUnattempted = 0;
      let secScore = 0;

      for (let i = sec.startIndex; i <= sec.endIndex; i++) {
        const q = questions[i];
        if (!q) continue;

        const userOptIdx = responses[i];
        if (userOptIdx === undefined || userOptIdx === null) {
          secUnattempted++;
          unattemptedCount++;
        } else {
          const userLetter = String.fromCharCode(65 + userOptIdx);
          if (userLetter === q.correct_option) {
            secCorrect++;
            correctCount++;
            secScore += (q.positive_marks || 1.0);
            score += (q.positive_marks || 1.0);
          } else {
            secIncorrect++;
            incorrectCount++;
            secScore -= (q.negative_marks || 0.33);
            score -= (q.negative_marks || 0.33);
          }
        }
      }

      return {
        sectionId: sec.id,
        sectionName: sec.nameEn,
        total: sec.total,
        correct: secCorrect,
        incorrect: secIncorrect,
        unattempted: secUnattempted,
        score: Math.max(0, secScore)
      };
    });

    const attemptedTotal = correctCount + incorrectCount;
    const accuracy = attemptedTotal > 0 ? (correctCount / attemptedTotal) * 100 : 0;
    const finalScore = Math.max(0, score);

    return {
      score: finalScore,
      totalMarks: 100,
      correctCount,
      incorrectCount,
      unattemptedCount,
      accuracy,
      sectionalScores,
      responses
    };
  };

  const handleFinalSubmit = () => {
    setShowSubmitConfirm(false);
    const results = calculateResults();
    setFinalResults(results);
    setShowScorecard(true);

    // Live sync completion state to remote DB
    if (candidate?.mobile_number) {
      syncTestAttempt({
        candidateMobile: candidate.mobile_number,
        candidateName: candidate.name,
        testId: 'rrb_cbt_mock_1',
        remainingSeconds,
        currentQuestionIndex,
        responses,
        questionStates,
        status: 'completed',
        score: results.score,
        correctCount: results.correctCount,
        incorrectCount: results.incorrectCount,
        unattemptedCount: results.unattemptedCount,
        accuracy: results.accuracy
      });
    }
  };

  const handleAutoSubmit = () => {
    handleFinalSubmit();
  };

  // Re-attempt
  const handleReattempt = () => {
    setResponses({});
    setQuestionStates({});
    setCurrentQuestionIndex(0);
    setRemainingSeconds(TOTAL_DURATION_SECONDS);
    setShowScorecard(false);
    setFinalResults(null);
    triggerSync('in_progress');
  };

  // Format Timer
  const timerHours = Math.floor(remainingSeconds / 3600);
  const timerMinutes = Math.floor((remainingSeconds % 3600) / 60);
  const timerSecs = remainingSeconds % 60;
  const formattedTimer = `${String(timerHours).padStart(2, '0')}:${String(timerMinutes).padStart(2, '0')}:${String(timerSecs).padStart(2, '0')}`;
  const isTimerCritical = remainingSeconds < 300; // < 5 mins
  const isTimerWarning = remainingSeconds < 900; // < 15 mins

  if (loadingQuestions) {
    return (
      <div className="min-h-screen bg-slate-900 text-white flex flex-col items-center justify-center p-6">
        <div className="w-12 h-12 border-4 border-amber-500 border-t-transparent rounded-full animate-spin mb-4"></div>
        <h2 className="text-xl font-bold">Initializing TCS iON CBT Examination Engine...</h2>
        <p className="text-xs text-slate-400 mt-2">Loading bilingual RRB Group D question paper.</p>
      </div>
    );
  }

  const currentQuestion = questions[currentQuestionIndex];

  return (
    <div className="min-h-screen bg-slate-200 flex flex-col h-screen overflow-hidden select-none text-slate-800">
      
      {/* 1. TCS iON Top Bar */}
      <Navbar
        candidate={candidate}
        isTestMode={true}
        testTitle="RRB Group D CBT Mock Test 01"
        onOpenInstructions={() => setShowInstructions(true)}
        onOpenQuestionPaper={() => setShowQuestionPaper(true)}
        isPaused={isPaused}
        onTogglePause={handleTogglePause}
      />

      {/* 2. Sub-header with Section Tabs & Timer */}
      <div className="bg-[#222831] text-white px-4 py-2 border-b border-slate-700 flex flex-wrap items-center justify-between gap-2 shadow-sm">
        
        {/* Section Navigation Tabs */}
        <div className="flex items-center space-x-1 overflow-x-auto py-0.5">
          <span className="text-[11px] font-bold text-amber-400 uppercase tracking-wider mr-2 hidden sm:inline">
            Sections:
          </span>
          {SECTIONS.map((sec) => {
            const isActive = activeSectionId === sec.id;
            return (
              <button
                key={sec.id}
                onClick={() => handleSelectSection(sec.id)}
                className={`px-3 py-1.5 text-xs font-bold rounded-t transition whitespace-nowrap ${
                  isActive
                    ? 'bg-white text-slate-900 shadow-sm border-t-2 border-amber-500'
                    : 'bg-slate-800/80 hover:bg-slate-700 text-slate-300'
                }`}
              >
                <span>{sec.nameEn}</span>
                <span className={`ml-1.5 text-[10px] px-1.5 py-0.2 rounded ${
                  isActive ? 'bg-blue-100 text-blue-800' : 'bg-slate-700 text-slate-300'
                }`}>
                  {sec.total}
                </span>
              </button>
            );
          })}
        </div>

        {/* Live Timer Display (TCS iON Standard) */}
        <div className="flex items-center gap-2 bg-slate-900/90 px-3 py-1.5 rounded border border-slate-700">
          <Clock className={`w-4 h-4 ${
            isTimerCritical ? 'text-red-500 animate-pulse' : isTimerWarning ? 'text-amber-400' : 'text-emerald-400'
          }`} />
          <div className="text-left leading-none">
            <span className="text-[9px] uppercase tracking-wider text-slate-400 font-semibold block">Time Left</span>
            <span className={`font-mono text-sm sm:text-base font-black ${
              isTimerCritical ? 'text-red-400 animate-pulse' : isTimerWarning ? 'text-amber-300' : 'text-emerald-300'
            }`}>
              {formattedTimer}
            </span>
          </div>
        </div>

      </div>

      {/* 3. Main Examination Two-Column Layout */}
      <div className="flex-1 flex flex-col lg:flex-row overflow-hidden bg-white">
        
        {/* Left: Question Presentation Area */}
        <div className="flex-1 flex flex-col h-full overflow-hidden border-r border-slate-300">
          <QuestionPanel
            question={currentQuestion}
            questionNumber={currentQuestionIndex + 1}
            totalQuestions={questions.length}
            currentLang={currentLang}
            onChangeLang={setCurrentLang}
            fontSize={fontSize}
            onChangeFontSize={setFontSize}
            selectedOption={selectedOption}
            onSelectOption={setSelectedOption}
            onSaveAndNext={handleSaveAndNext}
            onSaveAndMarkReview={handleSaveAndMarkReview}
            onMarkReviewAndNext={handleMarkReviewAndNext}
            onClearResponse={handleClearResponse}
            onPreviousQuestion={handlePreviousQuestion}
            isFirstQuestion={currentQuestionIndex === 0}
            isLastQuestion={currentQuestionIndex === questions.length - 1}
          />
        </div>

        {/* Right: TCS iON Question Palette Drawer */}
        <div className="w-full lg:w-80 h-auto lg:h-full shrink-0">
          <QuestionPalette
            candidate={candidate}
            sections={SECTIONS}
            activeSection={activeSection}
            onSelectSection={handleSelectSection}
            currentQuestionIndex={currentQuestionIndex}
            onSelectQuestion={handleSelectQuestion}
            questionStates={questionStates}
            responses={responses}
            onSubmitClick={() => setShowSubmitConfirm(true)}
          />
        </div>

      </div>

      {/* 4. Modals */}
      <InstructionsModal
        isOpen={showInstructions}
        onClose={() => setShowInstructions(false)}
        isPreExam={false}
      />

      <QuestionPaperModal
        isOpen={showQuestionPaper}
        onClose={() => setShowQuestionPaper(false)}
        questions={questions}
        sections={SECTIONS}
        lang={currentLang}
      />

      <SubmitConfirmModal
        isOpen={showSubmitConfirm}
        onClose={() => setShowSubmitConfirm(false)}
        onConfirmSubmit={handleFinalSubmit}
        sections={SECTIONS}
        questions={questions}
        responses={responses}
        questionStates={questionStates}
      />

      <PauseModal
        isOpen={isPaused}
        onResume={handleTogglePause}
        remainingSeconds={remainingSeconds}
        answeredCount={Object.keys(responses).length}
        totalQuestions={questions.length}
      />

      <ScorecardModal
        isOpen={showScorecard}
        results={finalResults}
        questions={questions}
        sections={SECTIONS}
        onGoToDashboard={onFinishExam}
        onReattempt={handleReattempt}
      />

    </div>
  );
}

