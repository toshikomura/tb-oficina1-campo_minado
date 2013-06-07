program resolvedor;
uses crt,sysutils;
const max=40;
type numeros=array[1..max,1..max]of integer;
	coordenadas=array[1..max*max,1..2]of integer;
	logicas=array[1..max,1..max]of boolean;
	porcentagem=array[1..max,1..max]of real;
var 	campo_numero:numeros;
	campo_coordenadas:coordenadas;
	campo_porcento:porcentagem;
	campo_revelado:logicas;
	a,b,espacos,tam_campo,qtd_bombas,possibilidades:integer;
	ganhando:boolean;
	arquivo:text;
	texto:string;


		(*leitura de arquivo*)
procedure le_quantidades(var tamanho,bombas:integer;var ganhando:boolean);
begin
	writeln('');
	writeln('Um momento acessando os valores do tamanho e da quantidade de bombas');
	read(arquivo,tamanho);
	if (tamanho<41)and(tamanho>0) then
	begin
		readln(arquivo,bombas);
		writeln('');
		if bombas>(tamanho*tamanho)-9 then
		begin
			ganhando:=false;
			writeln('A quantidade de bombss informados no programa anterior');
			writeln('deveria ser menor ');
			writeln('Deveria estar na faixa de 1 ',tamanho*tamanho-9);	
		end;
	end
	else
	begin
		ganhando:=false;
		writeln('O programa deveria receber um tamanho entre 8 e 40');
		writeln('mas acabou recebendo o valor de ',tamanho);
		writeln('que nao esta na faixa de criterio');
		writeln('Por isso ele sera fechado sem solucionar o problema');
	end;
end;



procedure imprime(var v:numeros;var x:logicas;var p:porcentagem;
												tamanho:integer);
var l,c:integer;
begin 
	write('   ');(*para chegar na matriz*)
	if tamanho<10 then (*se o tamanho da matriz for menor que 10*)
	begin
		for c:=1 to tamanho do (*imprime somente uma linha*)
		begin
			write(c);
		end;
	end
	else
	begin (*se nao imprime duas linhas*)
		for c:=1 to 10 do (*imprime primeira linha*)
		begin
			write(' ');
		end;
		for c:=10 to tamanho do  (*imprime casa das dezenas*)
		begin
			write(c div 10);
		end;
		writeln('');
		write('    '); (*para alcancar a matriz*)
		for c:=1 to tamanho do(*imprime segunda linha*)
		begin
			write(c mod 10);
		end;
		writeln('');
	end;
	write('   '); (*alcancar a matriz*)
	for c:=0 to tamanho+1 do (*imprime borda da matriz*)
	begin
		write('+');
	end;
	writeln('');
	for l:=1 to tamanho do (*imprime a matriz*)
	begin
		if l<10 then (*imprime linha*)
			write(l,'  +')
		else
			write(l,' +');
		for c:=1 to tamanho do
		begin
			if x[l,c] then (*se ja foi revelado abre o numero*)
			begin
				case v[l,c] of
				0:	write(' ');
				9:	begin
						TextColor(red);
						write('9');
						TextColor(white);
						NormVideo;
					end;
				else
					write(v[l,c]);
				end;
			end
			else (*se não esconde a posição*)
			begin
				if p[l,c]=1 then
				begin
					TextColor(yellow);
					write('b');
					TextColor(white);
					NormVideo;
				end
				else
					write('#');
			end;
		end;
		writeln('+ ',l); (*imprime linha*)
	end;
	write('   '); (*alcancar a matriz*)
	for c:=0 to tamanho+1 do (*imprime borda da matriz*)
	begin
		write('+');
	end;
	writeln('');
	write('   ');(*para chegar na matriz*)
	if tamanho<10 then (*se o tamanho da matriz for menor que 10*)
	begin
		for c:=1 to tamanho do (*imprime somente uma linha*)
		begin
			write(c);
		end;
	end
	else
	begin (*se nao imprime duas linhas*)
		for c:=1 to 10 do (*imprime primeira linha*)
		begin
			write(' ');
		end;
		for c:=10 to tamanho do 
		begin
			write(c div 10); (*imprime casa das dezenas*)
		end;
		writeln('');
		write('    '); (*para alcancar a matriz*)
		for c:=1 to tamanho do(*imprime segunda linha*)
		begin
			write(c mod 10);
		end;
		writeln('');
	end;

end; 


procedure imprimep(var p:porcentagem;tamanho:integer);
var l,c:integer;
begin
	writeln('');
	writeln('Matriz de porcentagem');
	writeln('');
	for l:=1 to tamanho do
	begin
		for c:=1 to tamanho do
		begin
			write(p[l,c]:3:3,' ');
		end;
		writeln('');
	end;
	writeln('');
end;


function conta_espacos_nao_revelados(var x:logicas;tamanho:integer):Integer;
var l,c,quantidade:integer;
begin
	quantidade:=0;
	for l:=1 to tamanho do
	begin
		for c:=1 to tamanho do
		begin
			if not(x[l,c]) then (*se nao foi revelado*)
				quantidade:=quantidade+1;
		end;
	end;
	conta_espacos_nao_revelados:=quantidade;
end;


procedure zera_porcentagens(var p:porcentagem;tamanho:integer);
var l,c:integer;
begin
	for l:=1 to tamanho do
	begin
		for c:=1 to tamanho do
		begin
			p[l,c]:=0;
		end;
	end;
end; 


procedure completa_matriz(var v:numeros;l,c,tamanho:integer);
var aux_l,aux_c,aux:integer;
begin
	aux_l:=l+2;
	aux_c:=c+2;
	l:=l-1;
	aux:=c-1;
	while l<aux_l do
	begin
		if (l<=tamanho)and(l>0) then
		begin
			c:=aux;
			while c<aux_c do
			begin
				if (c<=tamanho)and(c>0) then
				begin
					if v[l,c]<>9 then
						v[l,c]:=v[l,c]+1;
				end;
				c:=c+1;
			end;
		end;
		l:=l+1;
	end;
end;


procedure sorteia_bombas(var v:numeros;var x:logicas;tamanho,bombas:integer);
var l,c:integer;
begin
	while bombas<>0 do
	begin
		read(arquivo,l);
		readln(arquivo,c);
		bombas:=bombas-1;
		v[l,c]:=9;
		completa_matriz(v,l,c,tamanho);	
	end;
end;


procedure procura_zeros(var v:numeros;var x:logicas;l,c,tamanho:integer);
var aux_l,aux_c,menor_c:integer;
begin
	aux_l:=l+2;
	aux_c:=c+2;
    	l:=l-1;
	menor_c:=c-1;
    	x[l,c]:= true;
    	while l<aux_l do           
    	begin
		c:=menor_c;
       	while c<aux_c do
        	begin
            	if(v[l,c]=0)and(l>0)and(l<=tamanho)and(c>0)and(c<=tamanho) 
													and not(x[l,c])then
            	begin
              	 	x[l,c]:=true;
               	procura_zeros(v,x,l,c,tamanho);
            	end
            	else
			begin 
				if (v[l,c]<>0)and(v[l,c]<>9)and not(x[l,c])then
 					x[l,c]:= true;
			end;
            	c:=c+1;
		end;
          l:=l+1;
    	end;
end;


procedure inicia_matriz(var v:numeros;var x:logicas;tamanho:integer);
var l,c:integer;
begin
	for l:=1 to max do (*esconder posicoes*)
	begin
		for c:=1 to max do
		begin
			x[l,c]:=false;
		end;
	end;
	l:=tamanho div 2;(*posicao que ja pode ser revelada*)
	c:=l;
	writeln('O programa escolheu a linha ',l,' e a coluna ',c);
	writeln('');	
	procura_zeros(v,x,l,c,tamanho);
end;


procedure coloca_porcentagem(var x:logicas;var p:porcentagem;l,c,tamanho:integer;
													porcento:real);
var aux_l,aux_c,menor_c:integer;
begin
	aux_l:=l+2;
	aux_c:=c+2;
	l:=l-1;
	menor_c:=c-1;
	while l<aux_l do
	begin
		if (l<=tamanho)and(l>0) then (*para não sair da matriz*)
		begin
			c:=menor_c;
			while c<aux_c do
			begin
				if (c<=tamanho)and(c>0) then (*para não sair da matriz*)
				begin
					if not(x[l,c]) then (*se nao foi revelado*)
					begin
						if p[l,c]>=1 then (*garante a possibiidade bomba*)
							p[l,c]:=1 (*pois pode ultrapassar a 100%*)
						else
							p[l,c]:=p[l,c]+porcento;
					end;
				end;						
				c:=c+1;
			end;
		end;
		l:=l+1;
	end;
end;


procedure testes(var v:numeros;var x:logicas;var p:porcentagem;l,c,tamanho:integer);
var porcento:real;
begin 
	case v[l,c] of
	1:	begin
			porcento:=1/8;
			coloca_porcentagem(x,p,l,c,tamanho,porcento);
		end;
	2:	begin
			porcento:=2/8;
			coloca_porcentagem(x,p,l,c,tamanho,porcento);
		end;
	3:	begin
			porcento:=3/8;
			coloca_porcentagem(x,p,l,c,tamanho,porcento);
		end;
	4:	begin
			porcento:=4/8;
			coloca_porcentagem(x,p,l,c,tamanho,porcento);
		end;
	5:	begin
			porcento:=5/8;
			coloca_porcentagem(x,p,l,c,tamanho,porcento);
		end;
	6:	begin
			porcento:=6/8;
			coloca_porcentagem(x,p,l,c,tamanho,porcento);
		end;
	7:	begin
			porcento:=7/8;
			coloca_porcentagem(x,p,l,c,tamanho,porcento);
		end;
	8:	begin
			porcento:=8/8;
			coloca_porcentagem(x,p,l,c,tamanho,porcento);
		end;
	end;
end;


procedure rastreia_matriz(var v:numeros;var x:logicas;var p:porcentagem;
													   tamanho:integer);
var l,c:integer;
begin
	for l:=1 to tamanho do
	begin
		for c:=1 to tamanho do
		begin
			if (x[l,c])and(v[l,c]<>0) then (*se ja foi revelado*)
			begin
				testes(v,x,p,l,c,tamanho); (*nas posicoes abertas *)
			end;			(*verifica as possibilidades em volta*)
		end;
	end;
end;


procedure salva(var cordenada:coordenadas;l,c:integer;var linha:integer);
begin
	cordenada[linha,1]:=l; (*salva a linha*)
	cordenada[linha,2]:=c; (*salva a coluna*)
	linha:=linha+1; (*passa para proxima linha*)
end;


procedure apaga(var cordenada:coordenadas;linha:integer);
var aux:integer;
begin
	for aux:=linha downto 1 do (*zera toda a matriz*)
	begin
		cordenada[aux,1]:=0;
		cordenada[aux,2]:=0;
	end;
end;


procedure escolhe_posicao(var x:logicas;var p:porcentagem;var cordenada:coordenadas;
						var possibilidades,tamanho:integer);
var l,c:integer;
	menor:real;
begin
	possibilidades:=1;
	menor:=7/8;
	for l:=1 to tamanho do
	begin
		for c:=1 to tamanho do
		begin
			if p[l,c]=menor then (*se for o menor salva coordenada*)
			begin
				salva(cordenada,l,c,possibilidades);
			end
			else
			begin
				if (p[l,c]<menor)and(p[l,c]<>0) then (*se for menor troca o*) 
				begin					(*menor e nao pode ser zero*)
					menor:=p[l,c]; (*troca do menor*)
					apaga(cordenada,possibilidades); (*apaga a matriz que salva 
														coordenadas*)
					possibilidades:=1;  (*as possibilidades voltam ao inicio*)
					salva(cordenada,l,c,possibilidades);
				end;
			end;
		end;
	end;
	possibilidades:=possibilidades-1;(*retira 1 pois possibilidades sempre soma*)
end;		(*ao final e se ele nao encontra mais ninguem vai estar com um a mais*) 


procedure abre_posicao(var v:numeros;var x:logicas;var cordenada:coordenadas;
						possibilidades,tamanho:integer;var ganhando:boolean);
var l,linha,coluna,a:integer;
begin
	l:=random(possibilidades)+1; 
	linha:=cordenada[l,1];
	coluna:=cordenada[l,2];
	x[linha,coluna]:=true; (*posicao aberta*)
	writeln('Possibilidades de chute: ',possibilidades);
	for a:=1 to possibilidades do
	begin
		writeln('linha coluna');
		writeln(cordenada[a,1],'      ',cordenada[a,2]);
	end;
	writeln('O programa escolheu a linha ',linha,' e a coluna ',coluna);
	writeln('');	
	if v[linha,coluna]=9 then
		ganhando:=false
	else
	begin
		if v[linha,coluna]=0 then
		begin
			procura_zeros(v,x,linha,coluna,tamanho);
		end;
	end;
end;


function procura_bomba(var p:porcentagem;tamanho,bombas:integer):integer;
var l,c:integer;
begin
	for l:=1 to tamanho do
	begin
		for c:=1 to tamanho do
		begin
			if p[l,c]=1 then
				bombas:=bombas-1;
		end;
	end;
	procura_bomba:=bombas;
end;


begin (*PROGRAMA PRINCIPAL*)
	ganhando:=true;
	randomize;
	texto:=ParamStr(1);
	Assign(arquivo,texto);
	Reset(arquivo);
	le_quantidades(tam_campo,qtd_bombas,ganhando);
	sorteia_bombas(campo_numero,campo_revelado,tam_campo,qtd_bombas);
	imprimep(campo_porcento,tam_campo);
	inicia_matriz(campo_numero,campo_revelado,tam_campo);(*condicoes do jogo*)
	writeln('Tamanho ',tam_campo);
	writeln('Bombas ',qtd_bombas);
	writeln('');
	imprime(campo_numero,campo_revelado,campo_porcento,tam_campo);
	b:=qtd_bombas;
	delay(4000);
	while (qtd_bombas<>0)and(ganhando) do
	begin
		qtd_bombas:=b;
		espacos:=conta_espacos_nao_revelados(campo_revelado,tam_campo);
		if espacos=qtd_bombas then (*se a quantidade de bombas=espacos nao*)
		begin
			writeln('');
			write('A quantidade de espacos a ser revelado e igual a');
			writeln(' quantidade de bombas');
			write('Por isso ');
			qtd_bombas:=0			(*revelados fecha o programa*)
		end
		else
		begin		(*se nao verifica a melhor possiblidade*)
			zera_porcentagens(campo_porcento,tam_campo);	
			rastreia_matriz(campo_numero,campo_revelado,campo_porcento,tam_campo);
			escolhe_posicao(campo_revelado,campo_porcento,campo_coordenadas,
											possibilidades,tam_campo);
			imprimep(campo_porcento,tam_campo);
			abre_posicao(campo_numero,campo_revelado,campo_coordenadas,
										possibilidades,tam_campo,ganhando);
			writeln('Tamanho ',tam_campo);
			writeln('Bombas ',b);
			writeln('');
			qtd_bombas:=procura_bomba(campo_porcento,tam_campo,qtd_bombas);
			writeln('Restam ',qtd_bombas,' bombas para serem encontradas');
			writeln('');
			imprime(campo_numero,campo_revelado,campo_porcento,tam_campo);
			delay(4000);
		end;
	end;
	Close(arquivo);
	if ganhando then
	begin
		writeln('GANHOUUU');
		writeln('O programa conseguiu resolver o campo minado');
	end	
	else
	begin
		writeln('PERDEUUU');
		writeln('O campo nao conseguiu resolver o campo minado');
	end;
end.
