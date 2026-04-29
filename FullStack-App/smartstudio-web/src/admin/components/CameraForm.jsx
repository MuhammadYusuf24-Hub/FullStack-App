import React, { useState } from "react";
import { createKamera } from "../../user/services/authService";

const initialState = {
  nama: "",
  serial: "",
  lokasi: "",
  zona: "",
  merek: "",
  resolusi: "1080p",
  ip: "",
  port: "",
  tanggal: "",
  teknisi: "",
  status: "aktif",
  keterangan: "",
};

export default function CameraForm({ onSaved }) {
  const [form, setForm] = useState(initialState);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState("");

  const set = (field, val) => setForm((f) => ({ ...f, [field]: val }));

  const handleSubmit = async () => {
    setError("");
    if (!form.nama || !form.serial || !form.lokasi) {
      setError("Nama, Serial, dan Lokasi wajib diisi!");
      return;
    }
    setLoading(true);
    try {
      // Pakai fetch via authService (TANPA axios)
      const data = await createKamera(form);
      onSaved(data.data); // callback → update tabel
      setForm(initialState);
      alert(`Kamera "${form.nama}" berhasil disimpan!`);
    } catch (err) {
      setError(err.message || "Gagal menyimpan. Periksa koneksi atau server.");
      console.error(err);
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="form-section">
      <div className="form-sec-header">
        <div>
          <div className="form-sec-title">Tambah Kamera Baru</div>
          <div className="form-sec-sub">
            Isi data kamera yang akan didaftarkan ke sistem
          </div>
        </div>
        <span className="form-sec-badge">Form Input</span>
      </div>

      {error && (
        <div className="form-error" style={{
          background: "#fef2f2",
          border: "1px solid #fca5a5",
          color: "#dc2626",
          padding: "10px 14px",
          borderRadius: 8,
          margin: "0 24px",
          fontSize: 13,
        }}>
          ⚠ {error}
        </div>
      )}

      <div className="form-body">
        <div className="fg">
          <label>Nama Kamera *</label>
          <input
            placeholder="Contoh: CAM-LOBBY-01"
            value={form.nama}
            onChange={(e) => set("nama", e.target.value)}
          />
        </div>
        <div className="fg">
          <label>ID / Serial Number *</label>
          <input
            placeholder="Contoh: SN-20250426-001"
            value={form.serial}
            onChange={(e) => set("serial", e.target.value)}
          />
        </div>
        <div className="fg">
          <label>Lokasi Pemasangan *</label>
          <input
            placeholder="Contoh: Lobby Utama Lt. 1"
            value={form.lokasi}
            onChange={(e) => set("lokasi", e.target.value)}
          />
        </div>
        <div className="fg">
          <label>Zona Area</label>
          <select
            value={form.zona}
            onChange={(e) => set("zona", e.target.value)}
          >
            <option value="">— Pilih Zona —</option>
            <option value="A">Zona A – Lobby &amp; Pintu Masuk</option>
            <option value="B">Zona B – Ruang Kerja</option>
            <option value="C">Zona C – Parkiran</option>
            <option value="D">Zona D – Koridor</option>
            <option value="E">Zona E – Server Room</option>
          </select>
        </div>
        <div className="fg">
          <label>Merek / Model Kamera</label>
          <input
            placeholder="Contoh: Hikvision DS-2CD2143G2-I"
            value={form.merek}
            onChange={(e) => set("merek", e.target.value)}
          />
        </div>
        <div className="fg">
          <label>Resolusi</label>
          <select
            value={form.resolusi}
            onChange={(e) => set("resolusi", e.target.value)}
          >
            <option value="720p">720p (HD)</option>
            <option value="1080p">1080p (Full HD)</option>
            <option value="2K">2K (QHD)</option>
            <option value="4K">4K (Ultra HD)</option>
          </select>
        </div>
        <div className="fg">
          <label>Alamat IP (RTSP)</label>
          <input
            placeholder="Contoh: 192.168.1.101"
            value={form.ip}
            onChange={(e) => set("ip", e.target.value)}
          />
        </div>
        <div className="fg">
          <label>Port</label>
          <input
            placeholder="Contoh: 554"
            value={form.port}
            onChange={(e) => set("port", e.target.value)}
          />
        </div>
        <div className="fg">
          <label>Tanggal Pemasangan</label>
          <input
            type="date"
            value={form.tanggal}
            onChange={(e) => set("tanggal", e.target.value)}
          />
        </div>
        <div className="fg">
          <label>Teknisi Pemasang</label>
          <input
            placeholder="Nama teknisi"
            value={form.teknisi}
            onChange={(e) => set("teknisi", e.target.value)}
          />
        </div>

        <div className="fg full">
          <label>Status Kamera</label>
          <div className="status-row">
            {["aktif", "nonaktif", "maintenance"].map((s) => (
              <div
                key={s}
                className={`status-opt${form.status === s ? ` active-${s}` : ""}`}
                onClick={() => set("status", s)}
              >
                {s.charAt(0).toUpperCase() + s.slice(1)}
              </div>
            ))}
          </div>
        </div>

        <div className="fg full">
          <label>Keterangan Tambahan</label>
          <textarea
            placeholder="Tulis catatan khusus mengenai kamera ini..."
            value={form.keterangan}
            onChange={(e) => set("keterangan", e.target.value)}
          />
        </div>
      </div>

      <div className="form-actions">
        <button className="btn-reset" onClick={() => { setForm(initialState); setError(""); }}>
          Reset Form
        </button>
        <button className="btn-save" onClick={handleSubmit} disabled={loading}>
          {loading ? "Menyimpan..." : "Simpan Kamera"}
        </button>
      </div>
    </div>
  );
}