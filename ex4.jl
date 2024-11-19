using HorizonSideRobots
r = Robot(animate=true, 9, 9)

function ugol_right_up(r)
    n = 0  # Инициализация n
    while !isborder(r, Ost)
        if isborder(r, Nord)
            break  # Выход из цикла, если достигнута граница на севере
        end
        putmarker!(r)
        move!(r, Nord)  # Движение на север
        if !isborder(r, Ost)  # Проверка границы на востоке
            move!(r, Ost)  # Движение на восток
        end
        putmarker!(r)
        n += 1  # Увеличение n
    end 
    return n
end 

function comeback_right_up(r)
    n = ugol_right_up(r)
    for i in 1:n 
        if !isborder(r, West)
            move!(r, West)
        end
        if !isborder(r, Sud)
            move!(r, Sud)
        end
    end 
end

function ugol_left_up(r)
    n = 0  # Инициализация n
    while !isborder(r, West)
        if isborder(r, Nord)
            break  # Выход из цикла, если достигнута граница на севере
        end
        putmarker!(r)
        move!(r, Nord)  # Движение на север
        if !isborder(r, West)  # Проверка границы на западе
            move!(r, West)  # Движение на запад
        end
        putmarker!(r)
        n += 1  # Увеличение n
    end 
    return n
end 

function comeback_left_up(r)
    n = ugol_left_up(r)
    for i in 1:n 
        if !isborder(r, Ost)
            move!(r, Ost)
        end
        if !isborder(r, Sud)
            move!(r, Sud)
        end
    end 
end 

function ugol_right_down(r)
    n = 0  # Инициализация n
    while !isborder(r, Ost)
        if isborder(r, Sud)
            break  # Выход из цикла, если достигнута граница на юге
        end
        putmarker!(r)
        move!(r, Sud)  # Движение на юг
        if !isborder(r, Ost)  # Проверка границы на востоке
            move!(r, Ost)  # Движение на восток
        end
        putmarker!(r)
        n += 1  # Увеличение n
    end 
    return n
end 

function comeback_right_down(r)
    n = ugol_right_down(r)
    for i in 1:n
        if !isborder(r, Nord)
            move!(r, Nord)
        end
        if !isborder(r, West)
            move!(r, West)
        end
    end 
end 

function ugol_left_down(r)
    n = 0  # Инициализация n
    while !isborder(r, West)
        if isborder(r, Sud)
            break  # Выход из цикла, если достигнута граница на юге
        end
        putmarker!(r)
        move!(r, Sud)  # Движение на юг
        if !isborder(r, West)  # Проверка границы на западе
            move!(r, West)  # Движение на запад
        end
        putmarker!(r)
        n += 1  # Увеличение n
    end 
    return n
end 

function comeback_left_down(r)
    n = ugol_left_down(r)
    for i in 1:n 
        if !isborder(r, Nord)
            move!(r, Nord)
        end
        if !isborder(r, Ost)
            move!(r, Ost)
        end
    end 
end 

function go(r)
    comeback_right_up(r)
    comeback_left_down(r)
    comeback_left_up(r)
    comeback_right_down(r)
end 
