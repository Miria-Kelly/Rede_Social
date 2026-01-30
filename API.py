from fastapi import FastAPI
from pydantic import BaseModel
import sqlite3
import mysql.connector
from fastapi.middleware.cors import CORSMiddleware

app = FastAPI()

#nao sei oq significa nada o chat mandou colocar pra fazer conexao da api com o front que ele criou
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

#criar os requisitos da tabela
class Perfil(BaseModel):
    usuario: str
    email: str
    nome: str
    senha: str
    perfil_aberto: bool

#entrar em contato com o mysql
def get_contato():
    return mysql.connector.connect(
        host="localhost",
        user="root",
        password="#Mi31032005",
        database="projeto_bd"
    )


@app.post("/perfil")
def criar_perfil(perfil: Perfil):
    con = get_contato()
    #pra poder escrever no sql
    cur = con.cursor()

    cur.execute(
        """
        INSERT INTO Perfil (usuario, email, nome, senha, perfil_aberto)
        VALUES (%s, %s, %s, %s, %s)
        """,
        (perfil.usuario, perfil.email, perfil.nome, perfil.senha, perfil.perfil_aberto)
    )

    con.commit()
    cur.close()
    con.close()
    return {"msg": "Perfil criado"}

