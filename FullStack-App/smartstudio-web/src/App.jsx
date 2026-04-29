// src/App.jsx
import { useState } from "react";
import { isLoggedIn, getCurrentUser, isAdmin, logout } from "./user/services/authService";

import AuthPage        from "./user/pages/AuthPage";
import ForgotPassword  from "./user/pages/ForgotPassword";
import VerifOTP        from "./user/pages/VerifOTP";
import UbahPassword    from "./user/pages/UbahPassword";
import AdminDashboard  from "./admin/pages/AdminDashboard";
import UserDashboard   from "./user/pages/UserDashboard";

// ── Tentukan halaman awal berdasarkan session yang sudah ada ──
function getInitialPage() {
  if (!isLoggedIn()) return "auth";
  return isAdmin() ? "admin" : "user";
}

export default function App() {
  const [page, setPage] = useState(getInitialPage);

  // ── Navigasi dengan cek role setelah login ──
  const navigate = (target) => {
    // Setelah login berhasil, arahkan berdasarkan role
    if (target === "home") {
      setPage(isAdmin() ? "admin" : "user");
      return;
    }
    setPage(target);
  };

  // ── Handler logout ──
  const handleLogout = async () => {
    await logout();
    setPage("auth");
  };

  // ── Ambil data user untuk dikirim ke halaman ──
  const currentUser = getCurrentUser();

  return (
    <div className="app-root">
      {page === "auth"      && <AuthPage       navigate={navigate} />}
      {page === "forgot"    && <ForgotPassword navigate={navigate} />}
      {page === "verifotp"  && <VerifOTP       navigate={navigate} />}
      {page === "ubahpass"  && <UbahPassword   navigate={navigate} />}

      {/* ── Admin: hanya tampil jika role === "admin" ── */}
      {page === "admin" && isAdmin() && (
        <AdminDashboard user={currentUser} onLogout={handleLogout} />
      )}

      {/* ── User: hanya tampil jika login dan bukan admin ── */}
      {page === "user" && isLoggedIn() && !isAdmin() && (
        <UserDashboard user={currentUser} onLogout={handleLogout} />
      )}

      {/* ── Fallback: jika akses halaman tanpa hak ── */}
      {((page === "admin" && !isAdmin()) || (page === "user" && !isLoggedIn())) && (
        <AuthPage navigate={navigate} />
      )}
    </div>
  );
}