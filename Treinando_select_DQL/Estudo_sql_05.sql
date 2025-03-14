--1. Crie e execute Visões simples para responder as seguintes perguntas:


--a. Crie uma VISÃO “Total_Candidatos_ENEM_UF” para informar o Total de Candidatos do ENEM por Nome da UF.


create view Total_Candidatos_ENEM_UF
		as 
			select uf.nome_uf, count(distinct(ce.numero_inscricao)) as quantidade_canditados 
				from public.candidatos_enem ce
					inner join public.municipio m 
						on	m.codigo_municipio_dv = ce.codigo_municipio_dv_prova
					inner join public.unidade_federacao uf 
						on uf.cd_uf = m.cd_uf
					group by uf.nome_uf
					order by quantidade_canditados;
					
select * from Total_Candidatos_ENEM_UF;


-- b. Crie uma VISÃO “Candidatos_ENEM_MAT_Maior_500” para listar todos os Candidatos com mais de 500 pontos em Matemática.

create view Candidatos_ENEM_MAT_Maior_500
		as 
			select *
				from public.candidatos_enem ce
			where ce.nota_matematica > 500;
		
		
select * from Candidatos_ENEM_MAT_Maior_500;



-- c. Crie uma VISÃO “Candidatos_ENEM_MEDIA_MATEMATICA” para listar a média aritmética de cada Região, ordenadas de forma descendente.


create view Candidatos_ENEM_MEDIA_MATEMATICA
		as 
			select r.nome_regiao, avg(ce.nota_matematica) as Nota_media
				from public.candidatos_enem ce
					inner join public.municipio m 
						on	m.codigo_municipio_dv = ce.codigo_municipio_dv_prova
					inner join public.unidade_federacao uf 
						on uf.cd_uf = m.cd_uf
					inner join public.regiao r 
						on r.cd_regiao = uf.cd_regiao
					group by r.nome_regiao
					order by Nota_media desc ;
		
		
select * from Candidatos_ENEM_MEDIA_MATEMATICA;



-- d. Crie uma VISÃO “Candidatos_ENEM_Estatisticas_UF” para listar a média aritmética, desvio padrão, o mínimo e máximo das notas de Ciência da
-- Natureza de cada Unidade da Federação, ordenadas de forma ascendente pelo nome da Unidade da Federação.

create view Candidatos_ENEM_Estatisticas_UF
	as
		select uf.nome_uf, max(ce.nota_ciencias_da_natureza) as Maximo, min(ce.nota_ciencias_da_natureza) as Minimo,
			avg(ce.nota_ciencias_da_natureza) as Nota_media, stddev(ce.nota_ciencias_da_natureza) as Desvio_padrao
						from public.candidatos_enem ce
							inner join public.municipio m 
								on	m.codigo_municipio_dv = ce.codigo_municipio_dv_prova
							inner join public.unidade_federacao uf 
								on uf.cd_uf = m.cd_uf
							group by uf.nome_uf
							order by uf.nome_uf asc ;

						
						
select * from Candidatos_ENEM_Estatisticas_UF;



-- 2. Crie e execute Visões Materializadas para responder as seguintes perguntas:

-- a. Crie uma VISÃO “Candidatos_ENEM_MAT_Maior_500_MATERIALIZADA” para listar todos os Candidatos com mais de 500 pontos em Matemática.
-- Compare os resultados com a visão 1.b


create materialized view Candidatos_ENEM_MAT_Maior_500_MATERIALIZADA 
	as
		select *
				from public.candidatos_enem ce
			where ce.nota_matematica > 500;
		
		
select * from	Candidatos_ENEM_MAT_Maior_500_MATERIALIZADA;	



		
-- b. Crie uma VISÃO “Candidatos_ENEM_Estatisticas_UF_MATERIALIZADA” para listar a média aritmética, desvio padrão, o mínimo e 
-- máximo das notas de Ciência da Natureza de cada Unidade da Federação, ordenadas de forma ascendente pelo 
-- nome da Unidade da Federação. Compare os resultados com a visão 1.d




create materialized view Candidatos_ENEM_Estatisticas_UF_MATERIALIZADA 
	as
		select uf.nome_uf, max(ce.nota_ciencias_da_natureza) as Maximo, min(ce.nota_ciencias_da_natureza) as Minimo,
			avg(ce.nota_ciencias_da_natureza) as Nota_media, stddev(ce.nota_ciencias_da_natureza) as Desvio_padrao
						from public.candidatos_enem ce
							inner join public.municipio m 
								on	m.codigo_municipio_dv = ce.codigo_municipio_dv_prova
							inner join public.unidade_federacao uf 
								on uf.cd_uf = m.cd_uf
							group by uf.nome_uf
							order by uf.nome_uf asc ;


select * from	Candidatos_ENEM_Estatisticas_UF_MATERIALIZADA;




-- 3. Execute as seguintes alterações nos dados:

-- a. Altere 3 (três) notas de Matemática para valores superiores a 800 pontos e execute as visões Candidatos_ENEM_MAT_Maior_500 e
-- Candidatos_ENEM_MAT_Maior_500_MATERIALIZADA. O que aconteceu com os resultados? Justifique.



UPDATE public.candidatos_enem
	SET  nota_matematica= 550
	WHERE ano_enem='2020' AND numero_inscricao in('200001107664','200001125546','200001293093');

-- Visão não Materializada(Normal)
select * from Candidatos_ENEM_MAT_Maior_500
	WHERE ano_enem='2020' AND numero_inscricao in('200001107664','200001125546','200001293093');


-- Visão Materializada
select * from	Candidatos_ENEM_MAT_Maior_500_MATERIALIZADA
	WHERE ano_enem='2020' AND numero_inscricao in('200001107664','200001125546','200001293093') ;	




-- b. Altere 3 (três) notas de Ciência da Natureza para valores superiores a 2000 pontos e execute 
-- as visões Candidatos_ENEM_Estatisticas_UF e Candidatos_ENEM_Estatisticas_UF_MATERIALIZADA. O que aconteceu com os resultados? Justifique.



UPDATE public.candidatos_enem
	SET  nota_ciencias_da_natureza= 4000
	WHERE ano_enem='2020' AND numero_inscricao in('200001107664','200001125546','200001293093') ;


-- Visão não Materializada(Normal)
select * from Candidatos_ENEM_Estatisticas_UF
	WHERE nome_uf = 'Rondônia';


-- Visão Materializada
select * from	Candidatos_ENEM_Estatisticas_UF_MATERIALIZADA
	WHERE nome_uf = 'Rondônia' ;	



