import React from 'react';
import { AlertTriangle, CheckCircle } from 'lucide-react';

export default function SubmitConfirmModal({
  isOpen,
  onClose,
  onConfirmSubmit,
  sections = [],
  questions = [],
  responses = {},
  questionStates = {}
}) {
  if (!isOpen) return null;

  // Compute breakdown per section
  const sectionSummaries = (sections || []).map((sec) => {
    let answered = 0;
    let notAnswered = 0;
    let markedReview = 0;
    let markedReviewAnswered = 0;
    let notVisited = 0;

    const start = sec.startIndex ?? 0;
    const end = sec.endIndex ?? -1;

    for (let i = start; i <= end; i++) {
      const q = questions[i];
      if (!q) continue;
      const state = (questionStates && questionStates[i]) || 'not_visited';
      const hasAnswer = responses && responses[i] !== undefined && responses[i] !== null;

      if (state === 'answered' || (hasAnswer && state !== 'review_answered')) {
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
    }

    return {
      name: sec.nameEn || sec.name || 'Section',
      total: sec.total || 0,
      answered,
      notAnswered,
      markedReview,
      markedReviewAnswered,
      notVisited
    };
  });

  const grandTotal = sectionSummaries.reduce(
    (acc, curr) => ({
      total: acc.total + curr.total,
      answered: acc.answered + curr.answered,
      notAnswered: acc.notAnswered + curr.notAnswered,
      markedReview: acc.markedReview + curr.markedReview,
      markedReviewAnswered: acc.markedReviewAnswered + curr.markedReviewAnswered,
      notVisited: acc.notVisited + curr.notVisited
    }),
    { total: 0, answered: 0, notAnswered: 0, markedReview: 0, markedReviewAnswered: 0, notVisited: 0 }
  );

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/60 backdrop-blur-sm p-4 overflow-y-auto">
      <div className="bg-white rounded-lg shadow-2xl max-w-3xl w-full border border-slate-300 animate-in fade-in zoom-in-95 duration-150">
        
        {/* Header */}
        <div className="bg-[#30475e] text-white px-6 py-3.5 rounded-t-lg flex items-center justify-between border-b border-amber-500">
          <div className="flex items-center gap-2">
            <AlertTriangle className="w-5 h-5 text-amber-400" />
            <h3 className="font-bold text-base tracking-wide">
              Exam Summary & Submission
            </h3>
          </div>
        </div>

        {/* Content body */}
        <div className="p-6 space-y-4">
          <p className="text-xs text-slate-600 font-medium">
            Please verify your attempt summary before final submission. Once submitted, your answers cannot be altered.
          </p>

          <div className="overflow-x-auto border border-slate-200 rounded-lg">
            <table className="w-full text-xs text-left text-slate-700">
              <thead className="bg-slate-100 text-slate-900 uppercase font-bold border-b border-slate-200 text-[11px]">
                <tr>
                  <th className="px-3 py-2.5">Section Name</th>
                  <th className="px-2 py-2.5 text-center">No. of Qs</th>
                  <th className="px-2 py-2.5 text-center text-emerald-700">Answered</th>
                  <th className="px-2 py-2.5 text-center text-red-700">Not Answered</th>
                  <th className="px-2 py-2.5 text-center text-purple-700">Marked for Review</th>
                  <th className="px-2 py-2.5 text-center text-indigo-700">Ans & Marked Review</th>
                  <th className="px-2 py-2.5 text-center text-slate-600">Not Visited</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-slate-200">
                {sectionSummaries.map((s, idx) => (
                  <tr key={idx} className="hover:bg-slate-50">
                    <td className="px-3 py-2 font-medium text-slate-900">{s.name}</td>
                    <td className="px-2 py-2 text-center font-bold">{s.total}</td>
                    <td className="px-2 py-2 text-center font-bold text-emerald-700 bg-emerald-50/50">{s.answered}</td>
                    <td className="px-2 py-2 text-center font-bold text-red-700 bg-red-50/50">{s.notAnswered}</td>
                    <td className="px-2 py-2 text-center font-bold text-purple-700 bg-purple-50/50">{s.markedReview}</td>
                    <td className="px-2 py-2 text-center font-bold text-indigo-700 bg-indigo-50/50">{s.markedReviewAnswered}</td>
                    <td className="px-2 py-2 text-center font-bold text-slate-600 bg-slate-50">{s.notVisited}</td>
                  </tr>
                ))}
                {/* Grand Total Row */}
                <tr className="bg-slate-100 font-black text-slate-900 border-t-2 border-slate-300">
                  <td className="px-3 py-2.5">Total</td>
                  <td className="px-2 py-2.5 text-center">{grandTotal.total}</td>
                  <td className="px-2 py-2.5 text-center text-emerald-800">{grandTotal.answered}</td>
                  <td className="px-2 py-2.5 text-center text-red-800">{grandTotal.notAnswered}</td>
                  <td className="px-2 py-2.5 text-center text-purple-800">{grandTotal.markedReview}</td>
                  <td className="px-2 py-2.5 text-center text-indigo-800">{grandTotal.markedReviewAnswered}</td>
                  <td className="px-2 py-2.5 text-center text-slate-700">{grandTotal.notVisited}</td>
                </tr>
              </tbody>
            </table>
          </div>

          <div className="p-3 bg-amber-50 border border-amber-200 rounded text-xs text-amber-900 flex items-start gap-2">
            <AlertTriangle className="w-4 h-4 text-amber-600 shrink-0 mt-0.5" />
            <span>
              <strong>Note:</strong> Questions "Answered & Marked for Review" will be considered for evaluation in accordance with TCS iON RRB guidelines.
            </span>
          </div>

          <div className="text-center pt-2">
            <h4 className="font-bold text-slate-800 text-sm">
              Are you sure you want to submit the examination?
            </h4>
          </div>
        </div>

        {/* Footer actions */}
        <div className="bg-slate-100 px-6 py-3 rounded-b-lg border-t border-slate-300 flex items-center justify-between">
          <button
            onClick={onClose}
            className="px-5 py-2 text-xs font-semibold text-slate-700 bg-white border border-slate-300 rounded hover:bg-slate-50 transition"
          >
            No, Return to Exam
          </button>
          <button
            onClick={onConfirmSubmit}
            className="flex items-center gap-1.5 px-6 py-2 text-xs font-bold uppercase tracking-wider text-white bg-emerald-600 hover:bg-emerald-700 rounded shadow transition"
          >
            <CheckCircle className="w-4 h-4" />
            <span>Yes, Submit Exam</span>
          </button>
        </div>

      </div>
    </div>
  );
}
