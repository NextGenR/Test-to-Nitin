import React from 'react';
import { ArrowLeft, ArrowRight, RotateCcw, Bookmark, CheckSquare, BookOpen, CheckCircle, XCircle } from 'lucide-react';
import MathRenderer from './MathRenderer';

export default function QuestionPanel({
  question,
  questionNumber,
  totalQuestions,
  currentLang,
  onChangeLang,
  fontSize,
  onChangeFontSize,
  selectedOption,
  onSelectOption,
  onSaveAndNext,
  onSaveAndMarkReview,
  onMarkReviewAndNext,
  onClearResponse,
  onPreviousQuestion,
  isFirstQuestion,
  isLastQuestion,
  isReviewMode = false,
  onOpenScorecard = null,
  onExitReview = null
}) {
  if (!question) {
    return (
      <div className="flex-1 flex items-center justify-center p-8 text-slate-500">
        Loading question...
      </div>
    );
  }

  const questionText = currentLang === 'hi' && question.question_hi ? question.question_hi : question.question_en;
  const options = currentLang === 'hi' && question.options_hi ? question.options_hi : question.options_en;
  const explanationText = currentLang === 'hi' && question.explanation_hi ? question.explanation_hi : question.explanation_en;

  // Candidate choice details
  const userOptionLetter = selectedOption !== null && selectedOption !== undefined ? String.fromCharCode(65 + selectedOption) : null;
  const isCorrect = userOptionLetter === question.correct_option;
  const isAttempted = userOptionLetter !== null;

  // Completely suppress images for General Science (per requirement)
  const isScienceSection = question.part_number === 1 ||
    question.section === 'General Science' ||
    question.section_title === 'General Science' ||
    Number(questionNumber) <= 25 ||
    (question.id && Number(question.id) <= 25);

  // Language-specific diagram selection (Official TCS iON Dual-Language support)
  const activeSvg = isScienceSection ? null : (currentLang === 'hi' && question.image_svg_hi)
    ? question.image_svg_hi
    : (question.image_svg || question.question_image_svg);

  const activeImg = isScienceSection ? null : (currentLang === 'hi' && question.image_url_hi)
    ? question.image_url_hi
    : (question.image_url || question.question_image_url);

  // Font size multiplier
  const fontClass = fontSize === 'large' ? 'text-base sm:text-lg' : fontSize === 'small' ? 'text-xs' : 'text-sm';

  return (
    <div className="flex-1 flex flex-col h-full bg-white select-none">
      
      {/* Question Header Bar (TCS iON standard) */}
      <div className="bg-slate-100 border-b border-slate-300 px-4 py-2 flex flex-wrap items-center justify-between gap-2 text-xs">
        
        {/* Left: Question Number, Marks & Visual Figure Indicator */}
        <div className="flex items-center gap-3">
          <span className="font-bold text-slate-900 text-sm">
            Question No. {questionNumber}
          </span>

          {isReviewMode ? (
            <div className="flex items-center gap-2 pl-3 border-l border-slate-300">
              {!isAttempted ? (
                <span className="px-2 py-0.5 rounded-full text-[10px] font-bold bg-slate-200 text-slate-700">
                  Skipped (0.00)
                </span>
              ) : isCorrect ? (
                <span className="px-2 py-0.5 rounded-full text-[10px] font-bold bg-emerald-100 text-emerald-800 border border-emerald-300 flex items-center gap-1">
                  <CheckCircle className="w-3 h-3 text-emerald-600" /> Correct (+{question.positive_marks || 1.0})
                </span>
              ) : (
                <span className="px-2 py-0.5 rounded-full text-[10px] font-bold bg-red-100 text-red-800 border border-red-300 flex items-center gap-1">
                  <XCircle className="w-3 h-3 text-red-600" /> Wrong (-{question.negative_marks || 0.33})
                </span>
              )}
              <span className="text-[11px] font-bold text-emerald-800">
                Key: ({question.correct_option})
              </span>
            </div>
          ) : (
            <div className="flex items-center gap-2 text-[11px] text-slate-600 border-l border-slate-300 pl-3">
              <span className="text-emerald-700 font-semibold">Marks: +{question.positive_marks || 1.0}</span>
              <span className="text-slate-300">|</span>
              <span className="text-red-600 font-semibold">Negative: -{question.negative_marks || 0.33}</span>
            </div>
          )}

          {!isScienceSection && (activeSvg || activeImg || question.option_svgs || question.option_images) && (
            <span className="px-2 py-0.5 bg-blue-100 text-blue-800 font-bold text-[10px] rounded-full flex items-center gap-1 border border-blue-200">
              🖼 Visual Diagram
            </span>
          )}
        </div>

        {/* Right: Language Switcher and Font Size */}
        <div className="flex items-center gap-3">
          
          {/* Language selector */}
          <div className="flex items-center gap-1.5">
            <label className="text-[11px] font-semibold text-slate-600">View in:</label>
            <select
              value={currentLang}
              onChange={(e) => onChangeLang(e.target.value)}
              className="bg-white border border-slate-300 text-slate-800 text-xs rounded px-2 py-1 font-medium focus:outline-none focus:ring-1 focus:ring-blue-500"
            >
              <option value="en">English</option>
              <option value="hi">हिंदी (Hindi)</option>
            </select>
          </div>

          {/* Font Resizer */}
          <div className="flex items-center border border-slate-300 rounded overflow-hidden bg-white">
            <button
              onClick={() => onChangeFontSize('small')}
              className={`px-2 py-0.5 text-xs font-bold transition ${
                fontSize === 'small' ? 'bg-blue-600 text-white' : 'text-slate-600 hover:bg-slate-100'
              }`}
              title="Decrease Font Size"
            >
              A-
            </button>
            <button
              onClick={() => onChangeFontSize('normal')}
              className={`px-2 py-0.5 text-xs font-bold border-x border-slate-300 transition ${
                fontSize === 'normal' ? 'bg-blue-600 text-white' : 'text-slate-600 hover:bg-slate-100'
              }`}
              title="Normal Font Size"
            >
              A
            </button>
            <button
              onClick={() => onChangeFontSize('large')}
              className={`px-2 py-0.5 text-xs font-bold transition ${
                fontSize === 'large' ? 'bg-blue-600 text-white' : 'text-slate-600 hover:bg-slate-100'
              }`}
              title="Increase Font Size"
            >
              A+
            </button>
          </div>

        </div>

      </div>

      {/* Question Content Body */}
      <div className="flex-1 p-5 sm:p-6 overflow-y-auto">
        
        {/* Question Statement */}
        <div className={`text-slate-900 font-medium leading-relaxed mb-6 ${fontClass}`}>
          <div className="whitespace-pre-line">
            <MathRenderer text={questionText} />
          </div>
        </div>

        {/* Question Diagram / Figure Container (Clean Testbook Cyan Style) */}
        {(activeSvg || activeImg) && (
          <div className="mb-6 flex justify-start sm:justify-center">
            <div
              onContextMenu={(e) => e.preventDefault()}
              onDragStart={(e) => e.preventDefault()}
              className="w-full max-w-sm sm:max-w-md md:max-w-lg min-h-[190px] h-52 sm:h-64 bg-white border-2 border-[#00a8b5] rounded-xl p-3 sm:p-4 flex items-center justify-center shadow-xs overflow-hidden select-none"
            >
              {activeSvg ? (
                <div
                  className="w-full h-full flex items-center justify-center [&>svg]:w-full [&>svg]:h-full [&>svg]:max-h-full [&>svg]:max-w-full [&>svg]:object-contain pointer-events-none select-none"
                  dangerouslySetInnerHTML={{ __html: activeSvg }}
                />
              ) : (
                <img
                  src={activeImg}
                  alt="Question Diagram"
                  draggable={false}
                  onContextMenu={(e) => e.preventDefault()}
                  className="w-full h-full max-h-[220px] max-w-full object-contain pointer-events-none select-none"
                  loading="lazy"
                />
              )}
            </div>
          </div>
        )}

        {/* Visual Option Cards (Exact Testbook Style from Pictures 1 & 4) */}
        {!isScienceSection && (question.option_svgs || question.option_images) ? (
          <div className="space-y-3 max-w-3xl">
            {options.map((optText, oIdx) => {
              const optionNumber = oIdx + 1;
              const letterKey = String.fromCharCode(97 + oIdx); // 'a', 'b', 'c', 'd'
              const letter = String.fromCharCode(65 + oIdx); // 'A', 'B', 'C', 'D'
              const svgContent = question.option_svgs ? question.option_svgs[letterKey] : null;
              const imgUrl = question.option_images ? question.option_images[letterKey] : null;

              const isSelected = selectedOption === oIdx;
              const isThisCorrect = letter === question.correct_option;
              const isThisUser = letter === userOptionLetter;

              let cardStyle = 'border-slate-200 bg-white hover:border-slate-300 hover:bg-slate-50/80 shadow-2xs';
              if (isReviewMode) {
                if (isThisCorrect) {
                  cardStyle = 'border-emerald-500 bg-emerald-50/80 shadow-sm ring-1 ring-emerald-500';
                } else if (isThisUser) {
                  cardStyle = 'border-red-400 bg-red-50/80 shadow-sm ring-1 ring-red-400';
                } else {
                  cardStyle = 'border-slate-200 bg-white opacity-85';
                }
              } else if (isSelected) {
                cardStyle = 'border-cyan-600 bg-cyan-50/60 shadow-sm ring-1 ring-cyan-500';
              }

              return (
                <div
                  key={oIdx}
                  onClick={() => !isReviewMode && onSelectOption(oIdx)}
                  className={`flex items-center justify-between gap-4 p-3 rounded-xl border-2 transition select-none ${cardStyle} ${
                    isReviewMode ? 'cursor-default' : 'cursor-pointer'
                  }`}
                >
                  <div className="flex items-center gap-4">
                    {/* Option Circular Number Badge: 1, 2, 3, 4 */}
                    <div className={`w-7 h-7 rounded-full border-2 flex items-center justify-center font-bold text-xs shrink-0 transition ${
                      isReviewMode && isThisCorrect
                        ? 'border-emerald-600 bg-emerald-600 text-white'
                        : isReviewMode && isThisUser
                        ? 'border-red-600 bg-red-600 text-white'
                        : isSelected
                        ? 'border-cyan-600 bg-cyan-600 text-white shadow-xs'
                        : 'border-slate-300 bg-white text-slate-600'
                    }`}>
                      {optionNumber}
                    </div>

                    {/* Square Cyan Diagram Frame */}
                    <div className="w-20 h-20 sm:w-24 sm:h-24 bg-white rounded-md p-1 flex items-center justify-center shrink-0">
                      {svgContent ? (
                        <div
                          className="w-full h-full flex items-center justify-center [&>svg]:w-full [&>svg]:h-full"
                          dangerouslySetInnerHTML={{ __html: svgContent }}
                        />
                      ) : imgUrl ? (
                        <img src={imgUrl} alt={`Option ${optionNumber}`} className="max-h-full max-w-full object-contain" />
                      ) : null}
                    </div>

                    {/* Optional Text Label beside figure */}
                    {optText && (
                      <div className="text-slate-800 text-sm font-semibold pl-2">
                        <MathRenderer text={optText} />
                      </div>
                    )}
                  </div>

                  {/* Review Mode Badges */}
                  {isReviewMode && (
                    <div className="shrink-0 pr-2">
                      {isThisCorrect && (
                        <span className="px-2.5 py-1 bg-emerald-600 text-white font-black text-[10px] rounded uppercase tracking-wider flex items-center gap-1 shadow-xs">
                          <CheckCircle className="w-3 h-3" /> Correct Answer
                        </span>
                      )}
                      {!isThisCorrect && isThisUser && (
                        <span className="px-2.5 py-1 bg-red-600 text-white font-black text-[10px] rounded uppercase tracking-wider flex items-center gap-1 shadow-xs">
                          <XCircle className="w-3 h-3" /> Your Choice
                        </span>
                      )}
                    </div>
                  )}
                </div>
              );
            })}
          </div>
        ) : (
          <div className="space-y-3 max-w-3xl">
            {options.map((optText, oIdx) => {
              const optionLetter = String.fromCharCode(65 + oIdx);
              const isSelected = selectedOption === oIdx;
              const isThisCorrect = optionLetter === question.correct_option;
              const isThisUser = optionLetter === userOptionLetter;

              let cardStyle = 'border-slate-200 bg-white hover:bg-slate-50';
              if (isReviewMode) {
                if (isThisCorrect) {
                  cardStyle = 'border-emerald-500 bg-emerald-50/80 shadow-xs ring-1 ring-emerald-500';
                } else if (isThisUser) {
                  cardStyle = 'border-red-400 bg-red-50/80 shadow-xs ring-1 ring-red-400';
                } else {
                  cardStyle = 'border-slate-200 bg-white opacity-80';
                }
              } else if (isSelected) {
                cardStyle = 'border-blue-600 bg-blue-50/70 shadow-sm ring-1 ring-blue-600';
              }

              return (
                <div
                  key={oIdx}
                  onClick={() => !isReviewMode && onSelectOption(oIdx)}
                  className={`flex items-start justify-between gap-3.5 p-3.5 rounded-lg border transition select-none ${cardStyle} ${
                    isReviewMode ? 'cursor-default' : 'cursor-pointer'
                  }`}
                >
                  <div className="flex items-start gap-3.5 flex-1">
                    {/* Radio Button / Status Icon */}
                    <div className="mt-0.5 shrink-0">
                      {isReviewMode ? (
                        isThisCorrect ? (
                          <div className="w-5 h-5 rounded-full bg-emerald-600 text-white flex items-center justify-center">
                            <CheckCircle className="w-3.5 h-3.5" />
                          </div>
                        ) : isThisUser ? (
                          <div className="w-5 h-5 rounded-full bg-red-600 text-white flex items-center justify-center">
                            <XCircle className="w-3.5 h-3.5" />
                          </div>
                        ) : (
                          <div className="w-5 h-5 rounded-full border border-slate-300 bg-white"></div>
                        )
                      ) : (
                        <div className={`w-5 h-5 rounded-full border flex items-center justify-center ${
                          isSelected ? 'border-blue-600 bg-blue-600' : 'border-slate-400 bg-white'
                        }`}>
                          {isSelected && <div className="w-2 h-2 rounded-full bg-white"></div>}
                        </div>
                      )}
                    </div>

                    {/* Option Letter Badge & Text */}
                    <div className={`flex-1 text-slate-800 ${fontClass}`}>
                      <span className="font-bold text-slate-900 mr-2">({optionLetter})</span>
                      <MathRenderer text={optText} />
                    </div>
                  </div>

                  {/* Review Mode Badges */}
                  {isReviewMode && (
                    <div className="shrink-0 pl-2">
                      {isThisCorrect && (
                        <span className="px-2 py-0.5 bg-emerald-600 text-white font-black text-[10px] rounded uppercase tracking-wider">
                          Correct
                        </span>
                      )}
                      {!isThisCorrect && isThisUser && (
                        <span className="px-2 py-0.5 bg-red-600 text-white font-black text-[10px] rounded uppercase tracking-wider">
                          Your Choice
                        </span>
                      )}
                    </div>
                  )}
                </div>
              );
            })}
          </div>
        )}

        {/* Official Solution & Detailed Explanation (Review Mode) */}
        {isReviewMode && (
          <div className="mt-6 max-w-3xl p-4 sm:p-5 rounded-xl border border-blue-200 bg-gradient-to-r from-blue-50/80 to-indigo-50/60 shadow-xs">
            <div className="flex items-center gap-2 font-black text-blue-900 uppercase tracking-wide text-xs mb-2">
              <BookOpen className="w-4 h-4 text-blue-700" />
              <span>Official Solution & Step-by-Step Explanation</span>
            </div>
            <div className="text-slate-800 text-xs sm:text-sm leading-relaxed whitespace-pre-line font-medium">
              <MathRenderer text={explanationText || 'Step-by-step solution calculation: Correct Answer is Option (' + question.correct_option + ').'} />
            </div>
          </div>
        )}

      </div>

      {/* TCS iON Bottom Action Buttons Toolbar */}
      <div className="bg-slate-100 border-t border-slate-300 p-3 flex flex-wrap items-center justify-between gap-2 text-xs">
        {isReviewMode ? (
          <>
            <div className="flex items-center gap-2">
              {onOpenScorecard && (
                <button
                  onClick={onOpenScorecard}
                  className="px-3.5 py-2 font-bold rounded border border-slate-300 bg-white hover:bg-slate-50 text-slate-700 shadow-sm transition active:scale-95"
                >
                  View Scorecard
                </button>
              )}
              {onExitReview && (
                <button
                  onClick={onExitReview}
                  className="px-3.5 py-2 font-bold rounded border border-slate-300 bg-slate-200 hover:bg-slate-300 text-slate-800 transition active:scale-95"
                >
                  Exit Review
                </button>
              )}
            </div>

            <div className="flex items-center gap-2">
              <button
                onClick={onPreviousQuestion}
                disabled={isFirstQuestion}
                className={`flex items-center gap-1 px-4 py-2 font-bold rounded border transition ${
                  !isFirstQuestion
                    ? 'bg-white hover:bg-slate-50 text-slate-700 border-slate-300 shadow-sm'
                    : 'bg-slate-200 text-slate-400 border-slate-300 cursor-not-allowed'
                }`}
              >
                <ArrowLeft className="w-3.5 h-3.5" />
                <span>Previous</span>
              </button>

              <button
                onClick={onSaveAndNext}
                disabled={isLastQuestion}
                className={`flex items-center gap-1.5 px-5 py-2 font-bold rounded shadow transition active:scale-95 ${
                  !isLastQuestion
                    ? 'bg-[#1d638a] hover:bg-[#164e6d] text-white'
                    : 'bg-slate-300 text-slate-500 cursor-not-allowed'
                }`}
              >
                <span>Next Question</span>
                <ArrowRight className="w-3.5 h-3.5" />
              </button>
            </div>
          </>
        ) : (
          <>
            {/* Left Side Actions */}
            <div className="flex flex-wrap items-center gap-2">
              
              <button
                onClick={onMarkReviewAndNext}
                className="flex items-center gap-1.5 px-3 py-2 bg-purple-700 hover:bg-purple-800 text-white font-semibold rounded shadow-sm transition active:scale-95"
                title="Mark for Review & Next"
              >
                <Bookmark className="w-3.5 h-3.5" />
                <span>Mark for Review & Next</span>
              </button>

              <button
                onClick={onClearResponse}
                disabled={selectedOption === undefined || selectedOption === null}
                className={`flex items-center gap-1.5 px-3 py-2 font-semibold rounded border transition active:scale-95 ${
                  selectedOption !== undefined && selectedOption !== null
                    ? 'bg-white hover:bg-slate-50 text-slate-700 border-slate-300 shadow-sm'
                    : 'bg-slate-200 text-slate-400 border-slate-300 cursor-not-allowed'
                }`}
                title="Clear Chosen Response"
              >
                <RotateCcw className="w-3.5 h-3.5" />
                <span>Clear Response</span>
              </button>

            </div>

            {/* Right Side Actions */}
            <div className="flex flex-wrap items-center gap-2">
              
              <button
                onClick={onPreviousQuestion}
                disabled={isFirstQuestion}
                className={`flex items-center gap-1 px-3 py-2 font-semibold rounded border transition ${
                  !isFirstQuestion
                    ? 'bg-white hover:bg-slate-50 text-slate-700 border-slate-300 shadow-sm'
                    : 'bg-slate-200 text-slate-400 border-slate-300 cursor-not-allowed'
                }`}
              >
                <ArrowLeft className="w-3.5 h-3.5" />
                <span>Previous</span>
              </button>

              <button
                onClick={onSaveAndMarkReview}
                className="flex items-center gap-1.5 px-3 py-2 bg-amber-600 hover:bg-amber-700 text-white font-semibold rounded shadow-sm transition active:scale-95"
                title="Save answer and mark for review"
              >
                <CheckSquare className="w-3.5 h-3.5" />
                <span>Save & Mark for Review</span>
              </button>

              <button
                onClick={onSaveAndNext}
                className="flex items-center gap-1.5 px-4 py-2 bg-emerald-600 hover:bg-emerald-700 text-white font-bold rounded shadow transition active:scale-95"
                title="Save answer and go to next question"
              >
                <span>Save & Next</span>
                <ArrowRight className="w-3.5 h-3.5" />
              </button>

            </div>
          </>
        )}

      </div>

    </div>
  );
}
