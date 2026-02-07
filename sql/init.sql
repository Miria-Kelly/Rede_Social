CREATE TABLE IF NOT EXISTS perfil (
    id_perfil INT AUTO_INCREMENT PRIMARY KEY,
    email VARCHAR(255) NOT NULL UNIQUE,
    nome VARCHAR(20) NOT NULL,
    senha VARCHAR(20) NOT NULL,
    perfil_aberto BOOLEAN NOT NULL
);

                                  
CREATE TABLE IF NOT EXISTS segue (
    user_seguidor INT,
    user_seguido INT,
    PRIMARY KEY (user_seguidor, user_seguido),

    FOREIGN KEY (user_seguidor)
        REFERENCES perfil(id_perfil)
        ON DELETE CASCADE,

    FOREIGN KEY (user_seguido)
        REFERENCES perfil(id_perfil)
        ON DELETE CASCADE
);

create table if not exists conversa(
    id_conversa int AUTO_INCREMENT PRIMARY KEY,
    tipo_conversa varchar(10)
    
);
                                    
CREATE TABLE IF NOT EXISTS participa (
    id_perfil INT,
    id_conversa INT,
    PRIMARY KEY (id_perfil, id_conversa),

    FOREIGN KEY (id_perfil)
        REFERENCES perfil(id_perfil)
        ON DELETE CASCADE,

    FOREIGN KEY (id_conversa)
        REFERENCES conversa(id_conversa)
        ON DELETE CASCADE
);


create table if not exists mensagem(
    id_mensagem INT AUTO_INCREMENT PRIMARY KEY,
    id_conversa int not null,
    id_perfil int,
    data_hora TIMESTAMP DEFAULT CURRENT_TIMESTAMP not null,
    conteudo text,

    FOREIGN KEY (id_conversa)
        REFERENCES conversa(id_conversa)
        ON DELETE CASCADE,

    FOREIGN KEY (id_perfil)
        REFERENCES perfil(id_perfil)
        ON DELETE CASCADE
);
      
create table if not exists publicacao(
    id_publicacao INT AUTO_INCREMENT PRIMARY KEY, 
    id_perfil int,
    data_hora TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (id_perfil)
        REFERENCES perfil(id_perfil)
        ON DELETE CASCADE
);

create table if not exists interacao(
    id_interacao INT AUTO_INCREMENT PRIMARY KEY,
    id_perfil int,
    id_publicacao int NOT NULL,
    data_hora TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (id_perfil)
        REFERENCES perfil(id_perfil)
        ON DELETE CASCADE,

    FOREIGN KEY (id_publicacao)
        REFERENCES publicacao(id_publicacao)
        ON DELETE CASCADE
);
       
create table if not exists interacao_comentario(
    id_interacao int not null PRIMARY KEY,
    texto text,

    FOREIGN KEY (id_interacao)
        REFERENCES interacao(id_interacao)
        ON DELETE CASCADE
);

create table if not exists interacao_curtida(
    id_interacao INT NOT NULL primary key,
    FOREIGN KEY (id_interacao)
        REFERENCES interacao(id_interacao)
        ON DELETE CASCADE
);
		
create table if not exists arquivo_midia(
    id_arquivo INT AUTO_INCREMENT PRIMARY KEY,
    id_publicacao INT NOT NULL,
    tipo_midia varchar(15),
    url_midia varchar(255),
    FOREIGN KEY (id_publicacao)
        REFERENCES publicacao(id_publicacao)
        ON DELETE CASCADE
);

create table if not exists publicacao_permanente(
    id_publicacao INT NOT NULL PRIMARY KEY,
    legenda varchar(254),
    FOREIGN KEY (id_publicacao)
        REFERENCES publicacao(id_publicacao)
        ON DELETE CASCADE
);
