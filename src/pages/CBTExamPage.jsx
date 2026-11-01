import React, { useState, useEffect, useRef } from 'react';
import Navbar from '../components/Navbar';
import QuestionPanel from '../components/QuestionPanel';
import QuestionPalette from '../components/QuestionPalette';
import InstructionsModal from '../components/InstructionsModal';
import QuestionPaperModal from '../components/QuestionPaperModal';
import SubmitConfirmModal from '../components/SubmitConfirmModal';
import ScorecardModal from '../components/ScorecardModal';
import PauseModal from '../components/PauseModal';
import ScratchpadModal from '../components/ScratchpadModal';
import { X } from 'lucide-react';
import { Clock } from 'lucide-react';
import { SECTIONS } from '../data/mockQuestions';
import {
  fetchTestQuestions,
  syncTestAttempt,
  saveMockResponses,
  saveSingleQuestionResponse,
  getCandidateAttemptNumber
} from '../services/apiService';
import { randomizeQuestionsOptions } from '../utils/randomizer';

const TOTAL_DURATION_SECONDS = 90 * 60; // 90 minutes (5400 seconds)

export default function CBTExamPage({
  candidate,
  initialAttempt,
  mockNumber = 1,
  testId = 'rrb_cbt_mock_1',
  testTitle = 'RRB Group D CBT Mock Test 01',
  defaultLang = 'en',
  isRetake = false,
  onFinishExam
}) {
  const activeTestId = testId || `rrb_cbt_mock_${mockNumber}`;
  const storageKey = `rrb_test_attempt_${activeTestId}_${candidate?.mobile_number}`;

  // Instant synchronous recovery from localStorage on page refresh
  const getInitialState = () => {
    if (initialAttempt) return initialAttempt;
    try {
      const raw = localStorage.getItem(storageKey);
      return raw ? JSON.parse(raw) : null;
    } catch (e) {
      return null;
    }
  };

  const savedState = getInitialState();

  const [questions, setQuestions] = useState([]);
  const [loadingQuestions, setLoadingQuestions] = useState(true);
  const [currentQuestionIndex, setCurrentQuestionIndex] = useState(savedState?.currentQuestionIndex || 0);
  const [activeSectionId, setActiveSectionId] = useState('science');
  const [currentLang, setCurrentLang] = useState(defaultLang);
  const [fontSize, setFontSize] = useState('normal');
  const [attemptNumber, setAttemptNumber] = useState(savedState?.attemptNumber || (isRetake ? 2 : 1));

  // Exam state (recovered immediately on reload)
  const [remainingSeconds, setRemainingSeconds] = useState(
    savedState?.remainingSeconds !== undefined ? savedState.remainingSeconds : TOTAL_DURATION_SECONDS
  );
  const [isPaused, setIsPaused] = useState(savedState?.status === 'paused');
  const [responses, setResponses] = useState(savedState?.responses || {});
  const [questionStates, setQuestionStates] = useState(savedState?.questionStates || {});
  const [selectedOption, setSelectedOption] = useState(null);
  const [timeSpentMap, setTimeSpentMap] = useState({});

  // Modals
  const [showInstructions, setShowInstructions] = useState(false);
  const [showQuestionPaper, setShowQuestionPaper] = useState(false);
  const [showSubmitConfirm, setShowSubmitConfirm] = useState(false);
  const [showScorecard, setShowScorecard] = useState(false);
  const [showScratchpad, setShowScratchpad] = useState(false);
  const [showMobilePalette, setShowMobilePalette] = useState(false);
  const [isFullscreen, setIsFullscreen] = useState(false);

  // Automatic fullscreen trigger on entering the test
  useEffect(() => {
    const handleFullscreenChange = () => {
      setIsFullscreen(!!document.fullscreenElement);
    };
    document.addEventListener('fullscreenchange', handleFullscreenChange);

    const tryFullscreen = () => {
      if (!document.fullscreenElement) {
        const el = document.documentElement;
        if (el.requestFullscreen) {
          el.requestFullscreen().catch(() => {});
        } else if (el.webkitRequestFullscreen) {
          el.webkitRequestFullscreen();
        }
      }
    };

    // Attempt automatic fullscreen
    tryFullscreen();

    // Also trigger on first interaction if blocked by browser policy
    window.addEventListener('click', tryFullscreen, { once: true });

    return () => {
      document.removeEventListener('fullscreenchange', handleFullscreenChange);
      window.removeEventListener('click', tryFullscreen);
    };
  }, []);

  const handleToggleFullscreen = () => {
    if (!document.fullscreenElement) {
      const el = document.documentElement;
      if (el.requestFullscreen) {
        el.requestFullscreen().catch(() => {});
      } else if (el.webkitRequestFullscreen) {
        el.webkitRequestFullscreen();
      }
    } else {
      if (document.exitFullscreen) {
        document.exitFullscreen().catch(() => {});
      }
    }
  };
  const [finalResults, setFinalResults] = useState(null);

  // Periodic heartbeat sync reference
  const syncTimeoutRef = useRef(null);

  // 1. Load questions (remote DB or local fallback for Mock 1, 2, or 3) with randomized options
  useEffect(() => {
    let mounted = true;

    const loadExamQuestions = async (activeAttempt) => {
      const qCacheKey = `rrb_shuffled_qs_${activeTestId}_${candidate?.mobile_number}_att_${activeAttempt}`;
      try {
        const cached = localStorage.getItem(qCacheKey);
        if (cached) {
          const parsed = JSON.parse(cached);
          if (parsed && parsed.length > 0) {
            if (mounted) {
              setQuestions(parsed);
              setLoadingQuestions(false);
            }
            return;
          }
        }
      } catch (e) {}

      const rawQuestions = await fetchTestQuestions(mockNumber);
      if (!mounted) return;

      const seedKey = `${candidate?.mobile_number || 'cand'}_mock_${mockNumber}_att_${activeAttempt}`;
      const randomized = randomizeQuestionsOptions(rawQuestions, seedKey);

      try {
        localStorage.setItem(qCacheKey, JSON.stringify(randomized));
      } catch (e) {}

      if (mounted) {
        setQuestions(randomized);
        setLoadingQuestions(false);
      }
    };

    // Detect candidate attempt number and load questions
    if (candidate?.mobile_number) {
      getCandidateAttemptNumber(mockNumber, candidate.mobile_number).then((maxNum) => {
        if (!mounted) return;
        let resolvedAttempt = attemptNumber;
        if (savedState?.attemptNumber) {
          resolvedAttempt = savedState.attemptNumber;
          setAttemptNumber(resolvedAttempt);
        } else if (isRetake) {
          resolvedAttempt = Math.min(maxNum + 1, 5);
          setAttemptNumber(resolvedAttempt);
          saveLocalSnapshot({ attemptNumber: resolvedAttempt });
        } else {
          resolvedAttempt = maxNum;
          setAttemptNumber(resolvedAttempt);
          saveLocalSnapshot({ attemptNumber: resolvedAttempt });
        }
        loadExamQuestions(resolvedAttempt);
      });
    } else {
      loadExamQuestions(attemptNumber);
    }

    return () => {
      mounted = false;
    };
  }, [mockNumber, candidate?.mobile_number, isRetake]);

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
        const next = {
          ...prev,
          [currentQuestionIndex]: 'not_answered'
        };
        // Persist to local storage immediately
        saveLocalSnapshot({ questionStates: next });
        return next;
      }
      return prev;
    });
  }, [currentQuestionIndex]);

  // Helper to instantly save local snapshot to avoid refresh data loss
  const saveLocalSnapshot = (overrides = {}) => {
    if (!candidate?.mobile_number) return;
    try {
      const snapshot = {
        candidateMobile: candidate.mobile_number,
        candidateName: candidate.name,
        testId: activeTestId,
        remainingSeconds,
        currentQuestionIndex,
        responses,
        questionStates,
        status: isPaused ? 'paused' : 'in_progress',
        attemptNumber,
        ...overrides,
        updated_at: new Date().toISOString()
      };
      localStorage.setItem(storageKey, JSON.stringify(snapshot));
    } catch (e) {}
  };

  // 3. Countdown timer & per-question time tracking
  useEffect(() => {
    if (isPaused || showScorecard) return;

    const timer = setInterval(() => {
      setRemainingSeconds((prev) => {
        if (prev <= 1) {
          clearInterval(timer);
          handleAutoSubmit();
          return 0;
        }
        const updated = prev - 1;
        // Save timer snapshot every 5 seconds to local storage
        if (updated % 5 === 0) {
          saveLocalSnapshot({ remainingSeconds: updated });
        }
        return updated;
      });

      // Track seconds spent on current question
      setTimeSpentMap((prev) => ({
        ...prev,
        [currentQuestionIndex]: (prev[currentQuestionIndex] || 0) + 1
      }));
    }, 1000);

    return () => clearInterval(timer);
  }, [isPaused, showScorecard, currentQuestionIndex]);

  // 4. Live Sync to DB (Heartbeat every 15 seconds)
  const triggerSync = (forcedStatus = null) => {
    if (!candidate?.mobile_number) return;

    const attemptData = {
      candidateMobile: candidate.mobile_number,
      candidateName: candidate.name,
      rollNumber: candidate.roll_number,
      testId: activeTestId,
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
    saveLocalSnapshot({ currentQuestionIndex: index });
  };

  const handleSelectSection = (sectionId) => {
    setActiveSectionId(sectionId);
    const sec = SECTIONS.find((s) => s.id === sectionId);
    if (sec) {
      setCurrentQuestionIndex(sec.startIndex);
      saveLocalSnapshot({ currentQuestionIndex: sec.startIndex });
    }
  };

  const handleSaveAndNext = () => {
    const updatedResponses = { ...responses };
    const updatedStates = { ...questionStates };
    const currentQ = questions[currentQuestionIndex];

    let userOptLetter = null;
    if (selectedOption !== null && selectedOption !== undefined) {
      updatedResponses[currentQuestionIndex] = selectedOption;
      updatedStates[currentQuestionIndex] = 'answered';
      userOptLetter = String.fromCharCode(65 + selectedOption);
    } else {
      updatedStates[currentQuestionIndex] = 'not_answered';
    }

    setResponses(updatedResponses);
    setQuestionStates(updatedStates);

    const qTime = timeSpentMap[currentQuestionIndex] || 0;

    // Real-time live sync for this question directly to RRB_MOCK_X_responses
    if (currentQ && candidate?.mobile_number) {
      saveSingleQuestionResponse({
        mockNumber,
        candidateName: candidate.name,
        candidateMobile: candidate.mobile_number,
        questionNumber: currentQuestionIndex + 1,
        section: currentQ.section,
        correctAnswer: currentQ.correct_option,
        hisAnswer: userOptLetter,
        timeTaken: qTime,
        attemptNumber
      });
    }

    const nextIndex = currentQuestionIndex < questions.length - 1 ? currentQuestionIndex + 1 : currentQuestionIndex;
    setCurrentQuestionIndex(nextIndex);

    // Instant local save
    saveLocalSnapshot({
      responses: updatedResponses,
      questionStates: updatedStates,
      currentQuestionIndex: nextIndex,
      attemptNumber
    });
  };

  const handleSaveAndMarkReview = () => {
    const updatedResponses = { ...responses };
    const updatedStates = { ...questionStates };
    const currentQ = questions[currentQuestionIndex];

    let userOptLetter = null;
    if (selectedOption !== null && selectedOption !== undefined) {
      updatedResponses[currentQuestionIndex] = selectedOption;
      updatedStates[currentQuestionIndex] = 'review_answered';
      userOptLetter = String.fromCharCode(65 + selectedOption);
    } else {
      updatedStates[currentQuestionIndex] = 'review';
    }

    setResponses(updatedResponses);
    setQuestionStates(updatedStates);

    const qTime = timeSpentMap[currentQuestionIndex] || 0;

    // Real-time live sync for this question directly to RRB_MOCK_X_responses
    if (currentQ && candidate?.mobile_number) {
      saveSingleQuestionResponse({
        mockNumber,
        candidateName: candidate.name,
        candidateMobile: candidate.mobile_number,
        questionNumber: currentQuestionIndex + 1,
        section: currentQ.section,
        correctAnswer: currentQ.correct_option,
        hisAnswer: userOptLetter,
        timeTaken: qTime,
        attemptNumber
      });
    }

    const nextIndex = currentQuestionIndex < questions.length - 1 ? currentQuestionIndex + 1 : currentQuestionIndex;
    setCurrentQuestionIndex(nextIndex);

    saveLocalSnapshot({
      responses: updatedResponses,
      questionStates: updatedStates,
      currentQuestionIndex: nextIndex,
      attemptNumber
    });
  };

  const handleMarkReviewAndNext = () => {
    const updatedStates = { ...questionStates };
    if (responses[currentQuestionIndex] !== undefined && responses[currentQuestionIndex] !== null) {
      updatedStates[currentQuestionIndex] = 'review_answered';
    } else {
      updatedStates[currentQuestionIndex] = 'review';
    }
    setQuestionStates(updatedStates);

    const nextIndex = currentQuestionIndex < questions.length - 1 ? currentQuestionIndex + 1 : currentQuestionIndex;
    setCurrentQuestionIndex(nextIndex);

    saveLocalSnapshot({
      questionStates: updatedStates,
      currentQuestionIndex: nextIndex,
      attemptNumber
    });
  };

  const handleClearResponse = () => {
    setSelectedOption(null);
    const updatedResponses = { ...responses };
    delete updatedResponses[currentQuestionIndex];

    const updatedStates = {
      ...questionStates,
      [currentQuestionIndex]: 'not_answered'
    };

    setResponses(updatedResponses);
    setQuestionStates(updatedStates);

    const currentQ = questions[currentQuestionIndex];
    const qTime = timeSpentMap[currentQuestionIndex] || 0;

    // Real-time live sync: clear answer in DB
    if (currentQ && candidate?.mobile_number) {
      saveSingleQuestionResponse({
        mockNumber,
        candidateName: candidate.name,
        candidateMobile: candidate.mobile_number,
        questionNumber: currentQuestionIndex + 1,
        section: currentQ.section,
        correctAnswer: currentQ.correct_option,
        hisAnswer: null,
        timeTaken: qTime,
        attemptNumber
      });
    }

    saveLocalSnapshot({
      responses: updatedResponses,
      questionStates: updatedStates,
      attemptNumber
    });
  };

  const handlePreviousQuestion = () => {
    if (currentQuestionIndex > 0) {
      const prevIndex = currentQuestionIndex - 1;
      setCurrentQuestionIndex(prevIndex);
      saveLocalSnapshot({ currentQuestionIndex: prevIndex });
    }
  };

  // Toggle Pause/Resume
  const handleTogglePause = () => {
    const nextPause = !isPaused;
    setIsPaused(nextPause);
    saveLocalSnapshot({ status: nextPause ? 'paused' : 'in_progress' });
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

    // 1. Save question-level responses to table: RRB_MOCK_1_responses, RRB_MOCK_2_responses, or RRB_MOCK_3_responses
    saveMockResponses({
      mockNumber,
      candidateName: candidate?.name,
      candidateMobile: candidate?.mobile_number,
      questions,
      responses,
      timeSpentMap,
      attemptNumber
    });

    // 2. Save overall test attempt scorecard
    if (candidate?.mobile_number) {
      syncTestAttempt({
        candidateMobile: candidate.mobile_number,
        candidateName: candidate.name,
        rollNumber: candidate.roll_number,
        testId: activeTestId,
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

  const handleReattempt = () => {
    const nextAttempt = Math.min(attemptNumber + 1, 5);
    setAttemptNumber(nextAttempt);
    setResponses({});
    setQuestionStates({});
    setTimeSpentMap({});
    setSelectedOption(null);
    setCurrentQuestionIndex(0);
    setRemainingSeconds(TOTAL_DURATION_SECONDS);
    setShowScorecard(false);
    setFinalResults(null);
    setLoadingQuestions(true);

    // Randomize new option order for the new attempt!
    const seedKey = `${candidate?.mobile_number || 'cand'}_mock_${mockNumber}_att_${nextAttempt}`;
    fetchTestQuestions(mockNumber).then((rawQuestions) => {
      const randomized = randomizeQuestionsOptions(rawQuestions, seedKey);
      const qCacheKey = `rrb_shuffled_qs_${activeTestId}_${candidate?.mobile_number}_att_${nextAttempt}`;
      try {
        localStorage.setItem(qCacheKey, JSON.stringify(randomized));
      } catch (e) {}
      setQuestions(randomized);
      setLoadingQuestions(false);
    });

    saveLocalSnapshot({
      responses: {},
      questionStates: {},
      timeSpentMap: {},
      currentQuestionIndex: 0,
      remainingSeconds: TOTAL_DURATION_SECONDS,
      status: 'in_progress',
      attemptNumber: nextAttempt
    });
    triggerSync('in_progress');
  };

  const timerHours = Math.floor(remainingSeconds / 3600);
  const timerMinutes = Math.floor((remainingSeconds % 3600) / 60);
  const timerSecs = remainingSeconds % 60;
  const formattedTimer = `${String(timerHours).padStart(2, '0')}:${String(timerMinutes).padStart(2, '0')}:${String(timerSecs).padStart(2, '0')}`;
  const isTimerCritical = remainingSeconds < 300;
  const isTimerWarning = remainingSeconds < 900;

  if (loadingQuestions) {
    return (
      <div className="min-h-screen bg-slate-900 text-white flex flex-col items-center justify-center p-6">
        <div className="w-12 h-12 border-4 border-amber-500 border-t-transparent rounded-full animate-spin mb-4"></div>
        <h2 className="text-xl font-bold">Initializing TCS iON CBT Examination Engine...</h2>
        <p className="text-xs text-slate-400 mt-2">Loading {testTitle} question paper.</p>
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
        testTitle={testTitle}
        onOpenInstructions={() => setShowInstructions(true)}
        onOpenQuestionPaper={() => setShowQuestionPaper(true)}
        onOpenScratchpad={() => setShowScratchpad(true)}
        isFullscreen={isFullscreen}
        onToggleFullscreen={handleToggleFullscreen}
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

        {/* Live Timer Display */}
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

        {/* Right: Desktop Question Palette */}
        <div className="hidden lg:block w-80 h-full shrink-0">
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

        {/* Mobile Floating Palette Trigger */}
        <div className="lg:hidden fixed bottom-3 right-3 z-30">
          <button
            onClick={() => setShowMobilePalette(true)}
            className="flex items-center gap-1.5 px-3.5 py-2 bg-[#30475e] text-white font-bold text-xs rounded-full shadow-lg border-2 border-amber-400 active:scale-95 transition"
          >
            <span>Palette (100 Qs)</span>
          </button>
        </div>

        {/* Mobile Sliding Bottom Sheet Palette */}
        {showMobilePalette && (
          <div className="lg:hidden fixed inset-0 z-50 bg-black/60 backdrop-blur-xs flex flex-col justify-end">
            <div className="bg-white rounded-t-2xl max-h-[85vh] flex flex-col overflow-hidden shadow-2xl animate-in slide-in-from-bottom duration-200">
              <div className="p-3 bg-slate-800 text-white flex items-center justify-between border-b border-amber-500">
                <span className="font-bold text-xs">Question Palette</span>
                <button
                  onClick={() => setShowMobilePalette(false)}
                  className="p-1 text-slate-300 hover:text-white"
                >
                  <X className="w-4 h-4" />
                </button>
              </div>
              <div className="flex-1 overflow-y-auto">
                <QuestionPalette
                  candidate={candidate}
                  sections={SECTIONS}
                  activeSection={activeSection}
                  onSelectSection={handleSelectSection}
                  currentQuestionIndex={currentQuestionIndex}
                  onSelectQuestion={(idx) => {
                    handleSelectQuestion(idx);
                    setShowMobilePalette(false);
                  }}
                  questionStates={questionStates}
                  responses={responses}
                  onSubmitClick={() => {
                    setShowMobilePalette(false);
                    setShowSubmitConfirm(true);
                  }}
                />
              </div>
            </div>
          </div>
        )}

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
        candidate={candidate}
        timeSpentMap={timeSpentMap}
        onGoToDashboard={onFinishExam}
        onReattempt={handleReattempt}
      />

      <ScratchpadModal
        isOpen={showScratchpad}
        onClose={() => setShowScratchpad(false)}
      />

    </div>
  );
}
