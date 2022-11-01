INSERT INTO public.levels (directory, name, score, originalscore, status, owaspcategory, sans25category) values
('bd6d9d317a0d584c7f0bd1388070c2b6','SQL Injection 1',65,65,'disabled','Injection','1'),
('4282001647cd27cb8464a971ac650f9b','SQL Injection Quotation',65,65,'disabled','Injection','1'),
('0479b89ea4973aee81116cac3a993ee5','Weak Session IDs',65,65,'disabled','Broken Authentication and Session Management','10'),
('b02dd5f6d4e966ddc4b93f399b3fe1a3','A XSS',65,65,'disabled','XSS','4'),
('c58f56ee380a902acc2d71899683dc21','Broken Cryptography',65,65,'disabled','Cryptographic vulnerability','19'),
('a05e8206b7f83729cfae4b66436ed2a9','Use of Hard-Coded Creds',65,65,'disabled','Security Misconfiguration','17'),
('590df80f17969356918aa57b3cdffeb3','Verbose Error Message',65,65,'disabled','Error Handling','19');

select toggleLevel('SQL Injection 1');
select toggleLevel('SQL Injection Quotation');
select toggleLevel('Verbose Error Message');
select toggleLevel('A XSS');

select submitUserSolution('test1@test.com','b02dd5f6d4e966ddc4b93f399b3fe1a3');
select submitUserSolution('test4@test.com','b02dd5f6d4e966ddc4b93f399b3fe1a3');
select submitUserSolution('test7@test.com','b02dd5f6d4e966ddc4b93f399b3fe1a3');
select submitUserSolution('test2@test.com','bd6d9d317a0d584c7f0bd1388070c2b6');
select submitUserSolution('test5@test.com','bd6d9d317a0d584c7f0bd1388070c2b6');
select submitUserSolution('test8@test.com','bd6d9d317a0d584c7f0bd1388070c2b6');
select submitUserSolution('test3@test.com','4282001647cd27cb8464a971ac650f9b');
select submitUserSolution('test6@test.com','4282001647cd27cb8464a971ac650f9b');
select submitUserSolution('test9@test.com','4282001647cd27cb8464a971ac650f9b');
select submitUserSolution('test9@test.com','590df80f17969356918aa57b3cdffeb3');
select submitUserSolution('test6@test.com','590df80f17969356918aa57b3cdffeb3');
select submitUserSolution('test3@test.com','590df80f17969356918aa57b3cdffeb3');