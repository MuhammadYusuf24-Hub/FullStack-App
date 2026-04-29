import { useState } from "react";
import { login } from "../../services/authService";

export default function LoginForm({ navigate, switchMode }) {
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState("");

  const submit = async (e) => {
    e.preventDefault();
    setError("");
    setLoading(true);

    try {
      const data = await login(email, password);

      if (data.status === "success") {
        // ── Arahkan berdasarkan role dari response server ──
        // navigate("home") → App.jsx akan cek isAdmin() dan redirect
        navigate("home");
      } else {
        setError(data.message || "Login gagal.");
      }
    } catch (err) {
      // Error dari fetch (network) atau throw dari authService
      setError(err.message || "Gagal terhubung ke server.");
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="form-inner">
      <h2>Masuk Akun</h2>
      <p className="subtitle">Selamat datang kembali 👋</p>

      <form onSubmit={submit}>
        <div className="field-group">
          <div className="field">
            <label>Email</label>
            <input
              type="email"
              autoComplete="off"        // ← tambah ini
              placeholder="contoh@email.com"
              value={email}
              onChange={(e) => setEmail(e.target.value)}
              required
            />
          </div>

          <div className="field">
            <label>Password</label>
            <input
              type="password"
              autoComplete="new-password" 
              placeholder="Masukkan password"
              value={password}
              onChange={(e) => setPassword(e.target.value)}
              required
            />
          </div>
        </div>

        <div className="field-row">
          <a onClick={() => navigate("forgot")}>Lupa kata sandi?</a>
        </div>

        <button className="btn-primary">Masuk</button>
      </form>

      <p className="form-footer">
        Belum punya akun? <a onClick={switchMode}>Daftar</a>
      </p>
    </div>
  );
}
