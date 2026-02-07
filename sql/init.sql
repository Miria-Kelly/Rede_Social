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

    --Inserções dos dados

INSERT INTO perfil (email, nome, senha, perfil_aberto) VALUES
    ('ana.silva@example.com', 'Ana Silva', 'senha123', TRUE),
    ('bruno.santos@example.com', 'Bruno Santos', 'bruno88', TRUE),
    ('carla.oliveira@example.com', 'Carla Oliveira', 'carla!@#', FALSE),
    ('diego.souza@example.com', 'Diego Souza', 'diego99', TRUE),
    ('elena.martins@example.com', 'Elena Martins', 'elena_pass', TRUE),
    ('fabio.costa@example.com', 'Fabio Costa', 'fabio123', FALSE),
    ('gisele.rocha@example.com', 'Gisele Rocha', 'gigi2024', TRUE),
    ('hugo.ferreira@example.com', 'Hugo Ferreira', 'hugo_mestre', TRUE),
    ('isabela.lima@example.com', 'Isabela Lima', 'isa_bella', FALSE),
    ('joao.vitor@example.com', 'Joao Vitor', 'jv_pass', TRUE),
    ('lucas.mendes@example.com', 'Lucas Mendes', 'lucas123', TRUE),
    ('mariana.alves@example.com', 'Mariana Alves', 'mari_alves', TRUE),
    ('pedro.henrique@example.com', 'Pedro Henrique', 'pedro_sql', FALSE),
    ('fernanda.lima@example.com', 'Fernanda Lima', 'fer_2024', TRUE),
    ('ricardo.gomes@example.com', 'Ricardo Gomes', 'ricardo_g', TRUE),
    ('beatriz.nunes@example.com', 'Beatriz Nunes', 'bea_nunes', TRUE),
    ('andre.pinto@example.com', 'Andre Pinto', 'andre_p', FALSE),
    ('juliana.correia@example.com', 'Juliana Correia', 'ju_correia', TRUE),
    ('marcos.paulo@example.com', 'Marcos Paulo', 'marcos_p', TRUE),
    ('patricia.melo@example.com', 'Patricia Melo', 'paty_melo', TRUE),
    ('gabriel.dias@example.com', 'Gabriel Dias', 'gab_dias', TRUE),
    ('larissa.vieira@example.com', 'Larissa Vieira', 'lari_v', FALSE),
    ('thiago.silveira@example.com', 'Thiago Silveira', 'thiago_s', TRUE),
    ('camila.leite@example.com', 'Camila Leite', 'cami_leite', TRUE),
    ('rafael.marques@example.com', 'Rafael Marques', 'rafa_marques', TRUE),
    ('leticia.cardoso@example.com', 'Leticia Cardoso', 'let_card', FALSE),
    ('vinicius.teixeira@example.com', 'Vinicius Teixeira', 'vini_t', TRUE),
    ('amanda.barros@example.com', 'Amanda Barros', 'ama_barros', TRUE),
    ('leonardo.freitas@example.com', 'Leonardo Freitas', 'leo_f', TRUE),
    ('daniela.ribeiro@example.com', 'Daniela Ribeiro', 'dani_rib', TRUE),
    ('rodrigo.machado@example.com', 'Rodrigo Machado', 'rodrigo_m', FALSE),
    ('aline.pinto@example.com', 'Aline Pinto', 'aline_p', TRUE),
    ('caio.batista@example.com', 'Caio Batista', 'caio_b', TRUE),
    ('tatiane.moraes@example.com', 'Tatiane Moraes', 'tati_m', TRUE),
    ('felipe.duarte@example.com', 'Felipe Duarte', 'felipe_d', FALSE),
    ('vanessa.cavalcanti@example.com', 'Vanessa Cavalcanti', 'van_caval', TRUE),
    ('gustavo.borges@example.com', 'Gustavo Borges', 'gus_borges', TRUE),
    ('priscila.araujo@example.com', 'Priscila Araujo', 'pri_araujo', TRUE),
    ('marcelo.rezende@example.com', 'Marcelo Rezende', 'marcelo_r', TRUE),
    ('renata.guimaraes@example.com', 'Renata Guimaraes', 're_guimaraes', FALSE),
    ('igor.assuncao@example.com', 'Igor Assuncao', 'igor_a', TRUE),
    ('monica.lopes@example.com', 'Monica Lopes', 'monica_l', TRUE),
    ('vitor.nascimento@example.com', 'Vitor Nascimento', 'vitor_n', TRUE),
    ('sabrina.paiva@example.com', 'Sabrina Paiva', 'sab_paiva', TRUE),
    ('alexandre.cunha@example.com', 'Alexandre Cunha', 'alex_cunha', FALSE),
    ('caroline.borges@example.com', 'Caroline Borges', 'carol_b', TRUE),
    ('eduardo.andrade@example.com', 'Eduardo Andrade', 'edu_andrade', TRUE),
    ('bianca.farias@example.com', 'Bianca Farias', 'bia_farias', TRUE),
    ('samuel.leal@example.com', 'Samuel Leal', 'sam_leal', TRUE),
    ('debora.peixoto@example.com', 'Debora Peixoto', 'deb_peixoto', FALSE),
    ('matheus.aguiar@example.com', 'Matheus Aguiar', 'mat_aguiar', TRUE),
    ('natalia.vargas@example.com', 'Natalia Vargas', 'nat_vargas', TRUE),
    ('arthur.maia@example.com', 'Arthur Maia', 'arthur_m', TRUE),
    ('lorena.neves@example.com', 'Lorena Neves', 'lore_neves', TRUE),
    ('caio.moura@example.com', 'Caio Moura', 'caio_moura', FALSE),
    ('julia.sales@example.com', 'Julia Sales', 'julia_sales', TRUE),
    ('douglas.moraes@example.com', 'Douglas Moraes', 'doug_m', TRUE),
    ('milena.porto@example.com', 'Milena Porto', 'milena_p', TRUE),
    ('sergio.ramos@example.com', 'Sergio Ramos', 'sergio_r', TRUE),
    ('elisa.figueiredo@example.com', 'Elisa Figueiredo', 'elisa_f', FALSE),
    ('otavio.braga@example.com', 'Otavio Braga', 'otavio_b', TRUE),
    ('clara.mesquita@example.com', 'Clara Mesquita', 'clara_m', TRUE),
    ('nicolas.antunes@example.com', 'Nicolas Antunes', 'nico_a', TRUE),
    ('mirella.campos@example.com', 'Mirella Campos', 'mirella_c', TRUE),
    ('fabricio.queiroz@example.com', 'Fabricio Queiroz', 'fabri_q', FALSE),
    ('heloisa.medeiros@example.com', 'Heloisa Medeiros', 'helo_m', TRUE),
    ('jorge.valente@example.com', 'Jorge Valente', 'jorge_v', TRUE),
    ('alice.bezerra@example.com', 'Alice Bezerra', 'alice_b', TRUE),
    ('murilo.correia@example.com', 'Murilo Correia', 'murilo_c', TRUE),
    ('isabel.quintana@example.com', 'Isabel Quintana', 'isabel_q', FALSE),
    ('raul.seixas@example.com', 'Raul Seixas', 'raul_s', TRUE),
    ('rebeca.teles@example.com', 'Rebeca Teles', 'rebeca_t', TRUE),
    ('hudson.melo@example.com', 'Hudson Melo', 'hudson_m', TRUE),
    ('lara.fontes@example.com', 'Lara Fontes', 'lara_f', TRUE),
    ('willian.santos@example.com', 'Willian Santos', 'will_s', FALSE),
    ('stefany.souza@example.com', 'Stefany Souza', 'stef_s', TRUE),
    ('yago.oliveira@example.com', 'Yago Oliveira', 'yago_o', TRUE),
    ('ester.silva@example.com', 'Ester Silva', 'ester_s', TRUE),
    ('danilo.franca@example.com', 'Danilo Franca', 'danilo_f', TRUE),
    ('kelly.piva@example.com', 'Kelly Piva', 'kelly_p', FALSE),
    ('ronaldo.nazario@example.com', 'Ronaldo Nazario', 'ronaldo_n', TRUE),
    ('adriana.lima@example.com', 'Adriana Lima', 'adri_lima', TRUE),
    ('moises.batista@example.com', 'Moises Batista', 'moises_b', TRUE),
    ('viviane.araujo@example.com', 'Viviane Araujo', 'vivi_a', TRUE),
    ('caio.castro@example.com', 'Caio Castro', 'caio_c', FALSE),
    ('bruna.marquezine@example.com', 'Bruna Marquezine', 'bruna_m', TRUE),
    ('luan.santana@example.com', 'Luan Santana', 'luan_s', TRUE),
    ('anitta.machado@example.com', 'Anitta Machado', 'anitta_m', TRUE),
    ('neymar.jr@example.com', 'Neymar Jr', 'neymar_j', TRUE),
    ('paola.oliveira@example.com', 'Paola Oliveira', 'paola_o', FALSE),
    ('claudia.leitte@example.com', 'Claudia Leitte', 'claudia_l', TRUE),
    ('ivete.sangalo@example.com', 'Ivete Sangalo', 'ivete_s', TRUE),
    ('thiaguinho.melo@example.com', 'Thiaguinho Melo', 'thiago_m', TRUE),
    ('ludmilla.oliveira@example.com', 'Ludmilla Oliveira', 'lud_o', TRUE),
    ('pabllo.vittar@example.com', 'Pabllo Vittar', 'pabllo_v', FALSE),
    ('iza.pesqueira@example.com', 'Iza Pesqueira', 'iza_p', TRUE),
    ('dj.alok@example.com', 'Dj Alok', 'alok_dj', TRUE),
    ('whindersson.nunes@example.com', 'Whindersson Nunes', 'whind_n', TRUE),
    ('maisa.silva@example.com', 'Maisa Silva', 'maisa_s', TRUE),
    ('felipe.neto@example.com', 'Felipe Neto', 'felipe_n', FALSE);

    -- Criando 50 entradas na tabela publicacao
INSERT INTO publicacao (id_perfil) SELECT id_perfil FROM perfil LIMIT 50;

-- AGORA inserimos as legendas. Como inserimos 50 acima, os IDs 1 a 50 EXISTEM na tabela publicacao.
INSERT INTO publicacao_permanente (id_publicacao, legenda) VALUES
(1, 'Começando o dia com energia! ☕'), (2, 'Olha essa vista maravilhosa.'), (3, 'Trabalhando no novo projeto de banco de dados.'),
(4, 'TBT de uma viagem inesquecível.'), (5, 'A vida é curta demais para não comer bem.'), (6, 'Foco, força e café.'),
(7, 'Finalmente sexta-feira!'), (8, 'Dica de hoje: nunca pare de aprender.'), (9, 'Natureza é paz.'), (10, 'Reunião de equipe produtiva.'),
(11, 'Treino de hoje pago! 💪'), (12, 'Novo livro, novas ideias.'), (13, 'A simplicidade é o último grau da sofisticação.'),
(14, 'Mais um pôr do sol para a conta.'), (15, 'Programar é arte, o bug faz parte.'), (16, 'Família em primeiro lugar.'),
(17, 'Noite de pizza! 🍕'), (18, 'Desafio aceito e concluído.'), (19, 'Saudades desse paraíso.'), (20, 'Onde eu queria estar agora...'),
(21, 'Novidades vindo por aí!'), (22, 'Apenas gratidão.'), (23, 'Sabadou com estilo.'), (24, 'Meu novo setup está pronto.'),
(25, 'Caminhada matinal.'), (26, 'Mais um dia de aprendizado.'), (27, 'A persistência realiza o impossível.'), (28, 'Café e código.'),
(29, 'Explorando novos lugares.'), (30, 'Foto de agora!'), (31, 'Um pouco de cor no dia cinza.'), (32, 'Dando um tempo das telas.'),
(33, 'Festa com os amigos!'), (34, 'Minha motivação diária.'), (35, 'Cozinhando algo especial.'), (36, 'O inverno chegou.'),
(37, 'Lugar de paz.'), (38, 'Mente sã, corpo são.'), (39, 'Um brinde às conquistas!'), (40, 'Organização é tudo.'),
(41, 'Nascer do sol incrível.'), (42, 'Rumo ao sucesso.'), (43, 'Trabalho duro sempre vence.'), (44, 'Relaxando um pouco.'),
(45, 'Aproveitando o feriado.'), (46, 'Foco nos objetivos.'), (47, 'Estudando SQL pesado.'), (48, 'Docker é vida!'),
(49, 'Meu pet lindo.'), (50, 'Fim de mais um ciclo.');

-- Mídias
INSERT INTO arquivo_midia (id_publicacao, tipo_midia, url_midia) VALUES
(1, 'image/jpg', 'https://picsum.photos/id/10/800/800'),
(2, 'image/jpg', 'https://picsum.photos/id/20/800/800'),
(3, 'image/jpg', 'https://picsum.photos/id/30/800/800'),
(15, 'image/png', 'https://picsum.photos/id/40/800/800'),
(48, 'video/mp4', 'https://sample-videos.com/video123.mp4');

-- Adicionando mídias fictícias para algumas delas
INSERT INTO arquivo_midia (id_publicacao, tipo_midia, url_midia) VALUES
(1, 'image/jpg', 'https://picsum.photos/id/10/800/800'),
(2, 'image/jpg', 'https://picsum.photos/id/20/800/800'),
(3, 'image/jpg', 'https://picsum.photos/id/30/800/800'),
(15, 'image/png', 'https://picsum.photos/id/40/800/800'),
(48, 'video/mp4', 'https://sample-videos.com/video123.mp4');

-- Gerando 50 interações base (usuários 20 a 70 interagindo nas publicações 1 a 50)
INSERT INTO interacao (id_perfil, id_publicacao) VALUES
(21, 1), (22, 1), (23, 1), (24, 2), (25, 2), (26, 3), (27, 4), (28, 5), (29, 6), (30, 7),
(31, 8), (32, 9), (33, 10), (34, 11), (35, 12), (36, 13), (37, 14), (38, 15), (39, 16), (40, 17),
(41, 18), (42, 19), (43, 20), (44, 21), (45, 22), (46, 23), (47, 24), (48, 25), (49, 26), (50, 27),
(51, 28), (52, 29), (53, 30), (54, 31), (55, 32), (56, 33), (57, 34), (58, 35), (59, 36), (60, 37),
(61, 38), (62, 39), (63, 40), (64, 41), (65, 42), (66, 43), (67, 44), (68, 45), (69, 46), (70, 47);

-- Transformando as 30 primeiras interações em CURTIDAS
INSERT INTO interacao_curtida (id_interacao) 
SELECT id_interacao FROM interacao LIMIT 30;

-- Transformando as 20 restantes em COMENTÁRIOS
INSERT INTO interacao_comentario (id_interacao, texto) VALUES
(31, 'Muito bom!'), (32, 'Concordo plenamente.'), (33, 'Arrasou demais! 🔥'), (34, 'Que foto linda.'),
(35, 'Sensacional.'), (36, 'Top!'), (37, 'Uau!'), (38, 'Inspiração pura.'), (39, 'Adorei a legenda.'),
(40, 'Ficou massa!'), (41, 'Quero um desses.'), (42, 'Me ensina?'), (43, 'Muito sucesso para você.'),
(44, 'Merecido!'), (45, 'Boa!'), (46, 'Foco total.'), (47, 'Excelente reflexão.'),
(48, 'Com certeza!'), (49, 'Parabéns!'), (50, 'Show de bola.');

-- Criando uma rede de seguidores
INSERT INTO segue (user_seguidor, user_seguido) VALUES 
-- O usuário 1 segue os próximos 15
(1,2), (1,3), (1,4), (1,5), (1,6), (1,7), (1,8), (1,9), (1,10), (1,11), (1,12), (1,13), (1,14), (1,15), (1,16),
-- Seguidores mútuos (Amizades)
(2,1), (3,1), (4,1), (5,1), (10,1), 
(2,3), (3,2), (4,5), (5,4), (6,7), (7,6), (8,9), (9,8), (10,11), (11,10),
-- Usuários aleatórios seguindo perfis famosos (ex: 85 a 100 são famosos)
(20,85), (21,85), (22,85), (23,85), (24,85), (25,85),
(30,88), (31,88), (32,88), (33,88), (34,88), (35,88),
(40,90), (41,90), (42,90), (43,90), (44,90), (45,90),
(50,95), (51,95), (52,95), (53,95), (54,95), (55,95),
-- Mais algumas conexões variadas
(12,13), (13,14), (14,15), (15,16), (16,17), (17,18), (18,19), (19,20),
(60,61), (61,62), (62,63), (63,64), (64,65), (65,66), (66,67), (67,68),
(70,71), (71,72), (72,73), (73,74), (74,75), (75,76), (76,77), (77,78),
(80,81), (81,82), (82,83), (83,84), (84,85), (85,86), (86,87), (87,88),
(90,91), (91,92), (92,93), (93,94), (94,95), (95,96), (96,97), (97,98);

-- 3. Conversas (Tipos: 'privada' ou 'grupo')
-- Criando 15 conversas
INSERT INTO conversa (tipo_conversa) VALUES 
('privada'), ('privada'), ('privada'), ('privada'), ('privada'),
('privada'), ('privada'), ('privada'), ('privada'), ('privada'),
('grupo'), ('grupo'), ('grupo'), ('grupo'), ('grupo');

-- Inserindo participantes (Tabela participa)
INSERT INTO participa (id_perfil, id_conversa) VALUES
-- Privadas (IDs 1 a 10)
(1,1), (2,1),
(3,2), (4,2),
(5,3), (6,3),
(7,4), (8,4),
(9,5), (10,5),
(11,6), (12,6),
(13,7), (14,7),
(15,8), (16,8),
(17,9), (18,9),
(19,10), (20,10),
-- Grupos (IDs 11 a 15)
(1,11), (2,11), (3,11), (4,11), -- Grupo dos amigos
(10,12), (11,12), (12,12),      -- Grupo do trabalho
(50,13), (51,13), (52,13),      -- Grupo da família
(80,14), (81,14), (82,14),      -- Grupo de estudos
(90,15), (91,15), (92,15), (93,15); -- Grupo de futebol

-- 5. Mensagens
INSERT INTO mensagem (id_conversa, id_perfil, conteudo) VALUES
(1, 1, 'Oi Bruno! Vi sua foto nova, ficou show!'),
(1, 2, 'Valeu Ana! Foi naquela trilha que te falei.'),
(1, 1, 'Depois me manda a localização?'),
(2, 3, 'Carla, você viu o prazo do projeto?'),
(2, 4, 'Vi sim, Diego. Vamos focar amanhã?'),
(2, 3, 'Fechado!'),
(11, 1, 'Bom dia grupo! Alguém anima um café hoje?'),
(11, 2, 'Eu topo!'),
(11, 3, 'Tô dentro também.'),
(11, 4, 'Se for depois das 18h, eu vou.'),
(12, 10, 'A reunião foi adiada para segunda, pessoal.'),
(12, 11, 'Obrigado por avisar, João.'),
(13, 50, 'Mãe, não esquece de levar o bolo!'),
(13, 51, 'Pode deixar, Matheus.'),
(15, 90, 'Quem vai pro jogo hoje?'),
(15, 91, 'Eu vou!'),
(15, 92, 'Tô confirmado.'),
(15, 93, 'Vou chegar 10 min atrasado.'),
(3, 5, 'Elena, você tem o link da aula?'),
(3, 6, 'Tenho sim, vou te mandar no privado.'),
(4, 7, 'Gisele, parabéns pelo aniversário!'),
(4, 8, 'Obrigada, Hugo! Saudades.'),
(5, 9, 'Isa, me empresta aquele livro?'),
(5, 10, 'Claro, passo aí entregar hoje.'),
(6, 11, 'Lucas, já viu os preços das passagens?'),
(6, 12, 'Tão caros, melhor esperar a Black Friday.'),
(7, 13, 'Pedro, cadê você?'),
(7, 14, 'Tô no engarrafamento, chego em 5 min.'),
(8, 15, 'Ricardo, terminou o deploy?'),
(8, 16, 'Quase! Só falta testar o Docker.'),
(9, 17, 'Andre, bora jogar um CS?'),
(9, 18, 'Bora, entra lá no Discord.'),
(10, 19, 'Marcos, você viu a nova atualização do app?'),
(10, 20, 'Ficou bem mais rápido agora.'),
(11, 1, 'Combinado então, 18:30 no shopping!'),
(11, 4, 'Perfeito!'),
(14, 80, 'Alguém entendeu a questão 5 de SQL?'),
(14, 81, 'Eu fiz usando JOIN, quer ver?'),
(14, 82, 'Manda aqui no grupo, Rebeca.'),
(14, 80, 'Valeu, salvou muito!'),
(1, 2, 'Ana, acabei de te mandar o mapa.'),
(1, 1, 'Recebi aqui, valeu!'),
(12, 12, 'Alguém tem a ata da última reunião?'),
(12, 10, 'Tá no Drive da empresa.'),
(15, 90, 'Reservado o campo das 20h.'),
(15, 91, 'Boa!'),
(13, 52, 'Que horas começa o jantar?'),
(13, 50, 'Às 20:30.'),
(13, 51, 'Estaremos lá.'),
(10, 19, 'Vou testar as novas funções agora.');