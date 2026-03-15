const TOKEN_KEY = "token";

export function salvarToken(token) {
  localStorage.setItem(TOKEN_KEY, token);
}

export function obterToken() {
  return localStorage.getItem(TOKEN_KEY);
}

export function estaAutenticado() {
  return !!obterToken();
}

export function logout() {
  localStorage.removeItem(TOKEN_KEY);
  window.location.href = "/login.html";
}

export function authHeaders() {
  const token = obterToken();
  return token ? { Authorization: `Bearer ${token}` } : {};
}