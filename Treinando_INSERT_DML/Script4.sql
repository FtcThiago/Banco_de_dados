-- 1. Inclua 2 novas unidades da federação, informando o nome das colunas.

INSERT INTO public.unidade_federacao
(cd_uf, sigla_uf, nome_uf, cd_regiao)
VALUES(19, 'AS', 'Asgard', 1);

INSERT INTO public.unidade_federacao
(cd_uf, sigla_uf, nome_uf, cd_regiao)
VALUES(20, 'NA', 'Narnia', 2);

-- 2. Inclua 2 novas unidades da federação, não informando o nome das colunas

INSERT INTO public.unidade_federacao
VALUES(60, 'AN', 'Andrometa', 3),
(61,'AQ','Aquario',3);


--3. Inclua 5 novos municípios, informando o nome das colunas.

INSERT INTO public.municipio 
(codigo_municipio_dv,codigo_municipio,nome_municipio,cd_uf,municipio_capital,longitude,latitude)
values('1234568','123457','asgardinho',19,'Não',-204563,-4545),
('1234569','123458','narninha',20,'Não',-564972,-1216),
('1234566','123459','aquariano',61,'Sim',-26497,-1158),
('1234567','123454','androminha',60,'Não',-3425617,-123);


--4. Inclua 5 novos candidatos no ENEM, informando o nome das colunas.

INSERT INTO public.candidatos_enem
(ano_enem, numero_inscricao, codigo_municipio_dv_prova, 
cor_raca, sexo, idade, nota_ciencias_humanas, nota_linguagens_e_codigos, 
nota_ciencias_da_natureza, nota_matematica, nota_redacao, nota_media)
values
('2023', '201', '1234568', 'Branca', 'Masculino', 300, 600, 965, 253, 556, 458, 0),
('2023', '202', '1234569', 'Branca', 'Feminino', 500, 506, 458, 584, 250, 700, 0),
('2023', '203', '1234566', 'Parda', 'Masculino', 600, 458, 142, 456, 548, 100, 0),
('2023', '204', '1234566', 'Preta', 'Feminino', 500, 800, 605, 200, 512, 458, 0),
('2023', '205', '1234567', 'Branca', 'Masculino', 700, 500, 200, 100, 600, 600, 0);

update public.candidatos_enem 
set nota_media= 
avg(nota_ciencias_humanas, nota_linguagens_e_codigos, 
nota_ciencias_da_natureza, nota_matematica, nota_redacao)
WHERE ano_enem ='2023' AND numero_inscricao in('201','202','203','204','205');


-- 5. Altere os atributos NOTA_CIENCIAS_HUMANAS e NOTA_LINGUAGENS_E_CODIGOS da tabela Candidatos_ENEM para aceitarem nulos.

alter table public.candidatos_enem alter column nota_ciencias_humanas DROP NOT NULL;

alter table public.candidatos_enem alter column nota_linguagens_e_codigos DROP NOT NULL;

-- 6. Inclua 3 novos candidatos com nulo nas variáveis NOTA_CIENCIAS_HUMANAS e NOTA_LINGUAGENS_E_CODIGOS.

INSERT INTO public.candidatos_enem
(ano_enem, numero_inscricao, codigo_municipio_dv_prova, cor_raca, 
sexo, idade, nota_ciencias_humanas, nota_linguagens_e_codigos, 
nota_ciencias_da_natureza, nota_matematica, nota_redacao, nota_media)
values
('2023', '301', '1234568', 'Branca', 'Masculino', 18, null, null, 253, 556, 458, 300),
('2023', '302', '1234569', 'Branca', 'Feminino', 20, null, null, 584, 250, 700, 400),
('2023', '303', '1234566', 'Parda', 'Masculino', 17, null, null, 456, 548, 100,500);

--7. Altere o nome as unidades da federação que você criou para “Esperança”, “Novo Paraiso” e “Alto Amazonas”;

UPDATE public.unidade_federacao
SET nome_uf = 'Esperança' 
WHERE cd_uf = 60; 

UPDATE public.unidade_federacao
SET nome_uf = 'Novo Paraiso' 
WHERE cd_uf = 61; 

UPDATE public.unidade_federacao
SET nome_uf = 'Alto Amazonas' 
WHERE cd_uf = 19; 

--8. Exclua os candidatos do ENEM que você incluiu.

DELETE FROM public.candidatos_enem
WHERE ano_enem='2023' AND numero_inscricao in('201','202','203','204','205','301','302','303');

--9. Exclua todos os candidatos do ENEM com a Nota de Matemática < 400.

DELETE FROM public.candidatos_enem as ce
WHERE ce.nota_matematica < 400;


--10. Exclua as unidades da Federação do Centro-Oeste.

select * from public.unidade_federacao uf 
	where uf.cd_uf = '5';




