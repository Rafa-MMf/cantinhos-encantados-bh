PASSO 1 — Instalar Node.js
    Terminal:
        node -v
        npm -v

PASSO 2 — NÃO USAR node_modules do ZIP
    Terminal:
        cd backend
        rm -rf node_modules
        npm install

PASSO 3 — Rodar o servidor
    Terminal:
        node src/server.js
        npm run dev

PASSO 4 — Testar conexão
    Acessar: http://localhost:3000/teste-banco