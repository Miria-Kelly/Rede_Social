Create table if not exists perfil(
    email varchar(255) not null unique,
    nome varchar(20) not null,
    senha varchar(20) not null,
    perfil_aberto boolean not null,
    id_perfil int auto_increment,
    primary key(id_perfil)
);
                                  
create table if not exists segue (
    user_seguidor int,
    user_seguido int,
    primary key(user_seguidor, user_seguido),
    foreign key(user_seguidor) references perfil(id_perfil),
    foreign key(user_seguido) references perfil(id_perfil)
);

create table if not exists conversa(
    id_conversa int AUTO_INCREMENT,
    tipo_conversa varchar(10),
    primary key(id_conversa)
);
                                    
create table if not exists participa(
    id_perfil int,
    id_conversa int,
    primary key(id_perfil, id_conversa),
    foreign key (id_perfil) references perfil(id_perfil),
    foreign key (id_conversa) references conversa(id_conversa)
);

create table if not exists mensagem(
    id_mensagem INT AUTO_INCREMENT,
    id_conversa int not null,
    id_perfil int,
    data_hora TIMESTAMP DEFAULT CURRENT_TIMESTAMP not null,
    conteudo text,
    primary key(id_mensagem),
    foreign key (id_conversa) references conversa(id_conversa),
    foreign key (id_perfil) references perfil(id_perfil)
);
      
create table if not exists publicacao(
    id_publicacao INT AUTO_INCREMENT, 
    id_perfil int,
    data_hora TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    primary key (id_publicacao),
    foreign key(id_perfil) references perfil(id_perfil)
);

create table if not exists interacao(
    id_interacao INT AUTO_INCREMENT,
    id_perfil int,
    id_publicacao int NOT NULL,
    data_hora TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    primary key(id_interacao),
    foreign key(id_perfil) references perfil(id_perfil),
    foreign key(id_publicacao) references publicacao(id_publicacao)
);
       
create table if not exists interacao_comentario(
    id_interacao int not null,
    texto text,
    primary key(id_interacao),
    foreign key(id_interacao) references interacao(id_interacao)
);

create table if not exists interacao_curtida(
    id_interacao INT NOT NULL,
    primary key(id_interacao),
    foreign key(id_interacao) references interacao(id_interacao)
);
		
create table if not exists arquivo_midia(
    id_arquivo INT AUTO_INCREMENT,
    id_publicacao INT NOT NULL,
    tipo_midia varchar(15),
    url_midia varchar(255),
    primary key (id_arquivo),
    foreign key (id_publicacao) references publicacao(id_publicacao)
);

create table if not exists publicacao_permanente(
    id_publicacao INT NOT NULL,
    legenda varchar(254),
    primary key(id_publicacao),
    foreign key (id_publicacao) references publicacao(id_publicacao)
);
