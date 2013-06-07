program gerador;
uses crt,sysutils;
const max=40;
type numeros=array[1..max,1..max]of integer;
	logicas=array[1..max,1..max]of boolean;
var  campo_numero:numeros;
	campo_logica:logicas;
	jogos,tam_campo,qtd_bombas,diversidade:integer;
	arquivo:text;
	texto:string;

procedure inicia_jogo(var tamanho,bombas,jogos:integer);
begin
	if jogos=0 then
	begin
		jogos:=jogos+1;
		tamanho:=StrtoInt(paramstr(1));
		if (tamanho>40)or(tamanho<8)or(tamanho mod 2<>0)then
		begin
			writeln('O tamanho do campo deve estar entre 8 e 40 e par'); 
			inicia_jogo(tamanho,bombas,jogos);
		end
		else
		begin
			bombas:=StrtoInt(paramstr(2));
			if bombas>=tamanho*tamanho-6 then
			begin
				writeln('A quantidade de bombas deve ser menor que');
				writeln(tamanho*tamanho-9);
				inicia_jogo(tamanho,bombas,jogos);
			end;
		end;
	end
	else	(*Se nao for a primeira tentativa*)
	begin
		writeln('Digite o tamanho do campo');
		read(tamanho);
		if (tamanho>40)or(tamanho<8)or(tamanho mod 2<>0) then
		begin
			writeln('O tamanho do campo deve estar entre 8 e 40 e par');
			inicia_jogo(tamanho,bombas,jogos);
		end
		else
		begin
			writeln('Digite a quantidade de bombas');
			read(bombas);
			if bombas>=tamanho*tamanho-6 then
			begin
				writeln('A quantidade de bombas deve ser menor que');
				writeln(tamanho*tamanho-9);
				inicia_jogo(tamanho,bombas,jogos);
			end;
		end;
	end;
end;


procedure matriz_verdadeira(var x:logicas;tamanho:integer);
var linha,coluna,quase_metade,depois_metade:integer;
begin
	for linha:=1 to tamanho do
	begin
		for coluna:=1 to tamanho do
		begin
			x[linha,coluna]:=true;
		end;
	end;
	quase_metade:=(tamanho div 2)-1; (*no meio da matriz tambem*)
	depois_metade:=(tamanho div 2)+1;
	for linha:=quase_metade to depois_metade do
	begin
		for coluna:=quase_metade to depois_metade do
		begin
			x[linha,coluna]:=false;
		end;
	end;
end;


procedure completa_matriz(var v:numeros;l,c:integer);
var aux_l,aux_c,aux:integer;
begin
	aux_l:=l+2;
	aux_c:=c+2;
	l:=l-1;
	aux:=c-1;
	while l<aux_l do
	begin
		c:=aux; (*deve voltar para coluna anterior a posicao que foi colocada *)
		while c<aux_c do (*a bomba*)
		begin
			if v[l,c]<>9 then
				v[l,c]:=v[l,c]+1;
			c:=c+1;
		end;
		l:=l+1;
	end;
end;


procedure sorteia_bombas1(var v:numeros;var x:logicas;tamanho,bombas:integer);
var l,c:integer;
begin
	while bombas<>0 do
	begin
		l:=random(tamanho)+1;
		c:=random(tamanho)+1;
		if (x[l,c])and(v[l,c]<>9) then
		begin
			bombas:=bombas-1;
			v[l,c]:=9;
			write(arquivo,l,' ');
			writeln(arquivo,c);
			completa_matriz(v,l,c);
		end;	
	end;
end;


procedure sorteia_bombas2(var v:numeros;var x:logicas;tamanho,bombas:integer);
var l,c:integer;
begin
	l:=1;
	while bombas<>0 do
	begin
		c:=1;
		while(c<=tamanho)and(bombas<>0)do
		begin
			if(x[l,c])then (*se pode colocar bomba*)
			begin
				write(arquivo,l,' ');
				writeln(arquivo,c);
				v[l,c]:=9;
				bombas:=bombas-1;
				completa_matriz(v,l,c);
			end;
			c:=c+1;
		end;
		l:=l+1;
	end;
end;


procedure sorteia_bombas3(var v:numeros;var x:logicas;tamanho,bombas:integer);
var l,c:integer;
begin
	l:=tamanho;
	while bombas<>0 do
	begin
		c:=tamanho;
		while(c>0)and(bombas<>0)do
		begin
			if(x[l,c])then (*se pode colocar bomba*)
			begin
				write(arquivo,l,' ');
				writeln(arquivo,c);
				v[l,c]:=9;
				bombas:=bombas-1;
				completa_matriz(v,l,c);
			end;
			c:=c-1;
		end;
		l:=l-1;
	end;
end;


procedure imprime(var v:numeros;tamanho:integer);
var linha,coluna:integer;
begin
	for linha:=1 to tamanho do
	begin
		for coluna:=1 to tamanho do
		begin
			write(v[linha,coluna]);
		end;
		writeln('');
	end;
end;


begin(*PROGRAMA PRINCIPAL*)
	randomize;
	jogos:=0;
	inicia_jogo(tam_campo,qtd_bombas,jogos);
	texto:=ParamStr(3);	
	Assign(arquivo,texto);
	Rewrite(arquivo);
	write(arquivo,tam_campo,' ');
	writeln(arquivo, qtd_bombas);	
	matriz_verdadeira(campo_logica,tam_campo); (*se for verdadeiro coloca bombas*)
	diversidade:=random(3)+1;
	case diversidade of
	1:	begin
			sorteia_bombas1(campo_numero,campo_logica,tam_campo,qtd_bombas);
		end;
	2: 	begin
			sorteia_bombas2(campo_numero,campo_logica,tam_campo,qtd_bombas);
		end;
	3:	begin
			sorteia_bombas3(campo_numero,campo_logica,tam_campo,qtd_bombas);
		end;
	end;
	imprime(campo_numero,tam_campo);
	Close(arquivo);
end.
