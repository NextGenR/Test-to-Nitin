import React from 'react';
import { Play, PauseCircle, Clock, CheckCircle } from 'lucide-react';

export default function PauseModal({
  isOpen,
  onResume,
  remainingSeconds,
  answeredCount,
  totalQuestions = 100
}) {
  if (!isOpen) return null;

  const minutes = Math.floor(remainingSeconds / 60);
  const seconds = remainingSeconds % 60;
  const formattedTime = `${String(minutes).padStart(2, '0')}:${String(seconds).padStart(2, '0')}`;

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center bg-slate-900/80 backdrop-blur-md p-4">
      <div className="bg-white rounded-xl shadow-2xl max-w-md w-full border border-slate-300 p-6 text-center animate-in zoom-in-95 duration-150">
        
        <div className="w-16 h-16 bg-amber-100 text-amber-600 rounded-full flex items-center justify-center mx-auto mb-4 border-2 border-amber-300 shadow-inner">
          <PauseCircle className="w-9 h-9" />
        </div>

        <h3 className="font-bold text-xl text-slate-800 mb-1">
          Exam Paused
        </h3>
        <p className="text-xs text-slate-500 mb-6">
          Your answers and timer are frozen and safely synchronized.
        </p>

        {/* Stats Grid */}
        <div className="grid grid-cols-2 gap-3 mb-6">
          <div className="p-3 bg-slate-50 rounded-lg border border-slate-200">
            <div className="flex items-center justify-center gap-1.5 text-xs text-slate-500 mb-1">
              <Clock className="w-3.5 h-3.5 text-blue-500" />
              <span>Time Left</span>
            </div>
            <div className="font-mono font-bold text-lg text-slate-800">
              {formattedTime}
            </div>
          </div>

          <div className="p-3 bg-slate-50 rounded-lg border border-slate-200">
            <div className="flex items-center justify-center gap-1.5 text-xs text-slate-500 mb-1">
              <CheckCircle className="w-3.5 h-3.5 text-emerald-500" />
              <span>Answered</span>
            </div>
            <div className="font-mono font-bold text-lg text-slate-800">
              {answeredCount} / {totalQuestions}
            </div>
          </div>
        </div>

        <button
          onClick={onResume}
          className="w-full py-3 bg-gradient-to-r from-emerald-600 to-teal-600 hover:from-emerald-700 hover:to-teal-700 text-white font-bold text-sm uppercase tracking-wider rounded-lg shadow-lg flex items-center justify-center gap-2 transition transform active:scale-95"
        >
          <Play className="w-4 h-4 fill-current" />
          <span>Resume Examination</span>
        </button>

      </div>
    </div>
  );
}
