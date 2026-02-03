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
    tipo_midia: str

from pydantic import BaseModel
from typing import Optional

class Interacao(BaseModel):
    id_perfil: int
    id_publicacao: int
    tipo_interacao: str 
    texto: Optional[str] = None

class interacao_comentario(BaseModel):
    id_interacao: int
    texto: str

class interacao_curtida(BaseModel):
    id_interacao: int

class Mensagem(BaseModel):
    id_conversa: int
    id_perfil: int
    conteudo: str

class Conversa(BaseModel):
    id_conversa: int
    tipo_conversa: str

#entrar em contato com o meu mysql
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

@app.get("/ver/{id_perfil}")
def ver_seguidores(id_perfil: int):
    con = get_contato()
    cur = con.cursor(dictionary=True)

    cur.execute(
        """
        SELECT *
        FROM segue
        WHERE user_seguido = %s
        """,
        (id_perfil,)
    )

    seguidores = cur.fetchall()

    cur.close()
    con.close()

    return seguidores


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
        criar_conversa(dados.user_seguidor, dados.user_seguido)
        

    #se quiser seguir dnv um seguidor 
    except mysql.connector.errors.IntegrityError:
        return {"msg":"follow inválido (já segue ou usuário não existe)"}
        
    
    cur.close()
    con.close()

    return {"msg": "follow realizado"}

@app.post("/publicar")
def publicar(pub: Publicacao):
    con = get_contato()
    cur = con.cursor()

    # cria publicação
    cur.execute(
        """
        INSERT INTO Publicacao (id_perfil)
        VALUES (%s)
        """,
        (pub.id_perfil,)
    )

    id_publicacao = cur.lastrowid

    # cria arquivo de mídia
    cur.execute(
        """
        INSERT INTO Arquivo_midia (id_publicacao, tipo_midia)
        VALUES (%s, %s)
        """,
        (id_publicacao, pub.tipo_midia)
    )

    con.commit()
    cur.close()
    con.close()

    return {"msg": "A publicação foi enviada"}

@app.post("/interacao")
def interagir(i : Interacao):
    con = get_contato()
    cur = con.cursor()
    try:
        cur.execute(
            """
            INSERT INTO interacao (id_perfil, id_publicacao)
            VALUES(%s, %s)
            """,(i.id_perfil, i.id_publicacao)
        )
        id_interacao = cur.lastrowid

        if i.tipo_interacao == "curtida":
            cur.execute(
                "INSERT INTO interacao_curtida (id_interacao)"
                "VALUES(%s)", (id_interacao,)
            )
        if i.tipo_interacao == "comentario":
            cur.execute(
                "INSERT INTO interacao_comentario (id_interacao, texto)"
                "VALUES(%s, %s)", (id_interacao, i.texto)
            )   
    except mysql.connector.errors.IntegrityError:
        return {"msg":"Publicacao inexistente"}
    con.commit()
    cur.close()
    con.close()

    
    return {"msg":"Interação concluida"}

@app.post("/mensagem")
def mandar_msg(msg: Mensagem):
    con = get_contato()
    cur = con.cursor()

    cur.execute(
        """
        INSERT INTO Mensagem (id_conversa, id_perfil, conteudo)
        VALUES(%s, %s, %s)
        """,(msg.id_conversa, msg.id_perfil, msg.conteudo)
    )
    con.commit()
    cur.close()
    con.close()
    return {"msg":"Mensagem enviada"}

@app.post("/conversa")
def criar_conversa(seguidor, seguido):
    con = get_contato()
    cur = con.cursor(dictionary=True)
    #verifica se o id ja tem uma conversa criada e se tiver, agrupa
    cur.execute(
        """
        SELECT id_conversa
        FROM participa
        WHERE id_perfil in (%s, %s)
        GROUP BY id_conversa
        HAVING COUNT(DISTINCT id_perfil) = 2;
        """,
        (seguidor, seguido)
    )
    conversa = cur.fetchone()
    if conversa:
        cur.close()
        con.close()
        return {
            "msg": "Vocês já são amigos"
        }
    #cria a conversa
    cur.execute(
        """
        INSERT INTO conversa (tipo_conversa)
        VALUES(%s)

        """,("privado",)

    )
    
    #funcao pra busrcar a chave primaria auto_incremente que acbou de ser criada
    id_conversa = cur.lastrowid

    participa(cur, seguidor, id_conversa)
    participa(cur, seguido, id_conversa)
  
    con.commit()
    cur.close()
    con.close()
    return {"msg":"Chat criado"}

@app.post("/participa")
def participa(cur, perfil, id_conversa):
    cur.execute(
        """
        INSERT INTO participa (id_perfil, id_conversa)
        VALUES(%s, %s)

        """,(perfil, id_conversa)

    )
    return {"msg":"Chat criado"}
