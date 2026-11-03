import React from 'react';
import { X, FileText } from 'lucide-react';
import MathRenderer from './MathRenderer';

export default function QuestionPaperModal({
  isOpen,
  onClose,
  questions,
  sections,
  lang = 'en'
}) {
  if (!isOpen) return null;

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/60 backdrop-blur-sm p-4 overflow-y-auto">
      <div className="bg-white rounded-lg shadow-2xl max-w-4xl w-full max-h-[90vh] flex flex-col border border-slate-300">
        
        {/* Header */}
        <div className="bg-[#30475e] text-white px-6 py-3.5 rounded-t-lg flex items-center justify-between border-b border-amber-500">
          <div className="flex items-center gap-2">
            <FileText className="w-5 h-5 text-sky-400" />
            <h3 className="font-bold text-base tracking-wide">
              Question Paper - RRB Group D CBT
            </h3>
          </div>
          <button
            onClick={onClose}
            className="text-slate-300 hover:text-white p-1 rounded hover:bg-slate-700 transition"
          >
            <X className="w-5 h-5" />
          </button>
        </div>

        {/* Questions list */}
        <div className="p-6 overflow-y-auto space-y-6 text-sm text-slate-800">
          {sections.map((sec) => {
            const secQuestions = questions.slice(sec.startIndex, sec.endIndex + 1);
            return (
              <div key={sec.id} className="space-y-4">
                <div className="bg-slate-200 text-slate-800 px-4 py-2 font-bold text-sm rounded border-l-4 border-blue-600">
                  {sec.nameEn} / {sec.nameHi} ({sec.total} Questions)
                </div>

                <div className="space-y-4 pl-2">
                  {secQuestions.map((q, idx) => {
                    const qNumber = sec.startIndex + idx + 1;
                    const questionText = lang === 'hi' && q.question_hi ? q.question_hi : q.question_en;
                    const options = lang === 'hi' && q.options_hi ? q.options_hi : q.options_en;

                    return (
                      <div key={q.id || idx} className="p-3.5 bg-slate-50 border border-slate-200 rounded-lg">
                        <div className="font-semibold text-slate-900 mb-2.5">
                          Q.{qNumber} : <MathRenderer text={questionText} />
                        </div>
                        {/* Figure / Diagram if present (Omit for General Science) */}
                        {!(q.section === 'General Science' || q.section_title === 'General Science') && (q.image_svg || q.image_url) && (
                          <div className="my-2 max-w-xs h-32 bg-slate-50 border border-slate-200 rounded p-2 flex items-center justify-center overflow-hidden">
                            {q.image_svg ? (
                              <div
                                className="w-full h-full flex items-center justify-center [&>svg]:max-h-full [&>svg]:max-w-full"
                                dangerouslySetInnerHTML={{ __html: q.image_svg }}
                              />
                            ) : (
                              <img src={q.image_url} alt="Figure" className="max-h-full max-w-full object-contain" />
                            )}
                          </div>
                        )}

                        <div className="grid grid-cols-1 sm:grid-cols-2 gap-2 text-xs">
                          {options.map((opt, oIdx) => {
                            const optLetter = String.fromCharCode(65 + oIdx);
                            const letterKey = String.fromCharCode(97 + oIdx);
                            const svgOpt = q.option_svgs ? q.option_svgs[letterKey] : null;

                            return (
                              <div
                                key={oIdx}
                                className="p-2 bg-white rounded border border-slate-200 text-slate-700 flex flex-col gap-1.5"
                              >
                                <div className="flex items-center gap-2">
                                  <span className="w-5 h-5 rounded-full bg-slate-100 border border-slate-300 flex items-center justify-center font-bold text-[10px] shrink-0">
                                    {optLetter}
                                  </span>
                                  {opt && (
                                    <div>
                                      <MathRenderer text={opt} />
                                    </div>
                                  )}
                                </div>
                                {svgOpt && (
                                  <div
                                    className="h-16 w-full flex items-center justify-center [&>svg]:max-h-full [&>svg]:max-w-full py-1 bg-slate-50 rounded"
                                    dangerouslySetInnerHTML={{ __html: svgOpt }}
                                  />
                                )}
                              </div>
                            );
                          })}
                        </div>
                      </div>
                    );
                  })}
                </div>
              </div>
            );
          })}
        </div>

        {/* Footer */}
        <div className="bg-slate-100 px-6 py-3 rounded-b-lg border-t border-slate-300 flex justify-end">
          <button
            onClick={onClose}
            className="px-5 py-1.5 text-xs font-semibold text-slate-700 bg-white border border-slate-300 rounded hover:bg-slate-50 transition"
          >
            Back to Exam
          </button>
        </div>

      </div>
    </div>
  );
}
