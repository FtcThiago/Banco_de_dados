-- 1. Qual o total de alunos da faculdade?

select count(*)  as Alunos_da_faculdade
	from aluno a ; -- 176 Alunos na Faculdade
	
-- 2. Quantas disciplinas existem na faculdade?

select count(*) as Disciplinas_na_Faculdade 
	from disciplina d; -- 64 Disciplinas existem na faculdade
	
-- 3. Quantos alunos estão matriculados em 2024?

select count(distinct (am.matricula_aluno)) as Alunos_Matriculados
	from aluno_matriculado am
	where am.ano = '2024'; -- 85 Alunos estão matriculados em 2024
	
-- 4. Quantos alunos estão matriculados em 2024 no primeiro e no segundo semestre?
	
select count(distinct(am.matricula_aluno)) as Alunos_Matriculados_2024_seg
	from aluno_matriculado am 
	where am.ano = '2024' and am.semestre in('1','2'); 

-- 5. Quantos alunos estão matriculados em cada disciplina no ano/semestre? ****

select am.codigo_disciplina,am.ano,am.semestre, count(am.matricula_aluno) 
	from aluno_matriculado am
	group by am.codigo_disciplina,am.ano,am.semestre;
                                           

-- 6. Quais são os alunos matriculados na disciplina CIA027 no ano de 2024, segundo período?

select count(distinct(am.matricula_aluno)) 
	from aluno_matriculado am 
	where am.ano = '2024' and am.semestre ='2' and am.codigo_disciplina = 'CIA027';

-- 7. Informe a matrícula e o nome dos alunos matriculados na disciplina CIA007 na 
-- turma CIADM1B no ano de 2024, segundo período?

select am.matricula_aluno , a.nome_aluno  
	from aluno_matriculado am 
	inner join aluno a 
		on am.matricula_aluno = a.matricula_aluno
	where am.ano = '2024' 
		and am.semestre ='2' 
		and am.codigo_disciplina = 'CIA027'
		and am.codigo_turma = 'CIADM1B'
		and am.situacao = 'Matriculado';
		
			
-- 8. Faça uma lista das disciplinas e turmas de cada professor, informado o nome e matrícula do Professor.	

select distinct(p.nome_professor), d.nome_disciplina, td.codigo_turma 
	from professor p
	inner join turma_disciplina td 
		on p.matricula_professor = td.matricula_professor
	inner join disciplina d 
		on td.codigo_disciplina = d.codigo_disciplina; 
	
	
	
	

-- 9. Quais são os alunos do Professor “Fernando Anselmo” na disciplina “CIA061” da Turma CIAMM1B no ano de 2024, segundo semestre;
	
select a.matricula_aluno,a.nome_aluno
	from turma_disciplina td 
		inner join professor p 
			on td.matricula_professor = p.matricula_professor
		inner join aluno_matriculado am 
			on td.codigo_turma = am.codigo_turma 
		inner join aluno a 
			on am.matricula_aluno = a.matricula_aluno 
		where p.matricula_professor ='201482' ;
		
-- 10. Quais são os Professores que não estão alocados em nenhuma disciplina no Ano de 2024, segundo semestre;
	
	select *,td.codigo_disciplina  
		from professor p 
		left join turma_disciplina td 
			on td.matricula_professor = p.matricula_professor 
		where td.codigo_disciplina  is null ;