async function carregarCafeterias() {
    const res = await fetch("/cafeterias");
    const cafeterias = await res.json();

    const container = document.getElementById("listaCafeterias");

    if (cafeterias.length === 0) {
        container.innerHTML = "<p>Nenhuma cafeteria encontrada</p>";
        return;
    }

    cafeterias.forEach(cafe => {
        container.innerHTML += `
            <div class="card">
                <h3>${cafe.nome}</h3>
                <p>${cafe.bairro || ""}</p>
                <p>${cafe.faixa_preco || ""}</p>
                <a href="detalhe.html?id=${cafe.id_cafeteria}">
                    Ver mais
                </a>
            </div>
        `;
    });
}

carregarCafeterias();