import React, { useState } from 'react';
import { User, CheckCircle, XCircle, MinusCircle, BookOpen, ArrowLeft } from 'lucide-react';

export default function QuestionPalette({
  candidate,
  sections,
  activeSection,
  onSelectSection,
  currentQuestionIndex,
  onSelectQuestion,
  questionStates,
  responses,
  onSubmitClick,
  questions = [],
  isReviewMode = false,
  onExitReview = null,
  onOpenScorecard = null,
  isOnline = true
}) {
  const [filterMode, setFilterMode] = useState('all'); // 'all' | 'incorrect' | 'correct' | 'unattempted'

  // Compute counts for active section
  const start = activeSection.startIndex;
  const end = activeSection.endIndex;

  let answered = 0;
  let notAnswered = 0;
  let notVisited = 0;
  let markedReview = 0;
  let markedReviewAnswered = 0;

  // Review mode counts
  let sectionCorrect = 0;
  let sectionIncorrect = 0;
  let sectionUnattempted = 0;

  for (let i = start; i <= end; i++) {
    const state = questionStates[i] || 'not_visited';
    const hasResponse = responses[i] !== undefined && responses[i] !== null;

    if (state === 'answered' || (hasResponse && state !== 'review_answered')) {
      answered++;
    } else if (state === 'review_answered') {
      markedReviewAnswered++;
    } else if (state === 'review') {
      markedReview++;
    } else if (state === 'not_answered') {
      notAnswered++;
    } else {
      notVisited++;
    }

    if (isReviewMode && questions[i]) {
      const uOpt = responses[i];
      if (uOpt === undefined || uOpt === null) {
        sectionUnattempted++;
      } else {
        const uLetter = String.fromCharCode(65 + uOpt);
        if (uLetter === questions[i].correct_option) {
          sectionCorrect++;
        } else {
          sectionIncorrect++;
        }
      }
    }
  }

  return (
    <aside className="w-full lg:w-80 bg-white border-l border-slate-300 flex flex-col h-full select-none shadow-sm">
      
      {/* Candidate Profile Widget */}
      <div className="p-3 bg-slate-100 border-b border-slate-300 flex items-center gap-3">
        <div className="w-12 h-12 bg-slate-300 border border-slate-400 rounded flex items-center justify-center font-bold text-slate-700 text-lg shadow-inner overflow-hidden">
          {candidate?.name ? candidate.name.charAt(0).toUpperCase() : <User className="w-6 h-6 text-slate-500" />}
        </div>
        <div className="text-xs leading-tight">
          <div className="font-bold text-slate-900">{candidate?.name || 'Candidate'}</div>
          <div className="text-slate-600 font-mono text-[11px]">Roll: {candidate?.roll_number || 'RRB268041'}</div>
          {isOnline ? (
            <div className="text-[10px] text-emerald-700 font-semibold mt-0.5 flex items-center gap-1">
              <span className="w-2 h-2 rounded-full bg-emerald-500 animate-pulse"></span>
              <span>Connected to Exam Server</span>
            </div>
          ) : (
            <div className="text-[10px] text-amber-700 font-bold mt-0.5 flex items-center gap-1">
              <span className="w-2 h-2 rounded-full bg-amber-500"></span>
              <span>Working Offline (Local Storage)</span>
            </div>
          )}
        </div>
      </div>

      {/* TCS iON Status Counter Legend or Review Mode Legend */}
      {isReviewMode ? (
        <div className="p-3 border-b border-slate-200 bg-slate-50 text-[11px]">
          <div className="font-bold text-slate-800 text-[11px] mb-2 flex items-center justify-between">
            <span>Section Diagnostics:</span>
            <span className="text-[10px] font-mono text-slate-500">Q.{start + 1} - Q.{end + 1}</span>
          </div>

          <div className="grid grid-cols-3 gap-1.5 mb-2.5">
            <div className="p-1.5 bg-emerald-50 border border-emerald-200 rounded text-center">
              <div className="text-xs font-black text-emerald-700">{sectionCorrect}</div>
              <div className="text-[9px] font-bold text-emerald-800 uppercase">Correct</div>
            </div>
            <div className="p-1.5 bg-red-50 border border-red-200 rounded text-center">
              <div className="text-xs font-black text-red-700">{sectionIncorrect}</div>
              <div className="text-[9px] font-bold text-red-800 uppercase">Wrong</div>
            </div>
            <div className="p-1.5 bg-slate-100 border border-slate-200 rounded text-center">
              <div className="text-xs font-black text-slate-700">{sectionUnattempted}</div>
              <div className="text-[9px] font-bold text-slate-600 uppercase">Skipped</div>
            </div>
          </div>

          {/* Quick Filter Pills */}
          <div className="flex items-center gap-1">
            <button
              onClick={() => setFilterMode('all')}
              className={`flex-1 py-1 text-[10px] font-bold rounded transition ${
                filterMode === 'all' ? 'bg-[#30475e] text-white shadow-xs' : 'bg-slate-200 text-slate-700 hover:bg-slate-300'
              }`}
            >
              All ({activeSection.total})
            </button>
            <button
              onClick={() => setFilterMode('incorrect')}
              className={`flex-1 py-1 text-[10px] font-bold rounded transition ${
                filterMode === 'incorrect' ? 'bg-red-600 text-white shadow-xs' : 'bg-red-50 text-red-700 hover:bg-red-100'
              }`}
            >
              Wrong ({sectionIncorrect})
            </button>
            <button
              onClick={() => setFilterMode('correct')}
              className={`flex-1 py-1 text-[10px] font-bold rounded transition ${
                filterMode === 'correct' ? 'bg-emerald-600 text-white shadow-xs' : 'bg-emerald-50 text-emerald-700 hover:bg-emerald-100'
              }`}
            >
              Right ({sectionCorrect})
            </button>
          </div>
        </div>
      ) : (
        <div className="p-3 border-b border-slate-200 bg-slate-50 text-[11px]">
          <div className="grid grid-cols-2 gap-2">
            
            <div className="flex items-center gap-2">
              <span className="badge-answered palette-btn !w-6 !h-6 !text-[10px]">{answered}</span>
              <span className="text-slate-700 font-medium">Answered</span>
            </div>

            <div className="flex items-center gap-2">
              <span className="badge-not-answered palette-btn !w-6 !h-6 !text-[10px]">{notAnswered}</span>
              <span className="text-slate-700 font-medium">Not Answered</span>
            </div>

            <div className="flex items-center gap-2">
              <span className="badge-not-visited palette-btn !w-6 !h-6 !text-[10px]">{notVisited}</span>
              <span className="text-slate-700 font-medium">Not Visited</span>
            </div>

            <div className="flex items-center gap-2">
              <span className="badge-review palette-btn !w-6 !h-6 !text-[10px]">{markedReview}</span>
              <span className="text-slate-700 font-medium">Marked for Review</span>
            </div>

            <div className="flex items-center gap-2 col-span-2 pt-1 border-t border-slate-200">
              <span className="badge-review-answered palette-btn !w-6 !h-6 !text-[10px] relative">
                {markedReviewAnswered}
                <span className="absolute bottom-0 right-0 w-1.5 h-1.5 bg-emerald-400 rounded-full border border-white"></span>
              </span>
              <span className="text-slate-700 font-medium leading-tight">
                Ans & Marked for Review <span className="text-[9px] text-slate-500">(Evaluated)</span>
              </span>
            </div>

          </div>
        </div>
      )}

      {/* Section Indicator */}
      <div className="px-3 py-2 bg-[#30475e] text-white font-bold text-xs flex items-center justify-between">
        <span>Section: {activeSection.nameEn}</span>
        <span className="text-[10px] bg-amber-500 text-slate-900 px-1.5 py-0.5 rounded font-extrabold">
          {activeSection.total} Qs
        </span>
      </div>

      {/* Question Number Palette Grid */}
      <div className="flex-1 p-3 overflow-y-auto">
        <div className="text-[11px] font-bold text-slate-700 mb-2">
          {isReviewMode ? "Jump to Solution:" : "Choose a Question:"}
        </div>

        <div className="grid grid-cols-5 gap-2 justify-items-center">
          {Array.from({ length: activeSection.total }).map((_, idx) => {
            const qIndex = activeSection.startIndex + idx;
            const qNumber = qIndex + 1;
            const isCurrent = currentQuestionIndex === qIndex;
            const state = questionStates[qIndex] || 'not_visited';
            const hasAnswer = responses[qIndex] !== undefined && responses[qIndex] !== null;

            if (isReviewMode) {
              const q = questions[qIndex];
              const uOpt = responses[qIndex];
              const isAttempted = uOpt !== undefined && uOpt !== null;
              const uLetter = isAttempted ? String.fromCharCode(65 + uOpt) : null;
              const isCorrect = isAttempted && q && uLetter === q.correct_option;
              const isIncorrect = isAttempted && q && uLetter !== q.correct_option;

              // Filter out if not matching filter mode
              if (filterMode === 'correct' && !isCorrect) return null;
              if (filterMode === 'incorrect' && !isIncorrect) return null;
              if (filterMode === 'unattempted' && isAttempted) return null;

              let btnStyle = 'bg-slate-200 text-slate-700 border-slate-300';
              if (isCorrect) {
                btnStyle = 'bg-emerald-600 text-white border-emerald-700 font-bold';
              } else if (isIncorrect) {
                btnStyle = 'bg-red-600 text-white border-red-700 font-bold';
              }

              return (
                <button
                  key={qIndex}
                  onClick={() => onSelectQuestion(qIndex)}
                  className={`palette-btn ${btnStyle} ${
                    isCurrent ? 'ring-2 ring-blue-600 ring-offset-2 scale-110 shadow-md z-10' : ''
                  }`}
                  title={`Question ${qNumber}: ${isCorrect ? 'Correct' : isIncorrect ? 'Wrong' : 'Skipped'}`}
                >
                  {String(qNumber).padStart(2, '0')}
                </button>
              );
            }

            // Normal Exam Mode Badges
            let badgeClass = 'badge-not-visited';
            if (state === 'review_answered') {
              badgeClass = 'badge-review-answered';
            } else if (state === 'review') {
              badgeClass = 'badge-review';
            } else if (state === 'answered' || (hasAnswer && state !== 'review_answered')) {
              badgeClass = 'badge-answered';
            } else if (state === 'not_answered') {
              badgeClass = 'badge-not-answered';
            }

            return (
              <button
                key={qIndex}
                onClick={() => onSelectQuestion(qIndex)}
                className={`palette-btn ${badgeClass} ${
                  isCurrent ? 'ring-2 ring-blue-600 ring-offset-2 scale-110 shadow-md z-10' : ''
                }`}
                title={`Question ${qNumber} (${state.replace('_', ' ')})`}
              >
                {String(qNumber).padStart(2, '0')}
                {state === 'review_answered' && (
                  <span className="absolute bottom-0.5 right-0.5 w-1.5 h-1.5 bg-emerald-400 rounded-full border border-white"></span>
                )}
              </button>
            );
          })}
        </div>
      </div>

      {/* Footer Action */}
      <div className="p-3 bg-slate-100 border-t border-slate-300 space-y-2">
        {isReviewMode ? (
          <>
            {onOpenScorecard && (
              <button
                onClick={onOpenScorecard}
                className="w-full py-2 bg-indigo-600 hover:bg-indigo-700 text-white font-bold text-xs uppercase tracking-wider rounded shadow transition active:scale-95"
              >
                Scorecard & Analysis
              </button>
            )}
            {onExitReview && (
              <button
                onClick={onExitReview}
                className="w-full py-2 bg-slate-700 hover:bg-slate-800 text-white font-bold text-xs uppercase tracking-wider rounded transition active:scale-95"
              >
                Exit to Dashboard
              </button>
            )}
          </>
        ) : (
          <button
            onClick={onSubmitClick}
            className="w-full py-2.5 bg-blue-600 hover:bg-blue-700 text-white font-bold text-xs uppercase tracking-wider rounded shadow transition active:scale-95"
          >
            Submit Test
          </button>
        )}
      </div>

    </aside>
  );
}
