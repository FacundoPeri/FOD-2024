{
El encargado de ventas de un negocio de productos de limpieza desea administrar el stock
de los productos que vende. Para ello, genera un archivo maestro donde figuran todos los
productos que comercializa. De cada producto se maneja la siguiente información: código de
producto, nombre comercial, precio de venta, stock actual y stock mínimo. Diariamente se
genera un archivo detalle donde se registran todas las ventas de productos realizadas. De
cada venta se registran: código de producto y cantidad de unidades vendidas. Se pide
realizar un programa con opciones para:
a. Actualizar el archivo maestro con el archivo detalle, sabiendo que:
● Ambos archivos están ordenados por código de producto.
● Cada registro del maestro puede ser actualizado por 0, 1 ó más registros del
archivo detalle.
● El archivo detalle sólo contiene registros que están en el archivo maestro.
b. Listar en un archivo de texto llamado “stock_minimo.txt” aquellos productos cuyo
stock actual esté por debajo del stock mínimo permitido.
}

program ejercicio;
const
	valor_alto = '9999';
type	
	producto = record
		cod : string;
		nom : string;
		pre : real;
		stock_act : integer;
		stock_min : integer;
	end;
	
	venta = record
		cod : string;
		cant : integer;
	end;
	
	maestro = file of producto;
	detalle = file of venta;

procedure LeerProducto(var p : producto);
begin
	writeln('');
	writeln('------ Se cargara informacion de un Prodcuto -----');
	with p do begin
		write('- Codigo: ');
		readln(cod);
		if (cod <> '9999') then begin
			write('- Nombre: ');
			readln(nom);
			write('- Precio: ');
			readln(pre);
			write('- Stock Actual: ');
			readln(stock_act);
			write('- Stock Minimo: ');
			readln(stock_min);
		end;
	end;
	writeln('--------------------------------------------------');
end;

procedure CargarMaestro(var mae : maestro);
var p:producto;
begin
	rewrite(mae);
	writeln('');
	writeln('------ Se cargara el archivo de Productos -----');
	LeerProducto(p);
	while (p.cod <> '9999') do begin
		write(mae,p);
		LeerProducto(p);
	end;
	writeln('----------------------------------------------');
	close(mae);
end;

procedure LeerVenta(var v : venta);
begin
	writeln('');
	writeln('------ Se cargara informacion de una Venta -----');
	with v do begin
		write('- Codigo: ');
		readln(cod);
		if (cod <> '9999') then begin
			write('- Cantidad Vendida: ');
			readln(cant);
		end;
	end;
	writeln('--------------------------------------------------');
end;

procedure CargarDetalle(var det : detalle);
var v:venta;
begin
	rewrite(det);
	writeln('');
	writeln('------ Se cargara el archivo de Ventas -----');
	LeerVenta(v);
	while (v.cod <> '9999') do begin
		write(det,v);
		LeerVenta(v);
	end;
	writeln('----------------------------------------------');
	close(det);
end;

procedure LeerDetalle(var det:detalle; var regd : venta);
begin
	if (not eof(det)) then read(det,regd)
	else regd.cod := '9999'
end;

procedure ActualizarMaestro(var mae:maestro; var det:detalle);
var
	regd : venta;
	regm : producto;
	cod_act : string;
begin
	writeln('');
	writeln('------ SE ACTUALIZARA EL ARCHIVO DE PRODUCTOS ------');
	writeln('####################################################');

	reset(mae);
	reset(det);
	
	read(mae,regm);
	LeerDetalle(det,regd);
	
	while (regd.cod <> '9999') do begin
		cod_act := regd.cod;
		
		while (regm.cod <> cod_act) do read(mae,regm);
		
		while (cod_act = regd.cod) do begin
			regm.stock_act := regm.stock_act - regd.cant;
			LeerDetalle(det,regd);
		end;
		
		seek(mae,filepos(mae)-1);
		
		write(mae,regm);
		
		if(not eof(mae)) then read(mae,regm);
	
	end;
	writeln('####################################################');
	writeln('----------------------------------------------------');
	close(mae);
	close(det);
end;
		
procedure ImprimirDetalle(var det: detalle);
var 
	regd : venta;
begin
	reset(det);
	writeln('');
	writeln('------ Se imprimira la informacion del archivo de Ventas ------');
	while (not eof(det)) do begin
		read(det,regd);
		with regd do begin
			writeln('------ Venta ------');
			writeln('- Codigo Producto: ',cod);
			writeln('- Cantidad Vendida: ',cant);
			writeln('----------------------');
		end;
	end;	
	writeln('------------------------------------------------------------------');
	close(det);
end;

procedure ImprimirMaestro(var mae: maestro);
var 
	regm : producto;
begin
	reset(mae);
	writeln('');
	writeln('------ Se imprimira la informacion del archivo de Productos ------');
	while (not eof(mae)) do begin
		read(mae,regm);
		with regm do begin
			writeln('------ Producto ------');
			writeln('- Codigo: ',cod);
			writeln('- Nombre: ',nom);
			writeln('- Precio: ',pre:2:2);
			writeln('- Stock Actual: ',stock_act);
			writeln('- Stock Minimo: ',stock_min);
			writeln('----------------------');
		end;
	end;	
	writeln('------------------------------------------------------------------');
	close(mae);
end;

procedure InformarTXT(var mae:maestro);
var
	regm:producto;
	info : text;
begin
	assign(info,'stock_minimo.txt');
	rewrite(info);
	reset(mae);
	while (not eof(mae)) do begin
		read(mae, regm);
		with regm do begin
			if (stock_act < stock_min) then
				write(info,cod,' ',nom,' ',pre:2:2,' ',stock_act,' ',stock_min);
		end;
	end;
	close(mae);
	close(info);
end;

procedure MenuOpciones (var op : integer);
begin
	writeln('');
	writeln('===================================');
	writeln('------ Seleccione Una Opcion ------');
	writeln('1- Cargar Archivo Productos');
	writeln('2- Cargar Archivo Ventas');
	writeln('3- Actualizar Archivo Productos');
	writeln('4- Imprimir Archivo Prodcutos');
	writeln('5- Imprimir Archivo Ventas');
	writeln('6- Informar Productos Bajo Stock');
	writeln('7- Salir');
	writeln('===================================');
	write('Ingrese una opcion: ');
	readln(op);
end;
var
	mae : maestro;
	det : detalle;
	op:integer;
begin
	assign(det,'Ventas');
	assign(mae,'Maestro');
	
	MenuOpciones(op);
	while (op <> 7) do begin
		case op of
			1: CargarMaestro(mae);
			2: CargarDetalle(det);
			3: ActualizarMaestro(mae,det);
			4: ImprimirMaestro(mae);
			5: ImprimirDetalle(det);
			6: InformarTXT(mae);
			else writeln('!!!!!! No se selecciono una opcion valida !!!!!!');
		end;
		MenuOpciones(op);
	end;
end.	
