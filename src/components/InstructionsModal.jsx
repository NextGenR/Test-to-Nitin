import React, { useState } from 'react';
import { X, CheckSquare, Square, AlertCircle, Info } from 'lucide-react';

export default function InstructionsModal({
  isOpen,
  onClose,
  onStartExam,
  isPreExam = false,
  defaultLang = 'en',
  onChangeDefaultLang
}) {
  const [agreed, setAgreed] = useState(false);

  if (!isOpen) return null;

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/60 backdrop-blur-sm p-4 overflow-y-auto">
      <div className="bg-white rounded-lg shadow-2xl max-w-3xl w-full max-h-[90vh] flex flex-col border border-slate-300 animate-in fade-in zoom-in-95 duration-150">
        
        {/* Header */}
        <div className="bg-[#30475e] text-white px-6 py-3.5 rounded-t-lg flex items-center justify-between border-b border-amber-500">
          <div className="flex items-center gap-2">
            <Info className="w-5 h-5 text-amber-400" />
            <h3 className="font-bold text-base tracking-wide">
              General Instructions - Computer Based Test (CBT)
            </h3>
          </div>
          {!isPreExam && (
            <button
              onClick={onClose}
              className="text-slate-300 hover:text-white p-1 rounded hover:bg-slate-700 transition"
            >
              <X className="w-5 h-5" />
            </button>
          )}
        </div>

        {/* Content body */}
        <div className="p-6 overflow-y-auto space-y-5 text-sm text-slate-700 leading-relaxed">
          
          <div className="bg-amber-50 border-l-4 border-amber-500 p-3.5 rounded text-amber-900 text-xs">
            <p className="font-bold mb-1">Important Instructions for Candidates:</p>
            <p>1. Total duration of examination is <strong>90 minutes</strong> (100 Questions, 100 Marks).</p>
            <p>2. Negative marking: <strong>1/3rd (0.33 mark)</strong> will be deducted for each incorrect answer.</p>
            <p>3. The clock will be set at the server. The countdown timer in the top right corner will display the remaining time.</p>
          </div>

          <div>
            <h4 className="font-bold text-slate-900 mb-2 border-b pb-1">
              Question Palette Symbols & Legend:
            </h4>
            <div className="grid grid-cols-1 sm:grid-cols-2 gap-2.5 pt-1 text-xs">
              <div className="flex items-center gap-3 p-2 bg-slate-50 rounded border border-slate-200">
                <span className="badge-not-visited palette-btn">01</span>
                <span>You have <strong>not visited</strong> the question yet.</span>
              </div>
              <div className="flex items-center gap-3 p-2 bg-slate-50 rounded border border-slate-200">
                <span className="badge-not-answered palette-btn">02</span>
                <span>You have <strong>not answered</strong> the question.</span>
              </div>
              <div className="flex items-center gap-3 p-2 bg-slate-50 rounded border border-slate-200">
                <span className="badge-answered palette-btn">03</span>
                <span>You have <strong>answered</strong> the question.</span>
              </div>
              <div className="flex items-center gap-3 p-2 bg-slate-50 rounded border border-slate-200">
                <span className="badge-review palette-btn">04</span>
                <span>You have <strong>NOT answered</strong> the question, but have <strong>marked for review</strong>.</span>
              </div>
              <div className="flex items-center gap-3 p-2 bg-slate-50 rounded border border-slate-200 sm:col-span-2">
                <span className="badge-review-answered palette-btn">
                  05
                  <span className="absolute bottom-0.5 right-0.5 w-2 h-2 bg-emerald-400 rounded-full border border-white"></span>
                </span>
                <span>
                  The question has been <strong>answered AND marked for review</strong>. (<strong>This will be evaluated</strong>).
                </span>
              </div>
            </div>
          </div>

          <div>
            <h4 className="font-bold text-slate-900 mb-2 border-b pb-1">
              Navigating to a Question & Submitting Answers:
            </h4>
            <ul className="list-disc pl-5 space-y-1.5 text-xs text-slate-600">
              <li>Click on the question number in the Question Palette to go directly to that question.</li>
              <li>Click <strong>Save & Next</strong> to save your answer and move to the next question.</li>
              <li>Click <strong>Save & Mark for Review</strong> to save your answer, mark it for review, and move ahead.</li>
              <li>Click <strong>Mark for Review & Next</strong> to mark without answering and proceed.</li>
              <li>Click <strong>Clear Response</strong> to deselect your chosen option.</li>
              <li>You can freely switch between Sections (General Science, Mathematics, Reasoning, General Awareness) at any time.</li>
            </ul>
          </div>

          {/* Pre-Exam Declaration and Language selection */}
          {isPreExam && (
            <div className="pt-3 border-t border-slate-200 space-y-3">
              <div className="flex flex-wrap items-center justify-between gap-3 bg-slate-100 p-3 rounded">
                <label className="text-xs font-bold text-slate-800">
                  Choose your default language:
                </label>
                <select
                  value={defaultLang}
                  onChange={(e) => onChangeDefaultLang && onChangeDefaultLang(e.target.value)}
                  className="bg-white border border-slate-300 text-xs rounded px-3 py-1.5 font-medium text-slate-700 focus:outline-none focus:ring-2 focus:ring-blue-500"
                >
                  <option value="en">English</option>
                  <option value="hi">हिंदी (Hindi)</option>
                </select>
              </div>

              <div
                onClick={() => setAgreed(!agreed)}
                className="flex items-start gap-2.5 p-3 rounded-lg border border-amber-200 bg-amber-50/50 cursor-pointer select-none"
              >
                <button
                  type="button"
                  className="mt-0.5 text-blue-600 focus:outline-none"
                >
                  {agreed ? (
                    <CheckSquare className="w-5 h-5 text-blue-600 fill-blue-50" />
                  ) : (
                    <Square className="w-5 h-5 text-slate-400" />
                  )}
                </button>
                <p className="text-xs text-slate-700 leading-snug">
                  I have read and understood all the above instructions. I declare that I am not in possession of any prohibited electronic devices. I agree that in case of not adhering to the instructions, I shall be liable to be debarred from this examination.
                </p>
              </div>
            </div>
          )}

        </div>

        {/* Footer */}
        <div className="bg-slate-100 px-6 py-3 rounded-b-lg border-t border-slate-300 flex items-center justify-between">
          <button
            onClick={onClose}
            className="px-4 py-1.5 text-xs font-semibold text-slate-700 bg-white border border-slate-300 rounded hover:bg-slate-50 transition"
          >
            {isPreExam ? "Cancel" : "Close"}
          </button>

          {isPreExam && (
            <button
              onClick={() => {
                if (agreed) onStartExam();
              }}
              disabled={!agreed}
              className={`px-6 py-2 text-xs font-bold uppercase tracking-wider rounded transition ${
                agreed
                  ? 'bg-blue-600 hover:bg-blue-700 text-white shadow-md'
                  : 'bg-slate-300 text-slate-500 cursor-not-allowed'
              }`}
            >
              I am ready to begin
            </button>
          )}
        </div>

      </div>
    </div>
  );
}
