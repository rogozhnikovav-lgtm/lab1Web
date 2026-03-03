--1

SELECT
    Школа,
    Предмет,
    MAX(Баллы) AS МаксимальныйБалл
FROM
    Ученики
GROUP BY
    Школа, Предмет WITH ROLLUP;

	--2

	SELECT
    Школа,
    Предмет,
    MIN(Баллы) AS МинимальныйБалл
FROM
    Ученики
GROUP BY
    Школа, Предмет WITH CUBE;


	--3

	SELECT
    Школа,
    Предмет,
    AVG(Баллы) AS СреднийБалл
FROM
    Ученики
GROUP BY
    GROUPING SETS(Школа, Предмет);

	--4

	SELECT
    COALESCE(Школа, 'Все школы') AS Школа,
    COALESCE(Предмет, 'Все предметы') AS Предмет,
    COUNT(Фамилия) AS Количество
FROM
    Ученики
GROUP BY
    ROLLUP(Школа, Предмет);

	--5

	SELECT
    IIF(GROUPING(Школа) = 1, 'Итого по школам', Школа) AS Школа,
    IIF(GROUPING(Предмет) = 1, 'Итого по предметам', Предмет) AS Предмет,
    SUM(Баллы) AS СуммарныйБалл
FROM
    Ученики
GROUP BY
    CUBE(Школа, Предмет);

	--6

	SELECT
    CASE GROUPING_ID(Школа, Предмет)
        WHEN 1 THEN 'Итого по предметам'  
        WHEN 2 THEN 'Итого по школам'      
        WHEN 3 THEN 'Общий итог'          
        ELSE ''                          
    END AS УровеньИтога,
    ISNULL(Школа, '') AS Школа,
    ISNULL(Предмет, '') AS Предмет,
    MAX(Баллы) AS МаксимальныйБалл
FROM
    Ученики
GROUP BY
    CUBE(Школа, Предмет);

	--7

	SELECT
    'Средний балл' AS Показатель, Гимазия, Гимназия, Лицей
FROM
    (
    SELECT
        Школа,
        Баллы
    FROM
        Ученики
    ) AS Источник
PIVOT
    (
    AVG(Баллы)
    FOR Школа IN (Гимазия, Гимназия, Лицей)
    ) AS PIVOT_TABLE;

	--8

	SELECT Предмет,
    'Средний балл' AS Показатель, Гимазия, Гимназия, Лицей
FROM
    (
    SELECT
		Предмет,
        Школа,
        Баллы
    FROM
        Ученики
    ) AS Источник
PIVOT
    (
    AVG(Баллы)
    FOR Школа IN (Гимазия, Гимназия, Лицей)
    ) AS PIVOT_TABLE;

	--9

	SELECT
    Фамилия,
    ТипДанных,
    Значение
FROM
    (
    SELECT
        Фамилия,
        CAST(Предмет AS NVARCHAR(100)) AS Предмет,
        CAST(Школа AS NVARCHAR(100)) AS Школа 
    FROM
        Ученики
    ) AS Источник
UNPIVOT
    (
    Значение FOR ТипДанных IN (Предмет, Школа)
    ) AS UnpivotTable;
