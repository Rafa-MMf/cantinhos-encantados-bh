async function carregarPerfil() {

 const token = localStorage.getItem("token");

 if (!token) {

  window.location.href = "login.html";

 }

 const resposta = await fetch(
  "http://localhost:3000/perfil",
  {

   headers: {
    Authorization: "Bearer " + token
   }

  }
 );

 const dados = await resposta.json();

 document.getElementById("dadosUsuario").innerHTML = `

 <p>ID: ${dados.user.id}</p>

 <p>Tipo: ${dados.user.tipo}</p>

 `;

}

function logout() {

 localStorage.removeItem("token");

 window.location.href = "login.html";

}

carregarPerfil();