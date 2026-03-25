const form1 = document.getElementById("cadastroForm");
const btn = document.getElementById("btnSubmit");
const successMessage = document.getElementById("successMessage");

// ==========================
// TIPO DE CONTA (TOGGLE)
// ==========================
const btnUsuario = document.getElementById("btnUsuario");
const btnProprietario = document.getElementById("btnProprietario");
const camposProprietario = document.getElementById("camposProprietario");

let tipoConta = "COMUM";

btnUsuario.addEventListener("click", () => {
    tipoConta = "COMUM";
    btnUsuario.classList.add("ativo");
    btnProprietario.classList.remove("ativo");
    camposProprietario.style.display = "none";
});

btnProprietario.addEventListener("click", () => {
    tipoConta = "PROPRIETARIO";
    btnProprietario.classList.add("ativo");
    btnUsuario.classList.remove("ativo");
    camposProprietario.style.display = "block";
});

// ==========================
// TELEFONE
// ==========================
const telefoneInput = document.getElementById("telefone");

telefoneInput.addEventListener("input", (e) => {
    let value = e.target.value.replace(/\D/g, "");

    if (value.length >= 11) {
        value = value.replace(/(\d{2})(\d{5})(\d{4})/, "($1) $2-$3");
    } else if (value.length >= 7) {
        value = value.replace(/(\d{2})(\d{4})(\d{0,4})/, "($1) $2-$3");
    } else if (value.length >= 3) {
        value = value.replace(/(\d{2})(\d{0,5})/, "($1) $2");
    }

    e.target.value = value;
});

// ==========================
// FUNÇÕES AUXILIARES
// ==========================
function setError(input, message) {
    const field = input.closest(".field-group");
    const error = field.querySelector(".error");

    input.classList.add("error");
    input.classList.remove("success");
    error.innerText = message;
}

function setSuccess(input) {
    const field = input.closest(".field-group");
    const error = field.querySelector(".error");

    input.classList.remove("error");
    input.classList.add("success");
    error.innerText = "";
}

// ==========================
// SUBMIT
// ==========================
form1.addEventListener("submit", async (e) => {
    e.preventDefault();

    const nome = document.getElementById("nome");
    const email = document.getElementById("email");
    const senha = document.getElementById("senha");
    const confirmarSenha = document.getElementById("confirmarSenha");
    const termos = document.getElementById("termos");
    const erroTermos = document.getElementById("erro-termos");

    // Campos proprietário
    const nomeCafeteria = document.getElementById("nomeCafeteria");
    const endereco = document.getElementById("endereco");

    let valido = true;

    // Reset erros (SEM limpar inputs)
    document.querySelectorAll(".error").forEach(e => e.innerText = "");

    // Nome
    if (nome.value.trim() === "") {
        setError(nome, "Digite seu nome");
        valido = false;
    } else setSuccess(nome);

    // Email
    if (!email.value.includes("@")) {
        setError(email, "E-mail inválido");
        valido = false;
    } else setSuccess(email);

    // Senha
    if (senha.value.length < 4) {
        setError(senha, "Mínimo 4 caracteres");
        valido = false;
    } else setSuccess(senha);

    // Confirmar senha
    if (senha.value !== confirmarSenha.value) {
        setError(confirmarSenha, "As senhas não coincidem");
        valido = false;
    } else setSuccess(confirmarSenha);

    // Termos
    if (!termos.checked) {
        erroTermos.innerText = "Você precisa aceitar os termos";
        valido = false;
    } else {
        erroTermos.innerText = "";
    }

    // Validação extra proprietário
    if (tipoConta === "PROPRIETARIO") {
        if (nomeCafeteria.value.trim() === "") {
            setError(nomeCafeteria, "Informe o nome da cafeteria");
            valido = false;
        }
        if (endereco.value.trim() === "") {
            setError(endereco, "Informe o endereço");
            valido = false;
        }
    }

    if (!valido) return;

    // Loading
    btn.classList.add("loading");
    btn.innerText = "Criando conta...";

    try {
        const body = {
            nome: nome.value,
            telefone: telefoneInput.value,
            dataNascimento: document.getElementById("birthDate").value,
            email: email.value,
            senha: senha.value,
            tipo: tipoConta
        };

        // Adiciona dados extras se for proprietário
        if (tipoConta === "PROPRIETARIO") {
            body.nomeCafeteria = nomeCafeteria.value;
            body.endereco = endereco.value;
        }

        const resposta = await fetch(
            "https://cantinhos-encantados-bh-production.up.railway.app/auth/cadastro",
            {
                method: "POST",
                headers: {
                    "Content-Type": "application/json"
                },
                body: JSON.stringify(body)
            }
        );

        const dados = await resposta.json();

        if (resposta.ok) {
            successMessage.innerText = "Conta criada com sucesso!";
            successMessage.style.color = "#2ecc71";
            successMessage.classList.add("show");

            setTimeout(() => {
                window.location.href = "login.html";
            }, 1500);

        } else {
            successMessage.innerText = dados.message || "Erro ao cadastrar";
            successMessage.style.color = "#e74c3c";
            successMessage.classList.add("show");
        }

    } catch (erro) {
        successMessage.innerText = "Erro de conexão";
        successMessage.style.color = "#e74c3c";
        successMessage.classList.add("show");
    }

    btn.classList.remove("loading");
    btn.innerText = "Criar conta";
});

// ==========================
// BLOQUEIA RESET
// ==========================
form1.addEventListener("reset", (e) => {
    e.preventDefault();
});