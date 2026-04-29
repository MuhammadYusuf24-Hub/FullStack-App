import { useState } from "react";
import { register } from "../../services/authService";

export default function RegisterForm({ switchMode }) {
  const [form, setForm] = useState({});

  const change = (e) => {
    setForm({ ...form, [e.target.name]: e.target.value });
  };

  const submit = async (e) => {
    e.preventDefault();
    const data = await register(form);

    alert(data.message);

    if (data.status === "success") {
      switchMode();
    }
  };

  return (
    <div className="form-inner">
      <h2>Daftar Akun</h2>
      <p className="subtitle">Buat akun baru 🚀</p>

      <form onSubmit={submit}>
        <div className="field-group">
          <div className="field">
            <label>Nama</label>
            <input
              name="username"
              autoComplete="off"
              placeholder="Nama lengkap"
              onChange={change}
            />
          </div>

          <div className="field">
            <label>Email</label>
            <input name="email" autoComplete="off" placeholder="Email" onChange={change} />
          </div>

          <div className="field">
            <label>No HP</label>
            <input name="no_hp" autoComplete="off" placeholder="08xxxx" onChange={change} />
          </div>

          <div className="field">
            <label>Password</label>
            <input type="password" autoComplete="new-password" placeholder="Masukkan Password" name="password" onChange={change} />
          </div>
        </div>

        <button className="btn-primary">Daftar</button>
      </form>

      <p className="form-footer">
        Sudah punya akun? <a onClick={switchMode}>Masuk</a>
      </p>
    </div>
  );
}
