-- Sección 1: Consultas de Agregación y Agrupación (Conceptos Fundamentales) 
-- En esta sección, nos enfocaremos en resumir y agrupar datos para obtener información consolidada. 
-- 1. Conteo General: ¿Cuántos empleados hay en total en la base de datos? 
select  COUNT(emp_no) from employees; 
-- 2. Salarios Extremos: ¿Cuál es el salario más alto y el salario más bajo que se ha pagado en la historia de la empresa? 
select min(salary), max(salary) from salaries;
-- 3. Promedio Salarial: ¿Cuál es el salario promedio de todos los empleados? 
select avg(salary) from salaries;
-- 4. Agrupación por Género: Genera un reporte que muestre cuántos empleados hay de cada género (M y F). 
SELECT gender, COUNT(*) AS total_empleados FROM employees
GROUP BY gender;
-- 5. Conteo de Cargos: ¿Cuántos empleados han ostentado cada cargo (title) a lo largo del tiempo? Ordena los resultados del cargo más común al menos común. 
SELECT title, COUNT(*) AS num_empleados_ocupado
FROM titles
GROUP BY title
ORDER BY  num_empleados_ocupado DESC;
-- 6. Filtro de Grupos con HAVING: Muestra los cargos que han sido ocupados por más  de 75,000 personas. 
SELECT title, COUNT(*) as  num_empleados_ocupado
FROM titles
GROUP BY title
HAVING COUNT(title) > 75000;
-- 7. Agrupación Múltiple: ¿Cuántos empleados masculinos y femeninos hay por cada cargo?
SELECT 
    t.title,
    e.gender,
    COUNT(*) AS total_empleados
FROM employees e
JOIN titles t ON e.emp_no = t.emp_no
GROUP BY t.title, e.gender
ORDER BY t.title, e.gender;
-- Sección 2: JOINs y Combinación de Múltiples Tablas 
-- Aquí el objetivo es cruzar información de diferentes tablas para construir reportes más completos. 
-- 8. Nombres de Departamentos: Muestra una lista de todos los empleados (emp_no, f irst_name) junto al nombre del departamento en el que trabajan actualmente. 
SELECT 
    e.emp_no,
    e.first_name,
    dep.dept_name AS departamento
FROM employees e
JOIN dept_emp de ON e.emp_no = de.emp_no
JOIN departments dep ON de.dept_no = dep.dept_no;
-- 9. Empleados de un Departamento Específico: Obtén el nombre y apellido de todos los empleados que trabajan en el departamento de "Marketing".
SELECT 
    e.emp_no,
    e.first_name,
    e.last_name,
    dep.dept_name AS departamento
FROM employees e
JOIN dept_emp de ON e.emp_no = de.emp_no
JOIN departments dep ON de.dept_no = dep.dept_no
where  dep.dept_name in ("Marketing");
-- 10. Gerentes Actuales: Genera una lista de los gerentes de departamento (managers) actuales, mostrando su número de empleado, nombre completo y el nombre del departamento que dirigen. 
SELECT 
    e.emp_no,
    e.first_name,
    e.last_name,
    dep.dept_name AS departamento
    
FROM employees e
inner JOIN dept_manager  dm ON e.emp_no = dm.emp_no
JOIN departments dep ON dm.dept_no = dep.dept_no
JOIN titles t ON e.emp_no = t.emp_no
WHERE t.to_date = '9999-01-01';
-- 11. Salario por Departamento: Calcula el salario promedio actual para cada departamento. El reporte debe mostrar el nombre del departamento y su salario promedio. 
SELECT 
    dep.dept_name AS departamento,
    AVG(s.salary) AS promedio_salario
FROM employees e
JOIN dept_emp de ON e.emp_no = de.emp_no
JOIN departments dep ON de.dept_no = dep.dept_no
JOIN salaries s ON e.emp_no = s.emp_no
JOIN titles t ON e.emp_no = t.emp_no
WHERE t.to_date = '9999-01-01'
GROUP BY dep.dept_name
ORDER BY promedio_salario DESC;

-- 12. Historial de Cargos de un Empleado: Muestra todos los cargos que ha tenido el empleado número 10006, junto con las fechas de inicio y fin de cada cargo. 
SELECT 
    title,
    from_date,
    to_date
FROM titles 
WHERE emp_no = 10006;

-- 13. Departamentos sin Empleados (LEFT JOIN): ¿Hay algún departamento que no tenga empleados asignados? (Esta consulta teórica te ayudará a entender LEFT JOIN). 
SELECT 
    d.dept_no,
    d.dept_name
FROM departments d
LEFT JOIN dept_emp de ON d.dept_no = de.dept_no
WHERE de.emp_no IS NULL;

-- 14. Salario Actual del Empleado: Obtén el nombre, apellido y el salario actual de todos los empleados. 
select 
    e.first_name,
    e.last_name,
    s.salary
from employees e 
join salaries s on e.emp_no = s.emp_no
WHERE s.to_date = '9999-01-01'; 

-- Sección 3: Subconsultas (Consultas Anidadas) 
-- Ahora, resolveremos problemas que requieren una consulta interna para obtener un dato o una lista de datos necesarios para la consulta principal. 
-- 15. Salarios por Encima del Promedio: Encuentra a todos los empleados cuyo salario actual es mayor que el salario promedio de toda la empresa.
select  
 e.first_name,
    e.last_name,
    s.salary,
    avg(salary) as promedio
from employees e 
join salaries s on e.emp_no = s.emp_no
WHERE s.to_date = '9999-01-01' 
and s.salary > (
        SELECT AVG(salary) 
        FROM salaries 
  );
-- 16. Nombres de los Gerentes: Usando una subconsulta con IN, muestra el nombre y apellido de todas las personas que son o han sido gerentes de un departamento. 
SELECT 
    e.first_name,
    e.last_name
FROM employees e
WHERE e.emp_no IN (
    SELECT dm.emp_no
    FROM dept_manager dm
);
-- 17. Empleados que no son Gerentes: Encuentra a todos los empleados que nunca han sido gerentes de un departamento, usando NOT IN.
 SELECT 
    e.first_name,
    e.last_name
FROM employees e
WHERE e.emp_no not IN (
    SELECT dm.emp_no
    FROM dept_manager dm
);
-- 18. Último Empleado Contratado: ¿Quién es el último empleado que fue contratado? Muestra su nombre completo y fecha de contratación. 
SELECT first_name, last_name, hire_date
FROM employees
WHERE hire_date = (SELECT MAX(hire_date) FROM employees);

-- 19. Jefes del Departamento de "Development": Obtén los nombres de todos los gerentes que han dirigido el departamento de "Development". 
select 
      e.first_name,
      e.last_name
      from employees e
join dept_manager dm on dm.emp_no =e.emp_no
join  departments dep on dep.dept_no = dm.dept_no
wHERE dept_name in ("Development")  ;
-- 20. Empleados con el Salario Máximo: Encuentra al empleado (o empleados) que tiene el salario más alto registrado en la tabla de salarios. 
SELECT e.first_name, e.last_name, s.salary
FROM employees e
join salaries s on s.emp_no = e.emp_no
where salary  =(SELECT MAX(salary) FROM salaries)
-- Sección 4: Funciones Avanzadas (Manipulación de Datos) 
-- En esta sección, usaremos funciones para transformar y formatear los datos directamente en la consulta. 
-- 21. Nombres Completos: Muestra una lista de los primeros 100 empleados con su nombre y apellido combinados en una sola columna llamada nombre_completo. 
SELECT  
    CONCAT(first_name, ' ', last_name) AS nombre_completo
FROM employees
LIMIT 100;

-- 22. Antigüedad del Empleado: Calcula la antigüedad en años de cada empleado (desde hire_date hasta la fecha actual). Muestra el número de empleado y su antigüedad. 
SELECT 
    first_name, 
    last_name, 
    TIMESTAMPDIFF(YEAR, hire_date, CURDATE()) AS antiguedad
FROM employees;

-- 23. Categorización de Salarios con CASE: Clasifica los salarios actuales de los empleados en tres categorías: o 'Bajo': si es menor a 50,000. o 'Medio': si está entre 50,000 y 90,000. o 'Alto': si es mayor a 90,000. 
SELECT 
    e.first_name,
    e.last_name,
    s.salary,
    CASE
        WHEN s.salary < 50000 THEN 'Bajo'
        WHEN s.salary BETWEEN 50000 AND 90000 THEN 'Medio'
        ELSE 'Alto'
    END AS categoria_salario
FROM employees e 
JOIN salaries s ON e.emp_no = s.emp_no
WHERE s.to_date = '9999-01-01';

 
-- 24. Mes de Contratación: Genera un reporte que cuente cuántos empleados fueron contratados en cada mes del año (independientemente del año). 

select MONTH(hire_date) as mes_Contratado , count(*) as numero_empleados 
from employees
group by MONTH(hire_date);

-- 25. Iniciales de Empleados: Crea una columna que muestre las iniciales de cada empleado (por ejemplo, para 'Georgi Facello' sería 'G.F.'). 
select concat(SUBSTRING_INDEX(first_name,' ',1),' ',SUBSTRING_INDEX(last_name,' ',1))  as nombre_apellido 
from employees

-- Sección 5: Desafío Final (Combinando Todo) 
-- Estas consultas requieren la combinación de JOINs, subconsultas, agregaciones y funciones para resolver problemas más complejos. 
-- 26. Departamento con el Mejor Salario Promedio: ¿Qué departamento tiene el salario promedio actual más alto? 
select avg(s.salary) as promedio_Salario, d.dept_name
from departments d
join dept_emp de on de.dept_no = d.dept_no
join  employees e on e.emp_no = de.emp_no
join salaries s  on e.emp_no = s.emp_no
group by dept_name;
-- 27. Gerente con Más Tiempo en el Cargo: Encuentra al gerente que ha estado en su puesto por más tiempo. Muestra su nombre y el número de días en el cargo. 
select  e.first_name, e.last_name,DATEDIFF(dm.to_date, dm.from_date) AS dias_contratados
from dept_manager dm
inner join  employees e on e.emp_no = dm.emp_no
where  DATEDIFF(dm.to_date, dm.from_date) = (
    SELECT MAX(DATEDIFF(to_date, from_date)) 
    FROM dept_manager );

-- 28. Incremento Salarial por Empleado: Para el empleado 10001, calcula la diferencia entre su primer salario y su salario actual. 
SELECT 
    e.first_name, 
    e.last_name,
    primer.salary AS primer_salario,
    actual.salary AS salario_actual,
    actual.salary - primer.salary AS incremento
FROM employees e
JOIN (
    SELECT emp_no, salary
    FROM salaries
    WHERE emp_no = 10001 
    ORDER BY from_date ASC
    LIMIT 1
) AS primer ON e.emp_no = primer.emp_no
JOIN (
    SELECT emp_no, salary
    FROM salaries
    WHERE emp_no = 10001
      AND to_date = '9999-01-01'
) AS actual ON e.emp_no = actual.emp_no;

-- 29. Empleados Contratados el Mismo Día: Encuentra todos los pares de empleados que fueron contratados en la misma fecha. 
SELECT 
    e1.emp_no AS emp_no1,
    e1.first_name AS nombre1,
    e1.last_name AS apellido1,
    e2.emp_no AS emp_no2,
    e2.first_name AS nombre2,
    e2.last_name AS apellido2,
    e1.hire_date
FROM employees e1
JOIN employees e2 
    ON e1.hire_date = e2.hire_date
   AND e1.emp_no < e2.emp_no
ORDER BY e1.hire_date;


-- 30. El Ingeniero Mejor Pagado: ¿Quién es el 'Senior Engineer' con el salario actual más alto en toda la empresa? Muestra su nombre, apellido y salario.
SELECT 
    e.first_name, 
    e.last_name, 
    s.salary
FROM employees e
JOIN titles t ON t.emp_no = e.emp_no
JOIN salaries s ON s.emp_no = e.emp_no
WHERE t.title = 'Senior Engineer'
  AND s.to_date = '9999-01-01'
  AND s.salary = (
      SELECT MAX(s2.salary)
      FROM salaries s2
      JOIN titles t2 ON t2.emp_no = s2.emp_no
      WHERE t2.title = 'Senior Engineer'
        AND s2.to_date = '9999-01-01'
  );

