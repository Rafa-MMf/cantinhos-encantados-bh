const params = new URLSearchParams(window.location.search);
const id = params.get("id");

async function carregarDetalhe() {
    const res = await fetch(`/cafeterias/${id}`);
    const cafe = await res.json();

    document.getElementById("cafeteria").innerHTML = `
        <h1>${cafe.nome}</h1>
        <p>${cafe.descricao || ""}</p>
        <p><strong>Bairro:</strong> ${cafe.bairro || ""}</p>
        <p><strong>Endereço:</strong> ${cafe.endereco || ""}</p>
        <p><strong>Telefone:</strong> ${cafe.telefone || ""}</p>
        <p><strong>Instagram:</strong> ${cafe.instagram || ""}</p>
    `;
}

carregarDetalhe();