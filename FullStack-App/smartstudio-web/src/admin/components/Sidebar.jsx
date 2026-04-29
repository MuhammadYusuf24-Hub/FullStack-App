import React from "react";

const menuUtama = [
  {
    key: "kamera",
    label: "Kamera",
    icon: (
      <>
        <rect x="2" y="7" width="20" height="14" rx="2" />
        <path d="M16 3l2 4H6l2-4z" />
        <circle cx="12" cy="14" r="3" />
      </>
    ),
  },
  {
    key: "dashboard",
    label: "Dashboard",
    icon: (
      <>
        <rect x="3" y="3" width="7" height="7" />
        <rect x="14" y="3" width="7" height="7" />
        <rect x="14" y="14" width="7" height="7" />
        <rect x="3" y="14" width="7" height="7" />
      </>
    ),
  },
  {
    key: "monitor",
    label: "Live Monitor",
    icon: (
      <>
        <rect x="2" y="3" width="20" height="14" rx="2" />
        <line x1="8" y1="21" x2="16" y2="21" />
        <line x1="12" y1="17" x2="12" y2="21" />
      </>
    ),
  },
  {
    key: "rekaman",
    label: "Rekaman",
    icon: (
      <>
        <circle cx="12" cy="12" r="10" />
        <polygon points="10 8 16 12 10 16 10 8" />
      </>
    ),
  },
];

const menuManajemen = [
  {
    key: "pengguna",
    label: "Pengguna",
    icon: (
      <>
        <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2" />
        <circle cx="9" cy="7" r="4" />
        <path d="M23 21v-2a4 4 0 0 0-3-3.87M16 3.13a4 4 0 0 1 0 7.75" />
      </>
    ),
  },
  {
    key: "lokasi",
    label: "Lokasi",
    icon: (
      <>
        <path d="M21 10c0 7-9 13-9 13S3 17 3 10a9 9 0 0 1 18 0z" />
        <circle cx="12" cy="10" r="3" />
      </>
    ),
  },
  {
    key: "laporan",
    label: "Laporan",
    icon: (
      <>
        <line x1="18" y1="20" x2="18" y2="10" />
        <line x1="12" y1="20" x2="12" y2="4" />
        <line x1="6" y1="20" x2="6" y2="14" />
      </>
    ),
  },
  {
    key: "pengaturan",
    label: "Pengaturan",
    icon: (
      <>
        <circle cx="12" cy="12" r="3" />
        <path d="M19.07 4.93a10 10 0 0 1 0 14.14M4.93 4.93a10 10 0 0 0 0 14.14" />
      </>
    ),
  },
];

const SbIcon = ({ children }) => <svg viewBox="0 0 24 24">{children}</svg>;

export default function Sidebar({ activePage, onChangePage, user, onLogout }) {
  return (
    <aside className="sb">
      <div className="sb-logo">
        <div className="sb-logo-icon">
          <svg viewBox="0 0 24 24">
            <path d="M12 2L2 7l10 5 10-5-10-5z" />
            <polyline points="2 17 12 22 22 17" />
            <polyline points="2 12 12 17 22 12" />
          </svg>
        </div>
        <span className="sb-logo-text">Smart Studio</span>
      </div>

      <div className="sb-section">Main</div>
      {menuUtama.map((m) => (
        <div
          key={m.key}
          className={`sb-item${activePage === m.key ? " active" : ""}`}
          onClick={() => onChangePage(m.key)}
        >
          <SbIcon>{m.icon}</SbIcon>
          {m.label}
        </div>
      ))}

      <div className="sb-section">Manajemen</div>
      {menuManajemen.map((m) => (
        <div
          key={m.key}
          className={`sb-item${activePage === m.key ? " active" : ""}`}
          onClick={() => onChangePage(m.key)}
        >
          <SbIcon>{m.icon}</SbIcon>
          {m.label}
        </div>
      ))}

      <div className="sb-bottom">
        <div className="sb-user" onClick={onLogout}>
          <div className="sb-avatar">
            {user?.name?.slice(0, 2).toUpperCase() || "AD"}
          </div>
          <div>
            <div className="sb-user-name">{user?.name || "Admin"}</div>
            <div className="sb-user-role">{user?.role || "Super Admin"}</div>
          </div>
        </div>
      </div>
    </aside>
  );
}
