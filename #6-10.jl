#6-10

#6a

using HorizonSideRobots
function circle_pereg!(robot)
    W_list = []
    N_list = []
    n = 0
    while !isborder(robot, West) || !isborder(robot, Nord)
        push!(W_list, do_predela!(robot, West))
        push!(N_list, do_predela!(robot, Nord))
        n += 1
    end
    circle!(robot)
    for i in n:-1:1
        move!(robot, Sud, N_list[i])
        move!(robot, Ost, W_list[i])
    end
end

function circle!(robot)
    for side in (Ost, Sud, West, Nord)
        mark_direct!(robot, side)
    end
end

function do_predela!(robot, side)
    n = 0
    while !isborder(robot, side)
        move!(robot, side)
        n += 1
    end
    return n
end

function HorizonSideRobots.move!(robot, side, num_steps)
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

#6b

using HorizonSideRobots

function positions!(robot)
    W_list = []
    N_list = []
    n = 0
    while !isborder(robot, West) || !isborder(robot, Nord)
        push!(W_list, do_predela!(robot, West))
        push!(N_list, do_predela!(robot, Nord))
        n += 1
    end

    move!(robot, Ost, sum(W_list))
    putmarker!(robot)
    do_predela!(robot, Ost)
    move!(robot, Sud, sum(N_list))
    putmarker!(robot)

    do_predela!(robot, Nord)
    do_predela!(robot, West)

    move!(robot, Sud, sum(N_list))
    putmarker!(robot)
    do_predela!(robot, Sud)
    move!(robot, Ost, sum(W_list))
    putmarker!(robot)

    do_predela!(robot, West)
    do_predela!(robot, Nord)

    for i in n:-1:1
        move!(robot, Sud, N_list[i])
        move!(robot, Ost, W_list[i])
    end
end

function HorizonSideRobots.move!(robot, side, num_steps)
    for _ in 1:num_steps
        move!(robot, side)
    end
end

function do_predela!(robot, side)
    n = 0
    while !isborder(robot, side)
        move!(robot, side)
        n += 1
    end
    return n
end

#7

using HorizonSideRobots

function find_way(robot, side)
    s = HorizonSide((Int(side) + 1) % 4)
    num_steps = 1
    while isborder(robot, side)
        move!(robot, side, num_steps)
        s = inverse(s)
        num_steps += 1
    end
end

function inverse(side)
    return HorizonSide((Int(side) + 2) % 4)
end

function HorizonSideRobots.move!(robot, side, num_steps)
    for _ in 1:num_steps
        move!(robot, side)
    end
end

#8

using HorizonSideRobots

function find_marker(robot)
    n = 0
    side = HorizonSide(n)
    while move!(robot, side, n)
        n += 1
        side = HorizonSide((n) % 4)
    end
end


function HorizonSideRobots.move!(robot, side, n)
    num_steps = div(n, 2) + 1
    ismarker(robot) && return false
    for _ in 1:num_steps
        move!(robot, side)
        ismarker(robot) && return false
    end
    return true
end

#9

using HorizonSideRobots
function chessboard!(robot)
    num_steps_West = do_predela!(robot, West)
    num_steps_Sud = do_predela!(robot, Sud)
    n = (num_steps_Sud + num_steps_West) % 2
    chess!(robot, n)
    do_predela!(robot, Sud)
    do_predela!(robot, West)
    move!(robot, Nord, num_steps_Sud)
    move!(robot, Ost, num_steps_West)
end

function HorizonSideRobots.move!(robot, side, num_steps)
    for _ in 1:num_steps
        move!(robot, side)
    end
end

function do_predela!(robot, side)
    n = 0
    while !isborder(robot, side)
        move!(robot, side)
        n += 1
    end
    return n
end

function chess!(robot, chet)
    p = chet
    s = Ost
    while true
        p = chess_row!(robot, s, p)
        s = inverse!(s)
        if isborder(robot, Nord)
            break
        end
        move!(robot, Nord)
        p += 1
    end
end

function chess_row!(robot, side, chet)
    k = chet
    while !isborder(robot, side)
        if k % 2 == 0
            putmarker!(robot)
        end
        move!(robot, side)
        k = (k + 1) % 2
    end
    if k % 2 == 0
        putmarker!(robot)
    end
    return k
end

inverse!(side::HorizonSide) = HorizonSide((Int(side) + 2) % 4)

#10

using HorizonSideRobots
function chess_N(robot, N)
    num_steps_West = do_predela!(robot, West)
    num_steps_Sud = do_predela!(robot, Sud)
    n = 0
    while true
        line!(robot, n, N)
        if isborder(robot, Nord)
            break
        end
        go_back!(robot)
        n += 1
    end
    do_predela!(robot, West)
    do_predela!(robot, Sud)
    move!(robot, Nord, num_steps_Sud)
    move!(robot, Ost, num_steps_West)
end

function HorizonSideRobots.move!(robot, side, num_steps)
    for _ in 1:num_steps
        move!(robot, side)
    end
end

function do_predela!(robot, side)
    n = 0
    while !isborder(robot, side)
        move!(robot, side)
        n += 1
    end
    return n
end

function go_back!(robot)
    move!(robot, Nord)
    do_predela!(robot, West)
end

function line!(robot, n, N)
    k = 0
    if div(n, N) % 2 == 0
        while !isborder(robot, Ost)
            if div(k, N) % 2 == 0
                putmarker!(robot)
                move!(robot, Ost)
                k += 1
            elseif div(k, N) % 2 == 1
                move!(robot, Ost)
                k += 1
            end
        end
        if div(k, N) % 2 == 0
            putmarker!(robot)
        end
    elseif div(n, N) % 2 == 1
        while !isborder(robot, Ost)
            if div(k, N) % 2 == 1
                putmarker!(robot)
                move!(robot, Ost)
                k += 1
            elseif div(k, N) % 2 == 0
                move!(robot, Ost)
                k += 1
            end
        end
        if div(k, N) % 2 == 1
            putmarker!(robot)
        end
    end
end