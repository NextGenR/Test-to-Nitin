import React, { useState, useEffect } from 'react';
import LoginPage from './pages/LoginPage';
import DashboardPage from './pages/DashboardPage';
import CBTExamPage from './pages/CBTExamPage';
import { getCachedCandidate, clearCandidateSession } from './services/apiService';

export default function App() {
  const [currentPage, setCurrentPage] = useState('login'); // 'login' | 'dashboard' | 'exam'
  const [activeCandidate, setActiveCandidate] = useState(null);
  const [activeExamConfig, setActiveExamConfig] = useState(null);
  const [initialAttemptData, setInitialAttemptData] = useState(null);

  // Check cached login session on mount
  useEffect(() => {
    const cached = getCachedCandidate();
    if (cached && cached.mobile_number) {
      setActiveCandidate(cached);
      setCurrentPage('dashboard');
    }
  }, []);

  const handleLoginSuccess = (candidate) => {
    setActiveCandidate(candidate);
    setCurrentPage('dashboard');
  };

  const handleLogout = () => {
    clearCandidateSession();
    setActiveCandidate(null);
    setCurrentPage('login');
  };

  const handleStartExam = (config = {}) => {
    setActiveExamConfig(config);
    setInitialAttemptData(null);
    setCurrentPage('exam');
  };

  const handleResumeExam = (savedAttempt, mock) => {
    setActiveExamConfig({
      mockNumber: mock?.id || 1,
      testId: mock?.testId || 'rrb_cbt_mock_1',
      title: mock?.title || 'RRB Group D CBT Mock Test 01'
    });
    setInitialAttemptData(savedAttempt);
    setCurrentPage('exam');
  };

  const handleFinishExam = () => {
    setCurrentPage('dashboard');
  };

  return (
    <div className="w-full min-h-screen font-sans bg-[#f4f7f9]">
      {currentPage === 'login' && (
        <LoginPage onLoginSuccess={handleLoginSuccess} />
      )}

      {currentPage === 'dashboard' && (
        <DashboardPage
          candidate={activeCandidate}
          onStartExam={handleStartExam}
          onResumeExam={handleResumeExam}
          onLogout={handleLogout}
        />
      )}

      {currentPage === 'exam' && (
        <CBTExamPage
          candidate={activeCandidate}
          initialAttempt={initialAttemptData}
          mockNumber={activeExamConfig?.mockNumber || 1}
          testId={activeExamConfig?.testId || 'rrb_cbt_mock_1'}
          testTitle={activeExamConfig?.title || 'RRB Group D CBT Mock Test 01'}
          defaultLang={activeExamConfig?.defaultLang || 'en'}
          onFinishExam={handleFinishExam}
        />
      )}
    </div>
  );
}
