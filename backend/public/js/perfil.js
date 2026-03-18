async function carregarPerfil() {
    const token = localStorage.getItem("token");

    console.log("TOKEN:", token);

    if (!token) {
        window.location.href = "login.html";
        return;
    }

    try {
        const resposta = await fetch("https://cantinhos-encantados-bh-production.up.railway.app/perfil", {
            method: "GET",
            headers: {
                Authorization: "Bearer " + token
            }
        });

        console.log("STATUS:", resposta.status);

        // 🔒 Se não autorizado → volta pro login
        if (resposta.status === 401 || resposta.status === 403) {
            localStorage.removeItem("token");
            window.location.href = "login.html";
            return;
        }

        if (!resposta.ok) {
            throw new Error("Erro na requisição");
        }

        const dados = await resposta.json();
        console.log("DADOS:", dados);

        const user = dados || {};

        // ✅ Nome
        const nome = user.nome || "Nome não encontrado";

        // ✅ Data (se existir)
        let dataFormatada = "Não informada";

        if (user.data_nascimento || user.dataNascimento) {
            const data = new Date(user.data_nascimento || user.dataNascimento);

            if (!isNaN(data)) {
                dataFormatada = data.toLocaleDateString("pt-BR");
            }
        }

        // ✅ Tipo
        const tipo = user.tipo || "Não informado";

        // ✅ Atualizar HTML
        document.getElementById("userName").textContent = nome;
        document.getElementById("userBirth").textContent = dataFormatada;
        document.getElementById("userType").textContent = tipo;

        // 🔥 Log correto (dentro do escopo)
        console.log("USUARIO DO BANCO:", user);

    } catch (erro) {
        console.error("Erro ao carregar perfil:", erro);
    }
}

function logout() {
    localStorage.removeItem("token");
    window.location.href = "login.html";
}

carregarPerfil();