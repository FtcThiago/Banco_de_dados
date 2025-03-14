
-- 1. Calcule o Total de linhas nas tabelas:

-- Total de linhas aih
select count(*) 
	from public.aih;

-- Total de linhas ipca_brasil
select count(*) 
	from public.ipca_brasil;

-- Total de linhas municipio
select count(*) 
	from public.municipio;

-- Total de linhas municipio_ride_brasilia
select count(*) -- Sem permissão 
	from public.municipio_ride_brasilia;

-- Total de linhas pib_brasil
select count(*) 
	from public.pib_brasil;

-- Total de linhas populacao
select count(*) 
	from public.populacao;

-- Total de linhas regiao
select count(*) 
	from public.regiao;

-- Total de linhas unidade_federacao
select count(*) 
	from public.unidade_federacao;
	
-- 2. Calcule o valor total das variáveis em suas respectivas tabelas:


-- valor total da variável 	Numero_habitantes
select sum(numero_habitantes)  as Numero_habitantes
	from public.populacao;

-- valor total da variável 	aih(qtd_total,vl_total)
select sum(aih.qtd_total)  as qtd_total, sum(aih.vl_total) as Valor_Total
	from public.aih as aih;

-- valor total da variável  pib_brasil(vl_bruto_agropecuaria,vl_pib)	
select sum(pib.vl_bruto_agropecuaria) as Valor_Agropecuaria, sum(pib.vl_pib) as vl_pib
	from public.pib_brasil as pib;


-- 3. Calcule o total de municípios por “Nome da Unidade da Federação"

select uf.nome_uf , count(m.codigo_municipio) as quantidade_de_municipio
	from unidade_federacao uf 
	inner join municipio m 
		on uf.cd_uf = m.cd_uf 
		group by uf.nome_uf
	order by uf.nome_uf; 
	
	
-- 4. Calcule o total de candidatos do Enem por "Região (nome)"
	
select r.nome_regiao,count(ce.numero_inscricao) 
	from municipio m 
	inner join unidade_federacao uf 
		on m.cd_uf  = uf.cd_uf
	inner join regiao r 
		on uf.cd_regiao = r.cd_regiao 
	inner join candidatos_enem ce 
		on ce.codigo_municipio_prova = m.codigo_municipio_dv
	group by r.nome_regiao;
		

		

-- 5. Qual o valor total do PIB, PIB da Agricultura e PIB da Industria por Ano e Unidade da Federação (nome)

select uf.nome_uf , pb.ano_pib, sum(pb.vl_pib) as Valor_PIB,sum(pb.vl_bruto_agropecuaria) as Valor_Agropecuaria,sum(pb.vl_bruto_industria) as Valor_Industria 
	from pib_brasil pb 
	inner join municipio m 
		on m.codigo_municipio_dv = pb.codigo_municipio_dv
	inner join unidade_federacao uf 
		on uf.cd_uf = m.cd_uf 
	group by uf.nome_uf,pb.ano_pib;


--  6. Qual o valor da média aritmética, valores máximo e mínimo e desvio padrão do valor do PIB por ano?

select pb.ano_pib, sum(pb.vl_pib ) as Media_Aritmetica, 
	max(pb.vl_pib) as Valor_Maximo, min(pb.vl_pib) as Valor_Minino, stddev(pb.vl_pib ) as Desvio_padrao 
		from pib_brasil pb 
		group by pb.ano_pib;
	
	
-- 7. Qual o valor da média aritmética, valores máximo e mínimo e desvio padrão do valor do PIB por ano/unidade da federação?
	
select uf.nome_uf ,pb.ano_pib, sum(pb.vl_pib ) as Media_Aritmetica, 
	max(pb.vl_pib) as Valor_Maximo, min(pb.vl_pib) as Valor_Minino, stddev(pb.vl_pib ) as Desvio_padrao 
		from pib_brasil pb 
		inner join municipio m 
			on pb.codigo_municipio_dv = m.codigo_municipio_dv 
		inner join unidade_federacao uf 
			on uf.cd_uf = m.cd_uf 
		group by pb.ano_pib,uf.cd_uf ;
	

-- 8. Selecione os municípios (nome) que possuem a soma dos valores do PIB nos 3 anos superiores a 100 milhões.****
	
select uf.nome_uf ,pb.ano_pib, sum(pb.vl_pib)  as Soma_dos_valores 
		from pib_brasil pb 
		inner join municipio m 
			on pb.codigo_municipio_dv = m.codigo_municipio_dv 
		inner join unidade_federacao uf 
			on uf.cd_uf = m.cd_uf 
		where pb.ano_pib in ('2021','2020','2019') and pb.vl_pib > 100000000
		group by pb.ano_pib,uf.nome_uf;
	

-- 9. Acrescentar na tabela resultado da soma do VL_PIB por Região uma linha com o total Brasil, soma de todas as regiões;
	
select r.nome_regiao ,sum(pb.vl_pib) as Valores
	from pib_brasil pb 
	inner join municipio m 
		on pb.codigo_municipio_dv = m.codigo_municipio_dv 
	inner join unidade_federacao uf 
		on uf.cd_uf = m.cd_uf 
	inner join regiao r 
		on r.cd_regiao = uf.cd_regiao
	group by r.nome_regiao 
union	
select 'Total', sum(pb.vl_pib) as sominha
	from pib_brasil pb 
order by 1 ;

	

-- 10. Identificar todos os municípios (Código e Nome) dos municípios que não possuem Autorizações de Internações Hospitalares (AIH). 
	
	
select m.codigo_municipio, m.nome_municipio  
	from municipio m 
	left join aih a 
		on m.codigo_municipio_dv = a.codigo_municipio_dv
	where a.codigo_municipio_dv is null;
	
-- 11. Qual o valor da média aritmética, valores máximo e mínimo e desvio padrão do valor
-- da nota de matemática e de ciência da Natureza no ENEM 2023?	
	
	
select sum(ce.nota_matematica) / count(ce.nota_matematica) as Nota_matematica,sum(ce.nota_ciencias_da_natureza) / count(ce.nota_ciencias_da_natureza) as Nota_Ciencia_Natureza,
		min(ce.nota_matematica) as Minimo_matematica, max(ce.nota_matematica) as Maximo_matematica,
		min(ce.nota_ciencias_da_natureza) as Minimo_Ciencias_Natureza, max(ce.nota_ciencias_da_natureza) as Minimo_Ciencias_Natureza,
		stddev(ce.nota_matematica) as std_matematica, stddev(ce.nota_ciencias_humanas) as std_Ciencias_Natureza
		from candidatos_enem ce;
	
-- 12. Quais os nomes dos Municípios e seus estados que não tiveram provas do ENEM 2023?
	
select m.nome_municipio,uf.sigla_uf , codigo_municipio, ce.ano_enem 
	from municipio m 
	full outer join candidatos_enem ce 
		on ce.codigo_municipio_prova = m.codigo_municipio_dv 
	inner join unidade_federacao uf 
		on uf.cd_uf = m.cd_uf 
	where ce.codigo_municipio_prova is null;
	

-- 13. Selecione os nomes dos Municípios e seus Estados que possuem uma nota 
--média de Matemática e Linguagens e Códigos superiores a 600 pontos.
	
select m.nome_municipio , avg(ce.nota_matematica) as nota_matematica,
		avg(ce.nota_linguagens_e_codigos) as codigos 
	from municipio m 
	inner join candidatos_enem ce 
		on m.codigo_municipio_dv = ce.codigo_municipio_prova
	group by m.nome_municipio
	having avg(ce.nota_matematica) > 500 and avg(ce.nota_linguagens_e_codigos) > 500;
	

-- 14. Quais os nomes dos estados que possuem as três maiores medianas no ENEM 2023?
	
select uf.nome_uf as nome_regiao,PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY ce.nota_media) 
	from candidatos_enem ce 
	inner join municipio m 
	on ce.codigo_municipio_prova = m.codigo_municipio_dv 
	inner join unidade_federacao uf 
	on m.cd_uf = uf.cd_uf
	group by uf.nome_uf 
	order by uf.nome_uf 
	limit 3	;

-- 15. Calcule a média aritmética da nota de matemática de cada município e acrescente a população em 2022.

select m.nome_municipio , avg(ce.nota_matematica) as nota_matematica,sum(p.numero_habitantes) as total_populacao
	from municipio m 
	inner join candidatos_enem ce 
		on m.codigo_municipio_dv = ce.codigo_municipio_prova
	inner join populacao p 
		on m.codigo_municipio_dv = p.codigo_municipio_dv 
	where p.ano_pesquisa = '2022'
	group by m.nome_municipio;
	
	
	
	
	
	
	
	
	
	
	
	
	
	