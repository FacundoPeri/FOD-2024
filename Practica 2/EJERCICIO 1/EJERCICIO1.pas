{ Una empresa posee un archivo con información de los ingresos percibidos por diferentes
empleados en concepto de comisión, de cada uno de ellos se conoce: código de empleado,
nombre y monto de la comisión. La información del archivo se encuentra ordenada por
código de empleado y cada empleado puede aparecer más de una vez en el archivo de
comisiones.
Realice un procedimiento que reciba el archivo anteriormente descrito y lo compacte. En
consecuencia, deberá generar un nuevo archivo en el cual, cada empleado aparezca una
única vez con el valor total de sus comisiones.
NOTA: No se conoce a priori la cantidad de empleados. Además, el archivo debe ser
recorrido una única vez }

program ejercicio1;
const
	valor_alto = '9999';
type
	empleado = record
		cod_emp : string;
		nom_emp : string;
		monto_com : real;
	end;
	
	empleado_resumen = record
		cod_emp : string;
		total_com : real;
	end;
	
	detalle = file of empleado;
	maestro = file of empleado_resumen;

procedure LeerEmpleado(var e:empleado);
begin
	writeln('');
	writeln('------ Se leera Informacion de un Empleado ------');
	with e do begin
		write('- Codigo: ');
		readln(cod_emp);
		if (cod_emp <> valor_alto) then begin
			write('- Nombre: ');
			readln(nom_emp);
			write('- Monto Comision: ');
			readln(monto_com);
		end;
	end;
	writeln('-------------------------------------------------');
end;

procedure CargarEmpleados(var det:detalle);
var
	e : empleado;
begin
	rewrite(det);
	writeln('');
	writeln('------ Se Cargara una Base de Empleados ------');
	LeerEmpleado(e);
	while (e.cod_emp <> valor_alto) do begin
		write(det,e);
		LeerEmpleado(e);
	end;
	writeln('----------------------------------------------');
	close(det);
end;

procedure Leer(var det : detalle; var regd:empleado);
begin
	if(not eof(det))then read(det,regd)
	else regd.cod_emp := valor_alto;
end;

procedure Compactar(var det:detalle; var mae:maestro);
var
	regm : empleado_resumen;
	regd : empleado;
begin
	rewrite(mae);
	reset(det);
	writeln('');
	writeln('------ Se Cargara una Base de Resumen del archivo de Empleados ------');
	Leer(det,regd);
	while (regd.cod_emp <> valor_alto) do begin
	
		regm.cod_emp := regd.cod_emp;
		regm.total_com := 0;		
		
		while (regd.cod_emp = regm.cod_emp) do begin
			regm.total_com := regm.total_com + regd.monto_com;
			Leer(det,regd);
		end;
					
		write(mae,regm);
	end;
	writeln('---------------------------------------------------------------------');
	close(mae);
	close(det);
end;

procedure ImprimirDetalle(var det: detalle);
var 
	regd : empleado;
begin
	reset(det);
	writeln('');
	writeln('------ Se imprimira la informacion del archivo de empleados ------');
	while (not eof(det)) do begin
		read(det,regd);
		with regd do begin
			writeln('------ EMPLEADO ------');
			writeln('- Codigo: ',cod_emp);
			writeln('- Nombre: ',nom_emp);
			writeln('- Monto Comision: ',monto_com:4:2);
			writeln('----------------------');
		end;
	end;	
	writeln('------------------------------------------------------------------');
	close(det);
end;

procedure ImprimirMaestro(var mae: maestro);
var 
	regm : empleado_resumen;
begin
	reset(mae);
	writeln('');
	writeln('------ Se imprimira la informacion del archivo de resumen ------');
	while (not eof(mae)) do begin
		read(mae,regm);
		with regm do begin
			writeln('------ EMPLEADO ------');
			writeln('- Codigo: ',cod_emp);
			writeln('- Monto Comision Total: ',total_com:4:2);
			writeln('----------------------');
		end;
	end;	
	writeln('------------------------------------------------------------------');
	close(mae);
end;

procedure MenuOpciones (var op : integer);
begin
	writeln('------ Seleccione Una Opcion ------');
	writeln('1- Cargar Archivo Empleados');
	writeln('2- Comprimir Archivo Empleados en Archivo Resumen');
	writeln('3- Imprimir Archivo Empleados');
	writeln('4- Imprimir Archivo Resumen');
	writeln('5- Salir');
	write('Ingrese una opcion: ');
	readln(op);
end;

var
	mae : maestro;
	det : detalle;
	op:integer;
begin
	assign(det,'Empleados');
	assign(mae,'Resumen');
	
	MenuOpciones(op);
	while (op <> 5) do begin
		case op of
			1: CargarEmpleados(det);
			2: Compactar(det,mae);
			3: ImprimirDetalle(det);
			4: ImprimirMaestro(mae);
			else writeln('!!!!!! No se selecciono una opcion valida !!!!!!');
		end;
		MenuOpciones(op);
	end;
end.
