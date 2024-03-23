program ejer5;
type

	celular = record
		cod : integer;
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
			writeln('COD: ',cod);
			writeln('Nombre: ',nom);
			writeln('Descripcion: ',desc);
			writeln('Marca: ',marca);
			writeln('Precio: ',precio:2:2);
			writeln('Stock Minimo: ',stock_min);
			writeln('Stock Disponible: ',stock_dis);
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
			writeln(arCelTxT,c.cod,' ',c.precio:2:2,' ',c.marca);
			writeln(arCelTxT,c.stock_dis,' ',c.stock_min,' ',c.desc);
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
	
	function yaExiste(var arCel:ArchivoCelulares; cod : integer):boolean;
	var
		c:celular;
	begin
		yaExiste:= false;
		seek(arCel,0);
		while ((not eof(arCel)) and (not yaExiste)) do begin
			read(arCel,c);
			if (cod = c.cod) then yaExiste := true;			
		end;
	end;
	
	procedure agregarCelulares(var arCel:ArchivoCelulares);
	var
		c:celular;
	begin
		reset(arCel);
		writeln();
		writeln('------------------------------------------------------');
		writeln('------ Se cargaran nuevos celulares al archivo -------');
		leerCelular(c);
		while (c.nom <> 'fin') do begin
			if (not yaExiste(arCel, c.cod)) then begin
				seek(arCel,filesize(arCel));
				write(arCel,c);
				writeln(' ========== Se agrego el celular con EXITO ==========');
			end
			else writeln(' ========== NO se puede AGREGAR - El Empleado ya EXISTE. ==========');
				leerCelular(c);
			end;
		close(arCel);	
		writeln('------------------------------------------------------');	
	end;
	
	procedure modificarStockCel(var arCel:ArchivoCelulares);
	var
		exito:boolean;
		c:celular;
		cod: integer;
	begin
		reset(arCel);
		exito := false;
		writeln();
		writeln('---------------------------------------------------');
		writeln('------ Se modificara el stock de un celular -------');
		writeln();
		write('Ingrese el codigo del celular: ');
		readln(cod);
		while ((not eof(arCel)) and (not exito)) do begin
			read(arCel,c);
			if (c.cod = cod) then begin
				write('Ingrese el nuevo stock para el celular ', c.nom,': ');
				readln(c.stock_dis);
				exito:=true;
				seek(arCel,filepos(arCel)-1);
				write(arCel,c);
			end;
		end;
		if (exito) then writeln(' ====== Se cammbio el stock con exito ======')
		else writeln(' ====== Fallo en cambiar el stock, el celular no existe ======');
		close(arCel);	
		writeln('---------------------------------------------------');	
	end;
	
	procedure ExportarSinStock(var arCel:ArchivoCelulares);
	var
		arSinStock : Text;
		c:celular;
	begin	
		assign(arSinStock,'CelularesSinStock.txt');
		rewrite(arSinStock);
		reset(arCel);
		writeln();
		writeln('------ Se exportaran los celulares sin Stock ------');
		while (not eof(arCel)) do begin
			read(arCel,c);
			if (c.stock_dis = 0) then writeln(arSinStock,c.cod,c.nom,c.desc,c.marca,c.precio,c.stock_min,c.stock_dis);
		end;
		close(arSinStock);	
		close(arCel);	
		writeln('-----------------------------------------------');
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
		writeln('5 - Agregar Celulares');
		writeln('6 - Modificar el stock de un celular');
		writeln('7 - Exportar celulares sin stock');
		writeln('8 - Salir');
		writeln('------------------------------');
		writeln('9 - Cargar Archivo de Texto.');
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
	while (opcion <> 8) do begin
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
			5:
			begin
				writeln();
				write('Ingrese el nombre del archivo al que quiere agregar celulares: ');
				readln(nombre_fisico);
				assign(arCel,nombre_fisico);
				agregarCelulares(arCel);
			end;
			6:
			begin
				writeln();
				write('Ingrese el nombre del archivo que desea modificar: ');
				readln(nombre_fisico);
				assign(arCel,nombre_fisico);
				modificarStockCel(arCel);
			end;
			7:
			begin
				writeln();
				write('Ingrese el nombre del archivo del cual va a exportar: ');
				readln(nombre_fisico);
				assign(arCel,nombre_fisico);
				ExportarSinStock(arCel);
			end;
			9: cargarArCelularesTxT();
			else writeln('!!!!!!!!!!!! NO SE SELECCIONO UNA OPCION VALIDA !!!!!!!!!!!!');	
		end;
		opcion := menuOpciones();
	end;
end.
