SELECT * FROM Товары WHERE Цена > 1 AND Цена <3 


SELECT * FROM Заказы WHERE Дата_поставки > '2025.01.01'


SELECT * FROM ЗАКАЗЫ
WHERE ЗАКАЗЫ.Наименование_товара = 'Item1'
ORDER BY ЗАКАЗЫ.Дата_поставки

SELECT * FROM Заказы WHERE Заказчик = 'Company1' ORDER BY Дата_поставки