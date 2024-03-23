//Realizar un algoritmo, que utilizando el archivo de números enteros no ordenados
//creado en el ejercicio 1, informe por pantalla cantidad de números menores a 1500 y el
//promedio de los números ingresados. El nombre del archivo a procesar debe ser
//proporcionado por el usuario una única vez. Además, el algoritmo deberá listar el
//contenido del archivo en pantalla.
program ejer2;
type
    ArchivoEnteros = file of integer;
var
   nombre_fisico:string;
   arEnt:ArchivoEnteros;
   nro,cant_menores,total,cant_nros:integer;
   promedio:real;
begin

     cant_menores  := 0;
     total    := 0;
     cant_nros:= 0;

     write('Ingrese el nombre del archivo a procesar: ');
     readln(nombre_fisico);

     assign(arEnt,nombre_fisico);
     reset(arEnt);

     writeln('--------------------------');
     writeln('Lista de Numeros del Archivo');
     while not eof(arEnt) do begin
           read(arEnt,nro);
           writeln(nro);

           if (nro < 1500) then cant_menores:= cant_menores + 1;
           total := total + nro;
           cant_nros := cant_nros + 1;
     end;
     writeln('--------------------------');

     promedio:= total / cant_nros;

     writeln('La cantidad de numeros menores a 1500 es:', cant_menores);
     writeln('El promedio es: ',promedio:2:2);

    readln();
    close(arEnt);

end.


