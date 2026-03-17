const form = document.getElementById("cadastroForm");

form.addEventListener("submit", async (e) => {

 e.preventDefault();

 const nome = document.getElementById("nome").value;
 const email = document.getElementById("email").value;
 const senha = document.getElementById("senha").value;
 const tipo = document.getElementById("tipo").value;

 const resposta = await fetch(
  "https://cantinhos-encantados-bh-production.up.railway.app/auth/cadastro",
  {
   method: "POST",

   headers: {
    "Content-Type": "application/json"
   },

   body: JSON.stringify({
    nome,
    email,
    senha,
    tipo
   })
  }
 );

 const dados = await resposta.json();

 alert(dados.message);

 window.location.href = "login.html";

});