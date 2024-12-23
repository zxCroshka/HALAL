#1-5

#1
using HorizonSideRobots
function cross!(robot)#1.робот идет до края и ставит кресты. запоминает шаги 2. робот разворачивается и идет в обратное направление на записанное число шагов
    for side in (Nord, Ost, Sud, West)
        num_steps = mark_direct!(robot, side)#идет до края, ставит точки, запоминает шаги
        side = inverse(side)#разворот
        move!(robot, side, num_steps)#модификация изначальной функции, чтобы шел на фиксированное колличество шагов
    end
end

function HorizonSideRobots.move!(robot, side, num_steps::Integer)
    for _ in 1:num_steps
        move!(robot, side)
    end
end

function mark_direct!(robot, side)#::Int
    n = 0
    while !isborder(robot, side)
        move!(robot, side)
        putmarker!(robot)
        n += 1
    end
    return n
end

inverse(side::HorizonSide) = HorizonSide((Int(side) + 2) % 4)

#2
using HorizonSideRobots
function circle!(robot)
    num_steps_West = do_predela!(robot, West)
    num_steps_Sud = do_predela!(robot, Sud)
    for side in (Nord, Ost, Sud, West)
        mark_direct!(robot, side)
    end
    move!(robot, inverse!(Sud), num_steps_Sud)
    move!(robot, inverse!(West), num_steps_West)
end

function do_predela!(robot, side)
    n = 0
    while !isborder(robot, side)
        move!(robot, side)
        n += 1
    end
    return n
end

function HorizonSideRobots.move!(robot, side, num_steps::Integer)
    for _ in 1:num_steps
        move!(robot, side)
    end
end

function mark_direct!(robot, side)#::Int
    n = 0
    while !isborder(robot, side)
        move!(robot, side)
        putmarker!(robot)
        n += 1
    end
    return n
end

inverse(side::HorizonSide) = HorizonSide((Int(side) + 2) % 4)

#3

using HorizonSideRobots
function full_field!(robot)
    num_steps_West = do_predela!(robot, West)
    num_steps_Nord = do_predela!(robot, Nord)
    full!(robot)
    do_predela!(robot, West)
    do_predela!(robot, Nord)
    move!(robot, inverse!(Nord), num_steps_Nord)
    move!(robot, inverse!(West), num_steps_West)
end

function do_predela!(robot, side)
    n = 0
    while !isborder(robot, side)
        move!(robot, side)
        n += 1
    end
    return n
end

function HorizonSideRobots.move!(robot, side, num_steps::Integer)
    for _ in 1:num_steps
        move!(robot, side)
    end
end

function inverse!(side::HorizonSide)
    return HorizonSide((Int(side) + 2) % 4)
end

function mark_direct!(robot, side)
    n = 0
    while !isborder(robot, side)
        move!(robot, side)
        n += 1
        putmarker!(robot)
    end
end

function full!(robot)
    move_side = inverse!(West)
    while !isborder(robot, Sud)
        putmarker!(robot)
        mark_direct!(robot, move_side)
        move!(robot, Sud)
        move_side = inverse!(move_side)
    end
    putmarker!(robot)
    mark_direct!(robot, move_side)
end

#4

using HorizonSideRobots
function cross_diag!(robot)
    num_steps_Nord = diag_p_West!(robot, Nord)#движется ступенькой на запад в направлении сайд и запоминает число смещений
    diag_marker_Ost!(robot, Sud)#движется в направлении востока ступенькой в направлении сайд и ставит маркеры
    diag_p_West!(robot, Nord)#возврат на запомненую позицию
    diag!(robot, Sud, num_steps_Nord)#смещение на восток в направлении сайд на фиксированное коллическтво шагов
    num_steps_Sud = diag_p_West!(robot, Sud)
    diag_marker_Ost!(robot, Nord)
    diag_p_West!(robot, Sud)
    diag!(robot, Nord, num_steps_Sud)
end

function diag_p_West!(robot, side)
    n = 0
    while (!isborder(robot, West)) && (!isborder(robot, side))
        move!(robot, West)
        move!(robot, side)
        n += 1
    end
    return n
end

function diag_marker_Ost!(robot, side)
    putmarker!(robot)
    while !isborder(robot, Ost) && !isborder(robot, side)
        move!(robot, side)
        move!(robot, Ost)
        putmarker!(robot)
    end
end

function diag!(robot, side, num_steps)
    for _ in 1:num_steps
        move!(robot, side)
        move!(robot, Ost)
    end
end

#5

using HorizonSideRobots
function perimetr!(robot)
    num_steps_West = do_predela!(robot, West)
    num_steps_Nord = do_predela!(robot, Nord)
    circle!(robot, Nord)#обход
    checking!(robot, Ost)
    circle!(robot, Nord)
    do_predela!(robot, West)
    do_predela!(robot, Nord)
    move!(robot, Sud, num_steps_Nord)
    move!(robot, Ost, num_steps_West)
end

function do_predela!(robot, side)
    n = 0
    while !isborder(robot, side)
        move!(robot, side)
        n += 1
    end
    return n
end

function circle!(robot, side)
    s = side
    for i in 1::4
        s = HorizonSide((Int(s) + 1) % 4)
        mark_direct!(robot, s)
    end
end

function mark_direct!(robot, side)#::Int
    n = 0
    s = side
    s_wall_1 = HorizonSide((Int(s) + 1) % 4)
    s_wall_2 = HorizonSide((Int(s) + 3) % 4)
    while !isborder(robot, s) && (isborder(robot, s_wall_1) || isborder(robot, s_wall_2))
        move!(robot, s)
        putmarker!(robot)
        n += 1
    end
    return n
end

function checking!(robot, side)
    s = side
    while True
        if check_line!(robot, s)
            break
        end
        s = inverse!(s)
        move!(robot, Sud)
    end
    while isborder(robot, Sud)
        move!(robot, West)
    end
    move!(robot, Ost)
end

inverse(side::HorizonSide) = HorizonSide((Int(side) + 2) % 4)

function check_line!(robot, side)
    while !isborder(robot, side)
        if isborder(robot, Sud)
            return True
        end
        move!(robot, side)
    end
    return False
end

function HorizonSideRobots.move!(robot, side, num_steps)
    for _ in 1:num_steps
        move!(robot, side)
    end
end

