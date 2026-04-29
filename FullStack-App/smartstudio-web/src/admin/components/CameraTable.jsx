import React from "react";

const BADGE = {
  aktif: "badge-on",
  nonaktif: "badge-off",
  maintenance: "badge-maint",
};

export default function CameraTable({ cameras, onDelete }) {
  const handleDelete = async (id, nama) => {
    if (!window.confirm(`Hapus kamera "${nama}"?`)) return;
    try {
      await axios.delete(`/api/kamera/${id}`);
      onDelete(id);
    } catch {
      alert("Gagal menghapus kamera.");
    }
  };

  return (
    <div className="table-section">
      <div className="table-header">
        <div className="table-title">Daftar Kamera Terdaftar</div>
        <div className="table-actions">
          <button className="tbl-btn">
            <svg viewBox="0 0 24 24">
              <polyline points="23 6 13.5 15.5 8.5 10.5 1 18" />
              <polyline points="17 6 23 6 23 12" />
            </svg>
            Export
          </button>
          <button className="tbl-btn">
            <svg viewBox="0 0 24 24">
              <line x1="8" y1="6" x2="21" y2="6" />
              <line x1="8" y1="12" x2="21" y2="12" />
              <line x1="8" y1="18" x2="21" y2="18" />
              <line x1="3" y1="6" x2="3.01" y2="6" />
              <line x1="3" y1="12" x2="3.01" y2="12" />
              <line x1="3" y1="18" x2="3.01" y2="18" />
            </svg>
            Filter
          </button>
        </div>
      </div>

      <table>
        <thead>
          <tr>
            <th>#</th>
            <th>Nama Kamera</th>
            <th>Zona</th>
            <th>IP Address</th>
            <th>Resolusi</th>
            <th>Status</th>
            <th>Aksi</th>
          </tr>
        </thead>
        <tbody>
          {cameras.map((cam, i) => (
            <tr key={cam.id}>
              <td style={{ color: "#6a8aaa", fontWeight: 600 }}>
                {String(i + 1).padStart(2, "0")}
              </td>
              <td>
                <div className="cam-name">{cam.nama}</div>
                <div className="cam-loc">{cam.lokasi}</div>
              </td>
              <td>Zona {cam.zona || "-"}</td>
              <td style={{ fontFamily: "monospace", fontSize: 12 }}>
                {cam.ip || "-"}
              </td>
              <td>{cam.resolusi}</td>
              <td>
                <span className={`badge ${BADGE[cam.status] || "badge-off"}`}>
                  {cam.status.charAt(0).toUpperCase() + cam.status.slice(1)}
                </span>
              </td>
              <td>
                <button className="act-btn">Edit</button>
                <button
                  className="act-btn del"
                  onClick={() => handleDelete(cam.id, cam.nama)}
                >
                  Hapus
                </button>
              </td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
}
