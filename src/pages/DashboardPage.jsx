import React, { useState, useEffect } from 'react';
import Navbar from '../components/Navbar';
import InstructionsModal from '../components/InstructionsModal';
import { Play, RotateCcw, Clock, Award, BookOpen, CheckCircle, BarChart3, AlertCircle, FileCheck2, Sparkles } from 'lucide-react';
import { getTestAttempt } from '../services/apiService';

export default function DashboardPage({
  candidate,
  onStartExam,
  onResumeExam,
  onLogout
}) {
  const [activeTab, setActiveTab] = useState('rrb-series');
  const [savedAttempt, setSavedAttempt] = useState(null);
  const [showInstructions, setShowInstructions] = useState(false);
  const [defaultLang, setDefaultLang] = useState('en');

  // Check if candidate has an existing paused or completed attempt
  useEffect(() => {
    if (candidate?.mobile_number) {
      getTestAttempt(candidate.mobile_number, 'rrb_cbt_mock_1').then((attempt) => {
        if (attempt) {
          setSavedAttempt(attempt);
        }
      });
    }
  }, [candidate]);

  const handleStartClick = () => {
    setShowInstructions(true);
  };

  const handleInstructionsProceed = () => {
    setShowInstructions(false);
    onStartExam({ defaultLang });
  };

  const handleResumeClick = () => {
    onResumeExam(savedAttempt);
  };

  const isPaused = savedAttempt && savedAttempt.status === 'paused';
  const isCompleted = savedAttempt && savedAttempt.status === 'completed';

  return (
    <div className="min-h-screen bg-[#f1f5f9] flex flex-col text-slate-800">
      
      {/* Top Navbar */}
      <Navbar candidate={candidate} onLogout={onLogout} />

      {/* Main Container */}
      <main className="max-w-7xl mx-auto w-full px-4 sm:px-6 py-6 sm:py-8 flex-1 space-y-6">
        
        {/* Candidate Welcome Banner */}
        <div className="bg-gradient-to-r from-[#1d638a] via-[#285375] to-[#30475e] rounded-2xl p-6 sm:p-8 text-white shadow-lg relative overflow-hidden">
          <div className="absolute right-0 top-0 bottom-0 opacity-10 pointer-events-none flex items-center pr-10 font-black text-9xl text-white select-none">
            RRB
          </div>
          <div className="relative z-10 max-w-2xl">
            <span className="inline-block px-3 py-1 bg-amber-500/90 text-slate-900 text-xs font-black uppercase rounded-full tracking-wider mb-3">
              Official CBT Exam Portal
            </span>
            <h2 className="text-2xl sm:text-3xl font-extrabold tracking-tight mb-2">
              Welcome back, {candidate?.name || 'Candidate'}!
            </h2>
            <p className="text-sm text-slate-200 leading-relaxed">
              Your registered mobile <span className="font-mono text-amber-300 font-bold">{candidate?.mobile_number}</span> is connected to the examination portal. Access your assigned mock test series below with authentic TCS iON CBT simulation.
            </p>
          </div>
        </div>

        {/* Quick Exam Overview Cards */}
        <div className="grid grid-cols-2 lg:grid-cols-4 gap-4">
          <div className="bg-white p-4 rounded-xl border border-slate-200 shadow-sm flex items-center gap-3">
            <div className="w-10 h-10 rounded-lg bg-blue-100 text-blue-600 flex items-center justify-center">
              <BookOpen className="w-5 h-5" />
            </div>
            <div>
              <div className="text-xs text-slate-500 font-medium">Test Series</div>
              <div className="text-lg font-bold text-slate-900">RRB Group D</div>
            </div>
          </div>

          <div className="bg-white p-4 rounded-xl border border-slate-200 shadow-sm flex items-center gap-3">
            <div className="w-10 h-10 rounded-lg bg-emerald-100 text-emerald-600 flex items-center justify-center">
              <Clock className="w-5 h-5" />
            </div>
            <div>
              <div className="text-xs text-slate-500 font-medium">Total Duration</div>
              <div className="text-lg font-bold text-slate-900">90 Minutes</div>
            </div>
          </div>

          <div className="bg-white p-4 rounded-xl border border-slate-200 shadow-sm flex items-center gap-3">
            <div className="w-10 h-10 rounded-lg bg-purple-100 text-purple-600 flex items-center justify-center">
              <BarChart3 className="w-5 h-5" />
            </div>
            <div>
              <div className="text-xs text-slate-500 font-medium">Questions & Marks</div>
              <div className="text-lg font-bold text-slate-900">100 Qs / 100 M</div>
            </div>
          </div>

          <div className="bg-white p-4 rounded-xl border border-slate-200 shadow-sm flex items-center gap-3">
            <div className="w-10 h-10 rounded-lg bg-amber-100 text-amber-600 flex items-center justify-center">
              <Award className="w-5 h-5" />
            </div>
            <div>
              <div className="text-xs text-slate-500 font-medium">Cut-off Target</div>
              <div className="text-lg font-bold text-slate-900">40% Qualifying</div>
            </div>
          </div>
        </div>

        {/* Test Series Navigation Bar */}
        <div className="border-b border-slate-300">
          <div className="flex space-x-6">
            <button
              onClick={() => setActiveTab('rrb-series')}
              className={`pb-3 font-bold text-sm tracking-wide transition border-b-2 ${
                activeTab === 'rrb-series'
                  ? 'border-blue-600 text-blue-600'
                  : 'border-transparent text-slate-500 hover:text-slate-800'
              }`}
            >
              Test Series : RRB Mock Test
            </button>
            <button
              onClick={() => setActiveTab('history')}
              className={`pb-3 font-bold text-sm tracking-wide transition border-b-2 ${
                activeTab === 'history'
                  ? 'border-blue-600 text-blue-600'
                  : 'border-transparent text-slate-500 hover:text-slate-800'
              }`}
            >
              My Attempt History & Scorecard
            </button>
          </div>
        </div>

        {/* Tab 1: Test Series Section */}
        {activeTab === 'rrb-series' && (
          <div className="space-y-6">
            
            {/* Active Mock Test Card */}
            <div className="bg-white rounded-2xl border-2 border-blue-500 shadow-md p-6 sm:p-7 relative transition hover:shadow-lg">
              
              <div className="flex flex-wrap items-start justify-between gap-4 mb-4">
                <div>
                  <div className="flex items-center gap-2 mb-1.5">
                    <span className="px-2.5 py-0.5 bg-blue-100 text-blue-800 font-bold text-[11px] rounded-full uppercase tracking-wider">
                      Live Full-Length CBT
                    </span>
                    <span className="px-2.5 py-0.5 bg-emerald-100 text-emerald-800 font-bold text-[11px] rounded-full uppercase tracking-wider">
                      Bilingual (English + हिंदी)
                    </span>
                    {isPaused && (
                      <span className="px-2.5 py-0.5 bg-amber-500 text-slate-900 font-black text-[11px] rounded-full animate-pulse uppercase tracking-wider">
                        Exam Paused - In Progress
                      </span>
                    )}
                    {isCompleted && (
                      <span className="px-2.5 py-0.5 bg-purple-100 text-purple-800 font-bold text-[11px] rounded-full uppercase tracking-wider">
                        Completed (Score: {savedAttempt.score?.toFixed(2)})
                      </span>
                    )}
                  </div>
                  <h3 className="text-xl sm:text-2xl font-black text-slate-900">
                    RRB Group D CBT Mock Test 01
                  </h3>
                  <p className="text-xs text-slate-600 mt-1">
                    Based on standard Railway Recruitment Board pattern with official TCS iON CBT software interface.
                  </p>
                </div>

                {/* Start / Resume Action Button */}
                <div className="flex items-center gap-3">
                  {isPaused ? (
                    <button
                      onClick={handleResumeClick}
                      className="flex items-center gap-2 px-6 py-3 bg-gradient-to-r from-emerald-600 to-teal-600 hover:from-emerald-700 hover:to-teal-700 text-white font-bold text-sm uppercase tracking-wider rounded-xl shadow-md transition transform active:scale-95"
                    >
                      <Play className="w-4 h-4 fill-current" />
                      <span>Resume Test</span>
                    </button>
                  ) : (
                    <button
                      onClick={handleStartClick}
                      className="flex items-center gap-2 px-6 py-3 bg-gradient-to-r from-blue-600 to-indigo-700 hover:from-blue-700 hover:to-indigo-800 text-white font-bold text-sm uppercase tracking-wider rounded-xl shadow-md transition transform active:scale-95"
                    >
                      <Play className="w-4 h-4 fill-current" />
                      <span>{isCompleted ? "Re-Take Test" : "Start Mock Test"}</span>
                    </button>
                  )}
                </div>
              </div>

              {/* Sections Breakdown Grid */}
              <div className="grid grid-cols-2 sm:grid-cols-4 gap-3 pt-4 border-t border-slate-200 text-xs">
                <div className="p-2.5 bg-slate-50 rounded-lg border border-slate-200">
                  <span className="text-slate-500 block text-[11px]">Section 1</span>
                  <strong className="text-slate-800 text-xs">General Science</strong>
                  <div className="text-slate-600 font-mono text-[11px] mt-0.5">25 Qs &bull; 25 Marks</div>
                </div>

                <div className="p-2.5 bg-slate-50 rounded-lg border border-slate-200">
                  <span className="text-slate-500 block text-[11px]">Section 2</span>
                  <strong className="text-slate-800 text-xs">Mathematics</strong>
                  <div className="text-slate-600 font-mono text-[11px] mt-0.5">25 Qs &bull; 25 Marks</div>
                </div>

                <div className="p-2.5 bg-slate-50 rounded-lg border border-slate-200">
                  <span className="text-slate-500 block text-[11px]">Section 3</span>
                  <strong className="text-slate-800 text-xs">Reasoning</strong>
                  <div className="text-slate-600 font-mono text-[11px] mt-0.5">30 Qs &bull; 30 Marks</div>
                </div>

                <div className="p-2.5 bg-slate-50 rounded-lg border border-slate-200">
                  <span className="text-slate-500 block text-[11px]">Section 4</span>
                  <strong className="text-slate-800 text-xs">General Awareness</strong>
                  <div className="text-slate-600 font-mono text-[11px] mt-0.5">20 Qs &bull; 20 Marks</div>
                </div>
              </div>

              {/* Exam Rules Pill Footer */}
              <div className="mt-4 flex flex-wrap items-center gap-4 text-xs text-slate-500 pt-2 border-t border-slate-100">
                <span className="flex items-center gap-1">
                  <Clock className="w-3.5 h-3.5 text-blue-500" /> 90 Mins Total Duration
                </span>
                <span className="flex items-center gap-1">
                  <CheckCircle className="w-3.5 h-3.5 text-emerald-500" /> +1.0 for Correct Answer
                </span>
                <span className="flex items-center gap-1">
                  <AlertCircle className="w-3.5 h-3.5 text-red-500" /> -0.33 (1/3rd) Negative Marking
                </span>
                <span className="flex items-center gap-1">
                  <Sparkles className="w-3.5 h-3.5 text-purple-500" /> Live Database Sync & Session Recovery
                </span>
              </div>

            </div>

            {/* Upcoming Tests in the RRB Series */}
            <div className="space-y-3">
              <h4 className="font-bold text-slate-800 text-sm">
                More Tests in RRB Mock Test Series:
              </h4>

              <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                <div className="bg-white p-5 rounded-xl border border-slate-200 shadow-sm opacity-90">
                  <div className="flex items-center justify-between mb-2">
                    <span className="px-2 py-0.5 bg-slate-100 text-slate-600 font-bold text-[10px] rounded uppercase">
                      Upcoming
                    </span>
                    <span className="text-xs text-slate-500 font-medium">Full Syllabus</span>
                  </div>
                  <h5 className="font-bold text-slate-900 text-base">
                    RRB Group D CBT Mock Test 02
                  </h5>
                  <p className="text-xs text-slate-500 mt-1 mb-3">
                    High-yield practice test with latest current affairs and numerical reasoning questions.
                  </p>
                  <button
                    disabled
                    className="px-4 py-1.5 bg-slate-100 text-slate-400 font-bold text-xs rounded border border-slate-200 cursor-not-allowed"
                  >
                    Unlocks Soon
                  </button>
                </div>

                <div className="bg-white p-5 rounded-xl border border-slate-200 shadow-sm opacity-90">
                  <div className="flex items-center justify-between mb-2">
                    <span className="px-2 py-0.5 bg-slate-100 text-slate-600 font-bold text-[10px] rounded uppercase">
                      Upcoming
                    </span>
                    <span className="text-xs text-slate-500 font-medium">Stage 1 CBT</span>
                  </div>
                  <h5 className="font-bold text-slate-900 text-base">
                    RRB NTPC CBT-1 Mock Test 01
                  </h5>
                  <p className="text-xs text-slate-500 mt-1 mb-3">
                    Full-length exam simulation for Non-Technical Popular Categories (Graduate & Under-graduate).
                  </p>
                  <button
                    disabled
                    className="px-4 py-1.5 bg-slate-100 text-slate-400 font-bold text-xs rounded border border-slate-200 cursor-not-allowed"
                  >
                    Unlocks Soon
                  </button>
                </div>
              </div>
            </div>

          </div>
        )}

        {/* Tab 2: My Attempt History */}
        {activeTab === 'history' && (
          <div className="bg-white rounded-2xl border border-slate-200 shadow-sm p-6 space-y-4">
            <h3 className="font-bold text-base text-slate-900">
              Exam Performance History
            </h3>

            {savedAttempt ? (
              <div className="p-4 bg-slate-50 border border-slate-200 rounded-xl space-y-3">
                <div className="flex items-center justify-between">
                  <div>
                    <h4 className="font-bold text-slate-900 text-sm">
                      RRB Group D CBT Mock Test 01
                    </h4>
                    <span className="text-xs text-slate-500">
                      Status: <strong className="capitalize">{savedAttempt.status}</strong>
                    </span>
                  </div>
                  <span className="text-lg font-black text-blue-700">
                    Score: {savedAttempt.score?.toFixed(2) || '0.00'} / 100
                  </span>
                </div>

                <div className="grid grid-cols-3 gap-2 text-center text-xs">
                  <div className="bg-emerald-50 border border-emerald-200 p-2 rounded">
                    <span className="text-slate-500 block text-[10px]">Correct</span>
                    <strong className="text-emerald-700 font-bold">{savedAttempt.correctCount || 0}</strong>
                  </div>
                  <div className="bg-red-50 border border-red-200 p-2 rounded">
                    <span className="text-slate-500 block text-[10px]">Incorrect</span>
                    <strong className="text-red-700 font-bold">{savedAttempt.incorrectCount || 0}</strong>
                  </div>
                  <div className="bg-sky-50 border border-sky-200 p-2 rounded">
                    <span className="text-slate-500 block text-[10px]">Accuracy</span>
                    <strong className="text-sky-700 font-bold">{savedAttempt.accuracy?.toFixed(1) || 0}%</strong>
                  </div>
                </div>

                <div className="pt-2 flex justify-end">
                  <button
                    onClick={handleStartClick}
                    className="flex items-center gap-1.5 px-4 py-2 bg-blue-600 hover:bg-blue-700 text-white font-bold text-xs rounded transition"
                  >
                    <RotateCcw className="w-3.5 h-3.5" />
                    <span>Re-Attempt Examination</span>
                  </button>
                </div>
              </div>
            ) : (
              <div className="text-center py-10 text-slate-500 text-sm">
                <FileCheck2 className="w-12 h-12 text-slate-300 mx-auto mb-2" />
                <p>No completed test attempts yet. Click on "Start Mock Test" to take your first test!</p>
              </div>
            )}
          </div>
        )}

      </main>

      {/* Pre-Exam Instructions & Declaration Modal */}
      <InstructionsModal
        isOpen={showInstructions}
        onClose={() => setShowInstructions(false)}
        onStartExam={handleInstructionsProceed}
        isPreExam={true}
        defaultLang={defaultLang}
        onChangeDefaultLang={setDefaultLang}
      />

      {/* Footer */}
      <footer className="bg-slate-200 border-t border-slate-300 py-3 text-center text-xs text-slate-600">
        RRB Mock Test Portal &bull; Standard Computer-Based Test Engine
      </footer>

    </div>
  );
}

