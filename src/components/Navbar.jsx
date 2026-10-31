import React from 'react';
import { User, LogOut, ShieldCheck, HelpCircle, FileText, Pause, Play } from 'lucide-react';

export default function Navbar({
  candidate,
  isTestMode = false,
  testTitle = "RRB Group D CBT Mock Test 01",
  onOpenInstructions,
  onOpenQuestionPaper,
  isPaused = false,
  onTogglePause,
  onLogout
}) {
  return (
    <header className="bg-[#30475e] text-white shadow-md border-b-2 border-amber-500 sticky top-0 z-40 select-none">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 py-2.5 flex items-center justify-between">
        
        {/* Brand / Logo */}
        <div className="flex items-center space-x-3">
          <div className="w-10 h-10 rounded-lg bg-gradient-to-br from-amber-500 to-amber-700 flex items-center justify-center shadow font-black text-xl text-white tracking-wider border border-amber-300">
            RRB
          </div>
          <div>
            <h1 className="font-bold text-base sm:text-lg leading-tight tracking-wide text-white flex items-center gap-1.5">
              RRB Mock Test
              <span className="text-[10px] bg-amber-500/90 text-slate-900 font-extrabold uppercase px-1.5 py-0.5 rounded tracking-wider">
                CBT Portal
              </span>
            </h1>
            <p className="text-xs text-slate-300 font-medium">
              {isTestMode ? testTitle : "Railway Recruitment Board Examination System"}
            </p>
          </div>
        </div>

        {/* In-Test Actions */}
        {isTestMode && (
          <div className="hidden md:flex items-center space-x-2">
            <button
              onClick={onOpenInstructions}
              className="flex items-center gap-1.5 px-3 py-1.5 bg-slate-700/80 hover:bg-slate-700 text-xs font-semibold rounded border border-slate-600 transition"
              title="View Exam Instructions"
            >
              <HelpCircle className="w-3.5 h-3.5 text-amber-400" />
              <span>Instructions</span>
            </button>
            <button
              onClick={onOpenQuestionPaper}
              className="flex items-center gap-1.5 px-3 py-1.5 bg-slate-700/80 hover:bg-slate-700 text-xs font-semibold rounded border border-slate-600 transition"
              title="View Complete Question Paper"
            >
              <FileText className="w-3.5 h-3.5 text-sky-400" />
              <span>Question Paper</span>
            </button>
            <button
              onClick={onTogglePause}
              className={`flex items-center gap-1.5 px-3 py-1.5 text-xs font-semibold rounded border transition ${
                isPaused
                  ? 'bg-emerald-600 hover:bg-emerald-700 text-white border-emerald-500'
                  : 'bg-amber-600 hover:bg-amber-700 text-white border-amber-500'
              }`}
              title={isPaused ? "Resume Test" : "Pause Test"}
            >
              {isPaused ? <Play className="w-3.5 h-3.5 fill-current" /> : <Pause className="w-3.5 h-3.5 fill-current" />}
              <span>{isPaused ? 'Resume' : 'Pause'}</span>
            </button>
          </div>
        )}

        {/* Candidate Profile / System Info (TCS iON Style) */}
        {candidate && (
          <div className="flex items-center space-x-3 bg-slate-800/80 px-3 py-1.5 rounded-md border border-slate-700">
            {/* Candidate photo / avatar */}
            <div className="relative">
              <div className="w-9 h-9 rounded bg-slate-600 flex items-center justify-center text-slate-200 border border-slate-500 overflow-hidden font-bold">
                {candidate.name ? candidate.name.charAt(0).toUpperCase() : <User className="w-5 h-5" />}
              </div>
              <span className="absolute -bottom-0.5 -right-0.5 w-2.5 h-2.5 bg-emerald-500 rounded-full border-2 border-[#30475e]"></span>
            </div>

            {/* Candidate Details */}
            <div className="text-left leading-tight hidden sm:block">
              <div className="font-semibold text-xs text-amber-400 flex items-center gap-1">
                <span>{candidate.name || 'Candidate'}</span>
                <ShieldCheck className="w-3.5 h-3.5 text-emerald-400" />
              </div>
              <div className="text-[11px] text-slate-300 font-mono">
                Roll: {candidate.roll_number || 'RRB268041'}
              </div>
              {isTestMode && (
                <div className="text-[10px] text-slate-400 font-mono">
                  System ID: <span className="text-sky-300 font-bold">C001</span>
                </div>
              )}
            </div>

            {/* Logout button (only if not inside test) */}
            {!isTestMode && onLogout && (
              <button
                onClick={onLogout}
                className="ml-2 p-1.5 hover:bg-slate-700 rounded text-slate-300 hover:text-red-400 transition"
                title="Log Out"
              >
                <LogOut className="w-4 h-4" />
              </button>
            )}
          </div>
        )}

      </div>
    </header>
  );
}

