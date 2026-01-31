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

#requisitos da tabela perfil
class Perfil(BaseModel):
    email: str
    nome: str
    senha: str
    perfil_aberto: bool

#requisitos da tablea segue
class Segue(BaseModel):
    user_seguidor: int
    user_seguido: int

#requisitos da tabela publicacao
class Publicacao(BaseModel):
    id_perfil: int

class Interacao(BaseModel):
    id_perfil: int
    id_publicacao: int

class interacao_comentario(BaseModel):
    id_interacao: int
    texto: str

class interacao_curtida(BaseModel):
    id_interacao: int

class Arquivo_midia(BaseModel):
    id_publicacao: int
    tipo_midia: str

class Mensagem(BaseModel):
    id_conversa: int
    id_perfil: int
    conteudo: str

#entrar em contato com o mysql
def get_contato():
    return mysql.connector.connect(
        host="localhost",
        user="root",
        password="#Mi31032005",
        database="projeto_bd"
    )


@app.post("/criar")
def criar_perfil(perfil: Perfil):
    con = get_contato()
    #pra poder escrever no sql
    cur = con.cursor()

    cur.execute(
        """
        INSERT INTO Perfil (email, nome, senha, perfil_aberto)
        VALUES (%s, %s, %s, %s)
        """,
        (perfil.email, perfil.nome, perfil.senha, perfil.perfil_aberto)
    )

    con.commit()
    cur.close()
    con.close()
    return {"msg": "Perfil criado"}

@app.get("/ver")
def ver_perfis():
    con = get_contato()
    cur = con.cursor(dictionary=True)

    cur.execute("SELECT * FROM Perfil")
    perfis = cur.fetchall()

    cur.close()
    con.close()

    return perfis


@app.post("/seguir")
def seguir(dados: Segue):
    con = get_contato()
    cur = con.cursor()

    if dados.user_seguidor == dados.user_seguido:
        return {"erro": "não pode seguir a si mesmo"}
    try:
        cur.execute(
            """
            INSERT INTO Segue (user_seguidor, user_seguido)
            VALUES (%s, %s)
            """,
            (dados.user_seguidor, dados.user_seguido)   
        )
        con.commit()
    #se quiser seguir dnv um seguidor 
    except mysql.connector.errors.IntegrityError:
        return {"msg":"follow inválido (já segue ou usuário não existe)"}
        
    
    cur.close()
    con.close()

    return {"msg": "follow realizado"}

@app.post("/publicar")
def publicar():
    con = get_contato()
    cur = con.cursor()

    cur.execute(
        """
        INSERT INTO Publicacao (id_perfil)
        VALUES(%s)
        """,()
    )