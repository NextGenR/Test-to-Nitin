import React from 'react';
import { ArrowLeft, ArrowRight, RotateCcw, Bookmark, CheckSquare } from 'lucide-react';
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
  isLastQuestion
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

  // Font size multiplier
  const fontClass = fontSize === 'large' ? 'text-base sm:text-lg' : fontSize === 'small' ? 'text-xs' : 'text-sm';

  return (
    <div className="flex-1 flex flex-col h-full bg-white select-none">
      
      {/* Question Header Bar (TCS iON standard) */}
      <div className="bg-slate-100 border-b border-slate-300 px-4 py-2 flex flex-wrap items-center justify-between gap-2 text-xs">
        
        {/* Left: Question Number and Marks */}
        <div className="flex items-center gap-3">
          <span className="font-bold text-slate-900 text-sm">
            Question No. {questionNumber}
          </span>
          <div className="flex items-center gap-2 text-[11px] text-slate-600 border-l border-slate-300 pl-3">
            <span className="text-emerald-700 font-semibold">Marks: +{question.positive_marks || 1.0}</span>
            <span className="text-slate-300">|</span>
            <span className="text-red-600 font-semibold">Negative: -{question.negative_marks || 0.33}</span>
          </div>
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

        {/* Question Diagram / Figure Container (Fixed Height 220px-260px) */}
        {(question.image_svg || question.image_url) && (
          <div className="mb-6 flex justify-center">
            <div className="w-full max-w-md h-[220px] sm:h-[250px] bg-slate-50 border border-slate-300 rounded-xl p-3 flex items-center justify-center shadow-xs overflow-hidden select-none">
              {question.image_svg ? (
                <div
                  className="w-full h-full flex items-center justify-center [&>svg]:max-h-full [&>svg]:max-w-full [&>svg]:h-auto [&>svg]:w-auto"
                  dangerouslySetInnerHTML={{ __html: question.image_svg }}
                />
              ) : (
                <img
                  src={question.image_url}
                  alt="Question Diagram"
                  className="max-h-full max-w-full object-contain"
                  loading="lazy"
                />
              )}
            </div>
          </div>
        )}

        {/* Visual 2x2 Grid or Standard 1-Column Options */}
        {question.option_svgs || question.option_images ? (
          <div className="grid grid-cols-1 sm:grid-cols-2 gap-3.5 max-w-3xl">
            {options.map((optText, oIdx) => {
              const isSelected = selectedOption === oIdx;
              const optionLetter = String.fromCharCode(65 + oIdx);
              const letterKey = String.fromCharCode(97 + oIdx); // 'a', 'b', 'c', 'd'
              const svgContent = question.option_svgs ? question.option_svgs[letterKey] : null;
              const imgUrl = question.option_images ? question.option_images[letterKey] : null;

              return (
                <label
                  key={oIdx}
                  onClick={() => onSelectOption(oIdx)}
                  className={`flex flex-col p-3 rounded-xl border-2 cursor-pointer transition select-none ${
                    isSelected
                      ? 'border-blue-600 bg-blue-50/80 shadow-md ring-1 ring-blue-500'
                      : 'border-slate-200 bg-white hover:bg-slate-50 hover:border-slate-300'
                  }`}
                >
                  <div className="flex items-center justify-between mb-2">
                    <div className="flex items-center gap-2">
                      <div className={`w-5 h-5 rounded-full border flex items-center justify-center ${
                        isSelected ? 'border-blue-600 bg-blue-600' : 'border-slate-400 bg-white'
                      }`}>
                        {isSelected && <div className="w-2 h-2 rounded-full bg-white"></div>}
                      </div>
                      <span className="font-extrabold text-slate-900 text-sm">
                        ({optionLetter})
                      </span>
                    </div>
                    {optText && (
                      <span className="text-xs text-slate-600 font-medium truncate max-w-[160px]">
                        <MathRenderer text={optText} />
                      </span>
                    )}
                  </div>

                  {/* SVG / Image Figure */}
                  <div className="h-28 w-full bg-slate-50 border border-slate-200 rounded-lg p-2 flex items-center justify-center overflow-hidden">
                    {svgContent ? (
                      <div
                        className="w-full h-full flex items-center justify-center [&>svg]:max-h-full [&>svg]:max-w-full"
                        dangerouslySetInnerHTML={{ __html: svgContent }}
                      />
                    ) : imgUrl ? (
                      <img src={imgUrl} alt={`Option ${optionLetter}`} className="max-h-full max-w-full object-contain" />
                    ) : null}
                  </div>
                </label>
              );
            })}
          </div>
        ) : (
          <div className="space-y-3 max-w-3xl">
            {options.map((optText, oIdx) => {
              const isSelected = selectedOption === oIdx;
              const optionLetter = String.fromCharCode(65 + oIdx);

              return (
                <label
                  key={oIdx}
                  onClick={() => onSelectOption(oIdx)}
                  className={`flex items-start gap-3.5 p-3.5 rounded-lg border cursor-pointer transition select-none ${
                    isSelected
                      ? 'border-blue-600 bg-blue-50/70 shadow-sm ring-1 ring-blue-600'
                      : 'border-slate-200 bg-white hover:bg-slate-50'
                  }`}
                >
                  {/* Radio Button */}
                  <div className="mt-0.5 shrink-0">
                    <div className={`w-5 h-5 rounded-full border flex items-center justify-center ${
                      isSelected ? 'border-blue-600 bg-blue-600' : 'border-slate-400 bg-white'
                    }`}>
                      {isSelected && <div className="w-2 h-2 rounded-full bg-white"></div>}
                    </div>
                  </div>

                  {/* Option Letter Badge & Text */}
                  <div className={`flex-1 text-slate-800 ${fontClass}`}>
                    <span className="font-bold text-slate-900 mr-2">({optionLetter})</span>
                    <MathRenderer text={optText} />
                  </div>
                </label>
              );
            })}
          </div>
        )}

      </div>

      {/* TCS iON Bottom Action Buttons Toolbar */}
      <div className="bg-slate-100 border-t border-slate-300 p-3 flex flex-wrap items-center justify-between gap-2 text-xs">
        
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

      </div>

    </div>
  );
}
