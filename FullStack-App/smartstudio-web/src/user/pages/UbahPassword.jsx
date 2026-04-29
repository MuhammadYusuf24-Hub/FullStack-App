import { useState } from "react";
import { resetPassword } from "../services/authService";
import StepIndicator from "../components/auth/StepIndicator";
import "../styles/simpleForm.css";

function getStrength(pw) {
  if (!pw) return { score: 0, label: "", color: "", bg: "" };
  let score = 0;
  if (pw.length >= 6)           score++;
  if (pw.length >= 10)          score++;
  if (/[A-Z]/.test(pw))        score++;
  if (/[0-9]/.test(pw))        score++;
  if (/[^A-Za-z0-9]/.test(pw)) score++;
  if (score <= 1) return { score, label: "Lemah",  color: "#ef4444", bg: "#fef2f2" };
  if (score <= 3) return { score, label: "Sedang", color: "#f59e0b", bg: "#fffbeb" };
  return             { score, label: "Kuat",   color: "#22c55e", bg: "#f0fdf4" };
}

const EyeOpen = () => (
  <svg width="16" height="16" viewBox="0 0 24 24" fill="none">
    <path d="M1 12S5 4 12 4s11 8 11 8-4 8-11 8S1 12 1 12z"
      stroke="currentColor" strokeWidth="2" strokeLinecap="round"/>
    <circle cx="12" cy="12" r="3" stroke="currentColor" strokeWidth="2"/>
  </svg>
);

const EyeOff = () => (
  <svg width="16" height="16" viewBox="0 0 24 24" fill="none">
    <path d="M17.94 17.94A10.07 10.07 0 0112 20C7 20 2.73 16.39 1 12a10.07 10.07 0 012.06-3.94M9.9 4.24A9.12 9.12 0 0112 4c5 0 9.27 3.61 11 8-.57 1.48-1.43 2.82-2.51 3.96M3 3l18 18"
      stroke="currentColor" strokeWidth="2" strokeLinecap="round"/>
  </svg>
);

export default function UbahPassword({ navigate }) {
  const [password, setPassword]     = useState("");
  const [konfirmasi, setKonfirmasi] = useState("");
  const [showPw, setShowPw]         = useState(false);
  const [showKonf, setShowKonf]     = useState(false);
  const [loading, setLoading]       = useState(false);
  const [error, setError]           = useState("");

  const strength = getStrength(password);
  const match    = konfirmasi && password === konfirmasi;
  const noMatch  = konfirmasi && password !== konfirmasi;

  const handleSubmit = async (e) => {
    e.preventDefault();
    setError("");
    if (password !== konfirmasi) { setError("Konfirmasi password tidak cocok."); return; }
    if (password.length < 6)    { setError("Password minimal 6 karakter."); return; }

    setLoading(true);
    try {
      const email = localStorage.getItem("email");
      const otp   = localStorage.getItem("otp");
      const data  = await resetPassword(email, otp, password);
      if (data.status === "success") {
        localStorage.removeItem("email");
        localStorage.removeItem("otp");
        navigate("auth");
      } else {
        setError(data.message || "Gagal mereset password.");
      }
    } catch {
      setError("Gagal terhubung ke server. Coba lagi.");
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="sf-wrapper">
      <div className="sf-card">
        <StepIndicator current={3} />

        <div className="sf-icon-wrap green">
          <svg width="28" height="28" viewBox="0 0 24 24" fill="none">
            <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"
              stroke="#16a34a" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"/>
            <path d="M9 12l2 2 4-4"
              stroke="#16a34a" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"/>
          </svg>
        </div>

        <h2 className="sf-title">Buat Password Baru</h2>
        <p className="sf-subtitle">
          Buat password baru yang kuat dan mudah kamu ingat.
        </p>

        <form onSubmit={handleSubmit}>
          {/* Password baru */}
          <div className="sf-field">
            <label>Password Baru</label>
            <div className="sf-input-wrap">
              <svg className="sf-input-icon" width="15" height="15" viewBox="0 0 24 24" fill="none">
                <rect x="3" y="11" width="18" height="11" rx="2"
                  stroke="currentColor" strokeWidth="2"/>
                <path d="M7 11V7a5 5 0 0110 0v4"
                  stroke="currentColor" strokeWidth="2" strokeLinecap="round"/>
              </svg>
              <input
                type={showPw ? "text" : "password"}
                placeholder="Minimal 6 karakter"
                value={password}
                onChange={(e) => { setPassword(e.target.value); setError(""); }}
                required
              />
              <button type="button" className="sf-eye" onClick={() => setShowPw(!showPw)}>
                {showPw ? <EyeOff /> : <EyeOpen />}
              </button>
            </div>
            {password && (
              <>
                <div className="sf-strength-bar">
                  {[1,2,3,4,5].map((n) => (
                    <div key={n} className="sf-strength-seg"
                      style={{ background: n <= strength.score ? strength.color : undefined }} />
                  ))}
                </div>
                <span className="sf-strength-label"
                  style={{ color: strength.color, background: strength.bg }}>
                  {strength.label}
                </span>
              </>
            )}
          </div>

          {/* Konfirmasi password */}
          <div className="sf-field" style={{ marginTop: 14 }}>
            <label>Konfirmasi Password</label>
            <div className={`sf-input-wrap${match ? " valid" : ""}${noMatch ? " invalid" : ""}`}>
              <svg className="sf-input-icon" width="15" height="15" viewBox="0 0 24 24" fill="none">
                <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"
                  stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"/>
              </svg>
              <input
                type={showKonf ? "text" : "password"}
                placeholder="Ulangi password baru"
                value={konfirmasi}
                onChange={(e) => { setKonfirmasi(e.target.value); setError(""); }}
                required
              />
              <button type="button" className="sf-eye" onClick={() => setShowKonf(!showKonf)}>
                {showKonf ? <EyeOff /> : <EyeOpen />}
              </button>
            </div>
            {match   && <span className="sf-match-ok">✓ Password cocok</span>}
            {noMatch && <span className="sf-match-err">✗ Password tidak cocok</span>}
          </div>

          {error && (
            <span className="sf-error center" style={{ marginTop: 8 }}>{error}</span>
          )}

          <button
            type="submit"
            className="sf-btn green"
            disabled={loading || !match}
          >
            {loading
              ? <><span className="sf-spinner" /> Menyimpan...</>
              : "Simpan Password Baru"}
          </button>
        </form>

        <p className="sf-footer">
          <a onClick={() => navigate("auth")}>← Kembali ke Login</a>
        </p>
      </div>
    </div>
  );
}