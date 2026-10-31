import React, { useState, useEffect } from 'react';
import { ShieldCheck, Lock, Phone, User, RefreshCw, AlertCircle, CheckCircle, ArrowRight } from 'lucide-react';
import { loginOrRegisterCandidate } from '../services/apiService';

export default function LoginPage({ onLoginSuccess }) {
  const [name, setName] = useState('');
  const [mobile, setMobile] = useState('');
  const [passcode, setPasscode] = useState('');
  const [captchaInput, setCaptchaInput] = useState('');
  const [captchaProblem, setCaptchaProblem] = useState({ num1: 3, num2: 8, answer: 11 });
  const [loading, setLoading] = useState(false);
  const [errorMessage, setErrorMessage] = useState('');
  const [noticeMessage, setNoticeMessage] = useState('');

  // Generate dynamic arithmetic captcha
  const generateCaptcha = () => {
    const n1 = Math.floor(Math.random() * 12) + 1;
    const n2 = Math.floor(Math.random() * 12) + 1;
    setCaptchaProblem({
      num1: n1,
      num2: n2,
      answer: n1 + n2
    });
    setCaptchaInput('');
  };

  useEffect(() => {
    generateCaptcha();
  }, []);

  const handleSubmit = async (e) => {
    e.preventDefault();
    setErrorMessage('');
    setNoticeMessage('');

    // Validation
    const cleanName = name.trim();
    const cleanMobile = mobile.trim();
    const cleanPasscode = passcode.trim();

    if (!cleanName) {
      setErrorMessage('Please enter your full candidate name.');
      return;
    }

    // 10-digit mobile number validation
    const mobileRegex = /^[6-9]\d{9}$/;
    if (!mobileRegex.test(cleanMobile)) {
      setErrorMessage('Please enter a valid 10-digit Indian mobile number (e.g., 9876543210).');
      return;
    }

    // 4-digit passcode validation
    const passcodeRegex = /^\d{4}$/;
    if (!passcodeRegex.test(cleanPasscode)) {
      setErrorMessage('Please enter a 4-digit numeric passcode (e.g., 1234).');
      return;
    }

    // Captcha validation
    if (parseInt(captchaInput, 10) !== captchaProblem.answer) {
      setErrorMessage('Incorrect captcha calculation. Please solve the arithmetic sum again.');
      generateCaptcha();
      return;
    }

    setLoading(true);

    try {
      const result = await loginOrRegisterCandidate(cleanName, cleanMobile, cleanPasscode);

      if (result.success) {
        if (result.notice) {
          setNoticeMessage(result.notice);
        }
        setTimeout(() => {
          onLoginSuccess(result.candidate);
        }, 400);
      } else {
        setErrorMessage(result.error || 'Authentication failed. Please verify your passcode.');
      }
    } catch (err) {
      setErrorMessage('Network error during candidate verification: ' + err.message);
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="min-h-screen bg-gradient-to-br from-[#1b2a47] via-[#223656] to-[#0f172a] flex flex-col justify-between p-4 sm:p-6 text-slate-800">
      
      {/* Top Bar Branding */}
      <header className="max-w-6xl mx-auto w-full flex items-center justify-between py-2 text-white">
        <div className="flex items-center space-x-3">
          <div className="w-10 h-10 rounded-lg bg-amber-500 flex items-center justify-center font-black text-xl text-slate-900 shadow">
            RRB
          </div>
          <div>
            <h1 className="font-extrabold text-lg sm:text-xl tracking-wide">
              RRB Mock Test
            </h1>
            <p className="text-[11px] text-amber-300 font-medium">
              Official Railway CBT Examination Portal
            </p>
          </div>
        </div>

        <div className="hidden sm:flex items-center gap-2 text-xs bg-white/10 px-3 py-1.5 rounded-full border border-white/20">
          <ShieldCheck className="w-4 h-4 text-emerald-400" />
          <span className="text-slate-200">256-bit Secure Examination Node</span>
        </div>
      </header>

      {/* Center Auth Card */}
      <div className="w-full max-w-md mx-auto my-8">
        <div className="bg-white rounded-2xl shadow-2xl overflow-hidden border border-slate-200">
          
          {/* Card Top Banner */}
          <div className="bg-gradient-to-r from-[#1d638a] to-[#30475e] p-6 text-white text-center relative border-b-4 border-amber-500">
            <h2 className="text-xl font-bold tracking-wide mb-1">
              Candidate Login & Registration
            </h2>
            <p className="text-xs text-slate-200">
              Enter your credentials to access RRB Group D CBT Test Series
            </p>
          </div>

          {/* Form */}
          <form onSubmit={handleSubmit} className="p-6 sm:p-8 space-y-4">
            
            {/* Error message */}
            {errorMessage && (
              <div className="p-3 bg-red-50 border-l-4 border-red-500 rounded text-xs text-red-700 flex items-start gap-2">
                <AlertCircle className="w-4 h-4 text-red-500 shrink-0 mt-0.5" />
                <span>{errorMessage}</span>
              </div>
            )}

            {/* Notice message */}
            {noticeMessage && (
              <div className="p-3 bg-amber-50 border-l-4 border-amber-500 rounded text-xs text-amber-800 flex items-start gap-2">
                <CheckCircle className="w-4 h-4 text-amber-600 shrink-0 mt-0.5" />
                <span>{noticeMessage}</span>
              </div>
            )}

            {/* Candidate Name */}
            <div>
              <label className="block text-xs font-bold text-slate-700 uppercase tracking-wider mb-1.5">
                Candidate Full Name
              </label>
              <div className="relative">
                <div className="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none text-slate-400">
                  <User className="w-4 h-4" />
                </div>
                <input
                  type="text"
                  required
                  value={name}
                  onChange={(e) => setName(e.target.value)}
                  placeholder="e.g. Ramesh Kumar"
                  className="w-full pl-9 pr-3 py-2.5 text-sm bg-slate-50 border border-slate-300 rounded-lg focus:bg-white focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent transition"
                />
              </div>
            </div>

            {/* Mobile Number (10 Digits mandatory) */}
            <div>
              <label className="block text-xs font-bold text-slate-700 uppercase tracking-wider mb-1.5">
                10-Digit Mobile Number
              </label>
              <div className="relative">
                <div className="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none text-slate-400">
                  <Phone className="w-4 h-4" />
                </div>
                <input
                  type="tel"
                  required
                  maxLength={10}
                  value={mobile}
                  onChange={(e) => setMobile(e.target.value.replace(/\D/g, ''))}
                  placeholder="10-digit mobile (e.g. 9876543210)"
                  className="w-full pl-9 pr-3 py-2.5 text-sm font-mono bg-slate-50 border border-slate-300 rounded-lg focus:bg-white focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent transition"
                />
              </div>
              <p className="text-[10px] text-slate-500 mt-1">
                Returning candidates will have details auto-restored.
              </p>
            </div>

            {/* 4-digit Passcode */}
            <div>
              <label className="block text-xs font-bold text-slate-700 uppercase tracking-wider mb-1.5">
                4-Digit Passcode
              </label>
              <div className="relative">
                <div className="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none text-slate-400">
                  <Lock className="w-4 h-4" />
                </div>
                <input
                  type="password"
                  required
                  maxLength={4}
                  value={passcode}
                  onChange={(e) => setPasscode(e.target.value.replace(/\D/g, ''))}
                  placeholder="••••"
                  className="w-full pl-9 pr-3 py-2.5 text-sm font-mono tracking-widest bg-slate-50 border border-slate-300 rounded-lg focus:bg-white focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent transition"
                />
              </div>
              <p className="text-[10px] text-slate-500 mt-1">
                Passcode is recorded securely in your exam profile.
              </p>
            </div>

            {/* Arithmetic Captcha (e.g. 3 + 8 = ?) */}
            <div className="pt-1">
              <label className="block text-xs font-bold text-slate-700 uppercase tracking-wider mb-1.5">
                Security Captcha Verification
              </label>
              <div className="flex items-center gap-2">
                <div className="flex items-center justify-center bg-slate-100 border border-slate-300 rounded-lg px-4 py-2 font-mono font-black text-slate-800 tracking-wider text-base shadow-inner">
                  {captchaProblem.num1} + {captchaProblem.num2} = ?
                </div>
                <button
                  type="button"
                  onClick={generateCaptcha}
                  className="p-2.5 bg-slate-100 hover:bg-slate-200 text-slate-600 rounded-lg border border-slate-300 transition"
                  title="Generate new arithmetic sum"
                >
                  <RefreshCw className="w-4 h-4" />
                </button>
                <input
                  type="number"
                  required
                  value={captchaInput}
                  onChange={(e) => setCaptchaInput(e.target.value)}
                  placeholder="Sum"
                  className="w-24 px-3 py-2 text-sm text-center font-bold font-mono bg-slate-50 border border-slate-300 rounded-lg focus:bg-white focus:outline-none focus:ring-2 focus:ring-blue-500 transition"
                />
              </div>
            </div>

            {/* Submit Button */}
            <div className="pt-3">
              <button
                type="submit"
                disabled={loading}
                className="w-full py-3 bg-gradient-to-r from-blue-600 to-indigo-700 hover:from-blue-700 hover:to-indigo-800 text-white font-bold text-sm uppercase tracking-wider rounded-lg shadow-lg flex items-center justify-center gap-2 transition transform active:scale-95 disabled:opacity-70 disabled:cursor-not-allowed"
              >
                {loading ? (
                  <span>Verifying Credentials...</span>
                ) : (
                  <>
                    <span>Enter Examination Portal</span>
                    <ArrowRight className="w-4 h-4" />
                  </>
                )}
              </button>
            </div>

          </form>

          {/* Footer note */}
          <div className="bg-slate-50 px-6 py-3 border-t border-slate-200 text-center text-[11px] text-slate-500">
            National Railway Recruitment Board Mock Testing Engine
          </div>

        </div>
      </div>

      {/* Footer Branding */}
      <footer className="max-w-6xl mx-auto w-full text-center text-xs text-slate-400 py-2">
        RRB Mock Test System &bull; Designed in compliance with TCS iON CBT Standard Interface
      </footer>

    </div>
  );
}

