// src/services/authService.js
// Menggunakan fetch biasa, TANPA axios

const BASE_URL = "http://127.0.0.1:8000/api";

// ── Helper ambil token dari localStorage ──
const getToken = () => localStorage.getItem("token");

// ── Helper header dengan token ──
const authHeader = () => ({
  "Content-Type": "application/json",
  Authorization: `Bearer ${getToken()}`,
});

const safeJson = async (res) => {
  const contentType = res.headers.get("content-type");
  if (!contentType || !contentType.includes("application/json")) {
    throw new Error("Server error. Pastikan Laravel berjalan dengan benar.");
  }
  return res.json();
};

// ============================================================
// PUBLIC — Tidak butuh token
// ============================================================

export const login = async (email, password) => {
  const res = await fetch(`${BASE_URL}/login`, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({ email, password }),
  });

  const data = await res.json();
  if (!res.ok) throw new Error(data.message || "Login gagal");

  localStorage.setItem("token", data.token);
  localStorage.setItem("user", JSON.stringify(data.user));
  localStorage.setItem("role", data.user.role);

  return data;
};

export const register = async (formData) => {
  const res = await fetch(`${BASE_URL}/register`, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify(formData),
  });

  const data = await res.json();
  if (!res.ok) throw new Error(data.message || "Registrasi gagal");
  return data;
};

export const forgotPassword = async (email) => {
  const res = await fetch(`${BASE_URL}/lupapass`, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({ email }),
  });

  const data = await res.json();
  if (!res.ok) throw new Error(data.message || "Email tidak ditemukan");
  return data;
};

export const verifyOtp = async (email, otp) => {
  const res = await fetch(`${BASE_URL}/verifotp`, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({ email, otp }),
  });

  const data = await res.json();
  if (!res.ok) throw new Error(data.message || "OTP tidak valid");
  return data;
};

export const resetPassword = async (email, otp, password) => {
  const res = await fetch(`${BASE_URL}/ubahpass`, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({ email, otp, password }),
  });

  const data = await res.json();
  if (!res.ok) throw new Error(data.message || "Gagal mengubah password");
  return data;
};

// ============================================================
// PROTECTED — Butuh token
// ============================================================

export const logout = async () => {
  try {
    await fetch(`${BASE_URL}/logout`, {
      method: "POST",
      headers: authHeader(),
    });
  } catch {
    // abaikan error network saat logout
  } finally {
    localStorage.removeItem("token");
    localStorage.removeItem("user");
    localStorage.removeItem("role");
  }
};

export const getDashboardStats = async () => {
  const res = await fetch(`${BASE_URL}/admin/dashboard`, {
    method: "GET",
    headers: authHeader(),
  });
  const data = await res.json();
  if (!res.ok) throw new Error(data.message || "Gagal ambil statistik");
  return data;
};

export const getAllUsers = async () => {
  const res = await fetch(`${BASE_URL}/admin/users`, {
    method: "GET",
    headers: authHeader(),
  });
  const data = await res.json();
  if (!res.ok) throw new Error(data.message || "Gagal ambil data user");
  return data;
};

export const deleteUser = async (id) => {
  const res = await fetch(`${BASE_URL}/admin/users/${id}`, {
    method: "DELETE",
    headers: authHeader(),
  });
  const data = await res.json();
  if (!res.ok) throw new Error(data.message || "Gagal hapus user");
  return data;
};

export const getKamera = async () => {
  const res = await fetch(`${BASE_URL}/kamera`, {
    method: "GET",
    headers: authHeader(),
  });
  const data = await res.json();
  if (!res.ok) throw new Error(data.message || "Gagal ambil data kamera");
  return data;
};

export const createKamera = async (formData) => {
  const res = await fetch(`${BASE_URL}/kamera`, {
    method: "POST",
    headers: authHeader(),
    body: JSON.stringify(formData),
  });
  const data = await res.json();
  if (!res.ok) throw new Error(data.message || "Gagal simpan kamera");
  return data;
};

export const deleteKamera = async (id) => {
  const res = await fetch(`${BASE_URL}/kamera/${id}`, {
    method: "DELETE",
    headers: authHeader(),
  });
  const data = await res.json();
  if (!res.ok) throw new Error(data.message || "Gagal hapus kamera");
  return data;
};

// ============================================================
// HELPER — Cek status login dan role
// ============================================================

export const isLoggedIn = () => !!getToken();

export const getCurrentUser = () => {
  const raw = localStorage.getItem("user");
  return raw ? JSON.parse(raw) : null;
};

export const isAdmin = () => localStorage.getItem("role") === "admin";
