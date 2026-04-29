// src/admin/pages/AdminDashboard.jsx
import React, { useState, useEffect } from "react";
import { getKamera, getDashboardStats, getAllUsers, deleteUser } from "../../user/services/authService";

// ── Import komponen (sesuaikan path jika berbeda) ──
import Sidebar    from "../components/Sidebar";
import Navbar     from "../components/Navbar";
import StatCards  from "../components/StatCards";
import CameraForm from "../components/CameraForm";
import CameraTable from "../components/CameraTable";
import "../styles/admindashboard.css";

export default function AdminDashboard({ user, onLogout }) {
  const [activePage, setActivePage] = useState("kamera");
  const [cameras, setCameras]       = useState([]);
  const [stats, setStats]           = useState(null);
  const [users, setUsers]           = useState([]);
  const [search, setSearch]         = useState("");
  const [loadingCam, setLoadingCam] = useState(false);
  const [error, setError]           = useState("");

  // ── Ambil data kamera saat mount — pakai fetch via authService ──
  useEffect(() => {
    setLoadingCam(true);
    getKamera()
      .then((data) => setCameras(data.data || data || []))
      .catch((err) => setError(err.message))
      .finally(() => setLoadingCam(false));
  }, []);

  // ── Ambil statistik dashboard ──
  useEffect(() => {
    getDashboardStats()
      .then((data) => setStats(data.data || null))
      .catch((err) => console.error("Stats error:", err.message));
  }, []);

  // ── Ambil semua user (halaman manajemen user) ──
  useEffect(() => {
    if (activePage !== "users") return;
    getAllUsers()
      .then((data) => setUsers(data.data || []))
      .catch((err) => console.error("Users error:", err.message));
  }, [activePage]);

  const handleSaved  = (newCam) => setCameras((prev) => [...prev, newCam]);
  const handleDelete = (id)     => setCameras((prev) => prev.filter((c) => c.id !== id));

  // ── Hapus user via API ──
  const handleDeleteUser = async (id) => {
    if (!window.confirm("Yakin hapus user ini?")) return;
    try {
      await deleteUser(id);
      setUsers((prev) => prev.filter((u) => u.id !== id));
    } catch (err) {
      alert(err.message);
    }
  };

  const filtered = cameras.filter(
    (c) =>
      c.nama?.toLowerCase().includes(search.toLowerCase()) ||
      c.lokasi?.toLowerCase().includes(search.toLowerCase())
  );

  const aktif       = cameras.filter((c) => c.status === "aktif").length;
  const maintenance = cameras.filter((c) => c.status === "maintenance").length;
  const offline     = cameras.filter((c) => c.status === "nonaktif").length;

  return (
    <div className="admin-layout">

      {/* ── Sidebar sederhana (ganti dengan komponen Sidebar kamu) ── */}
      <aside style={{
        width: 220, background: "#0f172a", minHeight: "100vh",
        padding: "24px 16px", display: "flex", flexDirection: "column", gap: 8
      }}>
        <div style={{ color: "#fff", fontWeight: 700, fontSize: 18, marginBottom: 24 }}>
          Smart<span style={{ color: "#378ADD" }}>Studio</span>
        </div>

        {["kamera", "users"].map((p) => (
          <button key={p} onClick={() => setActivePage(p)} style={{
            background: activePage === p ? "#185FA5" : "transparent",
            color: "#fff", border: "none", borderRadius: 8,
            padding: "10px 14px", textAlign: "left",
            cursor: "pointer", fontWeight: activePage === p ? 700 : 400,
            textTransform: "capitalize"
          }}>
            {p === "kamera" ? "📷 Kamera" : "👥 Manajemen User"}
          </button>
        ))}

        {/* Info user yang login */}
        <div style={{ marginTop: "auto", color: "#94a3b8", fontSize: 12 }}>
          <div style={{ color: "#fff", fontWeight: 600 }}>{user?.username}</div>
          <div>{user?.email}</div>
          <div style={{
            display: "inline-block", marginTop: 4, padding: "2px 8px",
            background: "#185FA5", borderRadius: 20, color: "#fff",
            fontSize: 11, fontWeight: 700, textTransform: "uppercase"
          }}>
            {user?.role}
          </div>
          <button onClick={onLogout} style={{
            marginTop: 16, width: "100%", background: "#ef4444",
            color: "#fff", border: "none", borderRadius: 8,
            padding: "8px 0", cursor: "pointer", fontWeight: 600
          }}>
            Logout
          </button>
        </div>
      </aside>

      {/* ── Konten utama ── */}
      <div className="admin-main" style={{ flex: 1, padding: 24 }}>

        {/* Header */}
        <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center", marginBottom: 24 }}>
          <h1 style={{ fontSize: 20, fontWeight: 700, margin: 0 }}>
            {activePage === "kamera" ? "Manajemen Kamera" : "Manajemen User"}
          </h1>
          <input
            placeholder="Cari..."
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

        {/* ── Halaman Kamera ── */}
        {activePage === "kamera" && (
          <>
            {/* Stat Cards */}
            {stats && (
              <div style={{ display: "grid", gridTemplateColumns: "repeat(4, 1fr)", gap: 16, marginBottom: 24 }}>
                {[
                  { label: "Total Kamera",  value: cameras.length, color: "#185FA5" },
                  { label: "Aktif",         value: aktif,          color: "#22c55e" },
                  { label: "Maintenance",   value: maintenance,    color: "#f59e0b" },
                  { label: "Offline",       value: offline,        color: "#ef4444" },
                ].map((s) => (
                  <div key={s.label} style={{
                    background: "#fff", borderRadius: 12, padding: "16px 20px",
                    boxShadow: "0 1px 4px rgba(0,0,0,0.08)"
                  }}>
                    <div style={{ fontSize: 28, fontWeight: 800, color: s.color }}>{s.value}</div>
                    <div style={{ fontSize: 13, color: "#64748b", marginTop: 4 }}>{s.label}</div>
                  </div>
                ))}
              </div>
            )}

            {loadingCam && <p style={{ color: "#64748b" }}>Memuat data kamera...</p>}

            {/* Tabel kamera */}
            {!loadingCam && (
              <div style={{ background: "#fff", borderRadius: 12, overflow: "hidden", boxShadow: "0 1px 4px rgba(0,0,0,0.08)" }}>
                <table style={{ width: "100%", borderCollapse: "collapse" }}>
                  <thead>
                    <tr style={{ background: "#f8fafc" }}>
                      {["Nama", "Lokasi", "Status", "Aksi"].map((h) => (
                        <th key={h} style={{
                          padding: "12px 16px", textAlign: "left",
                          fontSize: 13, fontWeight: 600, color: "#475569",
                          borderBottom: "1px solid #e2e8f0"
                        }}>{h}</th>
                      ))}
                    </tr>
                  </thead>
                  <tbody>
                    {filtered.length === 0 ? (
                      <tr>
                        <td colSpan={4} style={{ padding: 32, textAlign: "center", color: "#94a3b8" }}>
                          Tidak ada data kamera
                        </td>
                      </tr>
                    ) : (
                      filtered.map((c) => (
                        <tr key={c.id} style={{ borderBottom: "1px solid #f1f5f9" }}>
                          <td style={{ padding: "12px 16px", fontWeight: 600 }}>{c.nama}</td>
                          <td style={{ padding: "12px 16px", color: "#64748b" }}>{c.lokasi}</td>
                          <td style={{ padding: "12px 16px" }}>
                            <span style={{
                              padding: "3px 10px", borderRadius: 20, fontSize: 12, fontWeight: 600,
                              background: c.status === "aktif" ? "#dcfce7" : c.status === "maintenance" ? "#fef3c7" : "#fee2e2",
                              color: c.status === "aktif" ? "#16a34a" : c.status === "maintenance" ? "#d97706" : "#dc2626",
                            }}>
                              {c.status}
                            </span>
                          </td>
                          <td style={{ padding: "12px 16px" }}>
                            <button onClick={() => handleDelete(c.id)} style={{
                              background: "#fef2f2", color: "#ef4444", border: "1px solid #fecaca",
                              borderRadius: 6, padding: "5px 12px", cursor: "pointer", fontSize: 13
                            }}>
                              Hapus
                            </button>
                          </td>
                        </tr>
                      ))
                    )}
                  </tbody>
                </table>
              </div>
            )}
          </>
        )}

        {/* ── Halaman Manajemen User ── */}
        {activePage === "users" && (
          <div style={{ background: "#fff", borderRadius: 12, overflow: "hidden", boxShadow: "0 1px 4px rgba(0,0,0,0.08)" }}>
            <table style={{ width: "100%", borderCollapse: "collapse" }}>
              <thead>
                <tr style={{ background: "#f8fafc" }}>
                  {["Username", "Email", "No HP", "Role", "Aksi"].map((h) => (
                    <th key={h} style={{
                      padding: "12px 16px", textAlign: "left",
                      fontSize: 13, fontWeight: 600, color: "#475569",
                      borderBottom: "1px solid #e2e8f0"
                    }}>{h}</th>
                  ))}
                </tr>
              </thead>
              <tbody>
                {users.length === 0 ? (
                  <tr>
                    <td colSpan={5} style={{ padding: 32, textAlign: "center", color: "#94a3b8" }}>
                      Tidak ada data user
                    </td>
                  </tr>
                ) : (
                  users
                    .filter((u) =>
                      u.username?.toLowerCase().includes(search.toLowerCase()) ||
                      u.email?.toLowerCase().includes(search.toLowerCase())
                    )
                    .map((u) => (
                      <tr key={u.id} style={{ borderBottom: "1px solid #f1f5f9" }}>
                        <td style={{ padding: "12px 16px", fontWeight: 600 }}>{u.username}</td>
                        <td style={{ padding: "12px 16px", color: "#64748b" }}>{u.email}</td>
                        <td style={{ padding: "12px 16px", color: "#64748b" }}>{u.no_hp}</td>
                        <td style={{ padding: "12px 16px" }}>
                          <span style={{
                            padding: "3px 10px", borderRadius: 20, fontSize: 12, fontWeight: 600,
                            background: u.role === "admin" ? "#dbeafe" : "#f1f5f9",
                            color: u.role === "admin" ? "#1d4ed8" : "#475569",
                          }}>
                            {u.role}
                          </span>
                        </td>
                        <td style={{ padding: "12px 16px" }}>
                          <button onClick={() => handleDeleteUser(u.id)} style={{
                            background: "#fef2f2", color: "#ef4444", border: "1px solid #fecaca",
                            borderRadius: 6, padding: "5px 12px", cursor: "pointer", fontSize: 13
                          }}>
                            Hapus
                          </button>
                        </td>
                      </tr>
                    ))
                )}
              </tbody>
            </table>
          </div>
        )}
      </div>
    </div>
  );
}