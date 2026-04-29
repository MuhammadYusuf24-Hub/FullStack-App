import { useState, useRef, useEffect } from "react";
import { verifyOtp, forgotPassword } from "../services/authService";
import StepIndicator from "../components/auth/StepIndicator";
import "../styles/simpleForm.css";

const OTP_LENGTH = 6;
const COUNTDOWN  = 5 * 60; // 300 detik

export default function VerifOTP({ navigate }) {
  const [otp, setOtp]           = useState(Array(OTP_LENGTH).fill(""));
  const [seconds, setSeconds]   = useState(COUNTDOWN);
  const [loading, setLoading]   = useState(false);
  const [resending, setResending] = useState(false);
  const [error, setError]       = useState("");
  const [info, setInfo]         = useState("");
  const inputRefs               = useRef([]);
  const email                   = localStorage.getItem("email") || "";

  /* ── Countdown ── */
  useEffect(() => {
    if (seconds <= 0) return;
    const t = setInterval(() => setSeconds((s) => s - 1), 1000);
    return () => clearInterval(t);
  }, [seconds]);

  const fmt = (s) => `${Math.floor(s / 60)}:${String(s % 60).padStart(2, "0")}`;
  const isExpired = seconds <= 0;

  /* ── OTP input handlers ── */
  const handleChange = (val, i) => {
    if (!/^[0-9]?$/.test(val)) return;
    const next = [...otp];
    next[i] = val;
    setOtp(next);
    setError("");
    if (val && i < OTP_LENGTH - 1) inputRefs.current[i + 1]?.focus();
  };

  const handleKeyDown = (e, i) => {
    if (e.key === "Backspace" && !otp[i] && i > 0)
      inputRefs.current[i - 1]?.focus();
  };

  const handlePaste = (e) => {
    e.preventDefault();
    const digits = e.clipboardData.getData("text").replace(/\D/g, "").slice(0, OTP_LENGTH);
    if (!digits) return;
    const next = [...otp];
    digits.split("").forEach((ch, i) => { next[i] = ch; });
    setOtp(next);
    const focusIdx = Math.min(digits.length, OTP_LENGTH - 1);
    inputRefs.current[focusIdx]?.focus();
  };

  /* ── Submit ── */
  const handleSubmit = async (e) => {
    e.preventDefault();
    setError("");
    const otpVal = otp.join("");
    if (otpVal.length < OTP_LENGTH) { setError("Masukkan 6 digit kode OTP."); return; }
    if (isExpired) { setError("Kode OTP sudah kedaluwarsa. Silakan kirim ulang."); return; }

    setLoading(true);
    try {
      const data = await verifyOtp(email, otpVal);
      if (data.status === "success") {
        localStorage.setItem("otp", otpVal);
        navigate("ubahpass");
      } else {
        setError(data.message || "Kode OTP tidak valid.");
        // shake + clear
        inputRefs.current.forEach((el) => el?.classList.add("err"));
        setTimeout(() => {
          inputRefs.current.forEach((el) => el?.classList.remove("err"));
          setOtp(Array(OTP_LENGTH).fill(""));
          inputRefs.current[0]?.focus();
        }, 500);
      }
    } catch {
      setError("Gagal terhubung ke server. Coba lagi.");
    } finally {
      setLoading(false);
    }
  };

  /* ── Resend ── */
  const handleResend = async () => {
    if (resending) return;
    setError("");
    setInfo("");
    setResending(true);
    try {
      const data = await forgotPassword(email);
      if (data.status === "success") {
        setSeconds(COUNTDOWN);
        setOtp(Array(OTP_LENGTH).fill(""));
        inputRefs.current[0]?.focus();
        setInfo("Kode OTP baru telah dikirim ke email kamu.");
        setTimeout(() => setInfo(""), 4000);
      } else {
        setError(data.message || "Gagal mengirim ulang kode.");
      }
    } catch {
      setError("Gagal terhubung ke server. Coba lagi.");
    } finally {
      setResending(false);
    }
  };

  const otpFull = otp.every(Boolean);

  return (
    <div className="sf-wrapper">
      <div className="sf-card">
        <StepIndicator current={2} />

        <div className="sf-icon-wrap blue">
          <svg width="28" height="28" viewBox="0 0 24 24" fill="none">
            <rect x="2" y="7" width="20" height="14" rx="2"
              stroke="#2563eb" strokeWidth="2" strokeLinecap="round"/>
            <path d="M16 7V5a2 2 0 00-2-2h-4a2 2 0 00-2 2v2"
              stroke="#2563eb" strokeWidth="2" strokeLinecap="round"/>
            <circle cx="12" cy="14" r="2" stroke="#2563eb" strokeWidth="2"/>
            <path d="M12 16v2" stroke="#2563eb" strokeWidth="2" strokeLinecap="round"/>
          </svg>
        </div>

        <h2 className="sf-title">Masukkan Kode OTP</h2>
        <p className="sf-subtitle">
          Kode 6 digit dikirim ke <strong>{email}</strong>.<br />
          Cek folder <em>Spam</em> jika tidak ada di kotak masuk.
        </p>

        <form onSubmit={handleSubmit}>
          {/* OTP Boxes */}
          <div className="sf-otp-group" onPaste={handlePaste}>
            {otp.map((val, i) => (
              <input
                key={i}
                ref={(el) => (inputRefs.current[i] = el)}
                className={`sf-otp-box${val ? " filled" : ""}`}
                type="text"
                inputMode="numeric"
                maxLength={1}
                value={val}
                placeholder="·"
                autoFocus={i === 0}
                autoComplete={i === 0 ? "one-time-code" : "off"}
                onChange={(e) => handleChange(e.target.value, i)}
                onKeyDown={(e) => handleKeyDown(e, i)}
              />
            ))}
          </div>

          {/* Timer */}
          <div className={`sf-timer${isExpired ? " sf-timer-expired" : ""}`}>
            <svg width="13" height="13" viewBox="0 0 24 24" fill="none">
              <circle cx="12" cy="12" r="10" stroke="currentColor" strokeWidth="2"/>
              <path d="M12 6v6l4 2" stroke="currentColor" strokeWidth="2" strokeLinecap="round"/>
            </svg>
            {isExpired
              ? <span style={{ color: "#ef4444", fontWeight: 700 }}>Kode kedaluwarsa</span>
              : <span>Berlaku selama <strong style={{ color: "#2563eb" }}>{fmt(seconds)}</strong></span>
            }
          </div>

          {/* Feedback */}
          {error && <span className="sf-error center" style={{ marginBottom: 6 }}>{error}</span>}
          {info  && (
            <span style={{
              display: "block", textAlign: "center", fontSize: 12.5,
              color: "#16a34a", background: "#f0fdf4", border: "1px solid #bbf7d0",
              borderRadius: 8, padding: "7px 12px", marginBottom: 6
            }}>{info}</span>
          )}

          <button
            type="submit"
            className="sf-btn"
            disabled={loading || !otpFull || isExpired}
          >
            {loading
              ? <><span className="sf-spinner" /> Memverifikasi...</>
              : "Verifikasi Kode"}
          </button>
        </form>

        {/* Resend */}
        <p className="sf-footer" style={{ marginTop: 14 }}>
          Tidak menerima kode?{" "}
          {resending
            ? <span style={{ color: "#94a3b8" }}>Mengirim...</span>
            : <a onClick={handleResend}>Kirim ulang</a>
          }
        </p>

        <p className="sf-footer" style={{ marginTop: 6 }}>
          <a onClick={() => navigate("auth")}>← Kembali ke Login</a>
        </p>
      </div>
    </div>
  );
}