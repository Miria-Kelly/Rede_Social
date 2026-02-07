from fastapi import FastAPI, UploadFile, File, Form
from pydantic import BaseModel
import mysql.connector
from typing import Optional
from drive.MidiaDrive import upload_google_drive
import os


app = FastAPI()

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
        # O host deve ser o nome do serviço no docker-compose
        host=os.getenv("DB_HOST", "mysql_db"), 
        user=os.getenv("DB_USER", "user"), # Use o usuário criado no compose
        password=os.getenv("DB_PASSWORD", "user123"), # Use a senha do usuário
        database=os.getenv("DB_NAME", "projeto_bd"),
        port=3306
    )


@app.post("/criar")
def criar_perfil(perfil: Perfil):
    con = get_contato()
    cur = con.cursor()

    try:
        cur.execute(
            """
            INSERT INTO perfil (email, nome, senha, perfil_aberto)
            VALUES (%s, %s, %s, %s)
            """,
            (perfil.email, perfil.nome, perfil.senha, perfil.perfil_aberto)
        )

        con.commit()

    finally:
        cur.close()
        con.close()

    return {"msg": "Perfil criado"}


@app.get("/ver/{id_perfil}")
def ver_seguidores(id_perfil: int):
    con = get_contato()
    cur = con.cursor(dictionary=True)

    cur.execute(
        """
        SELECT user_seguidor
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
            INSERT INTO segue (user_seguidor, user_seguido)
            VALUES (%s, %s)
            """,
            (dados.user_seguidor, dados.user_seguido)   
        )
        
        criar_conversa(cur, dados.user_seguidor, dados.user_seguido)
        con.commit()

    #se quiser seguir dnv um seguidor 
    except mysql.connector.errors.IntegrityError:
        return {"msg":"follow inválido (já segue ou usuário não existe)"}
        
    
    cur.close()
    con.close()

    return {"msg": "follow realizado"}


@app.post("/publicar")
async def publicar(
    id_perfil: int = Form(...),
    tipo_midia: str = Form(...),
    imagem: UploadFile = File(...)
):

    os.makedirs("temp", exist_ok=True)

    caminho = f"temp/{imagem.filename}"

    con = get_contato()
    cur = con.cursor()

    # cria publicação
    cur.execute(
        """
        INSERT INTO publicacao (id_perfil)
        VALUES (%s)
        """,
        (id_perfil,)
    )

    id_publicacao = cur.lastrowid

    #salva imagem temporariamente
    caminho = f"temp/{imagem.filename}"
    with open(caminho, "wb") as f:
        f.write(await imagem.read())

    #upload pro GD
    link_imagem = upload_google_drive(caminho)

    #cria arquivo de mídia
    cur.execute(
        """
        INSERT INTO arquivo_midia (id_publicacao, tipo_midia, url_midia)
        VALUES (%s, %s, %s)
        """,
        (id_publicacao, tipo_midia, link_imagem)
    )
    os.remove(caminho)

    con.commit()
    cur.close()
    con.close()

    return {
        "id_publicacao": id_publicacao,
        "imagem_url": link_imagem
    }



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
        elif i.tipo_interacao == "comentario":
            cur.execute(
                "INSERT INTO interacao_comentario (id_interacao, texto)"
                "VALUES(%s, %s)", (id_interacao, i.texto)
            )
            if not i.texto:
                return {"erro": "Comentário precisa de texto"}   
        
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
        INSERT INTO mensagem (id_conversa, id_perfil, conteudo)
        VALUES(%s, %s, %s)
        """,(msg.id_conversa, msg.id_perfil, msg.conteudo)
    )
    con.commit()
    cur.close()
    con.close()
    return {"msg":"Mensagem enviada"}

def criar_conversa(cur, seguidor, seguido):
    cur.execute(
        """
        SELECT id_conversa
        FROM participa
        WHERE id_perfil IN (%s, %s)
        GROUP BY id_conversa
        HAVING COUNT(DISTINCT id_perfil) = 2
        """,
        (seguidor, seguido)
    )

    conversa = cur.fetchone()
    if conversa:
        return

    cur.execute(
        """
        INSERT INTO conversa (tipo_conversa)
        VALUES (%s)
        """,
        ("privado",)
    )
    

    id_conversa = cur.lastrowid

    participa(cur, seguidor, id_conversa)
    participa(cur, seguido, id_conversa)


def participa(cur, perfil, id_conversa):
    cur.execute(
        """
        INSERT INTO participa (id_perfil, id_conversa)
        VALUES(%s, %s)

        """,(perfil, id_conversa)

    )
    return {"msg":"Chat criado"}

@app.delete("/seguir")
def deixar_de_seguir(dados: Segue):
    con = get_contato()
    cur = con.cursor()

    cur.execute("""
        DELETE FROM segue
        WHERE user_seguidor = %s AND user_seguido = %s
    """, (dados.user_seguidor, dados.user_seguido))

    con.commit()
    cur.close()
    con.close()

    return {"msg": "Relação removida"}

@app.delete("/seguidor")
def remover_seguidor(dados: Segue):
    con = get_contato()
    cur = con.cursor()

    cur.execute("""
        DELETE FROM segue
        WHERE user_seguido = %s AND user_seguidor = %s
    """, (dados.user_seguido, dados.user_seguidor))

    con.commit()
    cur.close()
    con.close()

    return {"msg": "Relação removida"}

@app.delete("/publicacao/{id_publicacao}")
def excluir_publicacao(id_publicacao: int):
    con = get_contato()
    cur = con.cursor()

    try:
        #comentarios
        cur.execute("""
            DELETE FROM interacao_comentario
            WHERE id_interacao IN (
                SELECT id_interacao FROM Interacao
                WHERE id_publicacao = %s
            )
        """, (id_publicacao,))

        #curtidas
        cur.execute("""
            DELETE FROM interacao_curtida
            WHERE id_interacao IN (
                SELECT id_interacao FROM Interacao
                WHERE id_publicacao = %s
            )
        """, (id_publicacao,))

        #interações
        cur.execute("""
            DELETE FROM interacao
            WHERE id_publicacao = %s
        """, (id_publicacao,))

        #tipos de publicação
        cur.execute("""
            DELETE FROM publicacao_permanente
            WHERE id_publicacao = %s
        """, (id_publicacao,))

        #arquivos
        cur.execute("""
            DELETE FROM arquivo_midia
            WHERE id_publicacao = %s
        """, (id_publicacao,))

        #publicação
        cur.execute("""
            DELETE FROM publicacao
            WHERE id_publicacao = %s
        """, (id_publicacao,))

        con.commit()

    except Exception as e:
        con.rollback()
        return {"erro": str(e)}

    cur.close()
    con.close()

    return {"msg": "Publicação excluída"}

@app.delete("/perfil/{id_perfil}")
def excluir_perfil(id_perfil: int):
    con = get_contato()
    cur = con.cursor()

    try:
        cur.execute(
            "DELETE FROM perfil WHERE id_perfil = %s",
            (id_perfil,)
        )

        if cur.rowcount == 0:
            con.rollback()
            return {"msg": "Perfil não encontrado"}

        con.commit()
        return {"msg": "Perfil excluído com sucesso"}

    except Exception as e:
        con.rollback()
        return {"erro": str(e)}

    finally:
        cur.close()
        con.close()
