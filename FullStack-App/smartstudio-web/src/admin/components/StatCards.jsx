import React from "react";

export default function StatCards({
  totalKamera,
  aktif,
  maintenance,
  offline,
}) {
  const cards = [
    {
      label: "Total Kamera",
      value: totalKamera,
      sub: "+2 bulan ini",
      iconClass: "ic-blue",
      icon: (
        <>
          <rect x="2" y="7" width="20" height="14" rx="2" />
          <path d="M16 3l2 4H6l2-4z" />
          <circle cx="12" cy="14" r="3" />
        </>
      ),
    },
    {
      label: "Aktif",
      value: aktif,
      sub: `${Math.round((aktif / totalKamera) * 100)}% dari total`,
      iconClass: "ic-green",
      icon: <polyline points="20 6 9 17 4 12" />,
    },
    {
      label: "Maintenance",
      value: maintenance,
      sub: "Perlu perhatian",
      iconClass: "ic-amber",
      icon: (
        <>
          <path d="M10.29 3.86L1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z" />
          <line x1="12" y1="9" x2="12" y2="13" />
          <line x1="12" y1="17" x2="12.01" y2="17" />
        </>
      ),
    },
    {
      label: "Offline",
      value: offline,
      sub: "Butuh perbaikan",
      iconClass: "ic-red",
      icon: (
        <>
          <circle cx="12" cy="12" r="10" />
          <line x1="15" y1="9" x2="9" y2="15" />
          <line x1="9" y1="9" x2="15" y2="15" />
        </>
      ),
    },
  ];

  return (
    <div className="stats-row">
      {cards.map((c) => (
        <div className="stat-card" key={c.label}>
          <div className="stat-card-top">
            <div className="stat-card-label">{c.label}</div>
            <div className={`stat-card-icon ${c.iconClass}`}>
              <svg viewBox="0 0 24 24">{c.icon}</svg>
            </div>
          </div>
          <div className="stat-card-num">{c.value}</div>
          <div className="stat-card-sub">{c.sub}</div>
        </div>
      ))}
    </div>
  );
}
