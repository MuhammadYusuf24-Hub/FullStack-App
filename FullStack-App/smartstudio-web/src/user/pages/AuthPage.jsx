import { useState, useRef } from "react";
import LoginForm from "../components/auth/LoginForm";
import RegisterForm from "../components/auth/RegisterForm";
import "../styles/auth.css";

export default function AuthPage({ navigate }) {
  const [mode, setMode] = useState("login");         // "login" | "register"
  const [animState, setAnimState] = useState(null);  // null | "animating-to-register" | "animating-to-login"
  const t1 = useRef(null);
  const t2 = useRef(null);

  const ANIM_MS = 900; // harus sama dengan --anim-dur di CSS

  const switchTo = (target) => {
    if (animState !== null) return; // block double-click

    clearTimeout(t1.current);
    clearTimeout(t2.current);

    const animClass = target === "register"
      ? "animating-to-register"
      : "animating-to-login";

    setAnimState(animClass);

    // Ganti konten di titik tengah animasi (saat panel full-cover)
    t1.current = setTimeout(() => {
      setMode(target);
    }, ANIM_MS * 0.5);

    // Hapus kelas animasi setelah selesai
    t2.current = setTimeout(() => {
      setAnimState(null);
    }, ANIM_MS + 50);
  };

  const isRegister = mode === "register";

  const cardClass = [
    "auth-card",
    isRegister ? "register-mode" : "login-mode",
    animState,
  ].filter(Boolean).join(" ");

  return (
    <div className={cardClass}>

      {/* ── FORM KANAN: Register (grid kolom 2) ── */}
      <div className="panel-form-register">
        <RegisterForm
          switchMode={() => switchTo("login")}
          navigate={navigate}
        />
      </div>

      {/* ── FORM KIRI: Login (grid kolom 1) ── */}
      <div className="panel-form-login">
        <LoginForm
          switchMode={() => switchTo("register")}
          navigate={navigate}
        />
      </div>

      

      {/* ── PANEL BIRU (overlay, dikontrol clip-path) ── */}
      <div className="panel-info">
        <div className="panel-info-inner">
          <div className="panel-text">
            <h1>{isRegister ? "Sudah punya akun?" : "Belum punya akun?"}</h1>
            <p>
              {isRegister
                ? "Silakan login untuk melanjutkan"
                : "Daftar sekarang dan mulai perjalananmu"}
            </p>
          </div>

          <button
            className="switch-btn"
            onClick={() => switchTo(isRegister ? "login" : "register")}
          >
            {isRegister ? "Masuk" : "Daftar"}
          </button>
        </div>
      </div>

    </div>
  );
}