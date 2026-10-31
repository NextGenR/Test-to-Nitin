import React, { useState } from 'react';
import { Award, CheckCircle2, XCircle, MinusCircle, ArrowRight, RotateCcw, ChevronDown, ChevronUp } from 'lucide-react';

export default function ScorecardModal({
  isOpen,
  results,
  questions,
  sections,
  onGoToDashboard,
  onReattempt
}) {
  const [expandedSection, setExpandedSection] = useState(null);
  const [showSolutions, setShowSolutions] = useState(false);

  if (!isOpen || !results) return null;

  const {
    score = 0,
    totalMarks = 100,
    correctCount = 0,
    incorrectCount = 0,
    unattemptedCount = 0,
    accuracy = 0,
    sectionalScores = [],
    responses = {}
  } = results;

  const isPassed = score >= 40.0; // 40% qualifying threshold for General category

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/70 backdrop-blur-sm p-4 overflow-y-auto">
      <div className="bg-white rounded-xl shadow-2xl max-w-4xl w-full max-h-[92vh] flex flex-col border border-slate-300 animate-in zoom-in-95 duration-200">
        
        {/* Header */}
        <div className="bg-gradient-to-r from-[#1d638a] to-[#30475e] text-white p-6 rounded-t-xl flex flex-col sm:flex-row sm:items-center justify-between gap-4 border-b-2 border-amber-500">
          <div>
            <div className="flex items-center gap-2 mb-1">
              <Award className="w-6 h-6 text-amber-400" />
              <h2 className="text-xl font-bold tracking-wide">
                RRB Group D CBT Performance Report
              </h2>
            </div>
            <p className="text-xs text-slate-200">
              Official Assessment Scorecard & Solution Analysis
            </p>
          </div>

          <div className="flex items-center gap-3 bg-white/10 px-4 py-2 rounded-lg border border-white/20">
            <div className="text-right">
              <div className="text-[10px] text-slate-300 uppercase tracking-wider font-semibold">Your Score</div>
              <div className="text-2xl font-black text-amber-300">
                {score.toFixed(2)} <span className="text-xs text-white/80 font-normal">/ {totalMarks}</span>
              </div>
            </div>
            <div className={`px-2.5 py-1 rounded text-xs font-bold uppercase tracking-wider ${
              isPassed ? 'bg-emerald-500 text-white' : 'bg-red-500 text-white'
            }`}>
              {isPassed ? 'Qualified' : 'Needs Practice'}
            </div>
          </div>
        </div>

        {/* Scrollable Body */}
        <div className="p-6 overflow-y-auto space-y-6">
          
          {/* Top Key Metrics */}
          <div className="grid grid-cols-2 sm:grid-cols-4 gap-3">
            <div className="p-3.5 bg-emerald-50 border border-emerald-200 rounded-lg">
              <div className="flex items-center gap-1.5 text-xs text-emerald-800 font-semibold mb-1">
                <CheckCircle2 className="w-4 h-4 text-emerald-600" />
                <span>Correct</span>
              </div>
              <div className="text-xl font-black text-emerald-700">{correctCount}</div>
              <div className="text-[10px] text-emerald-600">+{correctCount * 1.0} marks</div>
            </div>

            <div className="p-3.5 bg-red-50 border border-red-200 rounded-lg">
              <div className="flex items-center gap-1.5 text-xs text-red-800 font-semibold mb-1">
                <XCircle className="w-4 h-4 text-red-600" />
                <span>Incorrect</span>
              </div>
              <div className="text-xl font-black text-red-700">{incorrectCount}</div>
              <div className="text-[10px] text-red-600">-{(incorrectCount * 0.33).toFixed(2)} marks (-1/3)</div>
            </div>

            <div className="p-3.5 bg-slate-50 border border-slate-200 rounded-lg">
              <div className="flex items-center gap-1.5 text-xs text-slate-600 font-semibold mb-1">
                <MinusCircle className="w-4 h-4 text-slate-500" />
                <span>Unattempted</span>
              </div>
              <div className="text-xl font-black text-slate-700">{unattemptedCount}</div>
              <div className="text-[10px] text-slate-500">0 marks penalty</div>
            </div>

            <div className="p-3.5 bg-sky-50 border border-sky-200 rounded-lg">
              <div className="flex items-center gap-1.5 text-xs text-sky-800 font-semibold mb-1">
                <Award className="w-4 h-4 text-sky-600" />
                <span>Accuracy</span>
              </div>
              <div className="text-xl font-black text-sky-700">{accuracy.toFixed(1)}%</div>
              <div className="text-[10px] text-sky-600">Attempt Efficiency</div>
            </div>
          </div>

          {/* Section-Wise Breakdown Table */}
          <div>
            <h3 className="font-bold text-sm text-slate-900 mb-2 flex items-center justify-between">
              <span>Sectional Performance Analysis</span>
              <span className="text-xs text-slate-500 font-normal">Marking: +1.0 / -0.33</span>
            </h3>
            <div className="overflow-x-auto border border-slate-200 rounded-lg">
              <table className="w-full text-xs text-left text-slate-700">
                <thead className="bg-slate-100 text-slate-900 uppercase font-bold border-b border-slate-200 text-[11px]">
                  <tr>
                    <th className="px-3 py-2.5">Section</th>
                    <th className="px-2 py-2.5 text-center">Total Qs</th>
                    <th className="px-2 py-2.5 text-center text-emerald-700">Correct</th>
                    <th className="px-2 py-2.5 text-center text-red-700">Wrong</th>
                    <th className="px-2 py-2.5 text-center text-slate-600">Skipped</th>
                    <th className="px-3 py-2.5 text-right font-black">Score</th>
                  </tr>
                </thead>
                <tbody className="divide-y divide-slate-200">
                  {sectionalScores.map((sec, idx) => (
                    <tr key={idx} className="hover:bg-slate-50">
                      <td className="px-3 py-2.5 font-semibold text-slate-900">{sec.sectionName}</td>
                      <td className="px-2 py-2.5 text-center">{sec.total}</td>
                      <td className="px-2 py-2.5 text-center font-bold text-emerald-700">{sec.correct}</td>
                      <td className="px-2 py-2.5 text-center font-bold text-red-700">{sec.incorrect}</td>
                      <td className="px-2 py-2.5 text-center text-slate-500">{sec.unattempted}</td>
                      <td className="px-3 py-2.5 text-right font-black text-slate-900">{sec.score.toFixed(2)}</td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
          </div>

          {/* Toggle Solution Sheet */}
          <div>
            <button
              onClick={() => setShowSolutions(!showSolutions)}
              className="w-full flex items-center justify-between px-4 py-3 bg-slate-100 hover:bg-slate-200 rounded-lg border border-slate-300 font-bold text-xs text-slate-800 transition"
            >
              <span>{showSolutions ? "Hide Detailed Question Solutions" : "Review All 100 Questions & Explanations"}</span>
              {showSolutions ? <ChevronUp className="w-4 h-4" /> : <ChevronDown className="w-4 h-4" />}
            </button>

            {showSolutions && (
              <div className="mt-4 space-y-4 max-h-96 overflow-y-auto pr-1">
                {questions.map((q, idx) => {
                  const userOptionIdx = responses[idx];
                  const userOptionLetter = userOptionIdx !== undefined ? String.fromCharCode(65 + userOptionIdx) : null;
                  const isCorrect = userOptionLetter === q.correct_option;
                  const isAttempted = userOptionLetter !== null;

                  return (
                    <div
                      key={q.id || idx}
                      className={`p-4 rounded-lg border text-xs leading-relaxed ${
                        !isAttempted
                          ? 'bg-slate-50 border-slate-200'
                          : isCorrect
                          ? 'bg-emerald-50/50 border-emerald-200'
                          : 'bg-red-50/50 border-red-200'
                      }`}
                    >
                      <div className="flex items-start justify-between gap-2 mb-2">
                        <div className="font-bold text-slate-900">
                          Q.{idx + 1} ({q.section}): {q.question_en}
                          <div className="text-slate-600 font-normal mt-0.5">{q.question_hi}</div>
                        </div>
                        <span className={`px-2 py-0.5 rounded text-[10px] font-bold uppercase shrink-0 ${
                          !isAttempted
                            ? 'bg-slate-200 text-slate-700'
                            : isCorrect
                            ? 'bg-emerald-600 text-white'
                            : 'bg-red-600 text-white'
                        }`}>
                          {!isAttempted ? 'Skipped' : isCorrect ? 'Correct (+1)' : 'Wrong (-0.33)'}
                        </span>
                      </div>

                      <div className="grid grid-cols-1 sm:grid-cols-2 gap-2 my-2">
                        {q.options_en.map((opt, oIdx) => {
                          const letter = String.fromCharCode(65 + oIdx);
                          const isThisCorrect = letter === q.correct_option;
                          const isThisUser = letter === userOptionLetter;

                          return (
                            <div
                              key={oIdx}
                              className={`p-2 rounded border flex items-center justify-between text-xs ${
                                isThisCorrect
                                  ? 'bg-emerald-100 border-emerald-400 font-bold text-emerald-900'
                                  : isThisUser
                                  ? 'bg-red-100 border-red-300 font-semibold text-red-900'
                                  : 'bg-white border-slate-200 text-slate-700'
                              }`}
                            >
                              <span>{letter}. {opt}</span>
                              {isThisCorrect && <span className="text-[10px] font-black text-emerald-800">Correct Ans</span>}
                              {!isThisCorrect && isThisUser && <span className="text-[10px] font-black text-red-800">Your Choice</span>}
                            </div>
                          );
                        })}
                      </div>

                      {q.explanation_en && (
                        <div className="mt-2 pt-2 border-t border-slate-200 text-[11px] text-slate-600">
                          <strong>Explanation:</strong> {q.explanation_en}
                        </div>
                      )}
                    </div>
                  );
                })}
              </div>
            )}
          </div>

        </div>

        {/* Footer Actions */}
        <div className="bg-slate-100 px-6 py-3.5 rounded-b-xl border-t border-slate-300 flex items-center justify-between">
          <button
            onClick={onReattempt}
            className="flex items-center gap-1.5 px-4 py-2 text-xs font-semibold text-slate-700 bg-white border border-slate-300 rounded hover:bg-slate-50 transition"
          >
            <RotateCcw className="w-3.5 h-3.5" />
            <span>Re-attempt Test</span>
          </button>

          <button
            onClick={onGoToDashboard}
            className="flex items-center gap-1.5 px-6 py-2 text-xs font-bold uppercase tracking-wider text-white bg-[#1d638a] hover:bg-[#164e6d] rounded shadow transition"
          >
            <span>Return to Dashboard</span>
            <ArrowRight className="w-4 h-4" />
          </button>
        </div>

      </div>
    </div>
  );
}

