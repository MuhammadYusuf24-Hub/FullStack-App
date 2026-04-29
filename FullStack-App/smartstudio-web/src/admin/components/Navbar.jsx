import React from "react";

const PAGE_LABELS = {
  kamera: "Manajemen Kamera",
  dashboard: "Dashboard Utama",
  monitor: "Live Monitor",
  rekaman: "Rekaman & Playback",
  pengguna: "Manajemen Pengguna",
  lokasi: "Manajemen Lokasi",
  laporan: "Laporan & Analitik",
  pengaturan: "Pengaturan Sistem",
};

export default function Navbar({ activePage, user, search, onSearch }) {
  return (
    <nav className="nb">
      <div className="nb-title">{PAGE_LABELS[activePage] || "Dashboard"}</div>

      <div className="nb-search">
        <svg viewBox="0 0 24 24">
          <circle cx="11" cy="11" r="8" />
          <line x1="21" y1="21" x2="16.65" y2="16.65" />
        </svg>
        <input
          placeholder="Cari kamera, lokasi..."
          value={search}
          onChange={(e) => onSearch(e.target.value)}
        />
      </div>

      <button className="nb-icon-btn nb-badge">
        <svg viewBox="0 0 24 24">
          <path d="M18 8A6 6 0 0 0 6 8c0 7-3 9-3 9h18s-3-2-3-9" />
          <path d="M13.73 21a2 2 0 0 1-3.46 0" />
        </svg>
      </button>

      <button className="nb-icon-btn">
        <svg viewBox="0 0 24 24">
          <circle cx="12" cy="12" r="3" />
          <path d="M19.07 4.93a10 10 0 0 1 0 14.14M4.93 4.93a10 10 0 0 0 0 14.14" />
        </svg>
      </button>

      <div className="nb-admin">
        <div className="nb-admin-avatar">
          {user?.name?.slice(0, 2).toUpperCase() || "AD"}
        </div>
        <div>
          <div className="nb-admin-name">{user?.name || "Admin"}</div>
          <div className="nb-admin-role">{user?.role || "Super Admin"}</div>
        </div>
      </div>
    </nav>
  );
}
