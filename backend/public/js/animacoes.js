const loginForm = document.querySelector("form.usuario");
const signupForm = document.querySelector("form.proprietario");

const loginBtn = document.querySelector("button.usuario-btn");
const signupBtn = document.querySelector("button.proprietario-btn");

// Ir para cadastro
signupBtn.onclick = () => {
    loginForm.classList.remove("ativo");
    loginBtn.classList.remove("ativo");
    signupForm.classList.add("ativo");
    signupBtn.classList.add("ativo");
};

// Ir para login
loginBtn.onclick = () => {
    signupForm.classList.remove("ativo");
    signupBtn.classList.remove("ativo");
    loginForm.classList.add("ativo");
    loginBtn.classList.add("ativo");
};