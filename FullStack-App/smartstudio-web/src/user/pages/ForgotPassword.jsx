import { useState } from "react";
import { forgotPassword } from "../services/authService";
import StepIndicator from "../components/auth/StepIndicator";
import "../styles/simpleForm.css";

export default function ForgotPassword({ navigate }) {
  const [email, setEmail]     = useState("");
  const [loading, setLoading] = useState(false);
  const [error, setError]     = useState("");

  const handleSubmit = async (e) => {
    e.preventDefault();
    setError("");
    setLoading(true);
    try {
      const data = await forgotPassword(email);
      if (data.status === "success") {
        localStorage.setItem("email", email);
        navigate("verifotp"); // ← pastikan route ini terdaftar di router kamu
      } else {
        setError(data.message || "Email tidak ditemukan.");
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
        <StepIndicator current={1} />

        <div className="sf-icon-wrap blue">
          <svg width="28" height="28" viewBox="0 0 24 24" fill="none">
            <path
              d="M20 4H4C2.9 4 2 4.9 2 6v12c0 1.1.9 2 2 2h16c1.1 0 2-.9 2-2V6c0-1.1-.9-2-2-2z"
              stroke="#2563eb" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"
            />
            <path
              d="M22 6l-10 7L2 6"
              stroke="#2563eb" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"
            />
          </svg>
        </div>

        <h2 className="sf-title">Lupa Kata Sandi?</h2>
        <p className="sf-subtitle">
          Masukkan email terdaftar. Kami akan mengirim kode OTP yang berlaku{" "}
          <strong>5 menit</strong>.
        </p>

        <form onSubmit={handleSubmit}>
          <div className="sf-field">
            <label>Alamat Email</label>
            <div className="sf-input-wrap">
              <svg className="sf-input-icon" width="15" height="15" viewBox="0 0 24 24" fill="none">
                <path d="M20 4H4C2.9 4 2 4.9 2 6v12c0 1.1.9 2 2 2h16c1.1 0 2-.9 2-2V6c0-1.1-.9-2-2-2z"
                  stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"/>
                <path d="M22 6l-10 7L2 6"
                  stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"/>
              </svg>
              <input
                type="email"
                placeholder="contoh@email.com"
                value={email}
                onChange={(e) => { setEmail(e.target.value); setError(""); }}
                required
              />
            </div>
            {error && <span className="sf-error">{error}</span>}
          </div>

          <button type="submit" className="sf-btn" disabled={loading}>
            {loading
              ? <><span className="sf-spinner" /> Mengirim...</>
              : "Kirim Kode OTP"}
          </button>
        </form>

        <p className="sf-footer">
          Ingat kata sandi?{" "}
          <a onClick={() => navigate("auth")}>← Kembali Masuk</a>
        </p>
      </div>
    </div>
  );
}