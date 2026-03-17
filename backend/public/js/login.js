const form = document.getElementById("loginForm");

form.addEventListener("submit", async (e) => {

 e.preventDefault();

 const email = document.getElementById("email").value;
 const senha = document.getElementById("senha").value;

 const resposta = await fetch(
  "https://cantinhos-encantados-bh-production.up.railway.app/auth/login",
  {
   method: "POST",

   headers: {
    "Content-Type": "application/json"
   },

   body: JSON.stringify({
    email,
    senha
   })
  }
 );

 const dados = await resposta.json();

 if (dados.token) {

  localStorage.setItem("token", dados.token);

  window.location.href = "perfil.html";

 } else {

  alert(dados.message);

 }

});