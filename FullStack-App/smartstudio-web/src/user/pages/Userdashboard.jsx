// src/user/pages/UserDashboard.jsx
import { useState, useEffect } from "react";
import { getKamera, logout } from "../services/authService";

export default function UserDashboard({ user, onLogout }) {
  const [cameras, setCameras]     = useState([]);
  const [search, setSearch]       = useState("");
  const [loading, setLoading]     = useState(false);
  const [error, setError]         = useState("");

  // ── Ambil data kamera saat mount ──
  useEffect(() => {
    setLoading(true);
    getKamera()
      .then((data) => setCameras(data.data || data || []))
      .catch((err) => setError(err.message))
      .finally(() => setLoading(false));
  }, []);

  const filtered = cameras.filter(
    (c) =>
      c.nama?.toLowerCase().includes(search.toLowerCase()) ||
      c.lokasi?.toLowerCase().includes(search.toLowerCase())
  );

  return (
    <div style={{ minHeight: "100vh", background: "#f8fafc" }}>

      {/* ── Navbar ── */}
      <nav style={{
        background: "#fff", borderBottom: "1px solid #e2e8f0",
        padding: "0 24px", height: 60,
        display: "flex", alignItems: "center", justifyContent: "space-between"
      }}>
        <div style={{ fontWeight: 800, fontSize: 18, color: "#0f172a" }}>
          Smart<span style={{ color: "#185FA5" }}>Studio</span>
        </div>

        <div style={{ display: "flex", alignItems: "center", gap: 16 }}>
          <span style={{ fontSize: 14, color: "#475569" }}>
            Halo, <strong>{user?.username}</strong>
          </span>
          <span style={{
            padding: "3px 10px", background: "#dbeafe", color: "#1d4ed8",
            borderRadius: 20, fontSize: 12, fontWeight: 700, textTransform: "uppercase"
          }}>
            {user?.role}
          </span>
          <button onClick={onLogout} style={{
            background: "#ef4444", color: "#fff", border: "none",
            borderRadius: 8, padding: "8px 16px", cursor: "pointer",
            fontWeight: 600, fontSize: 13
          }}>
            Logout
          </button>
        </div>
      </nav>

      {/* ── Konten ── */}
      <div style={{ maxWidth: 1000, margin: "0 auto", padding: 24 }}>

        <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center", marginBottom: 20 }}>
          <h1 style={{ fontSize: 20, fontWeight: 700, margin: 0 }}>Daftar Kamera</h1>
          <input
            placeholder="Cari nama / lokasi..."
            value={search}
            onChange={(e) => setSearch(e.target.value)}
            style={{
              padding: "8px 14px", borderRadius: 8,
              border: "1px solid #e2e8f0", fontSize: 14, width: 220
            }}
          />
        </div>

        {error && (
          <div style={{
            padding: "12px 16px", background: "#fef2f2",
            border: "1px solid #fecaca", borderRadius: 8,
            color: "#ef4444", marginBottom: 16
          }}>
            {error}
          </div>
        )}

        {loading && <p style={{ color: "#64748b" }}>Memuat data kamera...</p>}

        {!loading && (
          <div style={{
            display: "grid",
            gridTemplateColumns: "repeat(auto-fill, minmax(280px, 1fr))",
            gap: 16
          }}>
            {filtered.length === 0 ? (
              <p style={{ color: "#94a3b8", gridColumn: "1/-1", textAlign: "center", padding: 48 }}>
                Tidak ada data kamera
              </p>
            ) : (
              filtered.map((c) => (
                <div key={c.id} style={{
                  background: "#fff", borderRadius: 12, padding: "18px 20px",
                  boxShadow: "0 1px 4px rgba(0,0,0,0.08)",
                  border: "1px solid #f1f5f9"
                }}>
                  <div style={{ display: "flex", justifyContent: "space-between", alignItems: "flex-start" }}>
                    <div>
                      <div style={{ fontWeight: 700, fontSize: 15, color: "#0f172a" }}>{c.nama}</div>
                      <div style={{ fontSize: 13, color: "#64748b", marginTop: 4 }}>📍 {c.lokasi}</div>
                    </div>
                    <span style={{
                      padding: "3px 10px", borderRadius: 20, fontSize: 12, fontWeight: 600,
                      background: c.status === "aktif" ? "#dcfce7" : c.status === "maintenance" ? "#fef3c7" : "#fee2e2",
                      color: c.status === "aktif" ? "#16a34a" : c.status === "maintenance" ? "#d97706" : "#dc2626",
                    }}>
                      {c.status}
                    </span>
                  </div>
                </div>
              ))
            )}
          </div>
        )}
      </div>
    </div>
  );
}