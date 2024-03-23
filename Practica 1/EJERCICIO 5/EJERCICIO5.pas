program ejer5;
type

	celular = record
		cod : string;
		nom : string;
		desc : string;
		marca : string;
		precio : real;
		stock_min : integer;
		stock_dis : integer;
	end;
	
	ArchivoCelulares = file of celular;
		
	// Lee por teclado la informacion de un registro de tipo celular.
	procedure leerCelular(var c : celular);
	begin
		writeln();
		writeln('====== SE INGRESARA LA INFORMACION DE UN CELULAR ======');
		with c do begin
			write('COD: ');
			readln(cod);
			write('Nombre: ');
			readln(nom);
			if (nom <> 'fin') then begin
				write('Descripcion: ');
				readln(desc);
				write('Marca: ');
				readln(marca);
				write('Precio: ');
				readln(precio);
				write('Stock Minimo: ');
				readln(stock_min);
				write('Stock Disponible: ');
				readln(stock_dis);
			end;
		end;
		writeln('=======================================================');
	end;
	
	// Imprime en pantalla la informacion de un registro de tipo celular
	procedure InformarCelular(var c : celular);
	begin
		writeln();
		writeln('================ Informacion de celular ===============');
		with c do begin
			write('COD: ',cod);
			write('Nombre: ',nom);
			write('Descripcion: ',desc);
			write('Marca: ',marca);
			write('Precio: ',precio);
			write('Stock Minimo: ',stock_min);
			write('Stock Disponible: ',stock_dis);
		end;
		writeln('=======================================================');
	end;
	
	// Solo para realizar una carga inicial del archivo para poder realizar el punto a
	procedure cargarArCelularesTxT();
	var
		arCelTxT : text;
		c:celular;
	begin
		assign(arCelTxT,'celulares.txt');
		rewrite(arCelTxT);
		writeln('========= SE CARGARA UN ARCHIVO DE CELULARES DE TEXTO ==========');
		leerCelular(c);
		while (c.nom <> 'fin') do begin
			writeln(arCelTxT,c.cod,c.precio:2:2,c.marca);
			writeln(arCelTxT,c.stock_dis,c.stock_min,c.desc);
			writeln(arCelTxT,c.nom);
			leerCelular(c);
		end;
		close(arCelTxT);
		writeln();
		writeln('=======================================================');
	end;
	
	// Se importan los datos guardados en el archivo de texto celulares.txt a 
	// un archivo de celulares binario
	procedure ImportarDeTexto(var arCel:ArchivoCelulares);
	var
		arCelTxT:text;
		c:celular;
	begin
		assign(arCelTxT,'celulares.txt');
		reset(arCelTxT);
		rewrite(arCel);

		writeln();
		writeln('====== Se Importaran los datos de un Archivo de Texto ======');
		while (not eof(arCelTxT)) do begin
			readln(arCelTxT,c.cod,c.precio,c.marca);
			readln(arCelTxT,c.stock_dis,c.stock_min,c.desc);
			readln(arCelTxT,c.nom);
			write(arCel,c);
		end;	
		writeln('============================================================');
		close(arCelTxT);	
		close(arCel);
	end;
	
	// Exporta toda la informacion del archivo binario a uno de texto.
	procedure ExportarATexto(var arCel:ArchivoCelulares);
	var
		arCelTxT:text;
		c:celular;
	begin
		assign(arCelTxT,'celulares.txt');
		rewrite(arCelTxT);
		reset(arCel);
		writeln();
		writeln('====== Se Exportaran los datos a un Archivo de Texto ======');
		while (not eof(arCel)) do begin
			read(arCel,c);
			writeln(arCelTxT,c.cod,' ',c.precio:2:2,' ',c.marca);
			writeln(arCelTxT,c.stock_dis,' ',c.stock_min,' ',c.desc);
			writeln(arCelTxT,c.nom);
		end;
		writeln('===========================================================');
		close(arCelTxT);	
		close(arCel);
	end;
		
	// Imprime en pantalla aquellos celulares con un stock disponible menor al minimo
	procedure ListarBajoStock(var arCel:ArchivoCelulares);
	var
		c:celular;
		contador:integer;
	begin
		contador:=0;
		reset(arCel);
		writeln();
		writeln('====== Se listaran los celulares que tengan un stock menor al minimo ======');
		while (not eof(arCel)) do begin
			read(arCel,c);
			if(c.stock_dis < c.stock_min) then begin
				InformarCelular(c);
				contador:= contador + 1;
			end;
		end;
		if (contador = 0) then writeln('No hay celulares con stock menor al minimo.');
		writeln();
		writeln('===========================================================================');
		close(arCel);
	end;
	
	// Imprime en pantalla aquellos celulares con descripcion igual a la ingresada por el usuario.
	procedure ListarPorDesc(var arCel:ArchivoCelulares);
	var
		c:celular;
		contador:integer;
		descripcion:string;
	begin
		contador:=0;
		reset(arCel);
		writeln();
		writeln('====== Se listaran los celulares que contengan la descripcion ingresada ======');
		write('Ingrese una Descripcion: ');
		readln(descripcion);
		while (not eof(arCel)) do begin
			read(arCel,c);
			if (c.desc = descripcion) then begin
				InformarCelular(c);
				contador:= contador + 1;
			end;
		end;
		if (contador = 0) then writeln('No hay celulares que coincidan con la descripcion ingresada.');
		writeln('==============================================================================');
		close(arCel);
	end;
	
	function menuOpciones():integer;
	begin
		writeln();
		writeln('--------- Bienvenido ---------');
		writeln('Elija alguna de las siguientes opciones ingresando el numero correspondiente:');
		writeln('1 - Crear un Archivo de Celulares Binario.');
		writeln('2 - Listar Celulares con Bajo Stock.');
		writeln('3 - Buscar Celulares Por Descripcion.');
		writeln('4 - Exportar Archivo Binario a Archivo de Texto.');
		writeln('5 - Salir');
		writeln('------------------------------');
		writeln('6 - Cargar Archivo de Texto.');
		writeln();
		write('Ingrese una opcion: ');
		readln(menuOpciones);
	end;
var
	arCel:ArchivoCelulares;
	nombre_fisico : string;
	opcion:integer;
begin
	opcion := menuOpciones();
	while (opcion <> 5) do begin
		case opcion of
			1:
			begin
				writeln();
				write('Ingrese un nombre para el archivo que quiere crear: ');
				readln(nombre_fisico);
				assign(arCel,nombre_fisico);
				ImportarDeTexto(arCel);
			end;
			2:
			begin
				writeln();
				write('Ingrese el nombre del archivo del cual quiere obtener la informacion: ');
				readln(nombre_fisico);
				assign(arCel,nombre_fisico);
				ListarBajoStock(arCel);
			end;
			3:
			begin
				writeln();
				write('Ingrese el nombre del archivo del cual quiere obtener la informacion: ');
				readln(nombre_fisico);
				assign(arCel,nombre_fisico);
				ListarPorDesc(arCel);
			end;
			4:
			begin
				writeln();
				write('Ingrese el nombre del archivo que quiere exportar a Texto: ');
				readln(nombre_fisico);
				assign(arCel,nombre_fisico);
				ExportarATexto(arCel);
			end;
			6: cargarArCelularesTxT();
			else writeln('!!!!!!!!!!!! NO SE SELECCIONO UNA OPCION VALIDA !!!!!!!!!!!!');	
		end;
		opcion := menuOpciones();
	end;
end.
