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

  const handleResumeExam = (savedAttempt) => {
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
          defaultLang={activeExamConfig?.defaultLang || 'en'}
          onFinishExam={handleFinishExam}
        />
      )}
    </div>
  );
}
